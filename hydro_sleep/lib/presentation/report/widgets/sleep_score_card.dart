import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/constants/app_constants.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
import 'package:hydro_sleep/core/utils/mock_data.dart';

/// 睡眠评分卡片
class SleepScoreCard extends StatelessWidget {
  const SleepScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // 左侧：圆形进度环
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 底色
                  CustomPaint(
                    size: const Size(120, 120),
                    painter: _CircleBgPainter(
                      size: 120,
                      strokeWidth: 10,
                      color: AppColors.lightGrayBg,
                    ),
                  ),
                  // 进度
                  CustomPaint(
                    size: const Size(120, 120),
                    painter: _CircleProgressPainter(
                      size: 120,
                      strokeWidth: 10,
                      progress: MockData.sleepScore / AppConstants.scoreMax,
                      color: AppColors.success,
                    ),
                  ),
                  // 中心文字
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${MockData.sleepScore}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '睡眠评分',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // 右侧：信息列
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 睡眠时长
                  Text(
                    MockData.sleepDuration,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Total Sleep
                  Text(
                    'Total Sleep',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  // 入睡 → 起床
                  Text(
                    '${MockData.bedtime}  →  ${MockData.wakeTime}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    'Bedtime  →  Wake Up',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 圆形进度绘制器
class _CircleBgPainter extends CustomPainter {
  final double size;
  final double strokeWidth;
  final Color color;

  const _CircleBgPainter({
    required this.size,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
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

  const _CircleProgressPainter({
    required this.size,
    required this.strokeWidth,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final radius = size.width / 2 - strokeWidth / 2;
    final startAngle = -math.pi / 2;
    final sweepAngle = progress * 2 * math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
