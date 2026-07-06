/// 设备存储报表概要模型 — 解析 0x93 响应中的每组 26 字节数据
///
/// 字节布局: [开始时间 4B LE][22字节结论数据 = 11个uint16 LE]
class ReportSummary {
  final DateTime? startTime; // null = 无效记录（0xFFFFFFFF）
  final int totalSleepMinutes; // 睡眠总时长（分钟）
  final int sleepEfficiency; // 睡眠效率（0~100%）
  final int sleepQuality; // 睡眠质量（0~100分）
  final int turnOverCount; // 翻身次数
  final int sleepLatencyMinutes; // 睡眠潜时（分钟）
  final int leaveBedCount; // 离床次数
  final int sleepRhythmPhase; // 睡眠节律相位
  final int reserved1; // slop1 留用
  final int longestSleepStartMinute; // 最长睡眠开始分钟点（0~1440）
  final int ahiIndex; // 呼吸障碍指数 AHI
  final int snoreTotalCount; // 打鼾总次数

  const ReportSummary({
    this.startTime,
    required this.totalSleepMinutes,
    required this.sleepEfficiency,
    required this.sleepQuality,
    required this.turnOverCount,
    required this.sleepLatencyMinutes,
    required this.leaveBedCount,
    required this.sleepRhythmPhase,
    required this.reserved1,
    required this.longestSleepStartMinute,
    required this.ahiIndex,
    required this.snoreTotalCount,
  });

  bool get isValid => startTime != null && totalSleepMinutes > 0 && totalSleepMinutes != 0xFFFF;

  /// 从 26 字节解析（offset 为该组数据在帧中的起始位置）
  factory ReportSummary.fromBytes(List<int> bytes, int offset) {
    // 时间戳 4 字节 BE（设备发送大端序）
    final t0 = bytes[offset];
    final t1 = bytes[offset + 1];
    final t2 = bytes[offset + 2];
    final t3 = bytes[offset + 3];
    final isAllFF = t0 == 0xFF && t1 == 0xFF && t2 == 0xFF && t3 == 0xFF;
    final timeRaw = (t0 << 24) | (t1 << 16) | (t2 << 8) | t3;

    return ReportSummary(
      startTime: isAllFF || timeRaw == 0
          ? null
          : DateTime.fromMillisecondsSinceEpoch(timeRaw * 1000),
      totalSleepMinutes: _u16LE(bytes, offset + 4),
      sleepEfficiency: _u16LE(bytes, offset + 6),
      sleepQuality: _u16LE(bytes, offset + 8),
      turnOverCount: _u16LE(bytes, offset + 10),
      sleepLatencyMinutes: _u16LE(bytes, offset + 12),
      leaveBedCount: _u16LE(bytes, offset + 14),
      sleepRhythmPhase: _u16LE(bytes, offset + 16),
      reserved1: _u16LE(bytes, offset + 18),
      longestSleepStartMinute: _u16LE(bytes, offset + 20),
      ahiIndex: _u16LE(bytes, offset + 22),
      snoreTotalCount: _u16LE(bytes, offset + 24),
    );
  }

  static int _u16LE(List<int> bytes, int offset) =>
      bytes[offset] | (bytes[offset + 1] << 8);

  @override
  String toString() =>
      'ReportSummary(time=$startTime, sleep=${totalSleepMinutes}min, '
      'eff=$sleepEfficiency%, quality=$sleepQuality, '
      'turns=$turnOverCount, latency=${sleepLatencyMinutes}min, '
      'leave=$leaveBedCount, ahi=$ahiIndex, snore=$snoreTotalCount)';
}
