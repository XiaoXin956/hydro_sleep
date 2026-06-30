import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';

/// 工作模式设定测试卡片（0x04/0x84） — 临时调试用
class ModeCommandTestCard extends StatefulWidget {
  const ModeCommandTestCard({super.key});

  @override
  State<ModeCommandTestCard> createState() => _ModeCommandTestCardState();
}

class _ModeCommandTestCardState extends State<ModeCommandTestCard> {
  bool _loading = false;
  String? _result;
  Color _resultColor = Colors.red;

  Future<void> _sendModeCommand(int mode) async {
    final dataCubit = context.read<BleDataCubit>();
    if (dataCubit.state.status != BleDataStatus.streaming) {
      setState(() => _result = '未连接设备');
      return;
    }

    final label = mode == BleDataCubit.modeMonitor ? '监控' : '调试';
    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      final content = await dataCubit.sendModeCommand(mode);
      if (mounted) {
        setState(() {
          _loading = false;
          if (content == null) {
            _result = '$label模式：发送异常';
            _resultColor = Colors.red;
          } else if (content == -1) {
            _result = '$label模式：等待响应超时';
            _resultColor = Colors.orange;
          } else {
            // 解析 0x84 响应内容
            switch (content) {
              case 0x20:
                _result = '监控模式：确认启动，设备开始工作';
                _resultColor = Colors.green;
              case 0x21:
                _result = '监控模式：设备已在工作中';
                _resultColor = Colors.blue;
              case 0x22:
                _result = '监控模式：仪器故障，无法启动';
                _resultColor = Colors.red;
              case 0x30:
                _result = '调试模式：确认启动，设备开始工作';
                _resultColor = Colors.green;
              case 0x31:
                _result = '调试模式：故障，无法启动';
                _resultColor = Colors.red;
              default:
                _result = '未知响应: 0x${content.toRadixString(16).padLeft(2, '0')}';
                _resultColor = Colors.orange;
            }
          }
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
            Text(
              '工作模式设定',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _loading ? null : () => _sendModeCommand(BleDataCubit.modeMonitor),
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
                        : const Text('监控模式(0x20)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _loading ? null : () => _sendModeCommand(BleDataCubit.modeDebug),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('调试模式(0x30)'),
                  ),
                ),
              ],
            ),
            if (_result != null) ...[
              const SizedBox(height: 8),
              Text(
                _result!,
                style: TextStyle(fontSize: 13, color: _resultColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
