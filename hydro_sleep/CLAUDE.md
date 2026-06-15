# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**SmartSleep** - Flutter app for BLE-based sleep monitoring. Target platform: Android/iOS.

- Flutter 3.44.1 / Dart 3.12.1
- `isar_community` 3.3.0 for local storage (with `build_runner` code generation)
- `go_router` 17.3.0 for routing
- `provider` for ThemeProvider state
- `flutter_bloc` in dependencies but not yet used in code

## Directory Structure

```
lib/
  app/app.dart              - App root widget (Provider wrapper + MaterialApp.router)
  main.dart                 - Entry point
  routing/app_router.dart   - GoRouter config (Startup -> HomePage tabs -> Search)
  core/
    constants/app_constants.dart  - App-wide constants
    theme/
      app_colors.dart       - Color palette
      app_theme.dart        - Light theme (CardThemeData, TextTheme)
      dark_theme.dart       - Dark theme
      theme_provider.dart   - ChangeNotifier for theme toggle
    utils/mock_data.dart    - Test/mock data for UI pages
  data/
    local/                  - Isar DB + models (build_runner generates .g.dart)
      isar_database.dart    - HydroSleepDatabase singleton
      models/               - SleepSession, SleepReport, SleepMinute (@collection)
    repositories/           - Business logic layer (device_repository, sleep_data_repository)
    storage/                - SecureStorageService singleton (flutter_secure_storage)
  domain/
    enums/sleep_stage.dart  - SleepStage, ReportSleepStage enums
    models/history_device.dart - HistoryDevice (Equatable, JSON serialization)
  presentation/
    startup/startup_page.dart         - Splash screen (auto-navigate to /home)
    home/home_page.dart               - Tab shell (HomeContent, Report, Profile)
    home/widgets/                     - ConnectionStatusCard, ModeSelectionCard, TemperatureControlCard, ScheduleCard
    report/report_page.dart           - Sleep report (score, stages, temp curve, heart rate charts)
    report/widgets/                   - DateHeader, SleepScoreCard, SleepStagesSummary, SleepTempCurve, HeartRateChart
    profile/profile_page.dart         - Settings (profile, device list, language, temp unit, mode preference, bed exit)
    profile/widgets/                  - ProfileCard, DeviceListCard, LanguageSelector, TemperatureUnitSelector, etc.
    device_search/device_search_page.dart - BLE device search (placeholder, no BLoC yet)
```

## Common Commands

```bash
# From hydro_sleep/ directory

# Get dependencies
flutter pub get

# Run build_runner (Isar models)
flutter pub run build_runner build --delete-conflicting-outputs

# Analyze
flutter analyze

# Run tests
flutter test

# Run on connected device
flutter run
```

## Architecture Notes

- **No BLoC yet**: `bloc/` directories exist but are empty. All pages are pure StatefulWidget/StatelessWidget.
- **Data layer**: Two singletons - `HydroSleepDatabase` (Isar) and `SecureStorageService` (flutter_secure_storage). Repositories wrap these.
- **Routing**: GoRouter with StatefulShellRoute for the 3-tab home (Home/Report/Profile). Startup -> /home auto-navigates after 2s.
- **State management**: Only `ThemeProvider` uses `ChangeNotifier`/`provider`. The rest is plain widget state.
- **Charts**: `fl_chart` 1.2.0 - use `LineChartBarData` (not `LineChartBar`), `withValues(alpha:)` (not `withOpacity`), `activeThumbColor` (not `activeColor`).
- **Flutter 3.44 API changes**: `CardTheme` -> `CardThemeData`, `SliverChildList.fixed` -> `SliverChildBuilderDelegate`, `StatefulNavigationShell` (not `StatefulShellNavigationShell`).
- **Isar**: Models use `@collection` annotation (lowercase, from `isar_community`). Run `build_runner` after any model change. Models live in `lib/data/local/models/`.
- **IMPORTANT**: After modifying **any file** under `lib/data/local/`, always run `flutter pub run build_runner build --delete-conflicting-outputs` to regenerate `.g.dart` files. This is required for the app to compile.
