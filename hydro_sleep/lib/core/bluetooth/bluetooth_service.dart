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

  /// 协议约定 MTU 为 247（见 BLE_PROTOCOL.md），与连接解耦：
  /// MTU 协商失败只告警，绝不让 connect() 抛错导致连接被误判为失败
  static const _preferredMtu = 247;

  Future<void> connect(
    String remoteId, {
    Duration timeout = const Duration(seconds: 15),
    bool autoConnect = false,
  }) async {
    debugPrint(
      '[蓝牙服务] 发起连接: $remoteId, 自动连接=$autoConnect, 超时=${timeout.inSeconds}秒',
    );
    final device = BluetoothDevice.fromId(remoteId);
    // 不把 mtu 传入 connect()：Android 上 requestMtu 失败/超时会
    // 让 connect() 抛错，即使物理连接已经建立（autoConnect 与 mtu 也不兼容）
    await device.connect(
      timeout: timeout,
      autoConnect: autoConnect,
      mtu: null,
      license: License.nonprofit,
    );
    // 连接成功后单独协商 MTU，失败不影响连接状态
    if (!autoConnect) {
      try {
        final mtu = await device.requestMtu(_preferredMtu);
        debugPrint('[蓝牙服务] MTU 协商结果: $mtu');
      } catch (e) {
        debugPrint('[蓝牙服务] MTU 请求失败（不影响连接）: $e');
      }
    }
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

  /// 设备写模式已降级标记（带响应写失败后切到无响应写）
  bool _writeWithoutResponseOnly = false;

  /// 判断特征值 UUID 是否匹配协议短 UUID（如 fff2）
  /// 兼容两种形式：
  /// 1. 标准 Bluetooth Base UUID：0000fff2-0000-1000-8000-00805f9b34fb
  /// 2. 自定义 128 位 UUID 以短 UUID 结尾：xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxfff2
  static bool _matchesUuid(BluetoothCharacteristic c, String shortUuid) {
    final str = c.uuid.str.toLowerCase().replaceAll('-', '');
    // 标准 Base UUID 形式：16 位 UUID 位于前 4 位（0000FFFF-...）
    if (str.length == 32 &&
        str.endsWith('00001000800000805f9b34fb') &&
        str.substring(4, 8) == shortUuid.toLowerCase()) {
      return true;
    }
    // 自定义 128 位 UUID 以短 UUID 结尾
    return str.endsWith(shortUuid.toLowerCase());
  }

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
          'writeWithoutResponse=${c.properties.writeWithoutResponse} '
          'notify=${c.properties.notify} '
          'indicate=${c.properties.indicate}',
        );
      }
    }
    return services;
  }

  /// 找到 Notify 特征值（优先协议 UUID fff1，fallback 第一个 notify）并缓存
  BluetoothCharacteristic? findNotifyCharacteristic(
    List<BluetoothService> services,
  ) {
    // 优先匹配协议规定的通知特征 UUID fff1
    for (final s in services) {
      for (final c in s.characteristics) {
        if (c.properties.notify && _matchesUuid(c, 'fff1')) {
          _notifyChar = c;
          debugPrint(
            '[蓝牙服务] 找到 Notify 特征值(协议): ${c.uuid} (service: ${s.uuid})',
          );
          return c;
        }
      }
    }
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

  /// 找到 Write 特征值（优先协议 UUID fff2，其次与 Notify 同服务，
  /// fallback 第一个可写）并缓存
  /// 兼容 write（带响应）和 writeWithoutResponse（无响应）两种属性
  BluetoothCharacteristic? findWriteCharacteristic(
    List<BluetoothService> services,
  ) {
    // 1. 优先匹配协议规定的写入特征 UUID fff2
    for (final s in services) {
      for (final c in s.characteristics) {
        if ((c.properties.write || c.properties.writeWithoutResponse) &&
            _matchesUuid(c, 'fff2')) {
          _writeChar = c;
          debugPrint(
            '[蓝牙服务] 找到 Write 特征值(协议): ${c.uuid} (service: ${s.uuid}) '
            'write=${c.properties.write} '
            'writeWithoutResponse=${c.properties.writeWithoutResponse}',
          );
          return c;
        }
      }
    }
    // 2. 与 Notify 特征值同一 service 的可写特征（协议数据服务 ff00）
    //    （避免 fallback 误选 Generic Access 的 Device Name 等无关可写特征）
    if (_notifyChar != null) {
      final notifyService = services
          .where((s) => s.characteristics.contains(_notifyChar))
          .firstOrNull;
      if (notifyService != null) {
        for (final c in notifyService.characteristics) {
          if (c.properties.write || c.properties.writeWithoutResponse) {
            _writeChar = c;
            debugPrint(
              '[蓝牙服务] 找到 Write 特征值(与Notify同服务): ${c.uuid} '
              '(service: ${notifyService.uuid}) '
              'write=${c.properties.write} '
              'writeWithoutResponse=${c.properties.writeWithoutResponse}',
            );
            return c;
          }
        }
      }
    }
    // 3. fallback 任意可写特征
    for (final s in services) {
      for (final c in s.characteristics) {
        if (c.properties.write || c.properties.writeWithoutResponse) {
          _writeChar = c;
          debugPrint(
            '[蓝牙服务] 找到 Write 特征值: ${c.uuid} (service: ${s.uuid}) '
            'write=${c.properties.write} '
            'writeWithoutResponse=${c.properties.writeWithoutResponse}',
          );
          return c;
        }
      }
    }
    debugPrint('[蓝牙服务] 未找到 Write 特征值');
    return null;
  }

  /// 向写特征值发送数据
  /// 优先带响应写入（可靠）；若设备不支持带响应写（超时/报错），
  /// 自动降级为无响应写入，并记住该设备模式，避免每次写都超时
  Future<void> writeData(List<int> data) async {
    final char = _writeChar;
    if (char == null) {
      debugPrint('[蓝牙服务] writeData 失败: 未找到写特征值');
      throw Exception('未找到写特征值');
    }
    final canWrite = char.properties.write;
    final canWriteWithoutResponse = char.properties.writeWithoutResponse;
    debugPrint(
      '[蓝牙服务] 写入数据 uuid=${char.uuid} '
      '(write=$canWrite, writeWithoutResponse=$canWriteWithoutResponse, '
      'withoutResponseOnly=$_writeWithoutResponseOnly): '
      '${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
    );

    if (_writeWithoutResponseOnly) {
      await char.write(data, withoutResponse: true);
      return;
    }

    // 仅支持无响应写时直接用无响应模式
    if (!canWrite && canWriteWithoutResponse) {
      _writeWithoutResponseOnly = true;
      await char.write(data, withoutResponse: true);
      return;
    }

    // 默认带响应写入；失败则降级无响应写入（针对固件不回复 ATT Write Response 的设备）
    try {
      await char.write(data, withoutResponse: false, timeout: 5);
    } catch (e) {
      debugPrint('[蓝牙服务] 带响应写入失败，降级无响应写入: $e');
      if (canWriteWithoutResponse) {
        _writeWithoutResponseOnly = true;
        await char.write(data, withoutResponse: true);
      } else {
        rethrow;
      }
    }
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
