import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';
import 'package:hydro_sleep/presentation/report/daily/daily_report_content.dart';
import 'package:hydro_sleep/presentation/report/weekly/weekly_report_content.dart';
import 'package:hydro_sleep/presentation/report/monthly/monthly_report_content.dart';
import 'package:hydro_sleep/presentation/report/yearly/yearly_report_content.dart';

/// 报告页 — 日/周/月/年 Tab 切换
class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.reportTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 48),
              centerTitle: false,
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              tabs: [
                Tab(text: l10n.dateDay),
                Tab(text: l10n.dateWeek),
                Tab(text: l10n.dateMonth),
                Tab(text: l10n.dateYear),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            DailyReportContent(),
            WeeklyReportContent(),
            MonthlyReportContent(),
            YearlyReportContent(),
          ],
        ),
      ),
    );
  }
}
