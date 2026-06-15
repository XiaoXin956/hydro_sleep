import 'package:hydro_sleep/data/local/isar_database.dart';

/// 睡眠数据仓储
class SleepDataRepository {
  SleepDataRepository._();

  static Future<void> init() async {
    await HydroSleepDatabase.getInstance();
  }

  // 占位：后续接入 Isar 查询
}
