import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- State ---

class MonthlyReportState extends Equatable {
  const MonthlyReportState();

  @override
  List<Object?> get props => [];
}

// --- Cubit ---

class MonthlyReportCubit extends Cubit<MonthlyReportState> {
  MonthlyReportCubit() : super(const MonthlyReportState());
}
