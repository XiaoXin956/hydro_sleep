/// 设备信息模型 — 解析 BLE 第一组数据（11 字节）
///
/// 字节布局: [0xA5][0x5A][电源][模式][功率][时间][目标温度][低水位][实际温度][0][0]
class DeviceInfo {
  final int powerStatus;
  final int workMode; // 0=自动, 1=制冷, 2=制热
  final int workPower;
  final int workTime;
  final int targetTemp;   // [6] 目标温度
  final int lowWater;
  final int actualTemp;   // [8] 实际温度

  const DeviceInfo({
    required this.powerStatus,
    required this.workMode,
    required this.workPower,
    required this.workTime,
    required this.targetTemp,
    required this.lowWater,
    required this.actualTemp,
  });

  factory DeviceInfo.fromBytes(List<int> bytes) {
    return DeviceInfo(
      powerStatus: bytes[2],
      workMode: bytes[3],
      workPower: bytes[4],
      workTime: bytes[5],
      targetTemp: bytes[6],
      lowWater: bytes[7],
      actualTemp: bytes[8],
    );
  }

  String get modeName => switch (workMode) {
        0 => '自动',
        1 => '制冷',
        2 => '制热',
        _ => '未知($workMode)',
      };

  @override
  String toString() =>
      'DeviceInfo(power=$powerStatus, mode=$modeName, power=$workPower, '
      'time=$workTime, target=$targetTemp°, lowWater=$lowWater, actual=$actualTemp°)';
}
