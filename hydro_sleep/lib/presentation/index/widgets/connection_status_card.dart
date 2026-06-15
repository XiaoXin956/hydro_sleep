import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';

/// 连接状态卡片
/// 三种状态：从未连接 / 已连接但断开 / 已连接
class ConnectionStatusCard extends StatelessWidget {
  const ConnectionStatusCard({super.key});

  // 模拟状态：实际应由 Bloc 提供
  // 0=从未连接, 1=已连接但断开, 2=已连接
  final int _mockState = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  _statusTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: _statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildActions(context, theme),
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

  String get _statusTitle {
    if (_mockState == 2) return '已连接';
    if (_mockState == 1) return '无法连接';
    return '设备未连接';
  }

  Widget _buildActions(BuildContext context, ThemeData theme) {
    if (_mockState == 2) {
      // 已连接
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
      // 已连接过但无法连接
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                context.push('/search');
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('重新连接'),
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
              label: const Text('连接新设备'),
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
      // 从未连接
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            context.push('/search');
          },
          icon: const Icon(Icons.add, size: 20),
          label: const Text('添加设备'),
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
