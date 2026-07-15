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
  // 设备参数（本地缓存，供断开后重连/开机使用）
  static const _keyDeviceWorkMode = 'device_work_mode';
  static const _keyDeviceTargetTemp = 'device_target_temp';
  static const _keyDeviceActualTemp = 'device_actual_temp';
  static const _keyDeviceWorkTime = 'device_work_time';
  static const _keyDeviceLowWater = 'device_low_water';

  /// 保存设备 ASCII ID（bytes[4..13]），key 按 remoteId 区分
  String _asciiIdKey(String remoteId) => 'device_ascii_id_$remoteId';

  Future<void> saveDeviceAsciiId(String remoteId, List<int> asciiId) async {
    final hex = asciiId.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
    await _storage.write(key: _asciiIdKey(remoteId), value: hex);
  }

  Future<List<int>?> getDeviceAsciiId(String remoteId) async {
    final hex = await _storage.read(key: _asciiIdKey(remoteId));
    if (hex == null || hex.isEmpty) return null;
    return hex.split(' ').map((s) => int.parse(s, radix: 16)).toList();
  }

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

  // 设备参数（供断开后重连/开机使用，模式调整后保存）
  Future<Map<String, int>> getDeviceParams() async {
    final mode = await _storage.read(key: _keyDeviceWorkMode);
    final target = await _storage.read(key: _keyDeviceTargetTemp);
    final actual = await _storage.read(key: _keyDeviceActualTemp);
    final time = await _storage.read(key: _keyDeviceWorkTime);
    final water = await _storage.read(key: _keyDeviceLowWater);
    return {
      'workMode': mode != null ? int.tryParse(mode) ?? 0 : 0,
      'targetTemp': target != null ? int.tryParse(target) ?? 30 : 30,
      'actualTemp': actual != null ? int.tryParse(actual) ?? 30 : 30,
      'workTime': time != null ? int.tryParse(time) ?? 8 : 8,
      'lowWater': water != null ? int.tryParse(water) ?? 0 : 0,
    };
  }

  Future<void> saveDeviceParams({
    required int workMode,
    required int targetTemp,
    required int actualTemp,
    required int workTime,
    required int lowWater,
  }) async {
    await Future.wait([
      _storage.write(key: _keyDeviceWorkMode, value: '$workMode'),
      _storage.write(key: _keyDeviceTargetTemp, value: '$targetTemp'),
      _storage.write(key: _keyDeviceActualTemp, value: '$actualTemp'),
      _storage.write(key: _keyDeviceWorkTime, value: '$workTime'),
      _storage.write(key: _keyDeviceLowWater, value: '$lowWater'),
    ]);
  }
}
