import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/data/repositories/sleep_data_repository.dart';
import 'package:hydro_sleep/domain/enums/sleep_minute_status.dart';
import 'package:hydro_sleep/domain/models/sleep_stage_stats.dart';

// --- State ---

class WeeklyReportState extends Equatable {
  final DateTime selectedDate;
  final int? avgScore; // 平均睡眠评分（周内有效报表）
  final int? avgTotalMinutes; // 平均睡眠时长（分钟）
  final SleepStageStats? stageStats;

  const WeeklyReportState({
    required this.selectedDate,
    this.avgScore,
    this.avgTotalMinutes,
    this.stageStats,
  });

  WeeklyReportState copyWith({
    DateTime? selectedDate,
    int? avgScore,
    int? avgTotalMinutes,
    SleepStageStats? stageStats,
    bool clearAvg = false,
    bool clearStageStats = false,
  }) {
    return WeeklyReportState(
      selectedDate: selectedDate ?? this.selectedDate,
      avgScore: clearAvg ? null : (avgScore ?? this.avgScore),
      avgTotalMinutes: clearAvg ? null : (avgTotalMinutes ?? this.avgTotalMinutes),
      stageStats: clearStageStats ? null : (stageStats ?? this.stageStats),
    );
  }

  @override
  List<Object?> get props => [selectedDate, avgScore, avgTotalMinutes, stageStats];
}

// --- Cubit ---

class WeeklyReportCubit extends Cubit<WeeklyReportState> {
  WeeklyReportCubit({required BleConnectCubit connectCubit})
      : _connectCubit = connectCubit,
        super(WeeklyReportState(selectedDate: DateTime.now()));

  final BleConnectCubit _connectCubit;

  Future<void> selectWeek(DateTime date) async {
    emit(state.copyWith(selectedDate: date));

    final deviceId = _connectCubit.state.remoteId;
    if (deviceId == null) return;

    // 周范围：周日起算（与 DateHeader 一致），如 "Jun 8 – 14, 2026"
    final weekStart = DateTime(date.year, date.month, date.day - date.weekday % 7);
    final weekEnd = weekStart.add(const Duration(days: 7)); // 下周日 00:00

    // 并行查询周内报表 + 分钟数据
    final reports = await SleepDataRepository.getReportsByDeviceAndDateRange(
      deviceId: deviceId,
      start: weekStart,
      end: weekEnd,
    );
    final minuteData = await SleepDataRepository.getSleepMinuteDataByRange(
      deviceId: deviceId,
      start: weekStart,
      end: weekEnd,
    );

    // 平均评分 + 平均时长
    if (reports.isNotEmpty) {
      final count = reports.length;
      final scoreSum = reports.fold<int>(0, (s, r) => s + r.sleepQuality);
      final minSum = reports.fold<int>(0, (s, r) => s + r.totalSleepMinutes);
      emit(state.copyWith(
        avgScore: scoreSum ~/ count,
        avgTotalMinutes: minSum ~/ count,
      ));
    } else {
      emit(state.copyWith(clearAvg: true));
    }

    // 睡眠阶段统计（整周汇总）
    if (minuteData.isNotEmpty) {
      var deep = 0, light = 0, rem = 0, awake = 0;
      for (final r in minuteData) {
        switch (SleepMinuteStatus.fromDbValue(r.status)) {
          case SleepMinuteStatus.deepSleep:
            deep++;
          case SleepMinuteStatus.lightSleep:
            light++;
          case SleepMinuteStatus.rem:
            rem++;
          case SleepMinuteStatus.awake:
          case SleepMinuteStatus.outOfBed:
          case SleepMinuteStatus.sitting:
            awake++;
        }
      }
      emit(state.copyWith(
        stageStats: SleepStageStats(
          deepMinutes: deep,
          lightMinutes: light,
          remMinutes: rem,
          awakeMinutes: awake,
          totalMinutes: minuteData.length,
        ),
      ));
    } else {
      emit(state.copyWith(clearStageStats: true));
    }
  }
}