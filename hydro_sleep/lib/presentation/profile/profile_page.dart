import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/constants/app_constants.dart';
import 'package:hydro_sleep/core/factory_reset/factory_reset_cubit.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 60,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              l10n.profileTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
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
                  const ProfileCard(),
                  const SizedBox(height: 16),
                  const DeviceListCard(),
                  const SizedBox(height: 16),
                  _buildSettingsWidget(theme, l10n),
                  const SizedBox(height: 16),
                  const _FactoryResetRow(),
                  const SizedBox(height: 16),
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

  Widget _buildSettingsWidget(ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.generalSettings,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _SettingsRow(
              theme: theme,
              label: l10n.language,
              child: const LanguageSelector(),
            ),
            _divider(theme),
            _SettingsRow(
              theme: theme,
              label: l10n.temperatureUnit,
              child: const TemperatureUnitSelector(),
            ),
            _divider(theme),
            _SettingsRow(
              theme: theme,
              label: l10n.modePreference,
              child: const ModePreferenceSelector(),
            ),
            _divider(theme),
            _SettingsRow(
              theme: theme,
              label: l10n.bedExitShutdown,
              child: const BedExitShutdownSelector(),
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
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
          const Spacer(),
          child,
        ],
      ),
    );
  }
}

class _FactoryResetRow extends StatelessWidget {
  const _FactoryResetRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<FactoryResetCubit, FactoryResetState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: state.isLoading
                  ? null
                  : () => _showConfirmDialog(context, l10n),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    Text(
                      l10n.restoreFactorySettings,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: state.isLoading
                          ? const SizedBox(
                              key: ValueKey('spinner'),
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                          : const Icon(
                              key: ValueKey('arrow'),
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppColors.textHint,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showConfirmDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.factoryResetTitle),
        content: Text(l10n.factoryResetMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<FactoryResetCubit>().reset();
            },
            child: Text(
              l10n.confirm,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
