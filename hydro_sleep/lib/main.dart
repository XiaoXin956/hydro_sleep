import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/app/app.dart';
import 'package:hydro_sleep/core/bed_exit/bed_exit_cubit.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/core/device_list/device_list_cubit.dart';
import 'package:hydro_sleep/core/factory_reset/factory_reset_cubit.dart';
import 'package:hydro_sleep/core/locale/locale_cubit.dart';
import 'package:hydro_sleep/core/temp_unit/temp_unit_cubit.dart';
import 'package:hydro_sleep/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => FactoryResetCubit()),
        BlocProvider(create: (_) => TempUnitCubit()),
        BlocProvider(create: (_) => BedExitCubit()),
        BlocProvider(create: (_) => DeviceListCubit()),
        BlocProvider(create: (_) => BleConnectCubit()),
      ],
      child: const App(),
    ),
  );
}
