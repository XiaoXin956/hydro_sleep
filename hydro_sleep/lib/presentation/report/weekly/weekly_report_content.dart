import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 周报告内容（占位）
class WeeklyReportContent extends StatelessWidget {
  const WeeklyReportContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.bar_chart, size: 48, color: AppColors.textHint),
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
          ),
        ),
      ],
    );
  }
}
