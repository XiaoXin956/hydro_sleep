import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/core/bluetooth/ble_scan_cubit.dart';
import 'package:hydro_sleep/core/device_list/device_list_cubit.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/data/storage/secure_storage_service.dart';
import 'package:hydro_sleep/domain/models/scanned_device.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

class DeviceSearchPage extends StatefulWidget {
  const DeviceSearchPage({super.key});

  @override
  State<DeviceSearchPage> createState() => _DeviceSearchPageState();
}

class _DeviceSearchPageState extends State<DeviceSearchPage> {
  @override
  void initState() {
    super.initState();
    context.read<BleScanCubit>().startScan();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<BleConnectCubit, BleConnectState>(
      listener: (context, connectState) {
        final scanCubit = context.read<BleScanCubit>();
        if (connectState.isConnecting && connectState.remoteId != null) {
          scanCubit.markConnecting(connectState.remoteId!);
        } else if (connectState.isConnected && connectState.remoteId != null) {
          scanCubit.markConnected(connectState.remoteId!);
          context.read<DeviceListCubit>().refresh();
          SecureStorageService().saveLastDeviceId(connectState.remoteId!);
        } else if (connectState.isFailed) {
          scanCubit.markConnectFailed();
        }
      },
      child: Scaffold(
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
            _buildAvailableHeader(context, theme, l10n),
            _buildAvailableDevices(context, theme, l10n),
          ],
        ),
      ),
    );
  }

  // --- 历史设备 ---

  Widget _buildHistorySection(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return BlocBuilder<DeviceListCubit, DeviceListState>(
      builder: (context, state) {
        if (state.devices.isEmpty) {
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
                ...state.devices.map((device) {
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
                          Icons.bluetooth,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(device.deviceName),
                      subtitle: Text(device.deviceId),
                      trailing: ElevatedButton(
                        onPressed: () => _showConfirmDialog(
                          context,
                          ScannedDevice(
                            remoteId: device.deviceId,
                            name: device.deviceName,
                            rssi: 0,
                          ),
                        ),
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
      },
    );
  }

  // --- 可用设备标题 + 刷新按钮 ---

  Widget _buildAvailableHeader(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return SliverPadding(
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
            GestureDetector(
              onTap: () => context.read<BleScanCubit>().startScan(),
              child: const Icon(Icons.refresh, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  // --- 可用设备列表（BLE 扫描结果）---

  Widget _buildAvailableDevices(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return BlocBuilder<BleScanCubit, BleScanState>(
      builder: (context, bleState) {
        if (bleState.isBluetoothOff) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Icon(Icons.bluetooth_disabled, size: 48),
                  const SizedBox(height: 8),
                  Text(l10n.bluetoothOff),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<BleScanCubit>().startScan(),
                    child: Text(l10n.turnOnBluetooth),
                  ),
                ],
              ),
            ),
          );
        }

        if (bleState.error != null) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(child: Text(bleState.error!)),
            ),
          );
        }

        if (bleState.scanning && bleState.devices.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(l10n.scanning),
                ],
              ),
            ),
          );
        }

        if (bleState.devices.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(child: Text(l10n.noDevicesFound)),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final device = bleState.devices[index];
                return _DeviceTile(
                  theme: theme,
                  device: device,
                  isConnecting: bleState.connectingId == device.remoteId,
                  isConnected: bleState.connectedIds.contains(device.remoteId),
                  onTap: () => _showConfirmDialog(context, device),
                );
              },
              childCount: bleState.devices.length,
            ),
          ),
        );
      },
    );
  }

  void _showConfirmDialog(BuildContext context, ScannedDevice device) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(l10n.connect),
        content: Text('${l10n.confirm} ${device.displayName}？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<BleConnectCubit>().connect(device);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  final ThemeData theme;
  final ScannedDevice device;
  final bool isConnecting;
  final bool isConnected;
  final VoidCallback onTap;

  const _DeviceTile({
    required this.theme,
    required this.device,
    required this.onTap,
    this.isConnecting = false,
    this.isConnected = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          device.displayName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(device.remoteId),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${device.rssi} dBm',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            if (isConnecting)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (isConnected)
              Text(
                l10n.deviceConnected,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              )
            else
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
                child: Text(l10n.connect),
              ),
          ],
        ),
      ),
    );
  }
}
