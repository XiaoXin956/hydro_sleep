import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hydro_sleep/domain/models/scanned_device.dart';

/// BLE 通信服务，封装 flutter_blue_plus 静态调用
class BleService {
  Stream<BluetoothAdapterState> get adapterState =>
      FlutterBluePlus.adapterState;

  Future<bool> isBluetoothOn() async {
    final state = await FlutterBluePlus.adapterState.first;
    return state == BluetoothAdapterState.on;
  }

  Future<void> turnOn() async {
    await FlutterBluePlus.turnOn();
  }

  Future<void> startScan({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    await FlutterBluePlus.startScan(
      timeout: timeout,
      androidScanMode: AndroidScanMode.lowLatency,
    );
  }

  Future<void> stopScan() async {
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
  }) async {
    final device = BluetoothDevice.fromId(remoteId);
    await device.connect(
      timeout: timeout,
      autoConnect: false,
      license: License.nonprofit,
    );
  }

  Future<void> disconnect(String remoteId) async {
    final device = BluetoothDevice.fromId(remoteId);
    await device.disconnect();
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
