import 'package:equatable/equatable.dart';

/// 设备历史条目
class HistoryDevice extends Equatable {
  final String deviceId;
  final String deviceName;
  final DateTime? lastConnectedAt;

  const HistoryDevice({
    required this.deviceId,
    required this.deviceName,
    this.lastConnectedAt,
  });

  factory HistoryDevice.fromJson(Map<String, dynamic> json) {
    return HistoryDevice(
      deviceId: json['id'] as String,
      deviceName: json['name'] as String,
      lastConnectedAt: json['lastConnected'] != null
          ? DateTime.parse(json['lastConnected'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': deviceId,
      'name': deviceName,
      'lastConnected': lastConnectedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [deviceId, deviceName];
}
