import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hydro_sleep/core/bluetooth/bluetooth_service.dart';
import 'package:hydro_sleep/domain/models/scanned_device.dart';

// --- State ---

class BleScanState extends Equatable {
  final bool scanning;
  final List<ScannedDevice> devices;
  final String? error;
  final BluetoothAdapterState adapterState;
  final String? connectingId;
  final Set<String> connectedIds;

  const BleScanState({
    this.scanning = false,
    this.devices = const [],
    this.error,
    this.adapterState = BluetoothAdapterState.unknown,
    this.connectingId,
    this.connectedIds = const {},
  });

  bool get isBluetoothOff => adapterState != BluetoothAdapterState.on;

  BleScanState copyWith({
    bool? scanning,
    List<ScannedDevice>? devices,
    String? error,
    BluetoothAdapterState? adapterState,
    String? connectingId,
    Set<String>? connectedIds,
  }) {
    return BleScanState(
      scanning: scanning ?? this.scanning,
      devices: devices ?? this.devices,
      error: error,
      adapterState: adapterState ?? this.adapterState,
      connectingId: connectingId,
      connectedIds: connectedIds ?? this.connectedIds,
    );
  }

  @override
  List<Object?> get props => [
        scanning,
        devices,
        error,
        adapterState,
        connectingId,
        connectedIds,
      ];
}

// --- Cubit ---

class BleScanCubit extends Cubit<BleScanState> {
  BleScanCubit({BleService? bleService})
      : _bleService = bleService ?? BleService(),
        super(const BleScanState()) {
    _init();
  }

  final BleService _bleService;
  StreamSubscription? _scanSub;
  StreamSubscription? _scanningSub;
  StreamSubscription? _adapterSub;

  void _init() {
    _adapterSub = _bleService.adapterState.listen((adapterState) {
      emit(state.copyWith(adapterState: adapterState, error: null));
    });

    _scanningSub = _bleService.isScanning.listen((scanning) {
      emit(state.copyWith(scanning: scanning));
    });
  }

  Future<void> startScan() async {
    await _bleService.stopScan();
    emit(state.copyWith(devices: const [], error: null));

    final isOn = await _bleService.isBluetoothOn();
    if (!isOn) {
      try {
        await _bleService.turnOn();
      } catch (_) {
        emit(state.copyWith(error: 'bluetoothOff'));
        return;
      }
    }

    _scanSub?.cancel();
    _scanSub = _bleService.scanResults.listen((scannedDevices) {
      final Map<String, ScannedDevice> deduped = {
        for (final d in state.devices) d.remoteId: d,
        for (final d in scannedDevices) d.remoteId: d,
      };
      emit(state.copyWith(devices: deduped.values.toList(), error: null));
    });

    try {
      await _bleService.startScan();
    } catch (e) {
      emit(state.copyWith(error: 'scanFailed'));
    }
  }

  Future<void> stopScan() async {
    await _bleService.stopScan();
  }

  void markConnecting(String remoteId) {
    emit(state.copyWith(connectingId: remoteId));
  }

  void markConnected(String remoteId) {
    emit(
      state.copyWith(
        connectingId: null,
        connectedIds: {...state.connectedIds, remoteId},
      ),
    );
  }

  void markConnectFailed() {
    emit(state.copyWith(connectingId: null));
  }

  @override
  Future<void> close() async {
    await _scanSub?.cancel();
    await _scanningSub?.cancel();
    await _adapterSub?.cancel();
    await _bleService.stopScan();
    return super.close();
  }
}
