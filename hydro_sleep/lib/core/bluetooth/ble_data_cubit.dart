import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/core/bluetooth/bluetooth_service.dart';
import 'package:hydro_sleep/domain/models/device_info.dart';

// --- Status ---

enum BleDataStatus {
  idle,
  discovering,
  subscribing,
  streaming,
  error,
}

// --- State ---

class BleDataState extends Equatable {
  final BleDataStatus status;
  final String? error;
  final DeviceInfo? deviceInfo;
  final List<int>? lastReceived;
  final List<String> rawLog;

  const BleDataState({
    this.status = BleDataStatus.idle,
    this.error,
    this.deviceInfo,
    this.lastReceived,
    this.rawLog = const [],
  });

  BleDataState copyWith({
    BleDataStatus? status,
    String? error,
    DeviceInfo? deviceInfo,
    List<int>? lastReceived,
    List<String>? rawLog,
  }) {
    return BleDataState(
      status: status ?? this.status,
      error: error,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      lastReceived: lastReceived ?? this.lastReceived,
      rawLog: rawLog ?? this.rawLog,
    );
  }

  @override
  List<Object?> get props => [status, error, deviceInfo, lastReceived, rawLog];
}

// --- Cubit ---

class BleDataCubit extends Cubit<BleDataState> {
  BleDataCubit({required BleConnectCubit connectCubit, BleService? bleService})
      : _connectCubit = connectCubit,
        _bleService = bleService ?? BleService(),
        super(const BleDataState()) {
    _connectSub = _connectCubit.stream.listen(_onConnectStateChanged);
    _adapterSub = _bleService.adapterState.listen(_onAdapterStateChanged);
  }

  final BleConnectCubit _connectCubit;
  final BleService _bleService;
  StreamSubscription<BleConnectState>? _connectSub;
  StreamSubscription<BluetoothAdapterState>? _adapterSub;
  StreamSubscription<List<int>>? _dataSub;

  static const _deviceInfoLength = 11;
  static const _headerDeviceByte1 = 0xA5;
  static const _headerDeviceByte2 = 0x5A;
  static const _headerCmd0x81 = 0x81;
  static const _headerCmd0x82 = 0x82;

  void _onConnectStateChanged(BleConnectState connectState) {
    debugPrint('[数据管理] 连接状态变化: ${connectState.status}');
    if (connectState.status == BleConnectStatus.connected) {
      _startDataFlow();
    } else if (connectState.status == BleConnectStatus.disconnected ||
        connectState.status == BleConnectStatus.failed) {
      _stopDataFlow();
    }
  }

  void _onAdapterStateChanged(BluetoothAdapterState adapterState) {
    debugPrint('[数据管理] 蓝牙适配器状态: $adapterState');
    if (adapterState == BluetoothAdapterState.off) {
      _dataSub?.cancel();
      _dataSub = null;
      _bleService.clearCharacteristicCache();
      if (state.status != BleDataStatus.idle) {
        debugPrint('[数据管理] 蓝牙已关闭，清理所有数据');
        emit(const BleDataState());
      }
    }
  }

  Future<void> _startDataFlow() async {
    debugPrint('[数据管理] 开始数据流');
    emit(state.copyWith(status: BleDataStatus.discovering, error: null));

    try {
      final remoteId = _connectCubit.state.remoteId;
      if (remoteId == null) {
        emit(state.copyWith(status: BleDataStatus.error, error: 'noRemoteId'));
        return;
      }

      // 1. 发现服务
      final services = await _bleService.discoverServices(remoteId);

      // 2. 找到 Notify 特征值
      final notifyChar = _bleService.findNotifyCharacteristic(services);
      if (notifyChar == null) {
        emit(state.copyWith(
          status: BleDataStatus.error,
          error: 'noNotifyChar',
        ));
        return;
      }

      // 3. 开启 Notify
      emit(state.copyWith(status: BleDataStatus.subscribing));
      await _bleService.enableNotify();

      // 4. 订阅数据流
      final dataStream = _bleService.onValueChanged;
      if (dataStream == null) {
        emit(state.copyWith(
          status: BleDataStatus.error,
          error: 'noDataStream',
        ));
        return;
      }

      emit(state.copyWith(status: BleDataStatus.streaming));
      _dataSub = dataStream.listen(
        _onDataReceived,
        onError: (e) {
          debugPrint('[数据管理] 数据流错误: $e');
          emit(state.copyWith(status: BleDataStatus.error, error: '$e'));
        },
      );
    } catch (e) {
      debugPrint('[数据管理] 启动数据流失败: $e');
      emit(state.copyWith(status: BleDataStatus.error, error: '$e'));
    }
  }

  static const _maxLogEntries = 200;

  void _onDataReceived(List<int> bytes) {
    debugPrint('[数据管理] 收到数据 (${bytes.length}字节): $bytes');

    if (bytes.isEmpty) return;

    // 格式化为 hex 字符串，带时间戳
    final now = DateTime.now();
    final time =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    final logEntry = '$time  $hex';

    final log = List<String>.from(state.rawLog)..add(logEntry);
    if (log.length > _maxLogEntries) {
      log.removeAt(0);
    }

    // 按包头分发
    if (bytes.length >= _deviceInfoLength &&
        bytes[0] == _headerDeviceByte1 &&
        bytes[1] == _headerDeviceByte2) {
      // 第一组：设备信息（11 字节）
      final info = DeviceInfo.fromBytes(bytes);
      debugPrint('[数据管理] 设备信息: $info');
      emit(state.copyWith(deviceInfo: info, lastReceived: bytes, rawLog: log));
    } else if (bytes[0] == _headerCmd0x81) {
      debugPrint('[数据管理] 收到 0x81 数据（预留）: $bytes');
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
    } else if (bytes[0] == _headerCmd0x82) {
      debugPrint('[数据管理] 收到 0x82 数据（预留）: $bytes');
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
    } else {
      debugPrint('[数据管理] 未知包头 0x${bytes[0].toRadixString(16)}: $bytes');
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
    }
  }

  void _stopDataFlow() {
    debugPrint('[数据管理] 停止数据流');
    _dataSub?.cancel();
    _dataSub = null;
    _bleService.disableNotify();
    _bleService.clearCharacteristicCache();
    emit(const BleDataState());
  }

  @override
  Future<void> close() {
    _connectSub?.cancel();
    _adapterSub?.cancel();
    _dataSub?.cancel();
    _bleService.disableNotify();
    _bleService.clearCharacteristicCache();
    return super.close();
  }
}
