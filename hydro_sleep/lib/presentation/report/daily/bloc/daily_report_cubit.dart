import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- State ---

class DailyReportState extends Equatable {
  const DailyReportState();

  @override
  List<Object?> get props => [];
}

// --- Cubit ---

class DailyReportCubit extends Cubit<DailyReportState> {
  DailyReportCubit() : super(const DailyReportState());
}
