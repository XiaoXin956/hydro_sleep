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
