import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';

/// 校准时钟测试卡片（0x0B/0x8B） — 临时调试用
class ClockCalibrateTestCard extends StatefulWidget {
  const ClockCalibrateTestCard({super.key});

  @override
  State<ClockCalibrateTestCard> createState() => _ClockCalibrateTestCardState();
}

class _ClockCalibrateTestCardState extends State<ClockCalibrateTestCard> {
  bool _loading = false;
  String? _result;
  Color _resultColor = Colors.red;

  Future<void> _calibrateClock() async {
    final dataCubit = context.read<BleDataCubit>();
    if (dataCubit.state.status != BleDataStatus.streaming) {
      setState(() => _result = '未连接设备');
      return;
    }

    setState(() {
      _loading = true;
      _result = null;
    });

    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';

    try {
      final ok = await dataCubit.sendCalibrateClockCommand(time: now);
      if (mounted) {
        setState(() {
          _loading = false;
          _result = ok ? '时钟已校准 ($timeStr)' : '校准时钟超时或失败';
          _resultColor = ok ? Colors.green : Colors.red;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _result = '异常: $e';
          _resultColor = Colors.red;
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
                Text('校准时钟', style: theme.textTheme.titleMedium),
                const Spacer(),
                ElevatedButton(
                  onPressed: _loading ? null : _calibrateClock,
                  child: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('校准时钟'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '将当前系统时间同步到设备',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            if (_result != null) ...[
              const SizedBox(height: 8),
              Text(_result!, style: TextStyle(fontSize: 13, color: _resultColor)),
            ],
          ],
        ),
      ),
    );
  }
}
