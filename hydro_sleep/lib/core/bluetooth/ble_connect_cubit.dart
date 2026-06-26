import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hydro_sleep/core/bluetooth/bluetooth_service.dart';
import 'package:hydro_sleep/data/repositories/device_repository.dart';
import 'package:hydro_sleep/domain/models/history_device.dart';
import 'package:hydro_sleep/domain/models/scanned_device.dart';

// --- Status ---

enum BleConnectStatus {
  idle,
  connecting,
  connected,
  disconnecting,
  disconnected,
  reconnecting,
  failed,
}

// --- State ---

class BleConnectState extends Equatable {
  final BleConnectStatus status;
  final String? error;
  final String? remoteId;
  final String? deviceName;

  const BleConnectState({
    this.status = BleConnectStatus.idle,
    this.error,
    this.remoteId,
    this.deviceName,
  });

  bool get isConnecting => status == BleConnectStatus.connecting;
  bool get isConnected => status == BleConnectStatus.connected;
  bool get isFailed => status == BleConnectStatus.failed;
  bool get isReconnecting => status == BleConnectStatus.reconnecting;

  BleConnectState copyWith({
    BleConnectStatus? status,
    String? error,
    String? remoteId,
    String? deviceName,
  }) {
    return BleConnectState(
      status: status ?? this.status,
      error: error,
      remoteId: remoteId ?? this.remoteId,
      deviceName: deviceName ?? this.deviceName,
    );
  }

  @override
  List<Object?> get props => [status, error, remoteId, deviceName];
}

// --- Cubit ---

class BleConnectCubit extends Cubit<BleConnectState> {
  BleConnectCubit({BleService? bleService})
      : _bleService = bleService ?? BleService(),
        super(const BleConnectState()) {
    // 蓝牙关闭时终止所有连接
    _adapterSub = _bleService.adapterState.listen((btAdapterState) {
      if (btAdapterState == BluetoothAdapterState.off) {
        _onBluetoothOff();
      }
    });
  }

  final BleService _bleService;
  StreamSubscription<BluetoothAdapterState>? _adapterSub;
  StreamSubscription<BluetoothConnectionState>? _connSub;
  Timer? _connCheckTimer;
  Completer<void>? _cancelReconnect;
  bool _userDisconnecting = false;

  /// 可被 _cancelReconnect 中断的 delay
  Future<void> _cancelableDelay(Duration duration) {
    final c = _cancelReconnect;
    if (c == null || c.isCompleted) return Future.value();
    return Future.any([
      Future.delayed(duration),
      c.future,
    ]);
  }

  void _onBluetoothOff() {
    debugPrint('[连接管理] 蓝牙已关闭，终止所有连接');
    _connSub?.cancel();
    _connSub = null;
    _connCheckTimer?.cancel();
    _userDisconnecting = false;
    _cancelReconnect?.complete();
    if (state.status != BleConnectStatus.idle &&
        state.status != BleConnectStatus.disconnected) {
      emit(state.copyWith(status: BleConnectStatus.disconnected, error: null));
    }
  }

  Future<void> connect(ScannedDevice device) async {
    debugPrint('[连接管理] 发起连接: ${device.remoteId} (${device.displayName})');
    await _connSub?.cancel();
    _connSub = null;
    _connCheckTimer?.cancel();
    _cancelReconnect?.complete();
    _cancelReconnect = null;
    _userDisconnecting = false;

    emit(
      state.copyWith(
        status: BleConnectStatus.connecting,
        remoteId: device.remoteId,
        deviceName: device.displayName,
        error: null,
      ),
    );

    try {
      await _bleService.connect(device.remoteId);
      await _saveHistory(device);
      debugPrint('[连接管理] 连接成功: ${device.remoteId}');
      emit(state.copyWith(status: BleConnectStatus.connected, error: null));
      _startConnectionMonitor(device.remoteId);
    } catch (e) {
      debugPrint('[连接管理] 连接失败: ${device.remoteId} 错误=$e');
      emit(state.copyWith(status: BleConnectStatus.failed, error: 'connectFailed'));
    }
  }

  void _startConnectionMonitor(String remoteId) {
    debugPrint('[连接管理] 启动连接监听: $remoteId');
    _connSub?.cancel();
    _connCheckTimer?.cancel();

    // 1) 订阅 stream
    _connSub = _bleService.connectionState(remoteId).listen((btState) {
      debugPrint('[连接管理] 连接状态流: $btState, 当前状态: ${state.status}');
      if (btState == BluetoothConnectionState.disconnected &&
          state.status == BleConnectStatus.connected) {
        debugPrint('[连接管理] 流检测到断开, 用户主动断开=$_userDisconnecting');
        _connCheckTimer?.cancel();
        _connSub?.cancel();
        _connSub = null;
        if (_userDisconnecting) {
          emit(state.copyWith(status: BleConnectStatus.disconnected, error: null));
        } else {
          _autoReconnect();
        }
      }
    });

    // 2) 定时轮询：stream 不触发时也能检测到断连
    _connCheckTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (state.status != BleConnectStatus.connected) return;
      try {
        final btState = await _bleService.connectionState(remoteId).first;
        // debugPrint('[连接管理] 定时轮询检查: $btState');
        if (btState == BluetoothConnectionState.disconnected) {
          debugPrint('[连接管理] 轮询检测到断开, 用户主动断开=$_userDisconnecting');
          _connCheckTimer?.cancel();
          _connSub?.cancel();
          _connSub = null;
          if (_userDisconnecting) {
            emit(state.copyWith(status: BleConnectStatus.disconnected, error: null));
          } else {
            _autoReconnect();
          }
        }
      } catch (e) {
        debugPrint('[连接管理] 定时轮询错误: $e');
      }
    });
  }

  Future<void> _autoReconnect() async {
    final remoteId = state.remoteId;
    if (remoteId == null) return;

    // 新建取消信号（旧的可能已被 complete）
    _cancelReconnect = Completer<void>();

    debugPrint('[连接管理] 自动重连开始: $remoteId');
    emit(
      state.copyWith(
        status: BleConnectStatus.reconnecting,
        error: null,
      ),
    );

    const maxRetries = 3;
    const attemptTimeout = Duration(seconds: 20);

    for (var i = 0; i < maxRetries; i++) {
      if (_cancelReconnect!.isCompleted) {
        debugPrint('[连接管理] 自动重连在第 ${i + 1} 次尝试前被取消');
        return;
      }

      debugPrint('[连接管理] 自动重连第 ${i + 1}/$maxRetries 次尝试');
      try {
        final completer = Completer<void>();
        _connSub?.cancel();
        _connSub = _bleService.connectionState(remoteId).listen((btState) {
          debugPrint('[连接管理] 重连流事件: $btState');
          if (btState == BluetoothConnectionState.connected &&
              !completer.isCompleted) {
            completer.complete();
          }
        });

        await _bleService.connect(remoteId, autoConnect: true);
        debugPrint('[连接管理] 重连第 ${i + 1} 次 connect() 已返回, 等待流确认连接...');
        await Future.any([
          completer.future,
          _cancelReconnect!.future,
        ]).timeout(attemptTimeout);

        // 连接成功
        _connSub?.cancel();
        debugPrint('[连接管理] 自动重连第 ${i + 1} 次成功');
        emit(state.copyWith(status: BleConnectStatus.connected, error: null));
        _startConnectionMonitor(remoteId);
        return;
      } catch (e) {
        debugPrint('[连接管理] 自动重连第 ${i + 1} 次失败: $e');
        _connSub?.cancel();
        _connSub = null;
        if (i < maxRetries - 1) {
          debugPrint('[连接管理] 自动重连等待 10 秒后重试...');
          await _cancelableDelay(const Duration(seconds: 10));
        }
      }
    }

    // 3 次全部失败，清理 BLE 连接状态后停止重连
    debugPrint('[连接管理] 自动重连 $maxRetries 次全部失败, 清理 BLE 状态');
    if (!_cancelReconnect!.isCompleted) {
      try {
        await _bleService.disconnect(remoteId);
        debugPrint('[连接管理] 重连失败后清理断开完成');
      } catch (e) {
        debugPrint('[连接管理] 重连失败后清理断开错误: $e');
      }
      emit(state.copyWith(status: BleConnectStatus.disconnected, error: null));
    }
  }

  Future<void> disconnect() async {
    final remoteId = state.remoteId;
    if (remoteId == null) return;

    debugPrint('[连接管理] 用户断开连接: $remoteId');
    _userDisconnecting = true;
    _connSub?.cancel();
    _connSub = null;
    _connCheckTimer?.cancel();
    _cancelReconnect?.complete();
    emit(state.copyWith(status: BleConnectStatus.disconnecting, error: null));
    try {
      await _bleService.disconnect(remoteId);
    } catch (e) {
      debugPrint('[连接管理] 断开连接错误: $e');
    }
    debugPrint('[连接管理] 断开连接完成');
    emit(state.copyWith(status: BleConnectStatus.disconnected, error: null));
  }

  @override
  Future<void> close() {
    _adapterSub?.cancel();
    _connSub?.cancel();
    _connCheckTimer?.cancel();
    return super.close();
  }

  Future<void> _saveHistory(ScannedDevice device) async {
    await DeviceRepository.saveHistoryDevice(
      HistoryDevice(
        deviceId: device.remoteId,
        deviceName: device.displayName,
        lastConnectedAt: DateTime.now(),
      ),
    );
  }
}
