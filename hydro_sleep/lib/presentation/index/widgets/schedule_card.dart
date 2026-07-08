import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 工作时间卡片
class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final deviceInfo = context.watch<BleDataCubit>().state.deviceInfo;
    final workTime = deviceInfo?.workTime;
    final poweredOff = deviceInfo?.isPoweredOff ?? false;

    return Card(
      child: Opacity(
        opacity: poweredOff ? 0.5 : 1,
        child: IgnorePointer(
          ignoring: poweredOff,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.workTimeTitle, style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, size: 20, color: workTime != null ? AppColors.primary : AppColors.textHint),
                      const SizedBox(width: 6),
                      Text(
                        workTime != null ? l10n.workTimeHours(workTime) : '--',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: workTime != null ? AppColors.primary : AppColors.textHint,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
