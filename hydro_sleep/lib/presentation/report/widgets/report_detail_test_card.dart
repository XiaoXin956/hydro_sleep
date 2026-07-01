import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';
import 'package:hydro_sleep/domain/models/sleep_minute_record.dart';

/// 设备存储数据读取测试卡片（0x14/0x94） — 临时调试用
class ReportDetailTestCard extends StatefulWidget {
  const ReportDetailTestCard({super.key});

  @override
  State<ReportDetailTestCard> createState() => _ReportDetailTestCardState();
}

class _ReportDetailTestCardState extends State<ReportDetailTestCard> {
  bool _loading = false;
  int _seq = 0;
  List<SleepMinuteRecord>? _records;
  String? _message;
  Color _messageColor = Colors.red;

  /// 用固定的测试时间戳（0x6305E890 = 2022-08-24 左右）
  static const _testStartTime = 0x6305E890;

  Future<void> _readData() async {
    final dataCubit = context.read<BleDataCubit>();
    if (dataCubit.state.status != BleDataStatus.streaming) {
      setState(() => _message = '未连接设备');
      return;
    }

    setState(() {
      _loading = true;
      _message = null;
      _records = null;
    });

    try {
      final records = await dataCubit.sendSleepDataReadCommand(
        startTime: _testStartTime,
        seq: _seq,
      );
      if (mounted) {
        setState(() {
          _loading = false;
          if (records.isNotEmpty) {
            _records = records;
            _message = '读取成功: seq=$_seq, ${records.length} 分钟';
            _messageColor = Colors.green;
          } else {
            _message = '读取超时或无数据（seq=$_seq）';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('存储数据读取', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              '读取设备存储的 30 分钟详细数据（0x14/0x94）',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('序号:', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _seq,
                  isDense: true,
                  items: List.generate(48, (i) => DropdownMenuItem(
                    value: i,
                    child: Text('$i (${i * 30}~${(i + 1) * 30}min)'),
                  )),
                  onChanged: _loading ? null : (v) => setState(() => _seq = v ?? 0),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _loading ? null : _readData,
                  child: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('读取'),
                ),
              ],
            ),
            if (_message != null) ...[
              const SizedBox(height: 8),
              Text(_message!, style: TextStyle(fontSize: 13, color: _messageColor)),
            ],
            if (_records != null) ...[
              const SizedBox(height: 12),
              _buildRecordList(theme),
            ],
          ],
        ),
      ),
    );
  }

  Color _statusColor(String name) {
    switch (name) {
      case '深睡眠':
        return Colors.indigo;
      case '浅睡眠':
        return Colors.blue;
      case 'REM':
        return Colors.purple;
      case '清醒':
        return Colors.orange;
      case '离床':
        return Colors.red;
      case '坐起':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRecordList(ThemeData theme) {
    return Wrap(
      spacing: 2,
      runSpacing: 2,
      children: List.generate(_records!.length, (i) {
        final r = _records![i];
        final color = _statusColor(r.statusName);
        final minOffset = _seq * 30 + i;
        return Tooltip(
          message: '${minOffset ~/ 60}:${(minOffset % 60).toString().padLeft(2, '0')} '
              '${r.statusName} HR=${r.heartRate} BR=${r.breathRate} MV=${r.bodyMovement}',
          child: Container(
            width: 16,
            height: 24,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.center,
            child: Text(
              '${i + 1}',
              style: const TextStyle(fontSize: 8, color: Colors.white),
            ),
          ),
        );
      }),
    );
  }
}
