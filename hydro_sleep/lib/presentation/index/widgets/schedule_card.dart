import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/constants/app_constants.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';

/// 日程卡片
class ScheduleCard extends StatefulWidget {
  const ScheduleCard({super.key});

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  bool _autoAdjust = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Text(
              'Schedule',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // 时间范围
            Row(
              children: [
                Expanded(
                  child: _TimeChip(
                    label: AppConstants.defaultScheduleStart,
                    onTap: () {},
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('→', style: TextStyle(fontSize: 18)),
                ),
                Expanded(
                  child: _TimeChip(
                    label: AppConstants.defaultScheduleEnd,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Auto adjust 开关
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Auto adjust during sleep',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Switch(
                  value: _autoAdjust,
                  activeThumbColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() => _autoAdjust = value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TimeChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time, size: 16, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
