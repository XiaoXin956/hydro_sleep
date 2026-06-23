import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/core/device_list/device_list_cubit.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 设备列表卡片
class DeviceListCard extends StatefulWidget {
  const DeviceListCard({super.key});

  @override
  State<DeviceListCard> createState() => _DeviceListCardState();
}

class _DeviceListCardState extends State<DeviceListCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final connectState = context.watch<BleConnectCubit>().state;

    return BlocConsumer<DeviceListCubit, DeviceListState>(
      listenWhen: (prev, curr) => prev.expanded != curr.expanded,
      listener: (_, state) {
        state.expanded ? _controller.forward() : _controller.reverse();
      },
      builder: (context, state) {
        final overflowDevices = state.devices.length > 3
            ? state.devices.sublist(3)
            : <dynamic>[];

        return Card(
          clipBehavior: Clip.antiAlias,
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
                ...state.devices.take(3).toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final device = entry.value;
                  final isCurrentDevice =
                      connectState.remoteId == device.deviceId;
                  return Column(
                    children: [
                      if (index > 0) _divider(theme),
                      _DeviceTile(
                        theme: theme,
                        name: device.deviceName,
                        isConnecting: isCurrentDevice &&
                            (connectState.isConnecting || connectState.isReconnecting),
                        isConnected:
                            isCurrentDevice && connectState.isConnected,
                        onDisconnect: isCurrentDevice && connectState.isConnected
                            ? () => context.read<BleConnectCubit>().disconnect()
                            : null,
                        l10n: l10n,
                      ),
                    ],
                  );
                }),
                // 纯高度动画：ClipRect + Align(heightFactor)
                SizeTransition(
                  sizeFactor: _heightFactor,
                  axis: Axis.vertical,
                  child: Column(
                    children: [
                      for (var i = 0; i < overflowDevices.length; i++) ...[
                        _divider(theme),
                        _DeviceTile(
                          theme: theme,
                          name: overflowDevices[i].deviceName,
                          isConnecting: (connectState.remoteId ==
                                      overflowDevices[i].deviceId) &&
                                  (connectState.isConnecting || connectState.isReconnecting),
                          isConnected: connectState.remoteId ==
                                  overflowDevices[i].deviceId &&
                              connectState.isConnected,
                          onDisconnect: connectState.remoteId ==
                                      overflowDevices[i].deviceId &&
                                  connectState.isConnected
                              ? () =>
                                  context.read<BleConnectCubit>().disconnect()
                              : null,
                          l10n: l10n,
                        ),
                      ],
                    ],
                  ),
                ),
                if (state.hasMore) ...[
                  const SizedBox(height: 4),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      final offsetTween = Tween<Offset>(
                        begin: const Offset(0.15, 0),
                        end: Offset.zero,
                      );
                      final fadeTween = Tween<double>(begin: 0, end: 1);
                      return SlideTransition(
                        position: animation.drive(offsetTween),
                        child: FadeTransition(
                          opacity: animation.drive(fadeTween),
                          child: child,
                        ),
                      );
                    },
                    child: TextButton(
                      key: ValueKey<bool>(state.expanded),
                      onPressed: () =>
                          context.read<DeviceListCubit>().toggleExpand(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedRotation(
                            turns: state.expanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.expand_more,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            state.expanded ? l10n.showLess : l10n.showMore,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                          ),
                        ],
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
  final bool isConnecting;
  final bool isConnected;
  final VoidCallback? onDisconnect;
  final AppLocalizations l10n;

  const _DeviceTile({
    required this.theme,
    required this.name,
    required this.l10n,
    this.isConnecting = false,
    this.isConnected = false,
    this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isConnected
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
              size: 20,
              color: isConnected ? AppColors.success : AppColors.primary,
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
                if (isConnecting)
                  Row(
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.connecting,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              isConnected ? AppColors.success : AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isConnected ? l10n.connected : l10n.disconnected,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              isConnected ? AppColors.success : AppColors.error,
                        ),
                      ),
                      if (onDisconnect != null) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: onDisconnect,
                          child: Text(
                            l10n.disconnect,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.red.shade400,
                            ),
                          ),
                        ),
                      ],
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
