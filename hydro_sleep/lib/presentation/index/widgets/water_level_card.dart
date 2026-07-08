import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 水位状态卡片
class WaterLevelCard extends StatelessWidget {
  const WaterLevelCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final deviceInfo = context.watch<BleDataCubit>().state.deviceInfo;
    final lowWater = deviceInfo?.lowWater;
    final poweredOff = deviceInfo?.isPoweredOff ?? false;

    final isUnknown = poweredOff || lowWater == null;
    final isAbnormal = !isUnknown && lowWater != 0;

    final color = isUnknown
        ? AppColors.textHint
        : (isAbnormal ? Colors.orange : AppColors.success);
    final icon = isUnknown
        ? Icons.help_outline
        : (isAbnormal ? Icons.warning_amber_rounded : Icons.water_drop);
    final label = poweredOff
        ? l10n.waterLevelUnknown
        : (lowWater == null
            ? l10n.waterLevelUnknown
            : (isAbnormal ? l10n.waterLevelAbnormal : l10n.waterLevelNormal));

    return Card(
      child: Opacity(
        opacity: poweredOff ? 0.5 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: IgnorePointer(
            ignoring: poweredOff,
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(l10n.waterLevel, style: theme.textTheme.titleMedium),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13),
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
