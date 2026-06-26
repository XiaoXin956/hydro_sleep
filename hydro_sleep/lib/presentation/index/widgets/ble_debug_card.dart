import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';

/// 调试用：显示 BLE 收到的原始数据（后期移除）
class BleDebugCard extends StatelessWidget {
  const BleDebugCard({super.key});

  @override
  Widget build(BuildContext context) {
    final rawLog = context.watch<BleDataCubit>().state.rawLog;
    final theme = Theme.of(context);

    return Card(
      color: const Color(0xFF1E1E1E),
      child: SizedBox(
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Text(
                    'BLE Raw Data',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${rawLog.length}/200',
                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFF333333)),
            Expanded(
              child: rawLog.isEmpty
                  ? const Center(
                      child: Text(
                        '等待数据...',
                        style: TextStyle(color: AppColors.textHint, fontSize: 13),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: rawLog.length,
                      itemBuilder: (context, index) {
                        // 倒序显示，最新的在上面
                        final entry = rawLog[rawLog.length - 1 - index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            entry,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: Color(0xFF4EC9B0),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
