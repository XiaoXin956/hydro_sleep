import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';

/// 初始化指令测试卡片（0x04/0x84） — 临时调试用
/// 发送监控模式初始化帧: 7D 04 10 00 55 4E 43 4F 4E 46 49 47 45 44 20 0D
class InitCommandTestCard extends StatefulWidget {
  const InitCommandTestCard({super.key});

  @override
  State<InitCommandTestCard> createState() => _InitCommandTestCardState();
}

class _InitCommandTestCardState extends State<InitCommandTestCard> {
  bool _loading = false;
  String? _result;
  Color _resultColor = Colors.red;
  String? _sendFrame;

  static String _hex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');

  Future<void> _sendInitCommand() async {
    final dataCubit = context.read<BleDataCubit>();
    final frame = [...BleDataCubit.initCommand];
    setState(() {
      _loading = true;
      _result = null;
      _sendFrame = _hex(frame);
    });

    if (dataCubit.state.status != BleDataStatus.streaming) {
      setState(() {
        _loading = false;
        _result = '未连接设备';
        _resultColor = Colors.red;
      });
      return;
    }

    try {
      final ok = await dataCubit.sendInitCommand();
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (!ok) {
          _result = '未连接设备';
          _resultColor = Colors.red;
        } else {
          _result = '初始化指令已发送（默认成功）';
          _resultColor = Colors.green;
        }
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
                Text('初始化指令', style: theme.textTheme.titleMedium),
                const Spacer(),
                ElevatedButton(
                  onPressed: _loading ? null : _sendInitCommand,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('初始化'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '发送 0x04 监控模式初始化帧（0x20）',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            if (_sendFrame != null) ...[
              const SizedBox(height: 8),
              Text('发送: $_sendFrame',
                  style: const TextStyle(
                      fontSize: 13, fontFamily: 'monospace')),
            ],
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
