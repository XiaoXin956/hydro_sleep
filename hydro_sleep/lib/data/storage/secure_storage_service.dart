import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 安全存储服务
class SecureStorageService {
  SecureStorageService._();

  static final SecureStorageService _instance = SecureStorageService._();
  factory SecureStorageService() => _instance;

  static const _storage = FlutterSecureStorage();

  // Key 常量
  static const _keyTheme = 'theme_mode';
  static const _keyLanguage = 'language';
  static const _keyTempUnit = 'temp_unit';
  static const _keyScheduleStart = 'schedule_start';
  static const _keyScheduleEnd = 'schedule_end';
  static const _keyHistoryDevices = 'history_devices';
  static const _keyLastDeviceId = 'last_device_id';
  static const _keyBedExitShutdown = 'bed_exit_shutdown';

  // 主题
  Future<String?> getTheme() async => await _storage.read(key: _keyTheme);
  Future<void> saveTheme(String theme) async =>
      await _storage.write(key: _keyTheme, value: theme);

  // 语言
  Future<String?> getLanguage() async => await _storage.read(key: _keyLanguage);
  Future<void> saveLanguage(String language) async =>
      await _storage.write(key: _keyLanguage, value: language);

  // 温度单位
  Future<String?> getTempUnit() async => await _storage.read(key: _keyTempUnit);
  Future<void> saveTempUnit(String unit) async =>
      await _storage.write(key: _keyTempUnit, value: unit);

  // 日程
  Future<String?> getScheduleStart() async =>
      await _storage.read(key: _keyScheduleStart);
  Future<void> saveScheduleStart(String start) async =>
      await _storage.write(key: _keyScheduleStart, value: start);

  Future<String?> getScheduleEnd() async =>
      await _storage.read(key: _keyScheduleEnd);
  Future<void> saveScheduleEnd(String end) async =>
      await _storage.write(key: _keyScheduleEnd, value: end);

  // 历史设备（JSON 字符串）
  Future<String?> getHistoryDevices() async =>
      await _storage.read(key: _keyHistoryDevices);
  Future<void> saveHistoryDevices(String json) async =>
      await _storage.write(key: _keyHistoryDevices, value: json);

  // 上次连接的设备 ID
  Future<String?> getLastDeviceId() async =>
      await _storage.read(key: _keyLastDeviceId);
  Future<void> saveLastDeviceId(String id) async =>
      await _storage.write(key: _keyLastDeviceId, value: id);

  // 离床关机
  Future<String?> getBedExitShutdown() async =>
      await _storage.read(key: _keyBedExitShutdown);
  Future<void> saveBedExitShutdown(String value) async =>
      await _storage.write(key: _keyBedExitShutdown, value: value);
}
