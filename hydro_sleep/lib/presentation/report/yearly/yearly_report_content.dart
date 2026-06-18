import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';
import 'package:hydro_sleep/presentation/report/widgets/date_header.dart';

/// 年报告内容（占位）
class YearlyReportContent extends StatelessWidget {
  const YearlyReportContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => [
                const DateHeader(period: DatePeriod.year),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.bar_chart,
                              size: 48, color: AppColors.textHint),
                          const SizedBox(height: 16),
                          Text(
                            l10n.reportTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ][index],
              childCount: 3,
            ),
          ),
        ),
      ],
    );
  }
}
