import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 连接状态卡片
/// 三种状态：从未连接 / 已连接但断开 / 已连接
class ConnectionStatusCard extends StatelessWidget {
  const ConnectionStatusCard({super.key});

  final int _mockState = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bluetooth_searching,
                  color: _statusColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _statusTitle(l10n),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: _statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildActions(context, theme, l10n),
          ],
        ),
      ),
    );
  }

  Color get _statusColor {
    if (_mockState == 2) return AppColors.success;
    if (_mockState == 1) return AppColors.error;
    return AppColors.textSecondary;
  }

  String _statusTitle(AppLocalizations l10n) {
    if (_mockState == 2) return l10n.deviceConnected;
    if (_mockState == 1) return l10n.cannotConnect;
    return l10n.notConnected;
  }

  Widget _buildActions(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    if (_mockState == 2) {
      return Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 20),
          const SizedBox(width: 8),
          Text(
            'SmartSleep Pro',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      );
    } else if (_mockState == 1) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                context.push('/search');
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(l10n.reconnect),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                context.push('/search');
              },
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.connectNewDevice),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            context.push('/search');
          },
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
}
