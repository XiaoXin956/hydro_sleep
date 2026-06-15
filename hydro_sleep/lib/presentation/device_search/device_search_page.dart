import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/core/utils/mock_data.dart';

/// 搜索设备页
class DeviceSearchPage extends StatelessWidget {
  const DeviceSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索设备'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 历史设备区域
          _buildHistorySection(context, theme),
          // 扫描区域标题
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text(
                    '可用设备',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.refresh, size: 18),
                ],
              ),
            ),
          ),
          // 设备列表
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final device = MockData.testDevices[index];
                  return _DeviceTile(
                    theme: theme,
                    name: device['name'] as String,
                    id: device['id'] as String,
                    rssi: device['rssi'] as int,
                    onTap: () {
                      // TODO: BLE 连接逻辑
                      context.pop();
                    },
                  );
                },
                childCount: MockData.testDevices.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context, ThemeData theme) {
    // 模拟：有历史设备
    if (MockData.historyDevices.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              '以往连接过的设备',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...MockData.historyDevices.map((device) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.history,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(device['name'] as String),
                  subtitle: Text(device['id'] as String),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // TODO: 连接历史设备
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('连接'),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  final ThemeData theme;
  final String name;
  final String id;
  final int rssi;
  final VoidCallback onTap;

  const _DeviceTile({
    required this.theme,
    required this.name,
    required this.id,
    required this.rssi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(id),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$rssi dBm',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('连接'),
            ),
          ],
        ),
      ),
    );
  }
}
