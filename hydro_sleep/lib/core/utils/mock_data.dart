/// 报告页测试数据
class MockData {
  MockData._();

  // 睡眠评分
  static const int sleepScore = 82;

  // 睡眠时长
  static const String sleepDuration = '7h 40m';

  // 入睡 / 起床时间
  static const String bedtime = '23:15';
  static const String wakeTime = '06:55';

  // 睡眠阶段数据
  static const List<Map<String, dynamic>> sleepStages = [
    {
      'name': 'Deep',
      'duration': '2h 15m',
      'percentage': 29,
      'colorHex': '0xFF1976D2',
    },
    {
      'name': 'Light',
      'duration': '3h 18m',
      'percentage': 40,
      'colorHex': '0xFF66BB6A',
    },
    {
      'name': 'REM',
      'duration': '1h 20m',
      'percentage': 18,
      'colorHex': '0xFF7E57C2',
    },
    {
      'name': 'Active',
      'duration': '15m',
      'percentage': 3,
      'colorHex': '0xFFFFCA28',
    },
  ];

  // 睡眠曲线数据（横坐标：入睡时间点到起床时间点，0-475分钟=7h55m）
  static const List<double> sleepCurve = [
    0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.85, 0.9, 0.92, 0.95,
    0.93, 0.9, 0.88, 0.85, 0.82, 0.8, 0.78, 0.75, 0.72, 0.7,
    0.68, 0.65, 0.63, 0.6, 0.58, 0.55, 0.53, 0.5, 0.48, 0.45,
    0.43, 0.4, 0.38, 0.35, 0.33, 0.3, 0.28, 0.25, 0.23, 0.2,
    0.22, 0.25, 0.28, 0.3, 0.33, 0.35, 0.38, 0.4, 0.45, 0.5,
    0.6, 0.7, 0.8, 0.85, 0.9, 0.93, 0.95, 0.97,
  ];

  // 睡眠阶段曲线数据（双 Y 轴用，5=深睡 4=浅睡 3=REM 2=快速眼动 1=醒来）
  static const List<double> sleepStagesCurve = [
    // 23:00-23:30 醒
    1.0, 1.0, 1.0, 1.0, 1.0,
    // 23:30-00:00 入睡→深睡
    2.0, 2.0, 3.0, 4.0, 5.0,
    // 00:00-01:30 深睡
    5.0, 5.0, 5.0, 5.0, 5.0,
    5.0, 5.0, 5.0, 5.0, 5.0,
    // 01:30-02:30 浅睡
    4.0, 4.0, 4.0, 4.0, 4.0,
    4.0, 4.0, 4.0, 4.0, 4.0,
    // 02:30-03:30 REM
    3.0, 3.0, 3.0, 3.0, 3.0,
    3.0, 3.0, 3.0, 3.0, 3.0,
    // 03:30-05:00 浅睡
    4.0, 4.0, 4.0, 4.0, 4.0,
    4.0, 4.0, 4.0, 4.0, 4.0,
    4.0, 4.0, 4.0, 4.0, 4.0,
    // 05:00-06:00 REM→醒
    3.0, 3.0, 2.0, 2.0, 2.0,
    1.0, 1.0, 1.0, 1.0,
  ];

  // 温度曲线数据（20-26°C）
  static const List<double> temperatureCurve = [
    22.0, 21.8, 21.5, 21.3, 21.0, 20.8, 20.6, 20.5, 20.4, 20.3,
    20.2, 20.1, 20.0, 20.0, 19.9, 19.8, 19.8, 19.7, 19.7, 19.6,
    19.5, 19.5, 19.6, 19.7, 19.8, 19.9, 20.0, 20.1, 20.2, 20.3,
    20.4, 20.5, 20.6, 20.8, 21.0, 21.2, 21.5, 21.8, 22.0, 22.2,
    22.5, 22.8, 23.0, 23.2, 23.5, 23.8, 24.0, 24.2, 24.5, 24.8,
    25.0, 25.2, 25.5,
  ];

  // 心率数据
  static const int avgHeartRate = 62;
  static const int minHeartRate = 48;
  static const int maxHeartRate = 85;

  // 心率曲线
  static const List<double> heartRateCurve = [
    65, 63, 60, 58, 56, 55, 54, 53, 52, 52,
    51, 50, 50, 51, 52, 53, 54, 55, 56, 57,
    58, 60, 62, 64, 66, 68, 70, 72, 74, 76,
    78, 80, 82, 85, 83, 80, 78, 75, 72, 70,
    68, 66, 64, 63, 62, 61, 60, 60, 59, 58,
    57, 56, 55,
  ];

  // 测试设备列表
  static const List<Map<String, dynamic>> testDevices = [
    {
      'name': 'SmartSleep Pro',
      'id': 'UID-8A3F2B',
      'rssi': -45,
      'connected': false,
    },
    {
      'name': 'SmartSleep Lite',
      'id': 'UID-9C1E4D',
      'rssi': -62,
      'connected': false,
    },
    {
      'name': 'SmartSleep Basic',
      'id': 'UID-5D7A1F',
      'rssi': -78,
      'connected': false,
    },
  ];

  // 历史设备
  static const List<Map<String, dynamic>> historyDevices = [
    {
      'name': 'SmartSleep Pro (旧)',
      'id': 'UID-3B2C8E',
      'lastConnected': '2026-06-10',
    },
  ];
}
