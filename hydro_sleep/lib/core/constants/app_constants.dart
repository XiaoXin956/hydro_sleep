/// 应用常量
class AppConstants {
  AppConstants._();

  static const String appName = 'SmartSleep';
  static const String appVersion = '0.0.1';
  static const String defaultProfileName = '用户';
  static const String defaultAvatarUrl = ''; // 暂无头像资源

  // 温度范围
  static const double temperatureMin = 28.0;
  static const double temperatureMax = 38.0;

  // 快捷预设温度
  static const List<double> temperaturePresets = [28, 30, 33, 36];

  // 快捷预设名称
  static const List<String> temperaturePresetNames = ['节能', '舒适', '温暖', '高温'];

  // 日程默认值
  static const String defaultScheduleStart = '23:00';
  static const String defaultScheduleEnd = '06:00';

  // 离床关机选项
  static const List<String> bedExitOptions = ['10min', '20min', '30min'];

  // 语言选项
  static const List<String> languageOptions = ['English', '中文'];

  // 温度单位选项
  static const List<String> temperatureUnitOptions = ['°C', '°F'];

  // 评分维度
  static const int scoreMax = 100;
}
