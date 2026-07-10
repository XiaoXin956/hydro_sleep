/// 设备状态模型 — 解析 0x87 响应
///
/// 0x87 帧结构: [7D][87][..][ID 10B][模式 1B][错误 1B][时间 4B BE][0D]
/// fromBytes 接收完整帧 bytes，从 offset 0 开始
class DeviceStatus {
  final String deviceId; // bytes[4..13]，10字节 MAC（前面补 00）
  final int mode;        // bytes[14]
  final int error;       // bytes[15]（0x00=无错误）
  final DateTime? timestamp; // bytes[16..19] Unix 秒，大端序

  const DeviceStatus({
    required this.deviceId,
    required this.mode,
    required this.error,
    this.timestamp,
  });

  bool get isStandby => mode == 0x00;
  bool get isMonitorMode => mode == 0x20;
  bool get isDebugMode => mode == 0x30;
  bool get isBleDebugMode => mode == 0x40;
  bool get isFirmwareUpdate => mode == 0xF0;
  bool get hasError => error != 0x00;

  String get modeName {
    switch (mode) {
      case 0x00:
        return '待机模式';
      case 0x20:
        return '上位机监控模式';
      case 0x30:
        return '数据调试模式';
      case 0x40:
        return 'BLE调试模式';
      case 0xF0:
        return '等待固件更新';
      default:
        return '未知(0x${mode.toRadixString(16).padLeft(2, '0')})';
    }
  }

  /// 解析完整 0x87 帧（至少 21 字节）
  factory DeviceStatus.fromBytes(List<int> bytes) {
    if (bytes.length < 21) {
      return const DeviceStatus(deviceId: '', mode: 0, error: 0);
    }
    // bytes[4..13] = 10字节 ID
    final idBytes = bytes.sublist(4, 14);
    final id = idBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    // bytes[14] = mode, bytes[15] = error
    final mode = bytes[14];
    final error = bytes[15];
    // bytes[16..19] = Unix 秒，大端序
    final timeRaw = (bytes[16] << 24) | (bytes[17] << 16) | (bytes[18] << 8) | bytes[19];
    return DeviceStatus(
      deviceId: id,
      mode: mode,
      error: error,
      timestamp: timeRaw == 0 ? null : DateTime.fromMillisecondsSinceEpoch(timeRaw * 1000),
    );
  }

  @override
  String toString() =>
      'DeviceStatus(id=$deviceId, mode=$modeName, error=${hasError ? "0x${error.toRadixString(16)}" : "无"}, time=$timestamp)';
}
