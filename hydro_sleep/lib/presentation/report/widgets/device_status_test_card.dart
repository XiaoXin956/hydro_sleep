import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';
import 'package:hydro_sleep/domain/models/device_status.dart';

/// 设备状态查询测试卡片（0x07/0x87） — 临时调试用
class DeviceStatusTestCard extends StatefulWidget {
  const DeviceStatusTestCard({super.key});

  @override
  State<DeviceStatusTestCard> createState() => _DeviceStatusTestCardState();
}

class _DeviceStatusTestCardState extends State<DeviceStatusTestCard> {
  bool _loading = false;
  DeviceStatus? _status;
  String? _error;

  Future<void> _queryDeviceStatus() async {
    final dataCubit = context.read<BleDataCubit>();
    if (dataCubit.state.status != BleDataStatus.streaming) {
      setState(() => _error = '未连接设备');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _status = null;
    });

    try {
      final status = await dataCubit.sendDeviceStatusCommand();
      if (mounted) {
        setState(() {
          _loading = false;
          if (status == null) {
            _error = '查询超时或异常';
          } else {
            _status = status;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '异常: $e';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '设备状态查询',
                  style: theme.textTheme.titleMedium,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _loading ? null : _queryDeviceStatus,
                  child: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('查询状态'),
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ],
            if (_status != null) ...[
              const SizedBox(height: 12),
              _buildStatusInfo(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusInfo(ThemeData theme) {
    final s = _status!;
    final modeColor = s.isStandby
        ? Colors.grey
        : s.isMonitorMode
            ? Colors.blue
            : s.isDebugMode
                ? Colors.teal
                : s.isBleDebugMode
                    ? Colors.purple
                    : s.isFirmwareUpdate
                        ? Colors.orange
                        : Colors.red;

    final timeStr = s.timestamp != null
        ? '${s.timestamp!.year}-${s.timestamp!.month.toString().padLeft(2, '0')}-'
            '${s.timestamp!.day.toString().padLeft(2, '0')} '
            '${s.timestamp!.hour.toString().padLeft(2, '0')}:'
            '${s.timestamp!.minute.toString().padLeft(2, '0')}:'
            '${s.timestamp!.second.toString().padLeft(2, '0')}'
        : '--';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (s.deviceId.isNotEmpty) ...[
          Row(
            children: [
              const Text('设备ID: ', style: TextStyle(fontSize: 13)),
              Text(
                s.deviceId,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace', color: Colors.blueGrey),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        Row(
          children: [
            const Text('模式: ', style: TextStyle(fontSize: 13)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: modeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                s.modeName,
                style: TextStyle(
                  fontSize: 13,
                  color: modeColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text('错误: ', style: TextStyle(fontSize: 13)),
            Text(
              s.hasError ? '0x${s.error.toRadixString(16).padLeft(2, '0')}（故障，需返厂）' : '无',
              style: TextStyle(
                fontSize: 13,
                color: s.hasError ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text('设备时间: ', style: TextStyle(fontSize: 13)),
            Text(timeStr, style: const TextStyle(fontSize: 13, fontFamily: 'monospace')),
          ],
        ),
      ],
    );
  }
}
