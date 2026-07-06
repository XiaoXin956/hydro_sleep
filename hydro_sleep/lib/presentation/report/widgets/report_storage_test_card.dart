import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';
import 'package:hydro_sleep/data/local/models/report_summary_record.dart';
import 'package:hydro_sleep/data/repositories/sleep_data_repository.dart';
import 'package:hydro_sleep/domain/models/report_summary.dart';

/// 0x93 报表存储测试卡片 — 显示 BLE 接收数据 + 数据库持久化数据
class ReportStorageTestCard extends StatefulWidget {
  const ReportStorageTestCard({super.key});

  @override
  State<ReportStorageTestCard> createState() => _ReportStorageTestCardState();
}

class _ReportStorageTestCardState extends State<ReportStorageTestCard> {
  bool _loading = false;
  List<ReportSummary>? _bleReports;
  List<ReportSummaryRecord>? _dbRecords;
  String? _message;
  Color _messageColor = Colors.red;

  Future<void> _queryAndSave() async {
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
      final reports = await dataCubit.sendReportQueryCommand();
      if (!mounted) return;

      final deviceId = context.read<BleConnectCubit>().state.remoteId;
      List<ReportSummaryRecord> dbRecords = [];
      if (deviceId != null) {
        dbRecords = await SleepDataRepository.getReportsByDevice(deviceId);
      }

      setState(() {
        _loading = false;
        _bleReports = reports;
        _dbRecords = dbRecords;
        _message = 'BLE: ${reports.length} 条 | DB: ${dbRecords.length} 条';
        _messageColor = Colors.green;
      });
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

  Future<void> _loadFromDb() async {
    final deviceId = context.read<BleConnectCubit>().state.remoteId;
    if (deviceId == null) {
      setState(() => _message = '未连接设备，无法查询');
      return;
    }

    final records = await SleepDataRepository.getReportsByDevice(deviceId);
    if (mounted) {
      setState(() {
        _dbRecords = records;
        _message = '数据库: ${records.length} 条记录';
        _messageColor = Colors.blue;
      });
    }
  }

  Future<void> _clearDb() async {
    final deleted = await SleepDataRepository.deleteAllReportSummaries();
    if (mounted) {
      setState(() {
        _dbRecords = [];
        _message = '已清空 $deleted 条记录';
        _messageColor = Colors.red;
      });
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
            Text('报表存储测试（0x93 + Isar）', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              '查询 BLE 数据并自动存库，或单独查看数据库内容',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _queryAndSave,
                    child: _loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('查询 + 存库'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _loading ? null : _loadFromDb,
                    child: const Text('查看数据库'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _loading ? null : _clearDb,
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('清空数据库'),
              ),
            ),
            if (_message != null) ...[
              const SizedBox(height: 8),
              Text(_message!, style: TextStyle(fontSize: 13, color: _messageColor)),
            ],

            // BLE 接收数据
            if (_bleReports != null) ...[
              const SizedBox(height: 16),
              _sectionHeader('BLE 接收数据（${_bleReports!.length} 条）', Colors.blue),
              const SizedBox(height: 8),
              ..._bleReports!.asMap().entries.map((e) => _bleReportTile(theme, e.key, e.value)),
            ],

            // 数据库数据
            if (_dbRecords != null) ...[
              const SizedBox(height: 16),
              _sectionHeader('数据库记录（${_dbRecords!.length} 条）', Colors.teal),
              const SizedBox(height: 8),
              if (_dbRecords!.isEmpty)
                const Text('暂无数据', style: TextStyle(fontSize: 12, color: Colors.grey))
              else
                ..._dbRecords!.asMap().entries.map((e) => _dbRecordTile(theme, e.key, e.value)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
    );
  }

  // ---- BLE 单条记录 ----
  Widget _bleReportTile(ThemeData theme, int index, ReportSummary r) {
    if (!r.isValid) {
      return _emptyTile('#${index + 1}  无效记录');
    }
    final timeStr = _formatTime(r.startTime);
    final sleepStr = '${r.totalSleepMinutes ~/ 60}h${r.totalSleepMinutes % 60}m';
    return _recordCard(
      theme,
      '#${index + 1}',
      timeStr,
      sleepStr,
      [
        _kv('效率', '${r.sleepEfficiency}%'),
        _kv('质量', '${r.sleepQuality}'),
        _kv('翻身', '${r.turnOverCount}'),
        _kv('潜时', '${r.sleepLatencyMinutes}m'),
        _kv('离床', '${r.leaveBedCount}'),
        _kv('节律', '${r.sleepRhythmPhase}'),
        _kv('最长段', '${r.longestSleepStartMinute}m'),
        _kv('AHI', '${r.ahiIndex}'),
        _kv('打鼾', '${r.snoreTotalCount}'),
      ],
      Colors.blue,
    );
  }

  // ---- DB 单条记录 ----
  Widget _dbRecordTile(ThemeData theme, int index, ReportSummaryRecord r) {
    final timeStr = _formatTime(r.startTime);
    final sleepStr = '${r.totalSleepMinutes ~/ 60}h${r.totalSleepMinutes % 60}m';
    return _recordCard(
      theme,
      '#${index + 1}',
      timeStr,
      sleepStr,
      [
        _kv('效率', '${r.sleepEfficiency}%'),
        _kv('质量', '${r.sleepQuality}'),
        _kv('翻身', '${r.turnOverCount}'),
        _kv('潜时', '${r.sleepLatencyMinutes}m'),
        _kv('离床', '${r.leaveBedCount}'),
        _kv('AHI', '${r.ahiIndex}'),
        _kv('打鼾', '${r.snoreTotalCount}'),
        _kv('数据', r.dataLoaded ? '已拉取' : '未拉取'),
      ],
      Colors.teal,
      Text(
        'asciiId: ${r.asciiId}',
        style: const TextStyle(fontSize: 9, color: Colors.grey, fontFamily: 'monospace'),
      ),
    );
  }

  Widget _recordCard(
    ThemeData theme,
    String indexLabel,
    String time,
    String sleep, [
    List<Widget> tags = const [],
    Color accent = Colors.grey,
    Widget? extra,
  ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: accent.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(indexLabel, style: TextStyle(fontSize: 11, color: accent, fontWeight: FontWeight.bold)),
                const SizedBox(width: 6),
                Text(time, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(sleep, style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
              ],
            ),
            const SizedBox(height: 4),
            Wrap(spacing: 8, runSpacing: 2, children: tags),
            if (extra != null) ...[const SizedBox(height: 2), extra],
          ],
        ),
      ),
    );
  }

  Widget _emptyTile(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text, style: const TextStyle(fontSize: 11, color: Colors.grey)),
    );
  }

  Widget _kv(String k, String v) {
    return Text('$k: $v', style: const TextStyle(fontSize: 10, color: Colors.black87));
  }

  String _formatTime(DateTime? t) {
    if (t == null) return '--';
    return '${t.month}/${t.day} '
        '${t.hour.toString().padLeft(2, '0')}:'
        '${t.minute.toString().padLeft(2, '0')}';
  }
}
