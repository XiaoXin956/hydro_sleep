import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- State ---

class YearlyReportState extends Equatable {
  const YearlyReportState();

  @override
  List<Object?> get props => [];
}

// --- Cubit ---

class YearlyReportCubit extends Cubit<YearlyReportState> {
  YearlyReportCubit() : super(const YearlyReportState());
}
