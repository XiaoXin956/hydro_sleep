import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';

/// 停止指令测试卡片（0x03/0x83） — 临时调试用
class StopCommandTestCard extends StatefulWidget {
  const StopCommandTestCard({super.key});

  @override
  State<StopCommandTestCard> createState() => _StopCommandTestCardState();
}

class _StopCommandTestCardState extends State<StopCommandTestCard> {
  bool _loading = false;
  String? _result;

  Future<void> _sendStopCommand() async {
    final dataCubit = context.read<BleDataCubit>();
    if (dataCubit.state.status != BleDataStatus.streaming) {
      setState(() => _result = '未连接设备');
      return;
    }

    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      final ok = await dataCubit.sendCommand(BleDataCubit.stopCommand);
      if (mounted) {
        setState(() {
          _loading = false;
          _result = ok ? '停止成功，设备已进入待机' : '等待响应超时';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _result = '异常: $e';
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
                  '停止指令',
                  style: theme.textTheme.titleMedium,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _loading ? null : _sendStopCommand,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
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
                      : const Text('强制停止'),
                ),
              ],
            ),
            if (_result != null) ...[
              const SizedBox(height: 8),
              Text(
                _result!,
                style: TextStyle(
                  fontSize: 13,
                  color: _result!.contains('成功')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
