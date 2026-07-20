import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/core/bluetooth/bluetooth_service.dart';
import 'package:hydro_sleep/domain/models/device_info.dart';
import 'package:hydro_sleep/domain/models/device_status.dart';
import 'package:hydro_sleep/domain/models/device_parameters.dart';
import 'package:hydro_sleep/domain/models/retransmit_record.dart';
import 'package:hydro_sleep/domain/models/retransmit30_record.dart';
import 'package:hydro_sleep/domain/models/report_summary.dart';
import 'package:hydro_sleep/domain/models/sleep_minute_record.dart';
import 'package:hydro_sleep/data/repositories/sleep_data_repository.dart';
import 'package:hydro_sleep/data/storage/secure_storage_service.dart';

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
  final String? deviceId; // 0x87 响应中返回的设备 ID（bytes[4..13]）
  final List<int>? lastReceived;
  final List<String> rawLog;
  final List<String> sentLog; // 发送数据日志（最新200条）

  /// 最新一条实时秒数据（0x85）
  final RetransmitRecord? latestSecondRecord;
  /// 实时秒数据缓冲区（最多 120 条）
  final List<RetransmitRecord> secondRecords;
  /// 最新一条实时分钟数据（0x86）
  final SleepMinuteRecord? latestMinuteRecord;
  /// 实时分钟数据缓冲区（最多 30 条）
  final List<SleepMinuteRecord> minuteRecords;
  /// 0x13 报表查询加载中
  final bool reportQueryLoading;

  const BleDataState({
    this.status = BleDataStatus.idle,
    this.error,
    this.deviceInfo,
    this.firmwareVersion,
    this.deviceId,
    this.lastReceived,
    this.rawLog = const [],
    this.sentLog = const [],
    this.latestSecondRecord,
    this.secondRecords = const [],
    this.latestMinuteRecord,
    this.minuteRecords = const [],
    this.reportQueryLoading = false,
  });

  BleDataState copyWith({
    BleDataStatus? status,
    String? error,
    DeviceInfo? deviceInfo,
    String? firmwareVersion,
    String? deviceId,
    List<int>? lastReceived,
    List<String>? rawLog,
    List<String>? sentLog,
    RetransmitRecord? latestSecondRecord,
    List<RetransmitRecord>? secondRecords,
    SleepMinuteRecord? latestMinuteRecord,
    List<SleepMinuteRecord>? minuteRecords,
    bool? reportQueryLoading,
  }) {
    return BleDataState(
      status: status ?? this.status,
      error: error,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      deviceId: deviceId ?? this.deviceId,
      lastReceived: lastReceived ?? this.lastReceived,
      rawLog: rawLog ?? this.rawLog,
      sentLog: sentLog ?? this.sentLog,
      latestSecondRecord: latestSecondRecord ?? this.latestSecondRecord,
      secondRecords: secondRecords ?? this.secondRecords,
      latestMinuteRecord: latestMinuteRecord ?? this.latestMinuteRecord,
      minuteRecords: minuteRecords ?? this.minuteRecords,
      reportQueryLoading: reportQueryLoading ?? this.reportQueryLoading,
    );
  }

  @override
  List<Object?> get props => [
        status,
        error,
        deviceInfo,
        firmwareVersion,
        deviceId,
        lastReceived,
        rawLog,
        sentLog,
        latestSecondRecord,
        secondRecords,
        latestMinuteRecord,
        minuteRecords,
        reportQueryLoading,
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
  final SecureStorageService _secureStorage = SecureStorageService();
  StreamSubscription<BleConnectState>? _connectSub;
  StreamSubscription<BluetoothAdapterState>? _adapterSub;
  StreamSubscription<List<int>>? _dataSub;
  Completer<bool>? _responseCompleter;

  // 重传相关（120秒）
  bool _awaitingRetransmit = false;
  Completer<List<RetransmitRecord>>? _retransmitCompleter;
  List<int> _retransmitBuffer = [];
  Timer? _retransmitTimer;

  // 重传相关（30分钟）
  bool _awaitingRetransmit30 = false;
  Completer<List<Retransmit30Record>>? _retransmit30Completer;
  List<int> _retransmit30Buffer = [];
  Timer? _retransmit30Timer;

  // 固件版本相关
  Completer<String?>? _firmwareVersionCompleter;

  // 模式设定相关
  Completer<int>? _modeCommandCompleter;

  // 设备状态查询相关
  Completer<DeviceStatus?>? _deviceStatusCompleter;

  // 参数查询相关（0x0A/0x8A）
  Completer<DeviceParameters?>? _parametersCompleter;

  // 报表查询相关（0x13/0x93）
  Completer<List<ReportSummary>>? _reportQueryCompleter;
  List<ReportSummary> _reportBuffer = [];
  int _reportBatchReceived = 0;
  String _lastReportAsciiId = '';

  // 存储数据读取相关（0x14/0x94）
  Completer<List<SleepMinuteRecord>>? _sleepDataCompleter;
  List<int> _sleepDataBuffer = [];

  // 温度存储节流（每 10 秒存一条）
  DateTime _lastTempSaveTime = DateTime.fromMillisecondsSinceEpoch(0);

  static const _deviceInfoLength = 11;
  static const _defaultTimeout = Duration(seconds: 30);
  static const _headerDeviceByte1 = 0xA5;
  static const _headerDeviceByte2 = 0x5A;
  static const _headerCmd0x81 = 0x81;
  static const _headerCmd0x82 = 0x82;
  static const _headerCmd0x83 = 0x83;
  static const _headerCmd0x84 = 0x84;
  static const _headerCmd0x85 = 0x85;
  static const _headerCmd0x86 = 0x86;
  static const _headerCmd0x87 = 0x87;
  static const _headerCmd0x88 = 0x88;
  static const _headerCmd0x89 = 0x89;
  static const _headerCmd0x8A = 0x8A;
  static const _headerCmd0x8B = 0x8B;
  static const _headerCmd0x8C = 0x8C;
  static const _headerCmd0x93 = 0x93;
  static const _headerCmd0x94 = 0x94;
  static const _headerResponse = 0x97;

  /// 指令 0x0C 设备版本及固件版本查询
  static const _firmwareVersionCommand = [
    0x7D, 0x0C, 0x0F, 0x00,
    0x55, 0x4E, 0x43, 0x4F, 0x4E, 0x46, 0x49, 0x47, 0x45, 0x44, 0x0D,
  ];

  /// 停止指令 0x03，强制停止工作，设备进入待机模式
  static const stopCommand = [
    0x7D, 0x03, 0x0F, 0x00,
    0x55, 0x4E, 0x43, 0x4F, 0x4E, 0x46, 0x49, 0x47, 0x45, 0x44, 0x0D,
  ];

  /// 工作模式设定 0x04，[模式字节] 决定设备行为
  /// 0x20 = 上位机监控模式，0x30 = 数据调试模式
  static const _modeCommandPrefix = [
    0x7D, 0x04, 0x10, 0x00,
    0x55, 0x4E, 0x43, 0x4F, 0x4E, 0x46, 0x49, 0x47, 0x45, 0x44,
  ];
  static const modeMonitor = 0x20;
  static const modeDebug = 0x30;

  /// 构建带真实 MAC 的 0x07 命令帧
  /// remoteId 格式 "98:DA:10:06:95:C0" → [98 DA 10 06 95 C0]
  /// ID 10 字节，前面补 00: 00 00 00 00 98 DA 10 06 95 C0
  List<int> _buildDeviceStatusCommand(String remoteId) {
    final macParts = remoteId.split(':').map((s) => int.parse(s, radix: 16)).toList();
    final idBytes = [0x00, 0x00, 0x00, 0x00, ...macParts]; // 4+6=10 bytes
    return [
      0x7D, 0x07, 0x0F, 0x00,
      ...idBytes,
      0x0D,
    ];
  }

  /// 心跳应答 0x08，每分钟发送一次，超 5 分钟未收到设备将重启 WiFi
  static const heartbeatCommand = [
    0x7D, 0x08, 0x0F, 0x00,
    0x55, 0x4E, 0x43, 0x4F, 0x4E, 0x46, 0x49, 0x47, 0x45, 0x44, 0x0D,
  ];

  /// 压力校准指令 0x09，设备强制停止工作并开始校准，约 4 秒返回
  static const pressureCalibrateCommand = [
    0x7D, 0x09, 0x0F, 0x00,
    0x55, 0x4E, 0x43, 0x4F, 0x4E, 0x46, 0x49, 0x47, 0x45, 0x44, 0x0D,
  ];

  /// 参数指令 0x0A 前缀（16 字节：7D 0A 10 00 ... 44 [子命令] 0D）
  static const _paramCommandPrefix = [
    0x7D, 0x0A, 0x10, 0x00,
    0x55, 0x4E, 0x43, 0x4F, 0x4E, 0x46, 0x49, 0x47, 0x45, 0x44,
  ];

  /// 校准时钟指令 0x0B 前缀（14 字节：7D 0B 10 00 ... 44 [4字节时间LE] 0D）
  static const _clockCalibratePrefix = [
    0x7D, 0x0B, 0x10, 0x00,
    0x55, 0x4E, 0x43, 0x4F, 0x4E, 0x46, 0x49, 0x47, 0x45, 0x44,
  ];

  /// 构建设备存储报表查询 0x13 命令，ID 从本地缓存读取
  Future<List<int>> _buildReportQueryCommand() async {
    final remoteId = _connectCubit.state.remoteId;
    final asciiId = remoteId != null
        ? await _secureStorage.getDeviceAsciiId(remoteId)
        : null;
    final id = asciiId ?? [0x55, 0x4E, 0x43, 0x4F, 0x4E, 0x46, 0x49, 0x47, 0x45, 0x44];
    return [0x7D, 0x13, 0x0F, 0x00, ...id, 0x0D];
  }

  /// 写入数据并记录发送日志
  Future<void> _writeWithLog(List<int> data) async {
    await _bleService.writeData(data);

    final now = DateTime.now();
    final time =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    final hex = data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    final logEntry = '$time  $hex';

    final log = List<String>.from(state.sentLog)..add(logEntry);
    if (log.length > _maxLogEntries) {
      log.removeAt(0);
    }
    emit(state.copyWith(sentLog: log));
  }

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
      _awaitingRetransmit30 = false;
      _retransmit30Buffer = [];
      _retransmit30Timer?.cancel();
      _retransmit30Timer = null;
      if (_retransmit30Completer != null && !_retransmit30Completer!.isCompleted) {
        _retransmit30Completer!.complete([]);
      }
      _retransmit30Completer = null;
      if (_firmwareVersionCompleter != null &&
          !_firmwareVersionCompleter!.isCompleted) {
        _firmwareVersionCompleter!.complete(null);
      }
      _firmwareVersionCompleter = null;
      if (_modeCommandCompleter != null && !_modeCommandCompleter!.isCompleted) {
        _modeCommandCompleter!.complete(-1);
      }
      _modeCommandCompleter = null;
      if (_deviceStatusCompleter != null && !_deviceStatusCompleter!.isCompleted) {
        _deviceStatusCompleter!.complete(null);
      }
      _deviceStatusCompleter = null;
      if (_parametersCompleter != null && !_parametersCompleter!.isCompleted) {
        _parametersCompleter!.complete(null);
      }
      _parametersCompleter = null;
      _reportBuffer = [];
      _reportBatchReceived = 0;
      if (_reportQueryCompleter != null && !_reportQueryCompleter!.isCompleted) {
        _reportQueryCompleter!.complete([]);
      }
      _reportQueryCompleter = null;
      if (_sleepDataCompleter != null && !_sleepDataCompleter!.isCompleted) {
        _sleepDataCompleter!.complete([]);
      }
      _sleepDataCompleter = null;
      _sleepDataBuffer = [];
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
      // 连接成功后自动查询设备状态（带 MAC 的 0x07）
      sendDeviceStatusCommand();
    } catch (e) {
      debugPrint('[数据管理] 启动数据流失败: $e');
      emit(state.copyWith(status: BleDataStatus.error, error: '$e'));
    }
  }

  /// 发送 BLE 命令并等待设备响应
  /// 返回 true 表示收到预期响应，false 表示超时或未连接
  Future<bool> sendCommand(
    List<int> data, {
    Duration timeout = _defaultTimeout,
  }) async {
    if (state.status != BleDataStatus.streaming) {
      debugPrint('[数据管理] sendCommand 失败: 未处于 streaming 状态');
      return false;
    }

    _responseCompleter = Completer<bool>();
    try {
      await _writeWithLog(data);
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

  /// 发送工作模式设定命令 0x04，等待 0x84 确认响应
  /// 返回响应内容字节（0x20/0x21/0x22/0x30/0x31），null 表示超时
  Future<int?> sendModeCommand(
    int mode, {
    Duration timeout = _defaultTimeout,
  }) async {
    if (state.status != BleDataStatus.streaming) {
      debugPrint('[数据管理] sendModeCommand 失败: 未处于 streaming 状态');
      return null;
    }

    _modeCommandCompleter = Completer<int>();
    try {
      final cmd = [..._modeCommandPrefix, mode, 0x0D];
      await _writeWithLog(cmd);
      debugPrint('[数据管理] 模式设定命令已发送 mode=0x${mode.toRadixString(16)}，等待 0x84 响应...');
      return await _modeCommandCompleter!.future.timeout(timeout, onTimeout: () {
        debugPrint('[数据管理] 模式设定响应超时');
        return -1;
      });
    } catch (e) {
      debugPrint('[数据管理] sendModeCommand 异常: $e');
      return null;
    } finally {
      _modeCommandCompleter = null;
    }
  }

  /// 发送设备控制帧 [A5 5A 电源 模式 功率 时间 目标温度 低水位 实际温度 控制模式 0]
  /// 优先读取 state.deviceInfo，无则读本地缓存，再无则用默认值
  /// 控制模式：自动模式=0，手动（制冷/制热）=1

  Future<bool> sendDeviceControlCommand({
    int? power,
    int? mode,
    int? workPower,
    int? workTime,
    int? targetTemp,
    int? lowWater,
    int? actualTemp,
  }) async {
    if (state.status != BleDataStatus.streaming) return false;

    final info = state.deviceInfo;

    // 设备参数：info 有则直接用，info==null 时读本地缓存，再无则默认值
    int baseMode, baseTarget, baseActual, baseTime, baseWater;
    if (info != null) {
      baseMode   = info.workMode;
      baseTarget = info.targetTemp;
      baseActual = info.actualTemp;
      baseTime   = info.workTime;
      baseWater  = info.lowWater;
    } else {
      final stored = await _secureStorage.getDeviceParams();
      baseMode   = stored['workMode']   ?? 0;
      baseTarget = stored['targetTemp'] ?? 30;
      baseActual = stored['actualTemp'] ?? 30;
      baseTime   = stored['workTime']   ?? 8;
      baseWater  = stored['lowWater']   ?? 0;
    }

    final pPower      = power      ?? info?.powerStatus ?? 1;
    final pMode       = mode       ?? baseMode;
    final pWorkPower  = workPower  ?? info?.workPower ?? 0;
    final pWorkTime   = workTime   ?? baseTime;
    final pTargetTemp = targetTemp ?? baseTarget;
    final pLowWater   = lowWater   ?? baseWater;
    final pActualTemp = actualTemp ?? baseActual;

    // 控制模式：自动(0) → 制冷/制热时手动(1)
    final pControlMode = (pMode == 1 || pMode == 2) ? 1 : 0;

    final dataBytes = [
      pPower, pMode, pWorkPower, pWorkTime,
      pTargetTemp, pLowWater, pActualTemp,
      pControlMode,
    ];
    final checksum = dataBytes.fold<int>(0, (s, b) => s + b) & 0xFF;

    final frame = [0xA5, 0x5A, ...dataBytes, checksum];
    debugPrint('[数据管理] sendDeviceControlCommand: ${frame.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
    await _writeWithLog(frame);
    return true;
  }

  /// 查询设备状态 0x07，等待 0x87 响应
  /// 返回 DeviceStatus（deviceId + 模式 + 错误 + 设备时间），null 表示超时或异常
  Future<DeviceStatus?> sendDeviceStatusCommand({
    Duration timeout = _defaultTimeout,
  }) async {
    if (state.status != BleDataStatus.streaming) {
      debugPrint('[数据管理] sendDeviceStatusCommand 失败: 未处于 streaming 状态');
      return null;
    }

    final remoteId = _connectCubit.state.remoteId;
    if (remoteId == null) {
      debugPrint('[数据管理] sendDeviceStatusCommand 失败: 无 remoteId');
      return null;
    }

    _deviceStatusCompleter = Completer<DeviceStatus?>();
    try {
      final cmd = _buildDeviceStatusCommand(remoteId);
      await _writeWithLog(cmd);
      debugPrint('[数据管理] 设备状态查询已发送（MAC=$remoteId），等待 0x87 响应...');
      return await _deviceStatusCompleter!.future.timeout(timeout, onTimeout: () {
        debugPrint('[数据管理] 设备状态查询超时');
        return null;
      });
    } catch (e) {
      debugPrint('[数据管理] sendDeviceStatusCommand 异常: $e');
      return null;
    } finally {
      _deviceStatusCompleter = null;
    }
  }

  /// 复位参数 0x0A+0x00，等待 0x8A 确认
  Future<bool> resetParameters({
    Duration timeout = _defaultTimeout,
  }) async {
    if (state.status != BleDataStatus.streaming) return false;
    final cmd = [..._paramCommandPrefix, 0x00, 0x0D];
    return sendCommand(cmd, timeout: timeout);
  }

  /// 读取参数 0x0A+0x01，等待 0x8A 返回 16 个 float 参数
  Future<DeviceParameters?> readParameters({
    Duration timeout = _defaultTimeout,
  }) async {
    if (state.status != BleDataStatus.streaming) return null;
    _parametersCompleter = Completer<DeviceParameters?>();
    try {
      final cmd = [..._paramCommandPrefix, 0x01, 0x0D];
      await _writeWithLog(cmd);
      debugPrint('[数据管理] 参数读取命令已发送，等待 0x8A 响应...');
      return await _parametersCompleter!.future.timeout(timeout, onTimeout: () {
        debugPrint('[数据管理] 参数读取超时');
        return null;
      });
    } catch (e) {
      debugPrint('[数据管理] readParameters 异常: $e');
      return null;
    } finally {
      _parametersCompleter = null;
    }
  }

  /// 设置参数 0x0A+0x02+[64字节]，等待 0x8A 确认
  Future<bool> setParameters(
    DeviceParameters params, {
    Duration timeout = _defaultTimeout,
  }) async {
    if (state.status != BleDataStatus.streaming) return false;
    final cmd = [..._paramCommandPrefix, 0x02, ...params.toBytes(), 0x0D];
    return sendCommand(cmd, timeout: timeout);
  }

  /// 校准时钟 0x0B，发送当前时间，设备更新时钟并返回 0x8B
  /// 可选传入指定时间，默认使用当前系统时间
  Future<bool> sendCalibrateClockCommand({
    DateTime? time,
    Duration timeout = _defaultTimeout,
  }) async {
    if (state.status != BleDataStatus.streaming) return false;
    final t = time ?? DateTime.now();
    final epoch = t.millisecondsSinceEpoch ~/ 1000;
    final timeBytes = [
      epoch & 0xFF,
      (epoch >> 8) & 0xFF,
      (epoch >> 16) & 0xFF,
      (epoch >> 24) & 0xFF,
    ];
    final cmd = [..._clockCalibratePrefix, ...timeBytes, 0x0D];
    debugPrint('[数据管理] 校准时钟: epoch=$epoch');
    return sendCommand(cmd, timeout: timeout);
  }

  /// 发送设备存储报表查询 0x13，等待设备回复 3 批 0x93 数据（共 15 组报表概要）
  /// 0x93 响应到达后自动保存到本地 Isar 数据库
  Future<List<ReportSummary>> sendReportQueryCommand({
    Duration timeout = _defaultTimeout,
  }) async {
    if (state.status != BleDataStatus.streaming) {
      debugPrint('[数据管理] sendReportQueryCommand 失败: 未处于 streaming 状态');
      return [];
    }

    _reportQueryCompleter = Completer<List<ReportSummary>>();
    _reportBuffer = [];
    _reportBatchReceived = 0;
    _lastReportAsciiId = '';
    emit(state.copyWith(reportQueryLoading: true));
    try {
      final cmd = await _buildReportQueryCommand();
      await _writeWithLog(cmd);
      debugPrint('[数据管理] 报表查询已发送，等待 0x93 响应...');
      final result = await _reportQueryCompleter!.future.timeout(
        timeout,
        onTimeout: () {
          debugPrint('[数据管理] 报表查询超时，已收到 $_reportBatchReceived 批');
          return List.unmodifiable(_reportBuffer);
        },
      );
      emit(state.copyWith(reportQueryLoading: false));
      return result;
    } catch (e) {
      debugPrint('[数据管理] sendReportQueryCommand 异常: $e');
      emit(state.copyWith(reportQueryLoading: false));
      return [];
    } finally {
      _reportQueryCompleter = null;
      _reportBuffer = [];
      _reportBatchReceived = 0;
    }
  }

  /// 发送设备存储数据读取 0x14，读取某个报表的某个 30 分钟段
  /// [startTime] 从 0x13 报表查询获得的 4 字节开始时间（LE）
  /// [seq] 序号 0~47，每序号 30 分钟，共 48×30=1440 分钟
  Future<List<SleepMinuteRecord>> sendSleepDataReadCommand({
    required int startTime,
    required int seq,
    Duration timeout = _defaultTimeout,
  }) async {
    if (state.status != BleDataStatus.streaming) {
      debugPrint('[数据管理] sendSleepDataReadCommand 失败: 未处于 streaming 状态');
      return [];
    }

    _sleepDataCompleter = Completer<List<SleepMinuteRecord>>();

    final remoteId = _connectCubit.state.remoteId;
    final asciiId = remoteId != null
        ? await _secureStorage.getDeviceAsciiId(remoteId)
        : null;
    final id = asciiId ?? [0x55, 0x4E, 0x43, 0x4F, 0x4E, 0x46, 0x49, 0x47, 0x45, 0x44];

    final cmd = [
      0x7D, 0x14, 0x14, 0x00,
      ...id,
      startTime & 0xFF, (startTime >> 8) & 0xFF,
      (startTime >> 16) & 0xFF, (startTime >> 24) & 0xFF,
      seq,
      0x0D,
    ];
    debugPrint('[数据管理] 读取存储数据: startTime=0x${startTime.toRadixString(16)}, seq=$seq');
    try {
      await _writeWithLog(cmd);
      return await _sleepDataCompleter!.future.timeout(
        timeout,
        onTimeout: () {
          debugPrint('[数据管理] 存储数据读取超时');
          return [];
        },
      );
    } catch (e) {
      debugPrint('[数据管理] sendSleepDataReadCommand 异常: $e');
      return [];
    } finally {
      _sleepDataCompleter = null;
    }
  }

  /// 批量拉取某个报表的全部分钟数据（seq 0~47，顺序执行，每段完成后才拉取下一段）
  ///
  /// [startTime] 从 0x93 报表解析的开始时间（Unix 秒，小端序 4 字节）
  /// [onProgress] 可选进度回调 (当前序号, 总数48)
  /// 返回全部记录列表，中途失败返回已拉取的部分数据
  Future<List<SleepMinuteRecord>> sendFullSleepDataReadCommand({
    required int startTime,
    void Function(int seq, int total)? onProgress,
  }) async {
    final allRecords = <SleepMinuteRecord>[];
    for (var seq = 0; seq < 48; seq++) {
      onProgress?.call(seq, 48);
      debugPrint('[数据管理] 拉取存储数据 seq=$seq/47');
      final records = await sendSleepDataReadCommand(startTime: startTime, seq: seq);
      if (records.isEmpty) {
        debugPrint('[数据管理] seq=$seq 无数据或错误，停止拉取');
        break;
      }
      allRecords.addAll(records);
    }
    debugPrint('[数据管理] 批量拉取完成: ${allRecords.length} 分钟');
    // 标记 dataLoaded
    final deviceId = _connectCubit.state.remoteId;
    if (deviceId != null && allRecords.isNotEmpty) {
      final frameStartTime = DateTime.fromMillisecondsSinceEpoch(startTime * 1000);
      await SleepDataRepository.markDataLoaded(deviceId, frameStartTime);
    }
    return allRecords;
  }

  /// 发送重传指令 0x01（过去 30 秒数据），等待设备回复 0x81 历史数据
  static const _retransmitCommand = [
    0x7D, 0x01, 0x0F, 0x00,
    0x55, 0x4E, 0x43, 0x4F, 0x4E, 0x46, 0x49, 0x47, 0x45, 0x44, 0x0D,
  ];
  static const _retransmitRecordSize = 12;

  /// 发送重传指令 0x02（过去 30 分钟），等待设备回复 0x82 数据
  static const _retransmit30Command = [
    0x7D, 0x02, 0x0F, 0x00,
    0x55, 0x4E, 0x43, 0x4F, 0x4E, 0x46, 0x49, 0x47, 0x45, 0x44, 0x0D,
  ];
  static const _retransmit30RecordSize = 15;

  Future<List<RetransmitRecord>> sendRetransmitCommand({
    Duration timeout = _defaultTimeout,
  }) async {
    if (state.status != BleDataStatus.streaming) {
      debugPrint('[数据管理] sendRetransmitCommand 失败: 未处于 streaming 状态');
      return [];
    }

    _awaitingRetransmit = true;
    _retransmitBuffer = [];
    _retransmitCompleter = Completer<List<RetransmitRecord>>();

    try {
      await _writeWithLog(_retransmitCommand);
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

  /// 发送重传指令 0x02（30分钟），等待设备回复 0x82 历史数据
  Future<List<Retransmit30Record>> sendRetransmit30Command({
    Duration timeout = _defaultTimeout,
  }) async {
    if (state.status != BleDataStatus.streaming) {
      debugPrint('[数据管理] sendRetransmit30Command 失败: 未处于 streaming 状态');
      return [];
    }

    _awaitingRetransmit30 = true;
    _retransmit30Buffer = [];
    _retransmit30Completer = Completer<List<Retransmit30Record>>();

    try {
      await _writeWithLog(_retransmit30Command);
      debugPrint('[数据管理] 重传指令(30分钟)已发送，等待 0x82 响应...');

      final result = await _retransmit30Completer!.future.timeout(
        timeout,
        onTimeout: () {
          debugPrint('[数据管理] 重传响应(30分钟)超时，尝试解析已有数据');
          return _parseRetransmit30Buffer();
        },
      );
      return result;
    } catch (e) {
      debugPrint('[数据管理] sendRetransmit30Command 异常: $e');
      return [];
    } finally {
      _awaitingRetransmit30 = false;
      _retransmit30Completer = null;
      _retransmit30Timer?.cancel();
      _retransmit30Timer = null;
      _retransmit30Buffer = [];
    }
  }

  List<Retransmit30Record> _parseRetransmit30Buffer() {
    final data = _retransmit30Buffer;
    if (data.length < _retransmit30RecordSize) {
      debugPrint('[数据管理] 重传数据(30分钟)不足一组: ${data.length}字节');
      return [];
    }
    final records = <Retransmit30Record>[];
    for (var i = 0; i + _retransmit30RecordSize <= data.length;
        i += _retransmit30RecordSize) {
      records.add(Retransmit30Record.fromBytes(data, i));
    }
    debugPrint('[数据管理] 解析重传记录(30分钟) ${records.length} 条');
    return records;
  }

  /// 发送固件版本查询命令，等待设备回复 0x8C 字符串
  Future<void> sendFirmwareVersionCommand({
    Duration timeout = _defaultTimeout,
  }) async {
    if (state.status != BleDataStatus.streaming) {
      debugPrint('[数据管理] sendFirmwareVersionCommand 失败: 未处于 streaming 状态');
      return;
    }

    _firmwareVersionCompleter = Completer<String?>();
    try {
      await _writeWithLog(_firmwareVersionCommand);
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
    final remoteId = _connectCubit.state.remoteId;
    final mtu = remoteId != null
        ? BluetoothDevice.fromId(remoteId).mtuNow
        : 0;
    debugPrint('[数据管理] MTU=$mtu, 收到数据 (${bytes.length}字节): ${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');

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
      // 设备信息（A5 5A 帧头，自动推送，11 字节）
      final info = DeviceInfo.fromBytes(bytes);
      debugPrint('[数据管理] 设备信息: $info');
      emit(state.copyWith(deviceInfo: info, lastReceived: bytes, rawLog: log));

      // 本地缓存设备参数（供断开/开机使用）
      unawaited(_secureStorage.saveDeviceParams(
        workMode: info.workMode,
        targetTemp: info.targetTemp,
        actualTemp: info.actualTemp,
        workTime: info.workTime,
        lowWater: info.lowWater,
      ));

      // 每 10 秒存储一次实际温度到 Isar
      final now = DateTime.now();
      if (now.difference(_lastTempSaveTime).inSeconds >= 10) {
        _lastTempSaveTime = now;
        final deviceId = _connectCubit.state.remoteId;
        if (deviceId != null) {
          unawaited(SleepDataRepository.saveTemperatureRecord(
            deviceId: deviceId,
            timestamp: now,
            temperature: info.actualTemp,
          ));
        }
      }
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x81) {
      // 0x81：重传响应（120秒），命令 0x01 触发，30组×12字节
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
      // 0x82：重传响应（30分钟），命令 0x02 触发，30组×15字节
      if (_awaitingRetransmit30) {
        // 重传响应（30分钟）：跳过帧头 + 数据类型（2字节），缓冲后续数据
        _retransmit30Buffer.addAll(bytes.sublist(2));
        debugPrint(
          '[数据管理] 重传数据缓冲(30分钟): +${bytes.length - 2}字节, '
          '累计${_retransmit30Buffer.length}字节',
        );
        _retransmit30Timer?.cancel();
        if (_retransmit30Buffer.length >= 30 * _retransmit30RecordSize) {
          _retransmit30Timer = null;
          if (_retransmit30Completer != null &&
              !_retransmit30Completer!.isCompleted) {
            _retransmit30Completer!.complete(_parseRetransmit30Buffer());
          }
        } else {
          _retransmit30Timer = Timer(
            const Duration(milliseconds: 500),
            () {
              debugPrint('[数据管理] 重传数据(30分钟) 500ms 无新包，解析已有数据');
              if (_retransmit30Completer != null &&
                  !_retransmit30Completer!.isCompleted) {
                _retransmit30Completer!.complete(_parseRetransmit30Buffer());
              }
            },
          );
        }
      } else {
        debugPrint('[数据管理] 收到 0x82 数据（非重传）: $bytes');
      }
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x8C) {
      // 0x8C：固件版本响应，命令 0x0C 触发，bytes[2..] 为版本字符串
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
    } else if (bytes.length >= 2 && bytes[0] == 0x7D && bytes[1] == _headerResponse) {
      // 0x97：恢复出厂设置完成响应，命令 0x17 触发
      debugPrint('[数据管理] 收到 0x97 响应: $bytes');
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
      if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
        _responseCompleter!.complete(true);
      }
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x83) {
      // 0x83：停止指令响应，命令 0x03 触发，设备进入待机模式
      debugPrint('[数据管理] 收到 0x83 响应: $bytes');
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
      if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
        _responseCompleter!.complete(true);
      }
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x84) {
      // 0x84：工作模式设定响应，命令 0x04 触发，bytes[2] 为确认内容
      final content = bytes.length >= 3 ? bytes[2] : 0;
      final contentHex = content.toRadixString(16).padLeft(2, '0');
      debugPrint('[数据管理] 收到 0x84 响应: content=0x$contentHex, $bytes');
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
      if (_modeCommandCompleter != null && !_modeCommandCompleter!.isCompleted) {
        _modeCommandCompleter!.complete(content);
      }
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x85) {
      // 0x85：实时秒数据（每秒），监控/调试模式下自动推送，12字节同 RetransmitRecord
      if (bytes.length >= 14) {
        final record = RetransmitRecord.fromBytes(bytes, 2);
        final updated = List<RetransmitRecord>.from(state.secondRecords)
          ..add(record);
        if (updated.length > 120) updated.removeAt(0);
        debugPrint('[数据管理] 0x85 实时数据: seq=${record.sequenceNo}, hr=${record.heartRate}, br=${record.breathRate}');
        emit(state.copyWith(
          latestSecondRecord: record,
          secondRecords: updated,
          lastReceived: bytes,
          rawLog: log,
        ));
      } else {
        emit(state.copyWith(lastReceived: bytes, rawLog: log));
      }
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x86) {
      // 0x86：实时分钟数据（每分钟），监控/调试模式下自动推送
      // 帧结构：[7D 86][数据 15B][0D]
      // 每组15字节: [序列号 1B][时间 4B LE][状态 1B][心率 1B][呼吸率 1B]
      //            [体动 1B][打鼾数 1B][呼吸障碍数 1B][PTHD 2B LE][TEMP 2B LE]
      if (bytes.length >= 18 && bytes[bytes.length - 1] == 0x0D) {
        final record = SleepMinuteRecord.fromBytesWithTime(bytes, 2);
        final updated = List<SleepMinuteRecord>.from(state.minuteRecords)
          ..add(record);
        if (updated.length > 30) updated.removeAt(0);
        debugPrint('[数据管理] 0x86 分钟数据: time=${record.dateTime}, '
            'status=${record.statusName}, hr=${record.heartRate}, br=${record.breathRate}');

        // 存入 DB
        final deviceId = _connectCubit.state.remoteId;
        if (deviceId != null && record.dateTime != null) {
          unawaited(SleepDataRepository.saveSleepMinuteData(
            deviceId: deviceId,
            groups: [(
              statusByte: record.status,
              heartRate: record.heartRate,
              breathRate: record.breathRate,
              bodyMove: record.bodyMovement,
              dateTime: record.dateTime!,
            )],
          ));
        }

        emit(state.copyWith(
          latestMinuteRecord: record,
          minuteRecords: updated,
          lastReceived: bytes,
          rawLog: log,
        ));
      } else {
        emit(state.copyWith(lastReceived: bytes, rawLog: log));
      }
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x87) {
      // 0x87：设备状态查询响应，命令 0x07 触发
      // 帧结构：[7D 87] [..2B] [ID 10B bytes4..13] [模式 1B] [错误 1B] [时间 4B BE] [0D]
      if (bytes.length >= 21) {
        final status = DeviceStatus.fromBytes(bytes);
        debugPrint('[数据管理] 设备状态: $status');
        emit(state.copyWith(
          deviceId: status.deviceId,
          lastReceived: bytes,
          rawLog: log,
        ));
        // 保存 asciiId 到本地，key 为当前连接的 remoteId
        final remoteId = _connectCubit.state.remoteId;
        if (remoteId != null && status.asciiId.isNotEmpty) {
          unawaited(_secureStorage.saveDeviceAsciiId(remoteId, status.asciiId));
        }
        if (_deviceStatusCompleter != null && !_deviceStatusCompleter!.isCompleted) {
          _deviceStatusCompleter!.complete(status);
        }
        // 拿到 asciiId 后自动查询存储报表（0x13）
        sendReportQueryCommand();
      } else {
        debugPrint('[数据管理] 0x87 响应数据不足: ${bytes.length}字节');
        emit(state.copyWith(lastReceived: bytes, rawLog: log));
        if (_deviceStatusCompleter != null && !_deviceStatusCompleter!.isCompleted) {
          _deviceStatusCompleter!.complete(null);
        }
      }
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x88) {
      // 0x88：心跳应答响应，命令 0x08 触发，内容无，保持设备联网
      debugPrint('[数据管理] 收到 0x88 心跳响应: $bytes');
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
      if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
        _responseCompleter!.complete(true);
      }
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x89) {
      // 0x89：压力校准响应，命令 0x09 触发，bytes[2] 为结果（0x00=完成，其他=无法校准）
      final result = bytes.length >= 3 ? bytes[2] : -1;
      final ok = result == 0x00;
      debugPrint('[数据管理] 收到 0x89 校准响应: result=0x${result.toRadixString(16).padLeft(2, '0')} (${ok ? "校准完成" : "无法校准"})');
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
      if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
        _responseCompleter!.complete(ok);
      }
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x8A) {
      // 0x8A：参数指令响应，命令 0x0A 触发
      // 响应帧头 16 字节后为内容：bytes[16] 为子命令
      final contentByte = bytes.length >= 17 ? bytes[16] : -1;
      debugPrint('[数据管理] 收到 0x8A 参数响应: content=0x${contentByte.toRadixString(16).padLeft(2, '0')}, ${bytes.length}字节');
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
      if (contentByte == 0x01 && bytes.length >= 81) {
        // 读取响应：0x01 + 64字节参数
        final params = DeviceParameters.fromBytes(bytes.sublist(17, 81));
        debugPrint('[数据管理] 参数读取成功: $params');
        if (_parametersCompleter != null && !_parametersCompleter!.isCompleted) {
          _parametersCompleter!.complete(params);
        }
      } else if (contentByte == 0x00 || contentByte == 0x02) {
        // 复位(0x00)或设置(0x02)成功
        if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
          _responseCompleter!.complete(true);
        }
        if (_parametersCompleter != null && !_parametersCompleter!.isCompleted) {
          _parametersCompleter!.complete(null);
        }
      } else if (contentByte == 0x03) {
        // 设置失败：数据位数不对或参数错误
        debugPrint('[数据管理] 参数设置失败: 数据错误');
        if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
          _responseCompleter!.complete(false);
        }
        if (_parametersCompleter != null && !_parametersCompleter!.isCompleted) {
          _parametersCompleter!.complete(null);
        }
      } else {
        if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
          _responseCompleter!.complete(false);
        }
        if (_parametersCompleter != null && !_parametersCompleter!.isCompleted) {
          _parametersCompleter!.complete(null);
        }
      }
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x8B) {
      // 0x8B：校准时钟响应，命令 0x0B 触发，内容无，设备时钟已更新
      debugPrint('[数据管理] 收到 0x8B 校准时钟响应: $bytes');
      emit(state.copyWith(lastReceived: bytes, rawLog: log));
      if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
        _responseCompleter!.complete(true);
      }
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x93) {
      // 0x93：设备存储报表查询响应，命令 0x13 触发
      // 帧结构：7D 93 [长度2B LE] [UNCONFIGED 10B] [序号1B] [5组×26B] 0D
      // 设备分 3 批发送（间隔 300ms），序号 = 0/1/2
      if (bytes.length >= 28) {
        // 提取 ASCII ID（bytes[4..13]）
        _lastReportAsciiId = String.fromCharCodes(bytes.sublist(4, 14));
        // UNCONFIGED 10B ([4..13]) 之后，记录数据从 bytes[14] 开始（seq = 首条记录首字节）
        final seq = bytes[14];
        final frameHex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
        debugPrint('[数据管理] 0x93 报表批次 $seq/2，${bytes.length}字节，asciiId=$_lastReportAsciiId');
        debugPrint('[数据管理] 0x93 帧原始数据: $frameHex');
        // 解析本批 5 组 × 26 字节（bytes[14] 开始）
        for (var i = 0; i < 5; i++) {
          final offset = 14 + i * 26;
          if (offset + 26 <= bytes.length) {
            final raw = bytes.sublist(offset, offset + 26);
            debugPrint('[数据管理] 0x93 组$i 原始数据: ${raw.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
            _reportBuffer.add(ReportSummary.fromBytes(bytes, offset));
          }
        }
        _reportBatchReceived++;
        emit(state.copyWith(lastReceived: bytes, rawLog: log));
        // 仅末尾批次带 0x0D 结束符
        final isLastBatch = bytes.last == 0x0D;
        debugPrint('[数据管理] 0x93 批次$_reportBatchReceived，尾帧=${isLastBatch ? "是" : "否"}');
        if (isLastBatch) {
          debugPrint('[数据管理] 报表查询完成: ${_reportBuffer.length} 条');
          // 收到全部 3 批，自动保存到数据库
          final deviceId = _connectCubit.state.remoteId;
          if (deviceId != null && _reportBuffer.isNotEmpty) {
            SleepDataRepository.saveReportSummaries(
              deviceId: deviceId,
              asciiId: _lastReportAsciiId,
              summaries: List.unmodifiable(_reportBuffer),
            ).then((_) {
              debugPrint('[数据管理] 报表已自动保存到数据库: ${_reportBuffer.length} 条');
            }).catchError((e) {
              debugPrint('[数据管理] 报表保存数据库失败: $e');
            });
          }
          if (_reportQueryCompleter != null && !_reportQueryCompleter!.isCompleted) {
            _reportQueryCompleter!.complete(List.unmodifiable(_reportBuffer));
          }
        }
      } else {
        debugPrint('[数据管理] 0x93 响应数据不足: ${bytes.length}字节');
        emit(state.copyWith(lastReceived: bytes, rawLog: log));
      }
    } else if (bytes.length >= 2 && bytes[1] == _headerCmd0x94) {
      // 0x94：分钟级睡眠数据，自动推送或 0x14 手动触发
      // 帧结构：[7D 94][长度2B][ID 10B][开始时间4B BE][序号1B][数据N×4B][0D仅末尾]
      // bytes[0]=7D, [1]=94, [2..3]=长度, [4..13]=ID, [14..17]=时间BE,
      // [18]=序号, [19..N-2]=数据, [N-1]=0D
      // 缓冲直到末尾为 0x0D
      _sleepDataBuffer.addAll(bytes);
      debugPrint('[数据管理] 0x94 累积 ${_sleepDataBuffer.length} 字节');

      if (_sleepDataBuffer.last != 0x0D) {
        // 数据未接收完，继续缓冲
        return;
      }

      // 数据接收完成，开始解析
      final buf = List<int>.from(_sleepDataBuffer);
      _sleepDataBuffer = [];

      if (buf.length < 20) {
        debugPrint('[数据管理] 0x94 数据过短: ${buf.length}字节');
        if (_sleepDataCompleter != null && !_sleepDataCompleter!.isCompleted) {
          _sleepDataCompleter!.complete([]);
        }
        return;
      }

      // 帧长度 bytes[2..3]（2字节，小端序）
      final frameLen = buf[2] | (buf[3] << 8);
      // ID bytes[4..13]（10字节 ASCII）
      final asciiId = String.fromCharCodes(buf.sublist(4, 14));
      // 开始时间 bytes[14..17] 小端序
      final timeRaw = buf[14] | (buf[15] << 8) | (buf[16] << 16) | (buf[17] << 24);
      // 序列号 bytes[18]
      final seq = buf[18];

      debugPrint('[数据管理] 0x94 帧长度=$frameLen, ID=$asciiId');

      if (seq == 0xFF) {
        debugPrint('[数据管理] 0x94 读取错误（序号0xFF）: 时间或序号无效');
        if (_sleepDataCompleter != null && !_sleepDataCompleter!.isCompleted) {
          _sleepDataCompleter!.complete([]);
        }
        return;
      }

      final frameStartTime = DateTime.fromMillisecondsSinceEpoch(timeRaw * 1000);
      debugPrint('[数据管理] 0x94 起始时间=$frameStartTime, 序号=$seq');

      // 数据组从 bytes[19] 到 bytes[N-2]（去掉末尾 0x0D）
      final dataStart = 19;
      final dataEnd = buf.length - 1; // 0x0D 之前
      final dataLen = dataEnd - dataStart;
      final groupCount = dataLen ~/ 4;

      if (groupCount <= 0) {
        debugPrint('[数据管理] 0x94 无有效数据组');
        if (_sleepDataCompleter != null && !_sleepDataCompleter!.isCompleted) {
          _sleepDataCompleter!.complete([]);
        }
        return;
      }

      final records = <SleepMinuteRecord>[];
      final dbGroups = <({int statusByte, int heartRate, int breathRate, int bodyMove, DateTime dateTime})>[];
      for (var i = 0; i < groupCount; i++) {
        final offset = dataStart + i * 4;
        final record = SleepMinuteRecord.from94Bytes(buf, offset);
        // dateTime = 帧开始时间 + (序号 × 30 + 组内序号) 分钟，秒归零
        final dt = frameStartTime.add(Duration(minutes: seq * 30 + i));
        final minuteDt = DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute);
        records.add(record);
        dbGroups.add((
          statusByte: record.status,
          heartRate: record.heartRate,
          breathRate: record.breathRate,
          bodyMove: record.bodyMovement,
          dateTime: minuteDt,
        ));
      }

      debugPrint('[数据管理] 0x94 解析完成: $groupCount 分钟, '
          '首条状态=${records.first.statusName}, '
          '末条状态=${records.last.statusName}');

      emit(state.copyWith(lastReceived: bytes, rawLog: log));

      // 存入 DB
      final deviceId = _connectCubit.state.remoteId;
      debugPrint('[数据管理] 0x94 准备存DB: deviceId=$deviceId, startTime=$frameStartTime');
      if (deviceId != null) {
        unawaited(SleepDataRepository.saveSleepMinuteData(
          deviceId: deviceId,
          groups: dbGroups,
        ));
      }

      if (_sleepDataCompleter != null && !_sleepDataCompleter!.isCompleted) {
        _sleepDataCompleter!.complete(records);
      }
    } else {
      // 未知数据类型：未匹配到已知帧头
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
    _awaitingRetransmit30 = false;
    _retransmit30Buffer = [];
    _retransmit30Timer?.cancel();
    _retransmit30Timer = null;
    if (_retransmit30Completer != null && !_retransmit30Completer!.isCompleted) {
      _retransmit30Completer!.complete([]);
    }
    _retransmit30Completer = null;
    if (_firmwareVersionCompleter != null &&
        !_firmwareVersionCompleter!.isCompleted) {
      _firmwareVersionCompleter!.complete(null);
    }
    _firmwareVersionCompleter = null;
    if (_modeCommandCompleter != null && !_modeCommandCompleter!.isCompleted) {
      _modeCommandCompleter!.complete(-1);
    }
    _modeCommandCompleter = null;
    if (_deviceStatusCompleter != null && !_deviceStatusCompleter!.isCompleted) {
      _deviceStatusCompleter!.complete(null);
    }
    _deviceStatusCompleter = null;
    if (_parametersCompleter != null && !_parametersCompleter!.isCompleted) {
      _parametersCompleter!.complete(null);
    }
    _parametersCompleter = null;
    _reportBuffer = [];
    _reportBatchReceived = 0;
    if (_reportQueryCompleter != null && !_reportQueryCompleter!.isCompleted) {
      _reportQueryCompleter!.complete([]);
    }
    _reportQueryCompleter = null;
    if (_sleepDataCompleter != null && !_sleepDataCompleter!.isCompleted) {
      _sleepDataCompleter!.complete([]);
    }
    _sleepDataCompleter = null;
    _sleepDataBuffer = [];
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
