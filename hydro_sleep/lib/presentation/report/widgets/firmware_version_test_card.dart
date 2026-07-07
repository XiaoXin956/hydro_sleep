import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';

/// 设备版本及固件版本测试卡片 — 显示 A5 5A 设备信息 + 0x0C 固件版本
class FirmwareVersionTestCard extends StatefulWidget {
  const FirmwareVersionTestCard({super.key});

  @override
  State<FirmwareVersionTestCard> createState() =>
      _FirmwareVersionTestCardState();
}

class _FirmwareVersionTestCardState extends State<FirmwareVersionTestCard> {
  bool _loading = false;
  String? _message;
  Color _messageColor = Colors.red;

  Future<void> _queryVersion() async {
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
      await dataCubit.sendFirmwareVersionCommand();
      if (mounted) {
        setState(() {
          _loading = false;
          final ver = dataCubit.state.firmwareVersion;
          if (ver != null && ver.isNotEmpty) {
            _message = '查询成功';
            _messageColor = Colors.green;
          } else {
            _message = '未收到版本信息';
            _messageColor = Colors.orange;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<BleDataCubit, BleDataState>(
      buildWhen: (prev, curr) =>
          prev.deviceInfo != curr.deviceInfo ||
          prev.firmwareVersion != curr.firmwareVersion,
      builder: (context, state) {
        final info = state.deviceInfo;
        final version = state.firmwareVersion;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('设备版本信息', style: theme.textTheme.titleMedium),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _loading ? null : _queryVersion,
                      child: _loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('查询版本'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'A5 5A 设备信息（自动推送）+ 0x0C 固件版本查询',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),

                // 固件版本
                _infoRow('固件版本', version ?? '--'),
                const Divider(height: 16),

                // A5 5A 设备信息
                if (info != null) ...[
                  _infoRow('电源', info.powerStatus == 1 ? '开' : '关'),
                  _infoRow('工作模式', info.modeName),
                  _infoRow('功率', '${info.workPower}%'),
                  _infoRow('工作时间', '${info.workTime} min'),
                  _infoRow('目标温度', '${info.targetTemp}°C'),
                  _infoRow('低水位', info.lowWater == 1 ? '是' : '否'),
                  _infoRow('实际温度', '${info.actualTemp}°C'),
                ] else
                  Text(
                    '未收到设备信息（A5 5A）',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),

                if (_message != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _message!,
                    style: TextStyle(fontSize: 13, color: _messageColor),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
