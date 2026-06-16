import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 首页（Tab 容器，仅负责导航）
class HomePage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomePage({super.key, required this.navigationShell});

  int get selectedIndex => navigationShell.currentIndex;

  void _goBranch(int index) {
    navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _goBranch,
        selectedItemColor: const Color(0xFF1976D2),
        unselectedItemColor: const Color(0xFF757575),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.bottomNavHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assessment_outlined),
            activeIcon: const Icon(Icons.assessment),
            label: l10n.bottomNavReport,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.bottomNavProfile,
          ),
        ],
      ),
    );
  }
}
