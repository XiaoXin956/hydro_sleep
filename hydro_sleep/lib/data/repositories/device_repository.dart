import 'dart:convert';
import 'package:hydro_sleep/domain/models/history_device.dart';
import '../storage/secure_storage_service.dart';

/// 设备仓储
class DeviceRepository {
  DeviceRepository._();

  // 获取所有历史设备列表
  static Future<List<HistoryDevice>> getAllHistoryDevices() async {
    final jsonStr = await SecureStorageService().getHistoryDevices();
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final list = jsonDecode(jsonStr) as List;
      return list
          .map((e) => HistoryDevice.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // 保存历史设备
  static Future<void> saveHistoryDevice(HistoryDevice device) async {
    final existing = await getAllHistoryDevices();
    // 去重
    existing.removeWhere((e) => e.deviceId == device.deviceId);
    existing.add(device);
    final jsonStr = jsonEncode(existing.map((e) => e.toJson()).toList());
    await SecureStorageService().saveHistoryDevices(jsonStr);
  }

  // 删除历史设备
  static Future<void> removeHistoryDevice(String deviceId) async {
    final existing = await getAllHistoryDevices();
    existing.removeWhere((e) => e.deviceId == deviceId);
    final jsonStr = jsonEncode(existing.map((e) => e.toJson()).toList());
    await SecureStorageService().saveHistoryDevices(jsonStr);
  }

  // 模拟：检查设备是否可连接（BLE 预留）
  static Future<bool> isDeviceConnected(String deviceId) async {
    // TODO: 实现 BLE 连接检查
    return false;
  }
}
