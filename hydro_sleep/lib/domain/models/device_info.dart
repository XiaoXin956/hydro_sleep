/// 设备信息模型 — 解析 BLE 第一组数据（11 字节）
///
/// 字节布局: [0xA5][0x5A][电源][模式][功率][时间][温度][低水位][NTC高][NTC低][0]
class DeviceInfo {
  final int powerStatus;
  final int workMode; // 1=自动, 2=手动
  final int workPower;
  final int workTime;
  final int workTemp;
  final int lowWater;
  final int ntcValue;

  const DeviceInfo({
    required this.powerStatus,
    required this.workMode,
    required this.workPower,
    required this.workTime,
    required this.workTemp,
    required this.lowWater,
    required this.ntcValue,
  });

  factory DeviceInfo.fromBytes(List<int> bytes) {
    return DeviceInfo(
      powerStatus: bytes[2],
      workMode: bytes[3],
      workPower: bytes[4],
      workTime: bytes[5],
      workTemp: bytes[6],
      lowWater: bytes[7],
      ntcValue: (bytes[8] << 8) | bytes[9],
    );
  }

  String get modeName => workMode == 1 ? '自动' : '手动';

  @override
  String toString() =>
      'DeviceInfo(power=$powerStatus, mode=$modeName, power=$workPower, '
      'time=$workTime, temp=$workTemp°, lowWater=$lowWater, ntc=$ntcValue)';
}
