import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';

// --- State ---

enum FactoryResetStatus { initial, loading, success, failed }

class FactoryResetState extends Equatable {
  final FactoryResetStatus status;
  final String? error;

  const FactoryResetState({this.status = FactoryResetStatus.initial, this.error});

  bool get isLoading => status == FactoryResetStatus.loading;
  bool get isSuccess => status == FactoryResetStatus.success;
  bool get isFailed => status == FactoryResetStatus.failed;

  @override
  List<Object?> get props => [status, error];
}

// --- Cubit ---

class FactoryResetCubit extends Cubit<FactoryResetState> {
  FactoryResetCubit({required BleDataCubit dataCubit})
      : _dataCubit = dataCubit,
        super(const FactoryResetState());

  final BleDataCubit _dataCubit;

  /// 恢复出厂设置：发送 0x17，等待设备回复 0x97
  Future<void> reset() async {
    if (state.isLoading) return;

    if (_dataCubit.state.status != BleDataStatus.streaming) {
      debugPrint('[恢复出厂] 未连接设备，无法执行');
      emit(const FactoryResetState(
        status: FactoryResetStatus.failed,
        error: 'notConnected',
      ));
      return;
    }

    emit(const FactoryResetState(status: FactoryResetStatus.loading));

    try {
      final success = await _dataCubit.sendCommand([0x17]);
      if (success) {
        debugPrint('[恢复出厂] 设备回复 0x97，操作成功');
        emit(const FactoryResetState(status: FactoryResetStatus.success));
      } else {
        debugPrint('[恢复出厂] 等待响应超时');
        emit(const FactoryResetState(
          status: FactoryResetStatus.failed,
          error: 'timeout',
        ));
      }
    } catch (e) {
      debugPrint('[恢复出厂] 异常: $e');
      emit(FactoryResetState(
        status: FactoryResetStatus.failed,
        error: '$e',
      ));
    }
  }

  void resetToInitial() {
    emit(const FactoryResetState());
  }
}
