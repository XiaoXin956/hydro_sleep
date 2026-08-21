import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/presentation/report/monthly/bloc/monthly_report_cubit.dart';
import 'package:hydro_sleep/presentation/report/widgets/date_header.dart';
import 'package:hydro_sleep/presentation/report/widgets/sleep_score_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/sleep_stages_summary.dart';

/// 月报告内容
class MonthlyReportContent extends StatelessWidget {
  const MonthlyReportContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MonthlyReportCubit(
        connectCubit: context.read<BleConnectCubit>(),
      )..selectMonth(DateTime.now()),
      child: const _MonthlyReportBody(),
    );
  }
}

class _MonthlyReportBody extends StatefulWidget {
  const _MonthlyReportBody();

  @override
  State<_MonthlyReportBody> createState() => _MonthlyReportBodyState();
}

class _MonthlyReportBodyState extends State<_MonthlyReportBody>
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
        BlocBuilder<MonthlyReportCubit, MonthlyReportState>(
          buildWhen: (prev, curr) => prev.selectedDate != curr.selectedDate,
          builder: (context, state) => DateHeader(
            period: DatePeriod.month,
            selectedDate: state.selectedDate,
            onPeriodChanged: (date) {
              context.read<MonthlyReportCubit>().selectMonth(date);
            },
          ),
        ),
        const SizedBox(height: 4),
        BlocBuilder<MonthlyReportCubit, MonthlyReportState>(
          builder: (context, state) => SleepScoreCard(
            score: state.avgScore,
            totalMinutes: state.avgTotalMinutes,
            showBedtime: false,
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<MonthlyReportCubit, MonthlyReportState>(
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