import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';

/// 调试用：BLE 响应数据类型日志开关（默认全部开启，关闭后停止打印和保存对应数据）
class BleLogSwitchCard extends StatelessWidget {
  const BleLogSwitchCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<BleDataCubit, BleDataState>(
      buildWhen: (prev, curr) =>
          prev.disabledLogTypes != curr.disabledLogTypes,
      builder: (context, state) {
        final disabled = state.disabledLogTypes;
        final total = BleLogType.values.length;

        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('数据日志开关', style: theme.textTheme.titleMedium),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.teal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${total - disabled.length}/$total',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ...BleLogType.values.map(
                  (type) => SwitchListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    title: Text(
                      type.label,
                      style: const TextStyle(fontSize: 13),
                    ),
                    value: !disabled.contains(type),
                    onChanged: (_) =>
                        context.read<BleDataCubit>().toggleLogType(type),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
