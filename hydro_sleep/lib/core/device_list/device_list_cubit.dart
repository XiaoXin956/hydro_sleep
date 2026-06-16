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
    var devices = await DeviceRepository.getAllHistoryDevices();
    // 本地无数据时填充测试数据
    if (devices.isEmpty) {
      devices = _mockDevices();
      for (final d in devices) {
        await DeviceRepository.saveHistoryDevice(d);
      }
    }
    emit(state.copyWith(devices: devices));
  }

  void toggleExpand() {
    emit(state.copyWith(expanded: !state.expanded));
  }

  List<HistoryDevice> _mockDevices() {
    return const [
      HistoryDevice(
        deviceId: 'UID-8A3F2B',
        deviceName: 'SmartSleep Pro',
        lastConnectedAt: null,
      ),
      HistoryDevice(
        deviceId: 'UID-9C1E4D',
        deviceName: 'SmartSleep Lite',
        lastConnectedAt: null,
      ),
      HistoryDevice(
        deviceId: 'UID-3B2C8E',
        deviceName: 'SmartSleep Pro (旧)',
        lastConnectedAt: null,
      ),
      HistoryDevice(
        deviceId: 'UID-5D7A1F',
        deviceName: 'SmartSleep Basic',
        lastConnectedAt: null,
      ),
      HistoryDevice(
        deviceId: 'UID-7F2E9A',
        deviceName: 'SmartSleep Mini',
        lastConnectedAt: null,
      ),
    ];
  }
}
