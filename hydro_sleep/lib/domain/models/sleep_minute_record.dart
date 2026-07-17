/// 睡眠分钟记录模型 — 解析 0x94 / 0x82 / 0x86 响应中的每分钟数据
///
/// 0x94 每组 4 字节: [状态 1B][心率 1B][呼吸率 1B][体动 1B]
/// 0x82 每组15 字节: [序列号 1B][时间 4B LE][状态 1B][心率 1B][呼吸率 1B]
///                    [体动 1B][打鼾数 1B][呼吸障碍数 1B][PTHD 2B LE][TEMP 2B LE]
/// 0x86 每组15 字节: 同 0x82 格式
///
/// 状态值:
///   实时: 0x01离床 0x02体动 0x03坐起 0x04睡眠 0x05清醒 0x06重物
///   解析: 0x11深睡 0x12浅睡 0x13REM 0x14清醒 0x15离床 0x16重物
class SleepMinuteRecord {
  /// 该分钟的起始时间（由帧头 startTime + 序号计算，0x94 专用）
  final DateTime? dateTime;

  /// 睡眠状态字节（见 statusName 映射）
  final int status;

  /// 心率（bpm，无符号 1 字节，离床时 = 0）
  final int heartRate;

  /// 呼吸率（次/分钟，无符号 1 字节，离床时 = 0）
  final int breathRate;

  /// 体动次数（无符号 1 字节）
  final int bodyMovement;

  /// 打鼾次数（0x82 专用，0x94 无此字段）
  final int? snoreCount;

  /// 呼吸障碍次数（0x82 专用，0x94 无此字段）
  final int? respiratoryObstruction;

  /// PTHD 值（2 字节小端序，0x82 专用）
  final int? pthd;

  /// 温度值（2 字节小端序，0x82 专用，单位取决于设备配置）
  final int? temp;

  const SleepMinuteRecord({
    this.dateTime,
    required this.status,
    required this.heartRate,
    required this.breathRate,
    required this.bodyMovement,
    this.snoreCount,
    this.respiratoryObstruction,
    this.pthd,
    this.temp,
  });

  /// 从 0x94 数据 4 字节解析（不含额外字段）
  factory SleepMinuteRecord.fromBytes(List<int> bytes, int offset) {
    return SleepMinuteRecord(
      status: bytes[offset],
      heartRate: bytes[offset + 1],
      breathRate: bytes[offset + 2],
      bodyMovement: bytes[offset + 3],
    );
  }

  /// 从 0x86 实时分钟数据 15 字节解析（同 0x82 格式，0x86 类型专用）
  ///
  /// 结构: [序列号 1B][时间 4B LE][状态 1B][心率 1B][呼吸率 1B]
  ///       [体动 1B][打鼾数 1B][呼吸障碍数 1B][PTHD 2B LE][TEMP 2B LE]
  factory SleepMinuteRecord.fromBytesWithTime(List<int> bytes, int offset) {
    final timeRaw = bytes[offset + 1] |
        (bytes[offset + 2] << 8) |
        (bytes[offset + 3] << 16) |
        (bytes[offset + 4] << 24);
    return SleepMinuteRecord(
      dateTime: timeRaw == 0
          ? null
          : DateTime.fromMillisecondsSinceEpoch(timeRaw * 1000),
      status: bytes[offset + 5],
      heartRate: bytes[offset + 6],
      breathRate: bytes[offset + 7],
      bodyMovement: bytes[offset + 8],
      snoreCount: bytes[offset + 9],
      respiratoryObstruction: bytes[offset + 10],
      pthd: bytes[offset + 11] | (bytes[offset + 12] << 8),
      temp: bytes[offset + 13] | (bytes[offset + 14] << 8),
    );
  }

  /// 从 0x82 数据 15 字节解析（含打鼾、呼吸障碍、PTHD、温度）
  factory SleepMinuteRecord.fromRetransmit30Bytes(List<int> bytes, int offset) {
    final timeRaw = bytes[offset + 1] |
        (bytes[offset + 2] << 8) |
        (bytes[offset + 3] << 16) |
        (bytes[offset + 4] << 24);
    return SleepMinuteRecord(
      dateTime: timeRaw == 0
          ? null
          : DateTime.fromMillisecondsSinceEpoch(timeRaw * 1000),
      status: bytes[offset + 5],
      heartRate: bytes[offset + 6],
      breathRate: bytes[offset + 7],
      bodyMovement: bytes[offset + 8],
      snoreCount: bytes[offset + 9],
      respiratoryObstruction: bytes[offset + 10],
      pthd: bytes[offset + 11] | (bytes[offset + 12] << 8),
      temp: bytes[offset + 13] | (bytes[offset + 14] << 8),
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
      'SleepMinute(time=$dateTime, status=$statusName, hr=$heartRate, '
      'br=$breathRate, mv=$bodyMovement, sn=$snoreCount, '
      'obs=$respiratoryObstruction, pthd=$pthd, temp=$temp)';
}
