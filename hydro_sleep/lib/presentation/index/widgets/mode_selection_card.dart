import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 模式选择卡片（自动 / 制冷 / 制热）
class ModeSelectionCard extends StatefulWidget {
  const ModeSelectionCard({super.key});

  @override
  State<ModeSelectionCard> createState() => _ModeSelectionCardState();
}

class _ModeSelectionCardState extends State<ModeSelectionCard> {
  bool _sending = false;

  Future<void> _onSelect(int mode) async {
    if (_sending) return;
    final currentMode = context.read<BleDataCubit>().state.deviceInfo?.workMode;
    if (mode == currentMode) return;

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
    final ok = await context.read<BleDataCubit>().sendDeviceControlCommand(mode: mode);
    if (mounted) {
      setState(() => _sending = false);
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('模式设置失败'), duration: Duration(seconds: 2)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final workMode = context.watch<BleDataCubit>().state.deviceInfo?.workMode;

    final modes = [
      (0, l10n.modeAuto, Icons.autorenew),
      (1, l10n.modeCooling, Icons.ac_unit),
      (2, l10n.modeHeating, Icons.whatshot),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.mode, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                for (final (value, label, icon) in modes) ...[
                  if (value > 0) const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _sending ? null : () => _onSelect(value),
                      child: _ModeButton(
                        label: label,
                        icon: icon,
                        isSelected: workMode == value,
                        sending: _sending && workMode == value,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool sending;

  const _ModeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    this.sending = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.divider,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          sending
              ? const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  icon,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  size: 28,
                ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
