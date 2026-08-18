import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/presentation/report/weekly/bloc/weekly_report_cubit.dart';
import 'package:hydro_sleep/presentation/report/widgets/date_header.dart';
import 'package:hydro_sleep/presentation/report/widgets/sleep_score_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/sleep_stages_summary.dart';

/// 周报告内容
class WeeklyReportContent extends StatelessWidget {
  const WeeklyReportContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeeklyReportCubit(
        connectCubit: context.read<BleConnectCubit>(),
      )..selectWeek(DateTime.now()),
      child: const _WeeklyReportBody(),
    );
  }
}

class _WeeklyReportBody extends StatelessWidget {
  const _WeeklyReportBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(6),
      physics: const ClampingScrollPhysics(),
      children: [
        DateHeader(
          period: DatePeriod.week,
          onPeriodChanged: (date) {
            context.read<WeeklyReportCubit>().selectWeek(date);
          },
        ),
        const SizedBox(height: 4),
        BlocBuilder<WeeklyReportCubit, WeeklyReportState>(
          builder: (context, state) => SleepScoreCard(
            score: state.avgScore,
            totalMinutes: state.avgTotalMinutes,
            showBedtime: false,
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<WeeklyReportCubit, WeeklyReportState>(
          builder: (context, state) => SleepStagesSummary(
            stats: state.stageStats,
            dateKey: state.selectedDate,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}