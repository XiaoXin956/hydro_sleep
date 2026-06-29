import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hydro_sleep/domain/models/scanned_device.dart';
import 'package:permission_handler/permission_handler.dart';

/// BLE 通信服务，封装 flutter_blue_plus 静态调用
class BleService {
  Stream<BluetoothAdapterState> get adapterState =>
      FlutterBluePlus.adapterState;

  Future<bool> isBluetoothOn() async {
    final state = await FlutterBluePlus.adapterState.first;
    debugPrint('[蓝牙服务] 蓝牙状态: $state');
    return state == BluetoothAdapterState.on;
  }

  Future<void> turnOn() async {
    debugPrint('[蓝牙服务] 请求开启蓝牙');
    await FlutterBluePlus.turnOn();
  }

  /// 请求 BLE 扫描所需的运行时权限，返回是否全部授权
  Future<bool> requestPermissions() async {
    if (!Platform.isAndroid) return true;

    final permissions = <Permission>[
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ];

    final statuses = await permissions.request();
    final granted = statuses.values.every(
      (s) => s.isGranted || s.isLimited,
    );
    debugPrint('[蓝牙服务] 权限请求结果: granted=$granted');
    return granted;
  }

  Future<void> startScan({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    debugPrint('[蓝牙服务] 开始扫描, 超时=${timeout.inSeconds}秒');
    await FlutterBluePlus.startScan(
      timeout: timeout,
      androidScanMode: AndroidScanMode.lowLatency,
    );
  }

  Future<void> stopScan() async {
    debugPrint('[蓝牙服务] 停止扫描');
    await FlutterBluePlus.stopScan();
  }

  Stream<List<ScannedDevice>> get scanResults =>
      FlutterBluePlus.onScanResults.map(
        (results) => results.map(_toDomain).toList(),
      );

  Stream<bool> get isScanning => FlutterBluePlus.isScanning;

  // --- Connection ---

  Future<void> connect(
    String remoteId, {
    Duration timeout = const Duration(seconds: 15),
    bool autoConnect = false,
  }) async {
    debugPrint(
      '[蓝牙服务] 发起连接: $remoteId, 自动连接=$autoConnect, 超时=${timeout.inSeconds}秒',
    );
    final device = BluetoothDevice.fromId(remoteId);
    await device.connect(
      timeout: timeout,
      autoConnect: autoConnect,
      mtu: autoConnect ? null : 247,
      license: License.nonprofit,
    );
    debugPrint('[蓝牙服务] 连接完成: $remoteId');
  }

  Future<void> disconnect(String remoteId) async {
    debugPrint('[蓝牙服务] 断开连接: $remoteId');
    final device = BluetoothDevice.fromId(remoteId);
    await device.disconnect();
    debugPrint('[蓝牙服务] 断开连接完成: $remoteId');
  }

  Stream<BluetoothConnectionState> connectionState(String remoteId) {
    final device = BluetoothDevice.fromId(remoteId);
    return device.connectionState;
  }

  // --- Data Communication ---

  BluetoothCharacteristic? _notifyChar;
  BluetoothCharacteristic? _writeChar;

  /// 发现设备所有服务和特征值
  Future<List<BluetoothService>> discoverServices(String remoteId) async {
    debugPrint('[蓝牙服务] 发现服务: $remoteId');
    final device = BluetoothDevice.fromId(remoteId);
    final services = await device.discoverServices();
    for (final s in services) {
      debugPrint('[蓝牙服务]   Service: ${s.uuid}');
      for (final c in s.characteristics) {
        debugPrint(
          '[蓝牙服务]     Char: ${c.uuid} '
          'read=${c.properties.read} '
          'write=${c.properties.write} '
          'notify=${c.properties.notify} '
          'indicate=${c.properties.indicate}',
        );
      }
    }
    return services;
  }

  /// 找到第一个支持 Notify 的特征值并缓存
  BluetoothCharacteristic? findNotifyCharacteristic(
    List<BluetoothService> services,
  ) {
    for (final s in services) {
      for (final c in s.characteristics) {
        if (c.properties.notify) {
          _notifyChar = c;
          debugPrint(
            '[蓝牙服务] 找到 Notify 特征值: ${c.uuid} (service: ${s.uuid})',
          );
          return c;
        }
      }
    }
    debugPrint('[蓝牙服务] 未找到 Notify 特征值');
    return null;
  }

  /// 找到第一个支持 Write 的特征值并缓存
  BluetoothCharacteristic? findWriteCharacteristic(
    List<BluetoothService> services,
  ) {
    for (final s in services) {
      for (final c in s.characteristics) {
        if (c.properties.write) {
          _writeChar = c;
          debugPrint(
            '[蓝牙服务] 找到 Write 特征值: ${c.uuid} (service: ${s.uuid})',
          );
          return c;
        }
      }
    }
    debugPrint('[蓝牙服务] 未找到 Write 特征值');
    return null;
  }

  /// 向写特征值发送数据
  Future<void> writeData(List<int> data) async {
    final char = _writeChar;
    if (char == null) {
      debugPrint('[蓝牙服务] writeData 失败: 未找到写特征值');
      throw Exception('未找到写特征值');
    }
    debugPrint(
      '[蓝牙服务] 写入数据: ${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
    );
    await char.write(data, withoutResponse: false);
  }

  /// 开启 Notify
  Future<void> enableNotify() async {
    final char = _notifyChar;
    if (char == null) {
      debugPrint('[蓝牙服务] enableNotify 失败: 未找到特征值');
      return;
    }
    debugPrint('[蓝牙服务] 开启 Notify: ${char.uuid}');
    await char.setNotifyValue(true);
  }

  /// 关闭 Notify
  Future<void> disableNotify() async {
    final char = _notifyChar;
    if (char == null) return;
    debugPrint('[蓝牙服务] 关闭 Notify: ${char.uuid}');
    try {
      await char.setNotifyValue(false);
    } catch (e) {
      debugPrint('[蓝牙服务] 关闭 Notify 失败（设备可能已断开）: $e');
    }
  }

  /// Notify 数据流
  Stream<List<int>>? get onValueChanged => _notifyChar?.onValueReceived;

  /// 清除缓存的特征值引用
  void clearCharacteristicCache() {
    _notifyChar = null;
    _writeChar = null;
  }

  // --- Helpers ---

  static ScannedDevice _toDomain(ScanResult r) {
    return ScannedDevice(
      remoteId: r.device.remoteId.str,
      name: r.advertisementData.advName,
      rssi: r.rssi,
      connectable: r.advertisementData.connectable,
    );
  }
}
