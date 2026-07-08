import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/data/repositories/sleep_data_repository.dart';
import 'package:hydro_sleep/domain/models/report_summary.dart';

// --- State ---

class DailyReportState extends Equatable {
  final DateTime selectedDate;
  final ReportSummary? report;

  const DailyReportState({
    required this.selectedDate,
    this.report,
  });

  DailyReportState copyWith({
    DateTime? selectedDate,
    ReportSummary? report,
    bool clearReport = false,
  }) {
    return DailyReportState(
      selectedDate: selectedDate ?? this.selectedDate,
      report: clearReport ? null : (report ?? this.report),
    );
  }

  @override
  List<Object?> get props => [selectedDate, report];
}

// --- Cubit ---

class DailyReportCubit extends Cubit<DailyReportState> {
  DailyReportCubit({required BleConnectCubit connectCubit})
      : _connectCubit = connectCubit,
        super(DailyReportState(selectedDate: DateTime.now()));

  final BleConnectCubit _connectCubit;

  Future<void> selectDate(DateTime date) async {
    emit(state.copyWith(selectedDate: date));

    final deviceId = _connectCubit.state.remoteId;
    if (deviceId == null) return;

    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final records = await SleepDataRepository.getReportsByDeviceAndDateRange(
      deviceId: deviceId,
      start: dayStart,
      end: dayEnd,
    );

    if (records.isNotEmpty) {
      final r = records.first;
      emit(state.copyWith(report: ReportSummary(
        startTime: r.startTime,
        totalSleepMinutes: r.totalSleepMinutes,
        sleepEfficiency: r.sleepEfficiency,
        sleepQuality: r.sleepQuality,
        turnOverCount: r.turnOverCount,
        sleepLatencyMinutes: r.sleepLatencyMinutes,
        leaveBedCount: r.leaveBedCount,
        sleepRhythmPhase: r.sleepRhythmPhase,
        reserved1: r.reserved1,
        longestSleepStartMinute: r.longestSleepStartMinute,
        ahiIndex: r.ahiIndex,
        snoreTotalCount: r.snoreTotalCount,
      )));
    } else {
      emit(state.copyWith(clearReport: true));
    }
  }
}
