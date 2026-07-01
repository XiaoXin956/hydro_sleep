import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';
import 'package:hydro_sleep/domain/models/report_summary.dart';

/// 设备存储报表查询测试卡片（0x13/0x93） — 临时调试用
class ReportQueryTestCard extends StatefulWidget {
  const ReportQueryTestCard({super.key});

  @override
  State<ReportQueryTestCard> createState() => _ReportQueryTestCardState();
}

class _ReportQueryTestCardState extends State<ReportQueryTestCard> {
  bool _loading = false;
  List<ReportSummary>? _reports;
  String? _message;
  Color _messageColor = Colors.red;

  Future<void> _queryReports() async {
    final dataCubit = context.read<BleDataCubit>();
    if (dataCubit.state.status != BleDataStatus.streaming) {
      setState(() => _message = '未连接设备');
      return;
    }

    setState(() {
      _loading = true;
      _message = null;
      _reports = null;
    });

    try {
      final reports = await dataCubit.sendReportQueryCommand();
      if (mounted) {
        setState(() {
          _loading = false;
          if (reports.isNotEmpty) {
            _reports = reports;
            _message = '查询成功: ${reports.length} 条记录';
            _messageColor = Colors.green;
          } else {
            _message = '查询超时或无数据';
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
            Row(
              children: [
                Text('设备报表查询', style: theme.textTheme.titleMedium),
                const Spacer(),
                ElevatedButton(
                  onPressed: _loading ? null : _queryReports,
                  child: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('查询报表'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '查询设备存储的 15 组历史报表概要（0x13/0x93）',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            if (_message != null) ...[
              const SizedBox(height: 8),
              Text(_message!, style: TextStyle(fontSize: 13, color: _messageColor)),
            ],
            if (_reports != null) ...[
              const SizedBox(height: 12),
              _buildReportList(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReportList(ThemeData theme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _reports!.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final r = _reports![index];
        if (!r.isValid) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              '#${index + 1}  无效记录',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          );
        }

        final timeStr = r.startTime != null
            ? '${r.startTime!.month}/${r.startTime!.day} '
              '${r.startTime!.hour.toString().padLeft(2, '0')}:'
              '${r.startTime!.minute.toString().padLeft(2, '0')}'
            : '--';
        final sleepH = r.totalSleepMinutes ~/ 60;
        final sleepM = r.totalSleepMinutes % 60;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '#${index + 1}  $timeStr',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${sleepH}h${sleepM}m',
                    style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  _tag('效率${r.sleepEfficiency}%', Colors.blue),
                  const SizedBox(width: 6),
                  _tag('质量${r.sleepQuality}分', Colors.teal),
                  const SizedBox(width: 6),
                  _tag('翻身${r.turnOverCount}', Colors.orange),
                  const SizedBox(width: 6),
                  _tag('AHI ${r.ahiIndex}', Colors.red),
                ],
              ),
              Row(
                children: [
                  _tag('潜时${r.sleepLatencyMinutes}min', Colors.purple),
                  const SizedBox(width: 6),
                  _tag('离床${r.leaveBedCount}', Colors.brown),
                  const SizedBox(width: 6),
                  _tag('打鼾${r.snoreTotalCount}', Colors.indigo),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tag(String text, Color color) {
    return Text(
      text,
      style: TextStyle(fontSize: 10, color: color),
    );
  }
}
