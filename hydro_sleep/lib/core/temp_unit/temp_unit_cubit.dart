import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/data/storage/secure_storage_service.dart';

/// 温度单位状态管理（°C / °F），持久化到 SecureStorageService。
class TempUnitCubit extends Cubit<String> {
  TempUnitCubit() : super('°C') {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final saved = await SecureStorageService().getTempUnit();
    if (saved != null && saved.isNotEmpty) {
      emit(saved);
    }
  }

  Future<void> setUnit(String unit) async {
    if (state == unit) return;
    emit(unit);
    await SecureStorageService().saveTempUnit(unit);
  }
}
