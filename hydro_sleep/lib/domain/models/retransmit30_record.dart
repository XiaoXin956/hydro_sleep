/// 重传记录模型（30分钟） — 解析 0x82 响应中的每组 15 字节数据
///
/// 字节布局: [序列号 1B][时间 4B LE][状态 1B][心率 1B][呼吸率 1B]
///           [体动数 1B][打鼾数 1B][呼吸障碍数 1B][PTHD 2B LE][TEMP 2B LE]
class Retransmit30Record {
  final int sequenceNo;
  final DateTime? timestamp; // null if 0x00000000 (invalid)
  final int status;
  final int heartRate;
  final int breathRate;
  final int bodyMovement;
  final int snoreCount;
  final int respiratoryObstruction;
  final int pthd;
  final int temp;

  const Retransmit30Record({
    required this.sequenceNo,
    this.timestamp,
    required this.status,
    required this.heartRate,
    required this.breathRate,
    required this.bodyMovement,
    required this.snoreCount,
    required this.respiratoryObstruction,
    required this.pthd,
    required this.temp,
  });

  bool get isValid => timestamp != null;

  factory Retransmit30Record.fromBytes(List<int> bytes, int offset) {
    // 时间戳：小端序（低位在前高位在后）
    final timeRaw = bytes[offset + 1] |
        (bytes[offset + 2] << 8) |
        (bytes[offset + 3] << 16) |
        (bytes[offset + 4] << 24);

    return Retransmit30Record(
      sequenceNo: bytes[offset],
      timestamp: timeRaw == 0
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

  @override
  String toString() =>
      'Retransmit30Record(seq=$sequenceNo, time=$timestamp, '
      'status=$status, hr=$heartRate, br=$breathRate, '
      'mv=$bodyMovement, sn=$snoreCount, obs=$respiratoryObstruction, '
      'pthd=$pthd, temp=$temp)';
}
