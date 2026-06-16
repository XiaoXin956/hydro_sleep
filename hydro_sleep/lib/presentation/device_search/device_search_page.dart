import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/core/utils/mock_data.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 搜索设备页
class DeviceSearchPage extends StatelessWidget {
  const DeviceSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchDevice),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          _buildHistorySection(context, theme, l10n),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text(
                    l10n.availableDevices,
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

  Widget _buildHistorySection(BuildContext context, ThemeData theme, AppLocalizations l10n) {
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
              l10n.previouslyConnected,
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
                    child: Text(l10n.connect),
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
              child: Text(AppLocalizations.of(context)!.connect),
            ),
          ],
        ),
      ),
    );
  }
}
