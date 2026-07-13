import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';
import 'package:hydro_sleep/core/constants/app_constants.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

class _TemperaturePreset {
  final double temp;
  final String label;
  const _TemperaturePreset(this.temp, this.label);
}

/// 温度控制卡片
class TemperatureControlCard extends StatefulWidget {
  const TemperatureControlCard({super.key});

  @override
  State<TemperatureControlCard> createState() => _TemperatureControlCardState();
}

class _TemperatureControlCardState extends State<TemperatureControlCard> {
  double _targetTemp = 30.0;
  bool _userDragging = false;
  bool _sending = false;
  int? _lastSyncedDeviceTemp;

  void _syncFromDevice(int deviceTemp) {
    if (_lastSyncedDeviceTemp == deviceTemp) return;
    _lastSyncedDeviceTemp = deviceTemp;
    if (!_userDragging && !_sending) {
      _targetTemp = deviceTemp.toDouble().clamp(28.0, 38.0);
    }
  }

  Future<void> _sendTargetTemp(double temp) async {
    if (_sending) return;
    final isConnected =
        context.read<BleConnectCubit>().state.status == BleConnectStatus.connected;
    if (!isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('未连接设备'), duration: Duration(seconds: 2)),
        );
      }
      return;
    }

    setState(() => _sending = true);
    final ok = await context
        .read<BleDataCubit>()
        .sendDeviceControlCommand(targetTemp: temp.toInt());
    if (mounted) {
      setState(() => _sending = false);
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('温度设置失败'), duration: Duration(seconds: 2)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BleConnectCubit, BleConnectState>(
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (context, connectState) {
        return BlocBuilder<BleDataCubit, BleDataState>(
          buildWhen: (prev, curr) =>
              prev.deviceInfo != curr.deviceInfo ||
              prev.status != curr.status,
          builder: (context, dataState) {
            return _buildContent(context, connectState, dataState);
          },
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    BleConnectState connectState,
    BleDataState dataState,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final deviceInfo = dataState.deviceInfo;
    final currentTemp = deviceInfo?.actualTemp;
    final isConnected = connectState.status == BleConnectStatus.connected;
    final poweredOff = deviceInfo?.isPoweredOff ?? false;
    // 未连接 或 未收到设备信息 或 关机 → 置灰禁用
    final disabled = !isConnected || deviceInfo == null || poweredOff;

    debugPrint('[温度卡片] status=${connectState.status}, '
        'isConnected=$isConnected, poweredOff=$poweredOff, disabled=$disabled');

    // 从设备同步目标温度
    if (deviceInfo != null && !disabled) {
      _syncFromDevice(deviceInfo.targetTemp);
    }

    return Card(
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: IgnorePointer(
          ignoring: disabled,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.temperature, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            // 实际温度
            Text(
              currentTemp != null ? l10n.currentTemp(currentTemp) : l10n.currentTemp(0),
              style: theme.textTheme.titleLarge?.copyWith(
                color: currentTemp != null ? AppColors.primary : AppColors.textHint,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // 滑块
            Row(
              children: [
                const Text('28°', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                Expanded(
                  child: Slider(
                    value: _targetTemp,
                    min: 28.0,
                    max: 38.0,
                    activeColor: disabled ? AppColors.textHint : AppColors.primary,
                    divisions: 10,
                    label: '${_targetTemp.toInt()}°',
                    onChanged: disabled
                        ? null
                        : (value) {
                            setState(() {
                              _userDragging = true;
                              _targetTemp = value;
                            });
                          },
                    onChangeEnd: disabled
                        ? null
                        : (value) {
                            _userDragging = false;
                            _sendTargetTemp(value);
                          },
                  ),
                ),
                const Text('38°', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
              ],
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.targetTemp(_targetTemp.toInt()),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: _sending
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            _presetGrid(theme, disabled),
          ],
        ), // Column
      ),   // Padding
        ),   // IgnorePointer
      ),     // Opacity
    );       // Card
  }

  Widget _presetGrid(ThemeData theme, bool disabled) {
    final presets = List.generate(
      AppConstants.temperaturePresets.length,
      (i) => _TemperaturePreset(
        AppConstants.temperaturePresets[i],
        AppConstants.temperaturePresetNames[i],
      ),
    );

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.2,
      ),
      itemCount: presets.length,
      itemBuilder: (context, index) {
        final preset = presets[index];
        final isSelected = _targetTemp == preset.temp;
        return InkWell(
          onTap: disabled
              ? null
              : () {
                  setState(() => _targetTemp = preset.temp);
                  _sendTargetTemp(preset.temp);
                },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected && !disabled
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : null,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected && !disabled
                    ? AppColors.primary
                    : AppColors.divider,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${preset.temp.toInt()}°',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: disabled
                        ? AppColors.textHint
                        : (isSelected ? AppColors.primary : AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  preset.label,
                  style: TextStyle(
                    fontSize: 10,
                    color: disabled
                        ? AppColors.textHint
                        : (isSelected ? AppColors.primary : AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
