import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/data/storage/secure_storage_service.dart';

/// Locale state management using BLoC pattern.
/// Persists selected locale to secure storage.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final saved = await SecureStorageService().getLanguage();
    if (saved != null && saved.isNotEmpty) {
      emit(Locale(saved));
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;
    emit(locale);
    await SecureStorageService().saveLanguage(locale.languageCode);
  }
}
