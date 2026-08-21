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

class _WeeklyReportBody extends StatefulWidget {
  const _WeeklyReportBody();

  @override
  State<_WeeklyReportBody> createState() => _WeeklyReportBodyState();
}

class _WeeklyReportBodyState extends State<_WeeklyReportBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsets.all(6),
      physics: const ClampingScrollPhysics(),
      children: [
        BlocBuilder<WeeklyReportCubit, WeeklyReportState>(
          buildWhen: (prev, curr) => prev.selectedDate != curr.selectedDate,
          builder: (context, state) => DateHeader(
            period: DatePeriod.week,
            selectedDate: state.selectedDate,
            onPeriodChanged: (date) {
              context.read<WeeklyReportCubit>().selectWeek(date);
            },
          ),
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