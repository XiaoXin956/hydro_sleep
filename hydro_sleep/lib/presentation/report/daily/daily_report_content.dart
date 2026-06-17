import 'package:flutter/material.dart';
import 'package:hydro_sleep/presentation/report/widgets/date_header.dart';
import 'package:hydro_sleep/presentation/report/widgets/sleep_score_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/sleep_stages_summary.dart';
import 'package:hydro_sleep/presentation/report/widgets/sleep_temp_curve.dart';
import 'package:hydro_sleep/presentation/report/widgets/heart_rate_chart.dart';

/// 日报告内容
class DailyReportContent extends StatelessWidget {
  const DailyReportContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
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
