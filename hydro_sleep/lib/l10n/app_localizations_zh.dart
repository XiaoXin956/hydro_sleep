// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'SmartSleep';

  @override
  String get smartSleepMonitor => '智能睡眠监测';

  @override
  String get bottomNavHome => '首页';

  @override
  String get bottomNavReport => '报告';

  @override
  String get bottomNavProfile => '我的';

  @override
  String get profileTitle => '我的';

  @override
  String get defaultUserName => '用户';

  @override
  String get myDevices => '我的设备';

  @override
  String get generalSettings => '通用设置';

  @override
  String get connected => '已连接';

  @override
  String get disconnected => '未连接';

  @override
  String get language => '语言';

  @override
  String get temperatureUnit => '温度单位';

  @override
  String get modePreference => '模式偏好';

  @override
  String get bedExitShutdown => '离床关机';

  @override
  String get restoreFactorySettings => '恢复出厂设置';

  @override
  String get reportTitle => '睡眠报告';

  @override
  String get sleepScore => '睡眠评分';

  @override
  String get totalSleep => '总睡眠时长';

  @override
  String get bedtimeToWakeUp => '入睡 → 起床';

  @override
  String get sleepStages => '睡眠阶段';

  @override
  String get sleepTempCurve => '睡眠与温度曲线';

  @override
  String get sleepLegend => '睡眠';

  @override
  String get tempLegend => '温度';

  @override
  String get heartRate => '心率';

  @override
  String get average => '平均';

  @override
  String get minimum => '最低';

  @override
  String get maximum => '最高';

  @override
  String get bpm => 'BPM';

  @override
  String get dateDay => '日';

  @override
  String get dateWeek => '周';

  @override
  String get dateMonth => '月';

  @override
  String get dateYear => '年';

  @override
  String get temperature => '温度';

  @override
  String currentTemp(int temp) {
    return '当前温度 $temp°C';
  }

  @override
  String targetTemp(int temp) {
    return '目标温度 $temp°C';
  }

  @override
  String get mode => '模式';

  @override
  String get autoMode => '自动模式';

  @override
  String get manualMode => '手动模式';

  @override
  String get schedule => '日程';

  @override
  String get autoAdjustDuringSleep => '睡眠期间自动调节';

  @override
  String get searchDevice => '搜索设备';

  @override
  String get availableDevices => '可用设备';

  @override
  String get previouslyConnected => '以往连接过的设备';

  @override
  String get reconnect => '重新连接';

  @override
  String get connectNewDevice => '连接新设备';

  @override
  String get addDevice => '添加设备';

  @override
  String get connect => '连接';

  @override
  String get notConnected => '设备未连接';

  @override
  String get cannotConnect => '无法连接';

  @override
  String get deviceConnected => '已连接';

  @override
  String get sleepStageDeep => '深睡';

  @override
  String get sleepStageLight => '浅睡';

  @override
  String get sleepStageRem => 'REM';

  @override
  String get sleepStageEyeMove => '眼动';

  @override
  String get sleepStageAwake => '清醒';

  @override
  String get factoryResetTitle => '恢复出厂设置';

  @override
  String get factoryResetMessage => '此操作将恢复所有设置为出厂默认值，且不可撤销。';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get showMore => '更多';

  @override
  String get showLess => '收起';
}
