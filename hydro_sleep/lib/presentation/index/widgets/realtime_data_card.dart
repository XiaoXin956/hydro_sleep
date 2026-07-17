import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/domain/models/retransmit_record.dart';

/// 0x85 实时秒数据卡片（每秒自动更新）
class RealtimeDataCard extends StatelessWidget {
  const RealtimeDataCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final record = context.select<BleDataCubit, RetransmitRecord?>(
      (cubit) => cubit.state.latestSecondRecord,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('实时数据', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            if (record == null)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('暂无数据', style: TextStyle(color: AppColors.textSecondary)),
                ),
              )
            else
              Row(
                children: [
                  _DataItem(
                    label: '时间',
                    value: _formatTime(record.timestamp),
                  ),
                  const SizedBox(width: 16),
                  _DataItem(
                    label: '状态',
                    value: _statusName(record.status),
                  ),
                  const SizedBox(width: 16),
                  _DataItem(
                    label: '心率',
                    value: '${record.heartRate}',
                    unit: 'bpm',
                  ),
                  const SizedBox(width: 16),
                  _DataItem(
                    label: '呼吸',
                    value: '${record.breathRate}',
                    unit: '次/分',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  static String _formatTime(DateTime? timestamp) {
    if (timestamp == null) return '--';
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }

  static String _statusName(int status) {
    switch (status) {
      case 0x01:
        return '离床';
      case 0x02:
        return '体动';
      case 0x03:
        return '坐起';
      case 0x04:
        return '睡眠';
      case 0x05:
        return '清醒';
      case 0x06:
        return '重物';
      default:
        return '未知';
    }
  }
}

class _DataItem extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;

  const _DataItem({required this.label, required this.value, this.unit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          if (unit != null)
            Text(unit!, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
