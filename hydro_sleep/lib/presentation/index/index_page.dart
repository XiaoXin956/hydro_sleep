import 'package:flutter/material.dart';
import 'package:hydro_sleep/presentation/index/widgets/connection_status_card.dart';
import 'package:hydro_sleep/presentation/index/widgets/mode_selection_card.dart';
import 'package:hydro_sleep/presentation/index/widgets/schedule_card.dart';
import 'package:hydro_sleep/presentation/index/widgets/temperature_control_card.dart';

/// 首页索引页（Tab 0）
class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 顶部栏
        SliverAppBar(
          pinned: true,
          expandedHeight: 70,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'SmartSleep',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
            centerTitle: false,
          ),
          actions: [

          ],
        ),
        // 内容区域
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
                  const TemperatureControlCard(),
                  const SizedBox(height: 16),
                  const ScheduleCard(),
                  const SizedBox(height: 80),
                ];
                return items[index];
              },
              childCount: 8,
            ),
          ),
        ),
      ],
    );
  }
}
