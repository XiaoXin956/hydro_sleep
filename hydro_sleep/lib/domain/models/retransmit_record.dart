/// 重传记录模型 — 解析 0x81 响应中的每组 12 字节数据
///
/// 字节布局: [序列号 1B][时间 4B][状态 1B][心率 1B][呼吸率 1B][SDATA 2B][PDATA 2B]
class RetransmitRecord {
  final int sequenceNo;
  final DateTime? timestamp; // null if 0x00000000 (invalid)
  final int status;
  final int heartRate;
  final int breathRate;
  final int sdata;
  final int pdata;

  const RetransmitRecord({
    required this.sequenceNo,
    this.timestamp,
    required this.status,
    required this.heartRate,
    required this.breathRate,
    required this.sdata,
    required this.pdata,
  });

  bool get isValid => timestamp != null;

  factory RetransmitRecord.fromBytes(List<int> bytes, int offset) {
    final timeRaw = (bytes[offset + 1] << 24) |
        (bytes[offset + 2] << 16) |
        (bytes[offset + 3] << 8) |
        bytes[offset + 4];

    return RetransmitRecord(
      sequenceNo: bytes[offset],
      timestamp: timeRaw == 0
          ? null
          : DateTime.fromMillisecondsSinceEpoch(timeRaw * 1000),
      status: bytes[offset + 5],
      heartRate: bytes[offset + 6],
      breathRate: bytes[offset + 7],
      sdata: (bytes[offset + 8] << 8) | bytes[offset + 9],
      pdata: (bytes[offset + 10] << 8) | bytes[offset + 11],
    );
  }

  @override
  String toString() =>
      'RetransmitRecord(seq=$sequenceNo, time=$timestamp, '
      'status=$status, hr=$heartRate, br=$breathRate, '
      's=$sdata, p=$pdata)';
}
