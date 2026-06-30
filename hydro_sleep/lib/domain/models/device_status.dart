/// 设备状态模型 — 解析 0x87 响应中的 6 字节内容
///
/// 字节布局: [模式 1B][错误 1B][时间 4B LE]
class DeviceStatus {
  final int mode;
  final int error;
  final DateTime? timestamp;

  const DeviceStatus({
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

  factory DeviceStatus.fromBytes(List<int> bytes) {
    // bytes 从偏移 0 开始（已跳过帧头+类型）
    final timeRaw = bytes.length >= 6
        ? bytes[2] | (bytes[3] << 8) | (bytes[4] << 16) | (bytes[5] << 24)
        : 0;
    return DeviceStatus(
      mode: bytes.isNotEmpty ? bytes[0] : 0,
      error: bytes.length >= 2 ? bytes[1] : 0,
      timestamp: timeRaw == 0 ? null : DateTime.fromMillisecondsSinceEpoch(timeRaw * 1000),
    );
  }

  @override
  String toString() =>
      'DeviceStatus(mode=$modeName, error=${hasError ? "0x${error.toRadixString(16)}" : "无"}, time=$timestamp)';
}
