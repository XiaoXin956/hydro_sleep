import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// --- State ---

enum FactoryResetStatus { initial, loading, success }

class FactoryResetState extends Equatable {
  final FactoryResetStatus status;

  const FactoryResetState({this.status = FactoryResetStatus.initial});

  bool get isLoading => status == FactoryResetStatus.loading;
  bool get isSuccess => status == FactoryResetStatus.success;

  @override
  List<Object?> get props => [status];
}

// --- Cubit ---

class FactoryResetCubit extends Cubit<FactoryResetState> {
  FactoryResetCubit() : super(const FactoryResetState());

  Future<void> reset() async {
    if (state.isLoading) return;
    emit(const FactoryResetState(status: FactoryResetStatus.loading));
    // 模拟恢复出厂设置（5秒），后续接入真实设备
    await Future.delayed(const Duration(seconds: 5));
    emit(const FactoryResetState(status: FactoryResetStatus.success));
  }

  void resetToInitial() {
    emit(const FactoryResetState());
  }
}
