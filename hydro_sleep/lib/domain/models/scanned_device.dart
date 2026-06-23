import 'package:equatable/equatable.dart';

/// BLE 扫描发现的设备
class ScannedDevice extends Equatable {
  final String remoteId;
  final String name;
  final int rssi;
  final bool connectable;

  const ScannedDevice({
    required this.remoteId,
    required this.name,
    required this.rssi,
    this.connectable = true,
  });

  String get displayName => name.isNotEmpty ? name : remoteId;

  @override
  List<Object?> get props => [remoteId];
}
