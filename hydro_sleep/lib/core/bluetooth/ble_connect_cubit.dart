import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hydro_sleep/core/bluetooth/bluetooth_service.dart';
import 'package:hydro_sleep/data/repositories/device_repository.dart';
import 'package:hydro_sleep/domain/models/history_device.dart';
import 'package:hydro_sleep/domain/models/scanned_device.dart';

// --- Status ---

enum BleConnectStatus {
  idle,
  connecting,
  connected,
  disconnecting,
  disconnected,
  failed,
}

// --- State ---

class BleConnectState extends Equatable {
  final BleConnectStatus status;
  final String? error;
  final String? remoteId;
  final String? deviceName;

  const BleConnectState({
    this.status = BleConnectStatus.idle,
    this.error,
    this.remoteId,
    this.deviceName,
  });

  bool get isConnecting => status == BleConnectStatus.connecting;
  bool get isConnected => status == BleConnectStatus.connected;
  bool get isFailed => status == BleConnectStatus.failed;

  BleConnectState copyWith({
    BleConnectStatus? status,
    String? error,
    String? remoteId,
    String? deviceName,
  }) {
    return BleConnectState(
      status: status ?? this.status,
      error: error,
      remoteId: remoteId ?? this.remoteId,
      deviceName: deviceName ?? this.deviceName,
    );
  }

  @override
  List<Object?> get props => [status, error, remoteId, deviceName];
}

// --- Cubit ---

class BleConnectCubit extends Cubit<BleConnectState> {
  BleConnectCubit({BleService? bleService})
      : _bleService = bleService ?? BleService(),
        super(const BleConnectState());

  final BleService _bleService;
  StreamSubscription? _connSub;

  Future<void> connect(ScannedDevice device) async {
    emit(
      state.copyWith(
        status: BleConnectStatus.connecting,
        remoteId: device.remoteId,
        deviceName: device.displayName,
        error: null,
      ),
    );

    _connSub?.cancel();
    _connSub = _bleService.connectionState(device.remoteId).listen((
      connState,
    ) async {
      if (connState == BluetoothConnectionState.connected) {
        await _saveHistory(device);
        emit(state.copyWith(status: BleConnectStatus.connected, error: null));
      } else if (connState == BluetoothConnectionState.disconnected) {
        if (state.isConnecting) {
          emit(
            state.copyWith(
              status: BleConnectStatus.failed,
              error: 'disconnected',
            ),
          );
        } else {
          emit(
            state.copyWith(status: BleConnectStatus.disconnected, error: null),
          );
        }
      }
    });

    try {
      await _bleService.connect(device.remoteId);
    } catch (e) {
      emit(state.copyWith(status: BleConnectStatus.failed, error: 'connectFailed'));
    }
  }

  Future<void> disconnect() async {
    final remoteId = state.remoteId;
    if (remoteId == null) return;

    emit(state.copyWith(status: BleConnectStatus.disconnecting, error: null));
    try {
      await _bleService.disconnect(remoteId);
    } catch (_) {
      // disconnect best-effort
    }
    emit(state.copyWith(status: BleConnectStatus.disconnected, error: null));
  }

  Future<void> _saveHistory(ScannedDevice device) async {
    await DeviceRepository.saveHistoryDevice(
      HistoryDevice(
        deviceId: device.remoteId,
        deviceName: device.displayName,
        lastConnectedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _connSub?.cancel();
    return super.close();
  }
}
