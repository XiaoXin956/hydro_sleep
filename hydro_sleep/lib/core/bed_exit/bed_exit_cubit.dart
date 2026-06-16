import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/constants/app_constants.dart';
import 'package:hydro_sleep/data/storage/secure_storage_service.dart';

/// 离床关机时间状态管理，持久化到 SecureStorageService。
class BedExitCubit extends Cubit<String> {
  BedExitCubit() : super(AppConstants.bedExitOptions.first) {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final saved = await SecureStorageService().getBedExitShutdown();
    if (saved != null && saved.isNotEmpty) {
      emit(saved);
    }
  }

  Future<void> setOption(String option) async {
    if (state == option) return;
    emit(option);
    await SecureStorageService().saveBedExitShutdown(option);
  }
}
