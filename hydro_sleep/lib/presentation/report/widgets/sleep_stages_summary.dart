import 'package:flutter/material.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';
import 'package:hydro_sleep/domain/models/sleep_stage_stats.dart';

/// 睡眠阶段汇总（日/周/月共用，数据由外部传入）
class SleepStagesSummary extends StatelessWidget {
  final SleepStageStats? stats;

  /// 切换日期/周期时用于触发动画重播的 key
  final DateTime dateKey;

  const SleepStagesSummary({
    super.key,
    required this.stats,
    required this.dateKey,
  });

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
            Builder(builder: (context) {
              final hasData = stats != null && stats!.totalMinutes > 0;

              final stages = [
                (color: Colors.indigo, name: '深睡眠', minutes: stats?.deepMinutes ?? 0, pct: stats?.deepPct ?? 0),
                (color: Colors.blue, name: '浅睡眠', minutes: stats?.lightMinutes ?? 0, pct: stats?.lightPct ?? 0),
                (color: Colors.purple, name: 'REM', minutes: stats?.remMinutes ?? 0, pct: stats?.remPct ?? 0),
                (color: Colors.orange, name: '清醒', minutes: stats?.awakeMinutes ?? 0, pct: stats?.awakePct ?? 0),
              ];

              return Row(
                children: List.generate(stages.length, (i) {
                  final stage = stages[i];
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: i > 0 ? 4 : 0, right: i < 3 ? 4 : 0),
                      child: _AnimatedStageItem(
                        key: ValueKey('stage_${dateKey}_$i'),
                        color: stage.color,
                        name: stage.name,
                        targetMinutes: stage.minutes,
                        targetPct: stage.pct,
                        hasData: hasData,
                      ),
                    ),
                  );
                }),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _AnimatedStageItem extends StatelessWidget {
  final Color color;
  final String name;
  final int targetMinutes;
  final double targetPct;
  final bool hasData;

  const _AnimatedStageItem({
    super.key,
    required this.color,
    required this.name,
    required this.targetMinutes,
    required this.targetPct,
    required this.hasData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: targetMinutes.toDouble()),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, animMin, _) {
        final h = animMin ~/ 60;
        final m = (animMin % 60).round();
        final animPct = targetMinutes > 0 ? (animMin / targetMinutes * targetPct) : 0.0;

        return Column(
          children: [
            Container(
              width: 10, height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(height: 6),
            Text(name, style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500, color: color,
            )),
            const SizedBox(height: 2),
            Text(
              hasData ? (h > 0 ? '${h}h ${m}m' : '${m}m') : '-',
              style: theme.textTheme.titleMedium?.copyWith(
                color: hasData ? null : Colors.grey,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              hasData ? '${animPct.toStringAsFixed(1)}%' : '-',
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasData ? null : Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }
}
