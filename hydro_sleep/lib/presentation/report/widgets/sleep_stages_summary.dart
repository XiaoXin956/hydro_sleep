import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/utils/mock_data.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 睡眠阶段汇总
class SleepStagesSummary extends StatelessWidget {
  const SleepStagesSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.sleepStages,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: MockData.sleepStages.map((stage) {
                final index = MockData.sleepStages.indexOf(stage);
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index > 0 ? 4 : 0,
                      right: index < 3 ? 4 : 0,
                    ),
                    child: _StageItem(
                      color: Color(int.parse(stage['colorHex'])),
                      name: stage['name'],
                      duration: stage['duration'],
                      percentage: '${stage['percentage']}%',
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageItem extends StatelessWidget {
  final Color color;
  final String name;
  final String duration;
  final String percentage;

  const _StageItem({
    required this.color,
    required this.name,
    required this.duration,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          duration,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 2),
        Text(
          percentage,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
