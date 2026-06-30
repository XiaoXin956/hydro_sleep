import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';

/// 心跳应答测试卡片（0x08/0x88） — 临时调试用
class HeartbeatTestCard extends StatefulWidget {
  const HeartbeatTestCard({super.key});

  @override
  State<HeartbeatTestCard> createState() => _HeartbeatTestCardState();
}

class _HeartbeatTestCardState extends State<HeartbeatTestCard> {
  bool _autoMode = false;
  Timer? _timer;
  int _sendCount = 0;
  String? _lastResult;

  Future<void> _sendHeartbeat() async {
    final dataCubit = context.read<BleDataCubit>();
    if (dataCubit.state.status != BleDataStatus.streaming) {
      setState(() => _lastResult = '未连接设备');
      return;
    }

    try {
      final ok = await dataCubit.sendCommand(BleDataCubit.heartbeatCommand);
      if (mounted) {
        setState(() {
          _sendCount++;
          _lastResult = ok ? '心跳 #$_sendCount 已确认' : '心跳 #$_sendCount 响应超时';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _lastResult = '异常: $e');
      }
    }
  }

  void _toggleAutoMode(bool value) {
    setState(() {
      _autoMode = value;
      if (value) {
        _sendHeartbeat();
        _timer = Timer.periodic(const Duration(minutes: 1), (_) {
          _sendHeartbeat();
        });
      } else {
        _timer?.cancel();
        _timer = null;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
            Text('心跳指令', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _autoMode ? null : _sendHeartbeat,
                  child: const Text('发送心跳'),
                ),
                const SizedBox(width: 16),
                const Text('自动心跳(1分钟)', style: TextStyle(fontSize: 13)),
                Switch(
                  value: _autoMode,
                  onChanged: _toggleAutoMode,
                ),
              ],
            ),
            if (_lastResult != null) ...[
              const SizedBox(height: 8),
              Text(
                _lastResult!,
                style: TextStyle(
                  fontSize: 13,
                  color: _lastResult!.contains('已确认')
                      ? Colors.green
                      : _lastResult!.contains('超时')
                          ? Colors.orange
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
