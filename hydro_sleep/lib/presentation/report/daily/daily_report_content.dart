import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/presentation/report/daily/bloc/daily_report_cubit.dart';
import 'package:hydro_sleep/presentation/report/widgets/date_header.dart';
import 'package:hydro_sleep/presentation/report/widgets/sleep_score_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/sleep_stages_summary.dart';
import 'package:hydro_sleep/presentation/report/widgets/sleep_temp_curve.dart';
import 'package:hydro_sleep/presentation/report/widgets/heart_rate_chart.dart';
import 'package:hydro_sleep/presentation/report/widgets/retransmit_test_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/retransmit30_test_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/stop_command_test_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/mode_command_test_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/device_status_test_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/heartbeat_test_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/pressure_calibrate_test_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/parameter_test_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/clock_calibrate_test_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/report_query_test_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/report_detail_test_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/firmware_version_test_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/report_storage_test_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/sleep_minute_data_test_card.dart';
import 'package:hydro_sleep/presentation/report/widgets/temperature_record_test_card.dart';

/// 日报告内容
class DailyReportContent extends StatelessWidget {
  const DailyReportContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DailyReportCubit(
        connectCubit: context.read<BleConnectCubit>(),
      )..selectDate(DateTime.now()),
      child: const _DailyReportBody(),
    );
  }
}

class _DailyReportBody extends StatelessWidget {
  const _DailyReportBody();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(6),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final items = <Widget>[
                DateHeader(
                  period: DatePeriod.day,
                  onPeriodChanged: (date) {
                    context.read<DailyReportCubit>().selectDate(date);
                  },
                ),
                const SizedBox(height: 4),
                const SleepScoreCard(),
                const SizedBox(height: 16),
                const SleepStagesSummary(),
                const SizedBox(height: 16),
                const SleepTempCurve(),
                const SizedBox(height: 16),
                const HeartRateChart(),
                const SizedBox(height: 16),
                const RetransmitTestCard(),
                const SizedBox(height: 16),
                const Retransmit30TestCard(),
                const SizedBox(height: 16),
                const StopCommandTestCard(),
                const SizedBox(height: 16),
                const ModeCommandTestCard(),
                const SizedBox(height: 16),
                const DeviceStatusTestCard(),
                const SizedBox(height: 16),
                const HeartbeatTestCard(),
                const SizedBox(height: 16),
                const PressureCalibrateTestCard(),
                const SizedBox(height: 16),
                const ParameterTestCard(),
                const SizedBox(height: 16),
                const ClockCalibrateTestCard(),
                const SizedBox(height: 16),
                const ReportQueryTestCard(),
                const SizedBox(height: 16),
                const ReportDetailTestCard(),
                const SizedBox(height: 16),
                const FirmwareVersionTestCard(),
                const SizedBox(height: 16),
                const ReportStorageTestCard(),
                const SizedBox(height: 16),
                const SleepMinuteDataTestCard(),
                const SizedBox(height: 16),
                const TemperatureRecordTestCard(),
                const SizedBox(height: 40),
              ];
              return items[index];
            }, childCount: 40),
          ),
        ),
      ],
    );
  }
}
