import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- State ---

class WeeklyReportState extends Equatable {
  const WeeklyReportState();

  @override
  List<Object?> get props => [];
}

// --- Cubit ---

class WeeklyReportCubit extends Cubit<WeeklyReportState> {
  WeeklyReportCubit() : super(const WeeklyReportState());
}
