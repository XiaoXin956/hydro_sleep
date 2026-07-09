import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hydro_sleep/data/local/models/sleep_session.model.dart';
import 'package:hydro_sleep/data/local/models/report_summary_record.dart';
import 'package:hydro_sleep/data/local/models/sleep_minute_data.dart';
import 'package:hydro_sleep/data/local/models/temperature_record.dart';

/// Isar 数据库管理器
class HydroSleepDatabase {
  HydroSleepDatabase._();

  static Isar? _isar;

  static Future<Isar> getInstance() async {
    _isar ??= await open();
    return _isar!;
  }

  static Future<Isar> open() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [SleepSessionSchema, ReportSummaryRecordSchema, SleepMinuteDataSchema, TemperatureRecordSchema],
      directory: dir.path,
    );
  }

  static Isar? get instance => _isar;

  static bool get isOpen => _isar?.isOpen ?? false;

  static Future<void> close() async {
    if (_isar != null) {
      await _isar!.close();
      _isar = null;
    }
  }
}
