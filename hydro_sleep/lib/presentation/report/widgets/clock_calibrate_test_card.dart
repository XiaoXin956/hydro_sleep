import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';

/// 校准时钟测试卡片（0x0B/0x8B） — 临时调试用
/// 将当前 UTC 时间转为 Unix 时间戳（十进制），再转小端 4 字节十六进制发送
class ClockCalibrateTestCard extends StatefulWidget {
  const ClockCalibrateTestCard({super.key});

  @override
  State<ClockCalibrateTestCard> createState() => _ClockCalibrateTestCardState();
}

class _ClockCalibrateTestCardState extends State<ClockCalibrateTestCard> {
  bool _loading = false;
  String? _result;
  Color _resultColor = Colors.red;
  String? _sendTime;
  int? _sendEpoch;
  String? _sendFrameHex;

  static String _hex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');

  static String _formatTime(DateTime t) {
    String p(int v) => v.toString().padLeft(2, '0');
    return '${t.year}-${p(t.month)}-${p(t.day)} '
        '${p(t.hour)}:${p(t.minute)}:${p(t.second)} (UTC)';
  }

  Future<void> _calibrateClock() async {
    final dataCubit = context.read<BleDataCubit>();
    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      final res = await dataCubit.sendCalibrateClockCommandV2();
      if (!mounted) return;
      setState(() {
        _loading = false;
        _result = res.ok ? '时钟已校准' : '校准时钟超时或失败';
        _resultColor = res.ok ? Colors.green : Colors.red;
        _sendTime = _formatTime(res.time);
        _sendEpoch = res.epoch;
        _sendFrameHex = _hex(res.frame);
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _result = '异常: $e';
          _resultColor = Colors.red;
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
            const SizedBox(height: 4),
            Text(
              '帧格式: 7D 0B 13 00 [ID 10B] [4字节时间LE] 0D',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            if (_result != null) ...[
              const SizedBox(height: 8),
              Text(_result!,
                  style: TextStyle(fontSize: 13, color: _resultColor)),
            ],
            if (_sendTime != null) ...[
              const SizedBox(height: 8),
              Text('时间: $_sendTime',
                  style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 4),
              Text('时间戳: $_sendEpoch (十进制)',
                  style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 4),
              Text('发送: $_sendFrameHex',
                  style: const TextStyle(
                      fontSize: 13, fontFamily: 'monospace')),
            ],
          ],
        ),
      ),
    );
  }
}