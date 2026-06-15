import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/constants/app_constants.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/presentation/profile/widgets/device_list_card.dart';
import 'package:hydro_sleep/presentation/profile/widgets/language_selector.dart';
import 'package:hydro_sleep/presentation/profile/widgets/mode_preference_selector.dart';
import 'package:hydro_sleep/presentation/profile/widgets/profile_card.dart';
import 'package:hydro_sleep/presentation/profile/widgets/temperature_unit_selector.dart';
import 'package:hydro_sleep/presentation/profile/widgets/bed_exit_shutdown_selector.dart';

/// 我的页面
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        // 顶部栏
        SliverAppBar(
          pinned: true,
          expandedHeight: 60,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              '我的',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
            centerTitle: false,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final items = <Widget>[
                  // 个人档案
                  const ProfileCard(),
                  const SizedBox(height: 16),

                  // 设备列表
                  const DeviceListCard(),
                  const SizedBox(height: 16),

                  // 设置项
                  _buildSettingsWidget(theme),
                  const SizedBox(height: 16),

                  // 恢复出厂设置
                  _factoryResetRowWidget(theme),
                  const SizedBox(height: 16),

                  // 底部版本信息
                  Center(
                    child: Text(
                      'SmartSleep v${AppConstants.appVersion}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ];
                return items[index];
              },
              childCount: 9,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsWidget(ThemeData theme) {
    return Card(
      child: Column(
        children: [
          _SettingsRow(
            theme: theme,
            label: 'Language',
            child: const LanguageSelector(),
          ),
          _divider(theme),
          _SettingsRow(
            theme: theme,
            label: 'Temperature Unit',
            child: const TemperatureUnitSelector(),
          ),
          _divider(theme),
          _SettingsRow(
            theme: theme,
            label: 'Mode Preference',
            child: const ModePreferenceSelector(),
          ),
          _divider(theme),
          _SettingsRow(
            theme: theme,
            label: 'Bed Exit Shutdown',
            child: const BedExitShutdownSelector(),
          ),
        ],
      ),
    );
  }

  Widget _divider(ThemeData theme) {
    return Divider(
      height: 1,
      color: theme.dividerTheme.color,
    );
  }

  Widget _factoryResetRowWidget(ThemeData theme) {
    return Card(
      child: InkWell(
        onTap: () {
          // TODO: 恢复出厂设置
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Text(
                'Restore Factory Settings',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final ThemeData theme;
  final String label;
  final Widget child;

  const _SettingsRow({
    required this.theme,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
          Spacer(),
          child,
          // SizedBox(width: 120, child: child),
        ],
      ),
    );
  }
}
