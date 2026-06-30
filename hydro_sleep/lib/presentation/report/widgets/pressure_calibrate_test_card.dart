import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';

/// 压力校准测试卡片（0x09/0x89） — 临时调试用
class PressureCalibrateTestCard extends StatefulWidget {
  const PressureCalibrateTestCard({super.key});

  @override
  State<PressureCalibrateTestCard> createState() => _PressureCalibrateTestCardState();
}

class _PressureCalibrateTestCardState extends State<PressureCalibrateTestCard> {
  bool _loading = false;
  String? _result;
  Color _resultColor = Colors.red;

  Future<void> _calibrate() async {
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
      final ok = await dataCubit.sendCommand(BleDataCubit.pressureCalibrateCommand);
      if (mounted) {
        setState(() {
          _loading = false;
          if (ok) {
            _result = '校准完成';
            _resultColor = Colors.green;
          } else {
            _result = '无法校准或响应超时';
            _resultColor = Colors.orange;
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    '压力校准',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                ElevatedButton(
                  onPressed: _loading ? null : _calibrate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
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
                      : const Text('开始校准'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '设备需处于无人状态，校准约 4 秒',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
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
