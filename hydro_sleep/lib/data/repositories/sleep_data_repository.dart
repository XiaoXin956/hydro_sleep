import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:hydro_sleep/data/local/isar_database.dart';
import 'package:hydro_sleep/data/local/models/report_summary_record.dart';
import 'package:hydro_sleep/data/local/models/sleep_minute_data.dart';
import 'package:hydro_sleep/data/local/models/temperature_record.dart';
import 'package:hydro_sleep/domain/models/report_summary.dart';
import 'package:hydro_sleep/domain/enums/sleep_minute_status.dart';

/// 睡眠数据仓储
class SleepDataRepository {
  SleepDataRepository._();

  static Future<void> init() async {
    await HydroSleepDatabase.getInstance();
  }

  /// 保存 0x93 报表概要列表（相同 deviceId+startTime 覆盖更新）
  static Future<void> saveReportSummaries({
    required String deviceId,
    required String asciiId,
    required List<ReportSummary> summaries,
  }) async {
    final db = await HydroSleepDatabase.getInstance();
    final now = DateTime.now();
    final records = <ReportSummaryRecord>[];

    for (final s in summaries) {
      if (!s.isValid) continue;

      final record = ReportSummaryRecord()
        ..deviceId = deviceId
        ..asciiId = asciiId
        ..startTime = s.startTime!
        ..totalSleepMinutes = s.totalSleepMinutes
        ..sleepEfficiency = s.sleepEfficiency
        ..sleepQuality = s.sleepQuality
        ..turnOverCount = s.turnOverCount
        ..sleepLatencyMinutes = s.sleepLatencyMinutes
        ..leaveBedCount = s.leaveBedCount
        ..sleepRhythmPhase = s.sleepRhythmPhase
        ..reserved1 = s.reserved1
        ..longestSleepStartMinute = s.longestSleepStartMinute
        ..ahiIndex = s.ahiIndex
        ..snoreTotalCount = s.snoreTotalCount
        ..dataLoaded = false
        ..syncedAt = now;

      final existing = await db.reportSummaryRecords
          .filter()
          .deviceIdEqualTo(deviceId)
          .startTimeEqualTo(s.startTime!)
          .findFirst();
      if (existing != null) {
        record.id = existing.id;
        record.dataLoaded = existing.dataLoaded;
      }

      records.add(record);
    }

    await db.writeTxn(() => db.reportSummaryRecords.putAll(records));
  }

  /// 按设备查询所有报表（按时间倒序）
  static Future<List<ReportSummaryRecord>> getReportsByDevice(
      String deviceId) async {
    final db = await HydroSleepDatabase.getInstance();
    return db.reportSummaryRecords
        .filter()
        .deviceIdEqualTo(deviceId)
        .sortByStartTimeDesc()
        .findAll();
  }

  /// 按设备和日期范围查询
  static Future<List<ReportSummaryRecord>> getReportsByDeviceAndDateRange({
    required String deviceId,
    required DateTime start,
    required DateTime end,
  }) async {
    final db = await HydroSleepDatabase.getInstance();
    return db.reportSummaryRecords
        .filter()
        .deviceIdEqualTo(deviceId)
        .startTimeBetween(start, end)
        .sortByStartTimeDesc()
        .findAll();
  }

  /// 标记某条报表的详细数据已拉取
  static Future<void> markDataLoaded(String deviceId, DateTime startTime) async {
    final db = await HydroSleepDatabase.getInstance();
    final record = await db.reportSummaryRecords
        .filter()
        .deviceIdEqualTo(deviceId)
        .startTimeEqualTo(startTime)
        .findFirst();
    if (record != null) {
      record.dataLoaded = true;
      await db.writeTxn(() => db.reportSummaryRecords.put(record));
    }
  }

  /// 清空所有报表数据
  static Future<int> deleteAllReportSummaries() async {
    final db = await HydroSleepDatabase.getInstance();
    final count = await db.reportSummaryRecords.count();
    await db.writeTxn(() => db.reportSummaryRecords.clear());
    return count;
  }

  // ── 0x94 分钟级睡眠数据 ──

  /// 保存分钟级睡眠数据（按 deviceId+timestamp 去重覆盖）
  static Future<void> saveSleepMinuteData({
    required String deviceId,
    required List<({int statusByte, int heartRate, int breathRate, int bodyMove, DateTime dateTime})> groups,
  }) async {
    final db = await HydroSleepDatabase.getInstance();
    final records = <SleepMinuteData>[];

    for (final g in groups) {
      final record = SleepMinuteData()
        ..deviceId = deviceId
        ..timestamp = g.dateTime
        ..status = SleepMinuteStatus.fromByte(g.statusByte).dbValue
        ..heartRate = g.heartRate
        ..breathRate = g.breathRate
        ..bodyMove = g.bodyMove;

      // 查找已有记录覆盖
      final existing = await db.sleepMinuteDatas
          .filter()
          .deviceIdEqualTo(deviceId)
          .timestampEqualTo(g.dateTime)
          .findFirst();
      if (existing != null) {
        record.id = existing.id;
      }

      records.add(record);
    }

    await db.writeTxn(() => db.sleepMinuteDatas.putAll(records));
    debugPrint('[数据管理] 0x94 已保存 ${records.length} 分钟数据到 DB, '
        'deviceId=$deviceId, 首条时间=${records.isNotEmpty ? records.first.timestamp : "无"}');
  }

  /// 按日期查询分钟级数据（睡眠日：前一天 18:00 ~ 当天 18:00）
  static Future<List<SleepMinuteData>> getSleepMinuteDataByDate({
    required String deviceId,
    required DateTime date,
  }) async {
    final db = await HydroSleepDatabase.getInstance();
    // 睡眠日边界 18:00：用户选 7/9 → 查 7/8 18:00 ~ 7/9 18:00
    final dayBase = DateTime(date.year, date.month, date.day);
    final sleepDayStart = dayBase.subtract(const Duration(hours: 6)); // 前一天 18:00
    final sleepDayEnd = dayBase.add(const Duration(hours: 18));      // 当天 18:00
    debugPrint('[数据管理] 查询分钟数据: deviceId=$deviceId, '
        'sleepDay=$sleepDayStart ~ $sleepDayEnd');
    final result = await db.sleepMinuteDatas
        .filter()
        .deviceIdEqualTo(deviceId)
        .timestampBetween(sleepDayStart, sleepDayEnd)
        .sortByTimestamp()
        .findAll();
    debugPrint('[数据管理] 查询结果: ${result.length} 条');
    return result;
  }

  /// 查询指定时间范围内是否存在分钟数据
  static Future<bool> hasSleepMinuteData({
    required String deviceId,
    required DateTime start,
    required DateTime end,
  }) async {
    final db = await HydroSleepDatabase.getInstance();
    final count = await db.sleepMinuteDatas
        .filter()
        .deviceIdEqualTo(deviceId)
        .timestampBetween(start, end)
        .count();
    return count > 0;
  }

  /// 查询所有分钟数据（调试用，不过滤 deviceId）
  static Future<List<SleepMinuteData>> getAllSleepMinuteData() async {
    final db = await HydroSleepDatabase.getInstance();
    final all = await db.sleepMinuteDatas.where().findAll();
    debugPrint('[数据管理] 全部分钟数据: ${all.length} 条');
    for (final r in all.take(5)) {
      debugPrint('[数据管理]   deviceId=${r.deviceId}, ts=${r.timestamp}, '
          'status=${r.status}, hr=${r.heartRate}');
    }
    return all;
  }

  /// 清空所有分钟级睡眠数据
  static Future<int> deleteAllSleepMinuteData() async {
    final db = await HydroSleepDatabase.getInstance();
    final count = await db.sleepMinuteDatas.count();
    await db.writeTxn(() => db.sleepMinuteDatas.clear());
    return count;
  }

  // ── 温度记录（A5 5A 实际温度）──

  /// 保存单条温度记录
  static Future<void> saveTemperatureRecord({
    required String deviceId,
    required DateTime timestamp,
    required int temperature,
  }) async {
    final db = await HydroSleepDatabase.getInstance();
    final record = TemperatureRecord()
      ..deviceId = deviceId
      ..timestamp = timestamp
      ..temperature = temperature;
    await db.writeTxn(() => db.temperatureRecords.put(record));
  }

  /// 按日期查询温度记录（睡眠日：前一天 18:00 ~ 当天 18:00）
  static Future<List<TemperatureRecord>> getTemperatureByDate({
    required String deviceId,
    required DateTime date,
  }) async {
    final db = await HydroSleepDatabase.getInstance();
    final dayBase = DateTime(date.year, date.month, date.day);
    final sleepDayStart = dayBase.subtract(const Duration(hours: 6));
    final sleepDayEnd = dayBase.add(const Duration(hours: 18));
    return db.temperatureRecords
        .filter()
        .deviceIdEqualTo(deviceId)
        .timestampBetween(sleepDayStart, sleepDayEnd)
        .sortByTimestamp()
        .findAll();
  }

  /// 查询所有温度记录（调试用）
  static Future<List<TemperatureRecord>> getAllTemperatureRecords() async {
    final db = await HydroSleepDatabase.getInstance();
    return db.temperatureRecords.where().findAll();
  }

  /// 清空所有温度记录
  static Future<int> deleteAllTemperatureRecords() async {
    final db = await HydroSleepDatabase.getInstance();
    final count = await db.temperatureRecords.count();
    await db.writeTxn(() => db.temperatureRecords.clear());
    return count;
  }
}
