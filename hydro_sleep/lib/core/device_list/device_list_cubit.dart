import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/data/repositories/device_repository.dart';
import 'package:hydro_sleep/domain/models/history_device.dart';

// --- State ---

class DeviceListState extends Equatable {
  final List<HistoryDevice> devices;
  final bool expanded;

  const DeviceListState({
    this.devices = const [],
    this.expanded = false,
  });

  List<HistoryDevice> get visibleDevices =>
      expanded ? devices : devices.take(3).toList();

  bool get hasMore => devices.length > 3;

  DeviceListState copyWith({
    List<HistoryDevice>? devices,
    bool? expanded,
  }) {
    return DeviceListState(
      devices: devices ?? this.devices,
      expanded: expanded ?? this.expanded,
    );
  }

  @override
  List<Object?> get props => [devices, expanded];
}

// --- Cubit ---

class DeviceListCubit extends Cubit<DeviceListState> {
  DeviceListCubit() : super(const DeviceListState()) {
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    final devices = await DeviceRepository.getAllHistoryDevices();
    emit(state.copyWith(devices: devices));
  }

  void toggleExpand() {
    emit(state.copyWith(expanded: !state.expanded));
  }

  Future<void> refresh() async {
    emit(state.copyWith(devices: const []));
    await _loadDevices();
  }

  Future<void> removeDevice(String deviceId) async {
    await DeviceRepository.removeHistoryDevice(deviceId);
    emit(state.copyWith(
      devices: state.devices.where((d) => d.deviceId != deviceId).toList(),
    ));
  }
}
