import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/data/local/models/sleep_minute_data.dart';
import 'package:hydro_sleep/data/repositories/sleep_data_repository.dart';
import 'package:hydro_sleep/domain/enums/sleep_minute_status.dart';

/// 0x94 分钟级睡眠数据测试卡片
class SleepMinuteDataTestCard extends StatefulWidget {
  const SleepMinuteDataTestCard({super.key});

  @override
  State<SleepMinuteDataTestCard> createState() => _SleepMinuteDataTestCardState();
}

class _SleepMinuteDataTestCardState extends State<SleepMinuteDataTestCard> {
  List<SleepMinuteData>? _dbRecords;
  String? _message;
  Color _messageColor = Colors.red;

  Future<void> _loadFromDb() async {
    final deviceId = context.read<BleConnectCubit>().state.remoteId;
    if (deviceId == null) {
      setState(() => _message = '未连接设备，无法查询');
      return;
    }

    final records = await SleepDataRepository.getSleepMinuteDataByDate(
      deviceId: deviceId,
      date: DateTime.now(),
    );
    if (mounted) {
      setState(() {
        _dbRecords = records;
        _message = '查询: deviceId=$deviceId\n'
            '数据库: ${records.length} 条分钟数据（今日）';
        _messageColor = records.isEmpty ? Colors.orange : Colors.blue;
      });
    }
  }

  Future<void> _loadAllFromDb() async {
    final all = await SleepDataRepository.getAllSleepMinuteData();
    if (mounted) {
      setState(() {
        _dbRecords = all;
        _message = '全部数据: ${all.length} 条（不过滤 deviceId）';
        _messageColor = all.isEmpty ? Colors.orange : Colors.blue;
      });
    }
  }

  Future<void> _clearDb() async {
    final deleted = await SleepDataRepository.deleteAllSleepMinuteData();
    if (mounted) {
      setState(() {
        _dbRecords = [];
        _message = '已清空 $deleted 条分钟数据';
        _messageColor = Colors.red;
      });
    }
  }

  Future<void> _generateTestData() async {
    final deviceId = context.read<BleConnectCubit>().state.remoteId ?? 'TEST_DEVICE';
    final rng = Random();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // 5 天：每天 23:00 → 次日 07:00（480 分钟）
    final days = List.generate(5, (i) => yesterday.subtract(Duration(days: i)));
    int totalMinutes = 0;
    for (final dayStart in days) {
      final startTime = DateTime(dayStart.year, dayStart.month, dayStart.day, 23, 0);
      final groups = <({int statusByte, int heartRate, int breathRate, int bodyMove})>[];
      for (var m = 0; m < 480; m++) {
        final int statusByte;
        final int hr; final int br; final int mv;
        if (m < 30) {
          // 入睡过渡
          statusByte = rng.nextBool() ? 0x14 : 0x12;
          hr = 62 + rng.nextInt(15); br = 13 + rng.nextInt(5); mv = rng.nextInt(2);
        } else if (m < 180) {
          // 深睡为主
          final r = rng.nextDouble();
          if (r < 0.4) {
            statusByte = 0x11; hr = 50 + rng.nextInt(12); br = 12 + rng.nextInt(4); mv = rng.nextInt(2);
          } else if (r < 0.75) {
            statusByte = 0x12; hr = 55 + rng.nextInt(15); br = 13 + rng.nextInt(5); mv = rng.nextInt(3);
          } else {
            statusByte = 0x13; hr = 58 + rng.nextInt(18); br = 14 + rng.nextInt(6); mv = rng.nextInt(4);
          }
        } else if (m < 360) {
          // REM+浅睡交替
          final r = rng.nextDouble();
          if (r < 0.35) {
            statusByte = 0x13; hr = 56 + rng.nextInt(20); br = 14 + rng.nextInt(6); mv = rng.nextInt(5);
          } else if (r < 0.7) {
            statusByte = 0x12; hr = 54 + rng.nextInt(15); br = 13 + rng.nextInt(5); mv = rng.nextInt(3);
          } else {
            statusByte = 0x11; hr = 50 + rng.nextInt(10); br = 11 + rng.nextInt(4); mv = rng.nextInt(2);
          }
        } else {
          // 逐渐清醒
          final r = rng.nextDouble();
          if (r < 0.3) {
            statusByte = 0x14; hr = 62 + rng.nextInt(15); br = 14 + rng.nextInt(5); mv = rng.nextInt(3);
          } else if (r < 0.6) {
            statusByte = 0x12; hr = 56 + rng.nextInt(15); br = 13 + rng.nextInt(5); mv = rng.nextInt(2);
          } else if (r < 0.85) {
            statusByte = 0x13; hr = 58 + rng.nextInt(18); br = 14 + rng.nextInt(6); mv = rng.nextInt(4);
          } else {
            statusByte = 0x11; hr = 50 + rng.nextInt(10); br = 11 + rng.nextInt(4); mv = rng.nextInt(2);
          }
        }
        groups.add((statusByte: statusByte, heartRate: hr, breathRate: br, bodyMove: mv));
      }
      await SleepDataRepository.saveSleepMinuteData(
        deviceId: deviceId, startTime: startTime, groups: groups,
      );
      totalMinutes += groups.length;
    }

    if (mounted) {
      setState(() {
        _message = '已生成 5 天测试数据（$totalMinutes 分钟）\n'
            'deviceId=$deviceId';
        _messageColor = Colors.green;
        _dbRecords = null;
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
            Text('分钟数据测试（0x94 + Isar）', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              '设备自动推送或手动触发 0x14 后，数据自动存库。\n'
              '生成测试数据：5 天，每天 23:00 → 次日 07:00（480 分钟）。',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loadFromDb,
                    child: const Text('查看数据库'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _loadAllFromDb,
                    child: const Text('全部数据'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _generateTestData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('生成测试数据'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearDb,
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('清空数据库'),
                  ),
                ),
              ],
            ),
            if (_message != null) ...[
              const SizedBox(height: 8),
              Text(_message!, style: TextStyle(fontSize: 13, color: _messageColor)),
            ],
            if (_dbRecords != null) ...[
              const SizedBox(height: 16),
              _sectionHeader('数据库记录（${_dbRecords!.length} 条）', Colors.teal),
              const SizedBox(height: 8),
              if (_dbRecords!.isEmpty)
                const Text('暂无数据', style: TextStyle(fontSize: 12, color: Colors.grey))
              else
                ..._dbRecords!.take(30).map((r) => _minuteTile(theme, r)),
              if (_dbRecords!.length > 30)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '... 共 ${_dbRecords!.length} 条，仅显示前 30 条',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
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

  Widget _minuteTile(ThemeData theme, SleepMinuteData r) {
    final status = SleepMinuteStatus.fromDbValue(r.status);
    final timeStr =
        '${r.timestamp.month.toString().padLeft(2, '0')}-'
        '${r.timestamp.day.toString().padLeft(2, '0')} '
        '${r.timestamp.hour.toString().padLeft(2, '0')}:'
        '${r.timestamp.minute.toString().padLeft(2, '0')}';
    final breathReal = (r.breathRate / 10).toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(timeStr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _statusColor(status).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status.displayName,
                style: TextStyle(fontSize: 11, color: _statusColor(status), fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Text('HR:${r.heartRate}', style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
            const SizedBox(width: 8),
            Text('BR:$breathReal', style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
            const SizedBox(width: 8),
            Text('MV:${r.bodyMove}', style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
          ],
        ),
      ),
    );
  }

  Color _statusColor(SleepMinuteStatus status) {
    switch (status) {
      case SleepMinuteStatus.deepSleep:
        return Colors.indigo;
      case SleepMinuteStatus.lightSleep:
        return Colors.blue;
      case SleepMinuteStatus.rem:
        return Colors.purple;
      case SleepMinuteStatus.awake:
        return Colors.orange;
      case SleepMinuteStatus.outOfBed:
        return Colors.red;
      case SleepMinuteStatus.sitting:
        return Colors.amber;
    }
  }
}
