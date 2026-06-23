import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/core/bluetooth/ble_scan_cubit.dart';
import 'package:hydro_sleep/presentation/device_search/device_search_page.dart';
import 'package:hydro_sleep/presentation/home/home_page.dart';
import 'package:hydro_sleep/presentation/index/index_page.dart';
import 'package:hydro_sleep/presentation/profile/profile_page.dart';
import 'package:hydro_sleep/presentation/report/report_page.dart';
import 'package:hydro_sleep/presentation/startup/startup_page.dart';

/// 应用路由配置
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // 启动页
    GoRoute(
      path: '/',
      name: 'startup',
      builder: (context, state) => const StartupPage(),
    ),

    // 首页（含 Tab）
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => HomePage(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const IndexPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/report',
              name: 'report',
              builder: (context, state) => const ReportPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),

    // 搜索设备页（独立）
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => BleScanCubit()),
          BlocProvider(create: (_) => BleConnectCubit()),
        ],
        child: const DeviceSearchPage(),
      ),
    ),
  ],
);
