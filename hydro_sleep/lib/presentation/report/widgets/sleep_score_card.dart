import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';
import 'package:hydro_sleep/presentation/report/daily/bloc/daily_report_cubit.dart';

/// 睡眠评分卡片
class SleepScoreCard extends StatelessWidget {
  const SleepScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final report = context.watch<DailyReportCubit>().state.report;

    final score = report?.sleepQuality ?? 0;
    final totalMin = report?.totalSleepMinutes ?? 0;
    final hasData = report != null;

    // 入睡时间 = startTime，起床时间 = startTime + totalSleepMinutes
    final startTime = report?.startTime;
    final wakeTime = startTime != null
        ? startTime.add(Duration(minutes: totalMin))
        : null;
    final bedtimeStr = startTime != null
        ? '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}'
        : '--';
    final wakeStr = wakeTime != null
        ? '${wakeTime.hour.toString().padLeft(2, '0')}:${wakeTime.minute.toString().padLeft(2, '0')}'
        : '--';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: hasData ? score / 100.0 : 0),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                builder: (context, progress, _) {
                  final displayScore = (progress * 100).round();
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(120, 120),
                        painter: _CircleBgPainter(size: 120, strokeWidth: 10, color: AppColors.lightGrayBg),
                      ),
                      if (progress > 0)
                        CustomPaint(
                          size: const Size(120, 120),
                          painter: _CircleProgressPainter(size: 120, strokeWidth: 10, progress: progress, color: AppColors.success),
                        ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            hasData ? '$displayScore' : '--',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: hasData ? AppColors.textPrimary : AppColors.textHint,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(l10n.sleepScore, style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: totalMin.toDouble()),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                builder: (context, animMin, _) {
                  final h = animMin ~/ 60;
                  final m = (animMin % 60).round();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasData ? '${h}h ${m}m' : '--',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: hasData ? AppColors.primary : AppColors.textHint,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(l10n.totalSleep, style: theme.textTheme.bodySmall),
                      const SizedBox(height: 8),
                      Text(
                        '$bedtimeStr  →  $wakeStr',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        l10n.bedtimeToWakeUp,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
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

class _CircleBgPainter extends CustomPainter {
  final double size;
  final double strokeWidth;
  final Color color;

  const _CircleBgPainter({required this.size, required this.strokeWidth, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = strokeWidth;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2 - strokeWidth / 2, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _CircleProgressPainter extends CustomPainter {
  final double size;
  final double strokeWidth;
  final double progress;
  final Color color;

  const _CircleProgressPainter({required this.size, required this.strokeWidth, required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round;
    final radius = size.width / 2 - strokeWidth / 2;
    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
      -math.pi / 2, progress * 2 * math.pi, false, paint,
    );
  }

  @override
  bool shouldRepaint(_CircleProgressPainter old) => old.progress != progress;
}
