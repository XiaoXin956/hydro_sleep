import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/data/repositories/sleep_data_repository.dart';
import 'package:hydro_sleep/domain/enums/sleep_minute_status.dart';
import 'package:hydro_sleep/domain/models/report_summary.dart';

// --- 睡眠阶段统计 ---

class SleepStageStats extends Equatable {
  final int deepMinutes;
  final int lightMinutes;
  final int remMinutes;
  final int awakeMinutes; // 清醒 + 离床 + 坐起
  final int totalMinutes;

  const SleepStageStats({
    required this.deepMinutes,
    required this.lightMinutes,
    required this.remMinutes,
    required this.awakeMinutes,
    required this.totalMinutes,
  });

  double get deepPct => totalMinutes > 0 ? deepMinutes / totalMinutes * 100 : 0;
  double get lightPct => totalMinutes > 0 ? lightMinutes / totalMinutes * 100 : 0;
  double get remPct => totalMinutes > 0 ? remMinutes / totalMinutes * 100 : 0;
  double get awakePct => totalMinutes > 0 ? awakeMinutes / totalMinutes * 100 : 0;

  static String formatMinutes(int m) {
    final h = m ~/ 60;
    final min = m % 60;
    if (h > 0) return '${h}h ${min}m';
    return '${min}m';
  }

  @override
  List<Object?> get props => [deepMinutes, lightMinutes, remMinutes, awakeMinutes, totalMinutes];
}

// --- State ---

class DailyReportState extends Equatable {
  final DateTime selectedDate;
  final ReportSummary? report;
  final SleepStageStats? stageStats;
  final List<double> stageCurve;
  final List<int> heartRateCurve;
  final List<double> temperatureCurve;
  final DateTime? curveStartTime;

  const DailyReportState({
    required this.selectedDate,
    this.report,
    this.stageStats,
    this.stageCurve = const [],
    this.heartRateCurve = const [],
    this.temperatureCurve = const [],
    this.curveStartTime,
  });

  DailyReportState copyWith({
    DateTime? selectedDate,
    ReportSummary? report,
    SleepStageStats? stageStats,
    List<double>? stageCurve,
    List<int>? heartRateCurve,
    List<double>? temperatureCurve,
    DateTime? curveStartTime,
    bool clearReport = false,
    bool clearStageStats = false,
    bool clearCurve = false,
  }) {
    return DailyReportState(
      selectedDate: selectedDate ?? this.selectedDate,
      report: clearReport ? null : (report ?? this.report),
      stageStats: clearStageStats ? null : (stageStats ?? this.stageStats),
      stageCurve: clearCurve ? const [] : (stageCurve ?? this.stageCurve),
      heartRateCurve: clearCurve ? const [] : (heartRateCurve ?? this.heartRateCurve),
      temperatureCurve: clearCurve ? const [] : (temperatureCurve ?? this.temperatureCurve),
      curveStartTime: clearCurve ? null : (curveStartTime ?? this.curveStartTime),
    );
  }

  @override
  List<Object?> get props => [selectedDate, report, stageStats, stageCurve, heartRateCurve, temperatureCurve, curveStartTime];
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

    // 并行查询报表、分钟数据、温度数据
    final records = await SleepDataRepository.getReportsByDeviceAndDateRange(
      deviceId: deviceId,
      start: dayStart,
      end: dayEnd,
    );
    final minuteData = await SleepDataRepository.getSleepMinuteDataByDate(
      deviceId: deviceId,
      date: date,
    );
    final tempData = await SleepDataRepository.getTemperatureByDate(
      deviceId: deviceId,
      date: date,
    );

    // 报表
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

    // 睡眠阶段统计 + 曲线数据
    if (minuteData.isNotEmpty) {
      var deep = 0, light = 0, rem = 0, awake = 0;
      final stageValues = <double>[];
      final hrValues = <int>[];
      for (final r in minuteData) {
        final status = SleepMinuteStatus.fromDbValue(r.status);
        switch (status) {
          case SleepMinuteStatus.deepSleep:
            deep++; stageValues.add(10);
          case SleepMinuteStatus.lightSleep:
            light++; stageValues.add(20);
          case SleepMinuteStatus.rem:
            rem++; stageValues.add(30);
          case SleepMinuteStatus.awake:
          case SleepMinuteStatus.outOfBed:
          case SleepMinuteStatus.sitting:
            awake++; stageValues.add(40);
        }
        hrValues.add(r.heartRate);
      }

      // 温度降采样：按分钟桶取平均值，与分钟数据对齐
      final tempByMinute = <int, List<int>>{};
      for (final r in tempData) {
        final key = r.timestamp.millisecondsSinceEpoch ~/ 60000;
        tempByMinute.putIfAbsent(key, () => []).add(r.temperature);
      }
      final tempValues = <double>[];
      for (final r in minuteData) {
        final key = r.timestamp.millisecondsSinceEpoch ~/ 60000;
        final bucket = tempByMinute[key];
        if (bucket != null && bucket.isNotEmpty) {
          tempValues.add(bucket.reduce((a, b) => a + b) / bucket.length);
        } else {
          tempValues.add(0); // 无数据点
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
        stageCurve: stageValues,
        heartRateCurve: hrValues,
        temperatureCurve: tempValues,
        curveStartTime: minuteData.first.timestamp,
      ));
    } else {
      emit(state.copyWith(clearStageStats: true, clearCurve: true));
    }
  }
}
