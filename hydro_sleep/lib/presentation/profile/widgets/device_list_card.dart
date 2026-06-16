import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/device_list/device_list_cubit.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 设备列表卡片
class DeviceListCard extends StatelessWidget {
  const DeviceListCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<DeviceListCubit, DeviceListState>(
      builder: (context, state) {
        final visible = state.visibleDevices;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.myDevices,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ...visible.asMap().entries.map((entry) {
                  final index = entry.key;
                  final device = entry.value;
                  return Column(
                    children: [
                      if (index > 0) _divider(theme),
                      _DeviceTile(
                        theme: theme,
                        name: device.deviceName,
                        connected: false, // BLE 预留，暂未连接
                        l10n: l10n,
                      ),
                    ],
                  );
                }),
                if (state.hasMore) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          context.read<DeviceListCubit>().toggleExpand(),
                      child: Text(
                        state.expanded ? l10n.showLess : l10n.showMore,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _divider(ThemeData theme) {
    return Divider(
      height: 1,
      color: theme.dividerTheme.color,
    );
  }
}

class _DeviceTile extends StatelessWidget {
  final ThemeData theme;
  final String name;
  final bool connected;
  final AppLocalizations l10n;

  const _DeviceTile({
    required this.theme,
    required this.name,
    required this.connected,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = connected ? l10n.connected : l10n.disconnected;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bluetooth,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: connected ? AppColors.success : AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: connected ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
