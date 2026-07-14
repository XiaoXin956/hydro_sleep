/// 设备信息模型 — 解析 BLE 第一组数据（11 字节）
///
/// 字节布局: [A5][5A][电源][模式][功率][时间][目标温度][低水位][实际温度][控制模式][0]
class DeviceInfo {
  final int powerStatus;
  final int workMode; // 0=自动, 1=制冷, 2=制热
  final int workPower;
  final int workTime;
  final int targetTemp;   // [6] 目标温度
  final int lowWater;
  final int actualTemp;   // [8] 实际温度
  final int controlMode;  // [9] 0=自动, 1=手动（制冷/制热触发）

  const DeviceInfo({
    required this.powerStatus,
    required this.workMode,
    required this.workPower,
    required this.workTime,
    required this.targetTemp,
    required this.lowWater,
    required this.actualTemp,
    this.controlMode = 0,
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
      controlMode: bytes.length > 9 ? bytes[9] : 0,
    );
  }

  bool get isPoweredOff => powerStatus == 0;
  bool get isManualControl => controlMode == 1;

  String get modeName => switch (workMode) {
        0 => '自动',
        1 => '制冷',
        2 => '制热',
        _ => '未知($workMode)',
      };

  String get controlModeName => controlMode == 1 ? '手动' : '自动';

  @override
  String toString() =>
      'DeviceInfo(power=$powerStatus, mode=$modeName, power=$workPower, '
      'time=$workTime, target=$targetTemp°, lowWater=$lowWater, actual=$actualTemp°, '
      'control=$controlModeName)';
}
