/// 睡眠分钟记录模型 — 解析 0x94 响应中的每分钟 4 字节数据
///
/// 字节布局: [状态 1B][心率 1B][呼吸率 1B][体动 1B]
///
/// 状态值:
///   实时: 0x01离床 0x02体动 0x03坐起 0x04睡眠 0x05清醒 0x06重物
///   解析: 0x11深睡 0x12浅睡 0x13REM 0x14清醒 0x15离床 0x16重物
class SleepMinuteRecord {
  final int status;
  final int heartRate;
  final int breathRate;
  final int bodyMovement;

  const SleepMinuteRecord({
    required this.status,
    required this.heartRate,
    required this.breathRate,
    required this.bodyMovement,
  });

  /// 从 4 字节解析
  factory SleepMinuteRecord.fromBytes(List<int> bytes, int offset) {
    return SleepMinuteRecord(
      status: bytes[offset],
      heartRate: bytes[offset + 1],
      breathRate: bytes[offset + 2],
      bodyMovement: bytes[offset + 3],
    );
  }

  /// 显示用状态名（合并实时/解析状态）
  String get statusName {
    switch (status) {
      case 0x01:
      case 0x15:
        return '离床';
      case 0x02:
        return '体动';
      case 0x03:
        return '坐起';
      case 0x04:
      case 0x12:
        return '浅睡眠';
      case 0x05:
      case 0x14:
        return '清醒';
      case 0x06:
      case 0x16:
        return '离床'; // 重物按离床处理
      case 0x11:
        return '深睡眠';
      case 0x13:
        return 'REM';
      default:
        return '未知(0x${status.toRadixString(16).padLeft(2, '0')})';
    }
  }

  @override
  String toString() =>
      'SleepMinute(status=$statusName, hr=$heartRate, br=$breathRate, mv=$bodyMovement)';
}
