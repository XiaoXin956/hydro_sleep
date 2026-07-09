import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/data/local/isar_database.dart';
import 'package:hydro_sleep/data/local/models/temperature_record.dart';
import 'package:hydro_sleep/data/repositories/sleep_data_repository.dart';

/// 温度记录测试卡片（A5 5A 实际温度）
class TemperatureRecordTestCard extends StatefulWidget {
  const TemperatureRecordTestCard({super.key});

  @override
  State<TemperatureRecordTestCard> createState() => _TemperatureRecordTestCardState();
}

class _TemperatureRecordTestCardState extends State<TemperatureRecordTestCard> {
  List<TemperatureRecord>? _dbRecords;
  String? _message;
  Color _messageColor = Colors.red;

  Future<void> _loadFromDb() async {
    final deviceId = context.read<BleConnectCubit>().state.remoteId;
    if (deviceId == null) {
      setState(() => _message = '未连接设备，无法查询');
      return;
    }
    final records = await SleepDataRepository.getTemperatureByDate(
      deviceId: deviceId,
      date: DateTime.now(),
    );
    if (mounted) {
      setState(() {
        _dbRecords = records;
        _message = '查询: deviceId=$deviceId\n${records.length} 条温度记录（今日睡眠日）';
        _messageColor = records.isEmpty ? Colors.orange : Colors.blue;
      });
    }
  }

  Future<void> _loadAllFromDb() async {
    final all = await SleepDataRepository.getAllTemperatureRecords();
    if (mounted) {
      setState(() {
        _dbRecords = all;
        _message = '全部数据: ${all.length} 条（不过滤 deviceId）';
        _messageColor = all.isEmpty ? Colors.orange : Colors.blue;
      });
    }
  }

  Future<void> _generateTestData() async {
    final deviceId = context.read<BleConnectCubit>().state.remoteId ?? 'TEST_DEVICE';
    final rng = Random();
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
    final days = List.generate(5, (i) => yesterday.subtract(Duration(days: i)));

    int totalRecords = 0;
    final db = await HydroSleepDatabase.getInstance();

    for (final dayStart in days) {
      final startTime = DateTime(dayStart.year, dayStart.month, dayStart.day, 23, 0);
      final endTime = startTime.add(const Duration(hours: 7));
      var t = startTime;
      var temp = 25.0 + rng.nextDouble() * 3;
      final records = <TemperatureRecord>[];

      while (t.isBefore(endTime)) {
        temp += (rng.nextDouble() - 0.48) * 0.5;
        temp = temp.clamp(18.0, 35.0);
        records.add(TemperatureRecord()
          ..deviceId = deviceId
          ..timestamp = t
          ..temperature = temp.round());
        t = t.add(const Duration(seconds: 5));
      }

      await db.writeTxn(() => db.temperatureRecords.putAll(records));
      totalRecords += records.length;
    }

    if (mounted) {
      setState(() {
        _message = '已生成 5 天温度数据（$totalRecords 条）\n'
            '23:00→06:00，每 5 秒一条\ndeviceId=$deviceId';
        _messageColor = Colors.green;
        _dbRecords = null;
      });
    }
  }

  Future<void> _clearDb() async {
    final deleted = await SleepDataRepository.deleteAllTemperatureRecords();
    if (mounted) {
      setState(() {
        _dbRecords = [];
        _message = '已清空 $deleted 条温度记录';
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
            Text('温度记录测试（A5 5A + Isar）', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'A5 5A 推送时每 10 秒存一条温度。\n'
              '生成测试数据：5 天，每天 23:00→06:00，每 5 秒一条。',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: ElevatedButton(
                  onPressed: _loadFromDb,
                  child: const Text('查看数据库'),
                )),
                const SizedBox(width: 8),
                Expanded(child: OutlinedButton(
                  onPressed: _loadAllFromDb,
                  child: const Text('全部数据'),
                )),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: ElevatedButton(
                  onPressed: _generateTestData,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                  child: const Text('生成测试数据'),
                )),
                const SizedBox(width: 8),
                Expanded(child: OutlinedButton(
                  onPressed: _clearDb,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('清空数据库'),
                )),
              ],
            ),
            if (_message != null) ...[
              const SizedBox(height: 8),
              Text(_message!, style: TextStyle(fontSize: 13, color: _messageColor)),
            ],
            if (_dbRecords != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '数据库记录（${_dbRecords!.length} 条）',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 8),
              if (_dbRecords!.isEmpty)
                const Text('暂无数据', style: TextStyle(fontSize: 12, color: Colors.grey))
              else
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: _dbRecords!.length > 200 ? 200 : _dbRecords!.length,
                    itemBuilder: (context, index) {
                      final r = _dbRecords![index];
                      final timeStr =
                          '${r.timestamp.month.toString().padLeft(2, '0')}-'
                          '${r.timestamp.day.toString().padLeft(2, '0')} '
                          '${r.timestamp.hour.toString().padLeft(2, '0')}:'
                          '${r.timestamp.minute.toString().padLeft(2, '0')}:'
                          '${r.timestamp.second.toString().padLeft(2, '0')}';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.teal.withValues(alpha: 0.15)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 110,
                                child: Text(timeStr, style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                              ),
                              const Spacer(),
                              Text(
                                '${r.temperature}°C',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _tempColor(r.temperature),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (_dbRecords!.length > 200)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '... 共 ${_dbRecords!.length} 条，仅显示前 200 条',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Color _tempColor(int temp) {
    if (temp < 20) return Colors.blue;
    if (temp < 25) return Colors.teal;
    if (temp < 30) return Colors.orange;
    return Colors.red;
  }
}
