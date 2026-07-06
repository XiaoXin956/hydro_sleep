import 'package:isar_community/isar.dart';
import 'package:hydro_sleep/data/local/isar_database.dart';
import 'package:hydro_sleep/data/local/models/report_summary_record.dart';
import 'package:hydro_sleep/domain/models/report_summary.dart';

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
}
