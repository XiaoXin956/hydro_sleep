import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 连接状态卡片
class ConnectionStatusCard extends StatelessWidget {
  const ConnectionStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final connectState = context.watch<BleConnectCubit>().state;

    final isConnected = connectState.isConnected;
    final isConnecting = connectState.isConnecting;
    final deviceName = connectState.deviceName;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isConnected
                      ? Icons.bluetooth_connected
                      : isConnecting
                          ? Icons.bluetooth_searching
                          : Icons.bluetooth_disabled,
                  color: isConnected
                      ? AppColors.success
                      : isConnecting
                          ? AppColors.primary
                          : AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isConnected
                      ? l10n.deviceConnected
                      : isConnecting
                          ? l10n.connecting
                          : l10n.notConnected,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isConnected
                        ? AppColors.success
                        : isConnecting
                            ? AppColors.primary
                            : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildActions(context, theme, l10n, isConnected, isConnecting, deviceName),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    bool isConnected,
    bool isConnecting,
    String? deviceName,
  ) {
    if (isConnecting) {
      return Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text(
            deviceName ?? '',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      );
    }

    if (isConnected) {
      return Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              deviceName ?? '',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: () => context.read<BleConnectCubit>().disconnect(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              l10n.disconnect,
              style: TextStyle(color: Colors.red.shade400, fontSize: 13),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => context.push('/search'),
        icon: const Icon(Icons.add, size: 20),
        label: Text(l10n.addDevice),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
