import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_connect_cubit.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 模式偏好选择器（自动/制冷/制热）
/// 通过 BlocBuilder 读取 BleDataCubit.state.deviceInfo.workMode 实时同步设备状态
class ModePreferenceSelector extends StatefulWidget {
  const ModePreferenceSelector({super.key});

  @override
  State<ModePreferenceSelector> createState() => _ModePreferenceSelectorState();
}

class _ModePreferenceSelectorState extends State<ModePreferenceSelector> {
  bool _sending = false;

  Future<void> _onSelect(int mode) async {
    if (_sending) return;

    final isConnected =
        context.read<BleConnectCubit>().state.status == BleConnectStatus.connected;
    if (!isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('未连接设备'), duration: Duration(seconds: 2)),
        );
      }
      return;
    }

    // 和当前模式相同则跳过
    final currentMode = context.read<BleDataCubit>().state.deviceInfo?.workMode;
    if (mode == currentMode) return;

    setState(() => _sending = true);
    final ok = await context.read<BleDataCubit>().sendDeviceControlCommand(mode: mode);
    if (!mounted) return;

    setState(() => _sending = false);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('模式设置失败'), duration: Duration(seconds: 2)),
      );
    }
    // 成功后不需要手动更新 — 设备推送新帧时 BlocBuilder 会自动刷新
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [l10n.modeAuto, l10n.modeCooling, l10n.modeHeating];

    return BlocBuilder<BleDataCubit, BleDataState>(
      builder: (context, state) {
        final currentMode = state.deviceInfo?.workMode;
        final display = (currentMode != null && currentMode >= 0 && currentMode <= 2)
            ? labels[currentMode]
            : '--';

        return MenuAnchor(
          builder: (context, controller, child) {
            return GestureDetector(
              onTap: () {
                if (_sending) return;
                controller.isOpen ? controller.close() : controller.open();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_sending)
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Text(display, style: const TextStyle(fontSize: 13)),
                  const Icon(Icons.arrow_drop_down, size: 18),
                ],
              ),
            );
          },
          menuChildren: List.generate(3, (i) {
            final isSelected = currentMode == i;
            return MenuItemButton(
              onPressed: () => _onSelect(i),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[
                    const Icon(Icons.check, size: 16),
                    const SizedBox(width: 6),
                  ],
                  Text(labels[i]),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
