import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/core/bluetooth/bluetooth_service.dart';
import 'package:hydro_sleep/domain/models/device_info.dart';
import 'package:hydro_sleep/domain/models/retransmit_record.dart';

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
  final String? firmwareVersion;
  final List<int>? lastReceived;
  final List<String> rawLog;

  const BleDataState({
    this.status = BleDataStatus.idle,
    this.error,
    this.deviceInfo,
    this.firmwareVersion,
    this.lastReceived,
    this.rawLog = const [],
  });

  BleDataState copyWith({
    BleDataStatus? status,
    String? error,
    DeviceInfo? deviceInfo,
    String? firmwareVersion,
    List<int>? lastReceived,
    List<String>? rawLog,
  }) {
    return BleDataState(
      status: status ?? this.status,
      error: error,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      lastReceived: lastReceived ?? this.lastReceived,
      rawLog: rawLog ?? this.rawLog,
    );
  }

  @override
  List<Object?> get props => [
        status,
        error,
        deviceInfo,
        firmwareVersion,
        lastReceived,
        rawLog,
      ];
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
  Completer<bool>? _responseCompleter;

  // 重传相关
  bool _awaitingRetransmit = false;
  Completer<List<RetransmitRecord>>? _retransmitCompleter;
  List<int> _retransmitBuffer = [];
  Timer? _retransmitTimer;

  // 固件版本相关
  Completer<String?>? _firmwareVersionCompleter;

  static const _deviceInfoLength = 11;
  static const _headerDeviceByte1 = 0xA5;
  static const _headerDeviceByte2 = 0x5A;
  static const _headerCmd0x81 = 0x81;
  static const _headerCmd0x82 = 0x82;
  static const _headerCmd0x8C = 0x8C;
  static const _headerResponse = 0x97;

  static const _firmwareVersionCommand = [
    0x7D, 0x0C, 0x0F, 0x00,
    0x55, 0x4E, 0x43, 0x4F, 0x4E, 0x46, 0x49, 0x47, 0x45, 0x44, 0x0D,
  ];

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
      if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
        _responseCompleter!.complete(false);
      }
      _responseCompleter = null;
      _awaitingRetransmit = false;
      _retransmitBuffer = [];
      _retransmitTimer?.cancel();
      _retransmitTimer = null;
      if (_retransmitCompleter != null && !_retransmitCompleter!.isCompleted) {
        _retransmitCompleter!.complete([]);
      }
      _retransmitCompleter = null;
      if (_firmwareVersionCompleter != null &&
          !_firmwareVersionCompleter!.isCompleted) {
        _firmwareVersionCompleter!.complete(null);
      }
      _firmwareVersionCompleter = null;
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

      // 2.5. 找到 Write 特征值（可选，不影响数据接收）
      _bleService.findWriteCharacteristic(services);

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

      // 连接成功后自动查询固件版本
      sendFirmwareVersionCommand();
    } catch (e) {
      debugPrint('[数据管理] 启动数据流失败: $e');
      emit(state.copyWith(status: BleDataStatus.error, error: '$e'));
    }
  }

  /// 发送 BLE 命令并等待设备响应
  /// 返回 true 表示收到预期响应，false 表示超时或未连接
  Future<bool> sendCommand(
    List<int> data, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (state.status != BleDataStatus.streaming) {
      debugPrint('[数据管理] sendCommand 失败: 未处于 streaming 状态');
      return false;
    }

    _responseCompleter = Completer<bool>();
    try {
      await _bleService.writeData(data);
      debugPrint('[数据管理] 命令已发送，等待响应...');
      return await _responseCompleter!.future.timeout(timeout, onTimeout: () {
        debugPrint('[数据管理] 等待响应超时');
        return false;
      });
    } catch (e) {
      debugPrint('[数据管理] sendCommand 异常: $e');
      return false;
    } finally {
      _responseCompleter = null;
    }
  }

  /// 发送重传指令 0x01，等待设备回复 0x81 历史数据
  static const _retransmitCommand = [
    0x7D, 0x01, 0x0F, 0x00,
    0x55, 0x4E, 0x43, 0x4F, 0x4E, 0x46, 0x49, 0x47, 0x45, 0x44, 0x0D,
  ];
  static const _retransmitRecordSize = 12;

  Future<List<RetransmitRecord>> sendRetransmitCommand({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (state.status != BleDataStatus.streaming) {
      debugPrint('[数据管理] sendRetransmitCommand 失败: 未处于 streaming 状态');
      return [];
    }

    _awaitingRetransmit = true;
    _retransmitBuffer = [];
    _retransmitCompleter = Completer<List<RetransmitRecord>>();

    try {
      await _bleService.writeData(_retransmitCommand);
      debugPrint('[数据管理] 重传指令已发送，等待 0x81 响应...');

      // 超时保底：即使数据不完整也返回已收到的
      final result = await _retransmitCompleter!.future.timeout(
        timeout,
        onTimeout: () {
          debugPrint('[数据管理] 重传响应超时，尝试解析已有数据');
          return _parseRetransmitBuffer();
        },
      );
      return result;
    } catch (e) {
      debugPrint('[数据管理] sendRetransmitCommand 异常: $e');
      return [];
    } finally {
      _awaitingRetransmit = false;
      _retransmitCompleter = null;
      _retransmitTimer?.cancel();
      _retransmitTimer = null;
      _retransmitBuffer = [];
    }
  }

  List<RetransmitRecord> _parseRetransmitBuffer() {
    final data = _retransmitBuffer;
    if (data.length < _retransmitRecordSize) {
      debugPrint('[数据管理] 重传数据不足一组: ${data.length}字节');
      return [];
    }
    final records = <RetransmitRecord>[];
    for (var i = 0; i + _retransmitRecordSize <= data.length;
        i += _retransmitRecordSize) {
      records.add(RetransmitRecord.fromBytes(data, i));
    }
    debugPrint('[数据管理] 解析重传记录 ${records.length} 条');
    return records;
  }

  /// 发送固件版本查询命令，等待设备回复 0x8C 字符串
  Future<void> sendFirmwareVersionCommand({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (state.status != BleDataStatus.streaming) {
      debugPrint('[数据管理] sendFirmwareVersionCommand 失败: 未处于 streaming 状态');
      return;
    }

    _firmwareVersionCompleter = Completer<String?>();
    try {
      await _bleService.writeData(_firmwareVersionCommand);
      debugPrint('[数据管理] 固件版本查询已发送，等待 0x8C 响应...');
      final version = await _firmwareVersionCompleter!.future.timeout(
        timeout,
        onTimeout: () {
          debugPrint('[数据管理] 固件版本响应超时');
          return null;
        },
      );
      if (version != null) {
        debugPrint('[数据管理] 固件版本: $version');
        emit(state.copyWith(firmwareVersion: version));
      }
    } catch (e) {
      debugPrint('[数据管理] sendFirmwareVersionCommand 异常: $e');
    } finally {
      _firmwareVersionCompleter = null;
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

    // 按 bytes[1] 数据类型分发（bytes[0] 为帧头）
    if (bytes.length >= _deviceInfoLength &&
        bytes[0] == _headerDeviceByte1 &&
        bytes[1] == _headerDeviceByte2) {
      // 设备信息（11 字节）
      final info = DeviceInfo.fromBytes(bytes);
      debugPrint('[数据管理] 设备信息: $info');
      emit(state.copyWith(deviceInfo: info, lastReceived: bytes, rawLog: log));
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x81) {
      if (_awaitingRetransmit) {
        // 重传响应：跳过帧头 + 数据类型（2字节），缓冲后续数据
        _retransmitBuffer.addAll(bytes.sublist(2));
        debugPrint(
          '[数据管理] 重传数据缓冲: +${bytes.length - 2}字节, '
          '累计${_retransmitBuffer.length}字节',
        );
        // 重置超时计时器：500ms 内无新包则认为传输完成
        _retransmitTimer?.cancel();
        if (_retransmitBuffer.length >= 30 * _retransmitRecordSize) {
          _retransmitTimer = null;
          if (_retransmitCompleter != null &&
              !_retransmitCompleter!.isCompleted) {
            _retransmitCompleter!.complete(_parseRetransmitBuffer());
          }
        } else {
          _retransmitTimer = Timer(
            const Duration(milliseconds: 500),
            () {
              debugPrint('[数据管理] 重传数据 500ms 无新包，解析已有数据');
              if (_retransmitCompleter != null &&
                  !_retransmitCompleter!.isCompleted) {
                _retransmitCompleter!.complete(_parseRetransmitBuffer());
              }
            },
          );
        }
      } else {
        debugPrint('[数据管理] 收到 0x81 数据（非重传）: $bytes');
      }
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x82) {
      debugPrint('[数据管理] 收到 0x82 数据（预留）: $bytes');
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x8C) {
      // 固件版本响应：bytes[2] 开始为字符串
      final versionBytes = bytes.sublist(2);
      final version = String.fromCharCodes(versionBytes);
      debugPrint('[数据管理] 固件版本响应: $version');
      emit(state.copyWith(
        firmwareVersion: version,
        lastReceived: bytes,
        rawLog: log,
      ));
      if (_firmwareVersionCompleter != null &&
          !_firmwareVersionCompleter!.isCompleted) {
        _firmwareVersionCompleter!.complete(version);
      }
    } else if (bytes.length >= 2 && bytes[1] == _headerResponse) {
      debugPrint('[数据管理] 收到 0x97 响应: $bytes');
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
      if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
        _responseCompleter!.complete(true);
      }
    } else {
      debugPrint('[数据管理] 未知数据类型 bytes[1]=0x${bytes.length >= 2 ? bytes[1].toRadixString(16) : '??'}: $bytes');
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
    }
  }

  void _stopDataFlow() {
    debugPrint('[数据管理] 停止数据流');
    _dataSub?.cancel();
    _dataSub = null;
    if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
      _responseCompleter!.complete(false);
    }
    _responseCompleter = null;
    _awaitingRetransmit = false;
    _retransmitBuffer = [];
    _retransmitTimer?.cancel();
    _retransmitTimer = null;
    if (_retransmitCompleter != null && !_retransmitCompleter!.isCompleted) {
      _retransmitCompleter!.complete([]);
    }
    _retransmitCompleter = null;
    if (_firmwareVersionCompleter != null &&
        !_firmwareVersionCompleter!.isCompleted) {
      _firmwareVersionCompleter!.complete(null);
    }
    _firmwareVersionCompleter = null;
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
