import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/bluetooth/ble_data_cubit.dart';

/// 发送数据记录卡片（最新 200 条，ListView）
class SentDataLogCard extends StatelessWidget {
  const SentDataLogCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<BleDataCubit, BleDataState>(
      buildWhen: (prev, curr) => prev.sentLog.length != curr.sentLog.length,
      builder: (context, state) {
        final log = state.sentLog;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('发送数据记录', style: theme.textTheme.titleMedium),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.teal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${log.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (log.isEmpty)
                  const Text('暂无发送记录', style: TextStyle(fontSize: 12, color: Colors.grey))
                else
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: log.length,
                      reverse: true, // 最新在上
                      itemBuilder: (context, index) {
                        final entry = log[log.length - 1 - index];
                        // entry 格式: "HH:mm:ss  xx xx xx ..."
                        final parts = entry.split('  ');
                        final time = parts.isNotEmpty ? parts[0] : '';
                        final hex = parts.length > 1 ? parts[1] : entry;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.teal.withValues(alpha: 0.12)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  time,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'monospace',
                                    color: Colors.teal,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    hex,
                                    style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                                    softWrap: true,
                                  ),
                                ),
                              ],
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
      },
    );
  }
}
