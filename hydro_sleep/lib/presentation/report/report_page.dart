import 'package:flutter/material.dart';
import 'package:hydro_sleep/presentation/report/widgets/date_header.dart';
import 'package:hydro_sleep/presentation/report/widgets/sleep_score_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/sleep_stages_summary.dart';
import 'package:hydro_sleep/presentation/report/widgets/sleep_temp_curve.dart';
import 'package:hydro_sleep/presentation/report/widgets/heart_rate_chart.dart';

/// 报告页
class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 顶部栏
        SliverAppBar(
          pinned: true,
          expandedHeight: 60,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Sleep Report', style: TextStyle(fontWeight: FontWeight.bold)),
            titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
            centerTitle: false,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final items = <Widget>[
                const DateHeader(),
                const SizedBox(height: 16),
                const SleepScoreCard(),
                const SizedBox(height: 16),
                const SleepStagesSummary(),
                const SizedBox(height: 16),
                const SleepTempCurve(),
                const SizedBox(height: 16),
                const HeartRateChart(),
                const SizedBox(height: 40),
              ];
              return items[index];
            }, childCount: 10),
          ),
        ),
      ],
    );
  }
}
