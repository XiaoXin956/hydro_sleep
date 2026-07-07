import 'package:flutter/material.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';
import 'package:hydro_sleep/presentation/index/widgets/ble_debug_card.dart';
import 'package:hydro_sleep/presentation/index/widgets/connection_status_card.dart';
import 'package:hydro_sleep/presentation/index/widgets/mode_selection_card.dart';
import 'package:hydro_sleep/presentation/index/widgets/water_level_card.dart';
import 'package:hydro_sleep/presentation/index/widgets/schedule_card.dart';
import 'package:hydro_sleep/presentation/index/widgets/temperature_control_card.dart';

/// 首页索引页（Tab 0）
class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 70,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              AppLocalizations.of(context)!.appTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
            centerTitle: false,
          ),
          actions: [],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final items = <Widget>[
                  const ConnectionStatusCard(),
                  const SizedBox(height: 16),
                  const ModeSelectionCard(),
                  const SizedBox(height: 16),
                  const WaterLevelCard(),
                  const SizedBox(height: 16),
                  const TemperatureControlCard(),
                  const SizedBox(height: 16),
                  const ScheduleCard(),
                  const SizedBox(height: 16),
                  const BleDebugCard(),
                  const SizedBox(height: 80),
                ];
                return items[index];
              },
              childCount: 12,
            ),
          ),
        ),
      ],
    );
  }
}
