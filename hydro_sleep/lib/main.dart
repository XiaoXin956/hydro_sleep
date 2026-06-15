import 'package:flutter/material.dart';
import 'package:hydro_sleep/app/app.dart';
import 'package:hydro_sleep/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const App(),
    ),
  );
}
