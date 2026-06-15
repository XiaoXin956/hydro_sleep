import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';

/// 设备列表卡片
class DeviceListCard extends StatelessWidget {
  const DeviceListCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Devices',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            // 测试设备条目
            _DeviceTile(
              theme: theme,
              name: 'SmartSleep Pro',
              status: 'Connected',
              connected: true,
            ),
            _divider(theme),
            _DeviceTile(
              theme: theme,
              name: 'SmartSleep Lite',
              status: 'Disconnected',
              connected: false,
            ),
          ],
        ),
      ),
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
  final String status;
  final bool connected;

  const _DeviceTile({
    required this.theme,
    required this.name,
    required this.status,
    required this.connected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // 头像占位
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
          // 信息
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
                      status,
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
