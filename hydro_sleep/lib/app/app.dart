import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/locale/locale_cubit.dart';
import 'package:hydro_sleep/core/theme/dark_theme.dart';
import 'package:hydro_sleep/core/theme/theme_provider.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';
import 'package:hydro_sleep/routing/app_router.dart';
import 'package:provider/provider.dart';

/// 应用配置
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final locale = context.watch<LocaleCubit>().state;
        return MaterialApp.router(
          title: 'SmartSleep',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: Theme.of(context).copyWith(),
          darkTheme: DarkTheme.dark,
          routerConfig: appRouter,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
