import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/domain/models/device_parameters.dart';

/// 参数管理测试卡片（0x0A/0x8A） — 临时调试用
class ParameterTestCard extends StatefulWidget {
  const ParameterTestCard({super.key});

  @override
  State<ParameterTestCard> createState() => _ParameterTestCardState();
}

class _ParameterTestCardState extends State<ParameterTestCard> {
  bool _loading = false;
  DeviceParameters? _params;
  String? _message;
  Color _messageColor = Colors.red;

  Future<void> _readParams() async {
    final dataCubit = context.read<BleDataCubit>();
    if (dataCubit.state.status != BleDataStatus.streaming) {
      setState(() => _message = '未连接设备');
      return;
    }

    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      final params = await dataCubit.readParameters();
      if (mounted) {
        setState(() {
          _loading = false;
          if (params != null) {
            _params = params;
            _message = '读取成功';
            _messageColor = Colors.green;
          } else {
            _message = '读取超时或异常';
            _messageColor = Colors.red;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _message = '异常: $e';
          _messageColor = Colors.red;
          _loading = false;
        });
      }
    }
  }

  Future<void> _resetParams() async {
    final dataCubit = context.read<BleDataCubit>();
    if (dataCubit.state.status != BleDataStatus.streaming) {
      setState(() => _message = '未连接设备');
      return;
    }

    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      final ok = await dataCubit.resetParameters();
      if (mounted) {
        setState(() {
          _loading = false;
          _message = ok ? '参数已复位' : '复位失败或超时';
          _messageColor = ok ? Colors.green : Colors.red;
          if (ok) _params = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _message = '异常: $e';
          _messageColor = Colors.red;
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
            Text('参数管理', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _loading ? null : _readParams,
                  child: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('读取参数'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _loading ? null : _resetParams,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('复位参数'),
                ),
              ],
            ),
            if (_message != null) ...[
              const SizedBox(height: 8),
              Text(_message!, style: TextStyle(fontSize: 13, color: _messageColor)),
            ],
            if (_params != null) ...[
              const SizedBox(height: 12),
              _buildParamList(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildParamList(ThemeData theme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: DeviceParameters.count,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final name = DeviceParameters.names[index];
        final value = _params!.values[index];
        final defaultVal = DeviceParameters.defaults[index];
        final isModified = defaultVal != null && (value - defaultVal).abs() > 0.001;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 70,
                child: Text(
                  value.toStringAsFixed(value == value.roundToDouble() ? 0 : 2),
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    fontWeight: isModified ? FontWeight.bold : FontWeight.normal,
                    color: isModified ? Colors.orange : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              if (defaultVal != null) ...[
                const SizedBox(width: 4),
                SizedBox(
                  width: 50,
                  child: Text(
                    '(默认$defaultVal)',
                    style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
