import 'package:isar_community/isar.dart';
import 'package:hydro_sleep/data/local/models/sleep_session.model.dart';

/// Isar 数据库管理器
class HydroSleepDatabase {
  HydroSleepDatabase._();

  static Isar? _isar;

  static Future<Isar> getInstance() async {
    _isar ??= await open();
    return _isar!;
  }

  static Future<Isar> open() async {
    return Isar.open(
      [SleepSessionSchema],
      directory: 'hydro_sleep_db',
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
