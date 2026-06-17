import 'package:flutter/material.dart';

/// 应用色板
class AppColors {
  AppColors._();

  // 主色调（蓝色）
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color primaryDark = Color(0xFF0D47A1);

  // 状态色
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);

  // 睡眠阶段色
  static const Color sleepDeep = Color(0xFF1976D2);       // 深睡 - 蓝
  static const Color sleepLight = Color(0xFF66BB6A);      // 浅睡 - 浅绿
  static const Color sleepRem = Color(0xFF7E57C2);        // REM - 紫
  static const Color sleepActive = Color(0xFFFFCA28);     // 活跃 - 黄

  // 通用色
  static const Color temperatureCurve = Color(0xFFEF5350); // 温度曲线 - 红
  static const Color heartRate = Color(0xFFE53935);        // 心率 - 红

  // 文字色
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // 背景色
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceCard = Color(0xFFFFFFFF);

  // 边框
  static const Color divider = Color(0xFFE0E0E0);
  static const Color lightGrayBg = Color(0xFFE0E0E0); // 进度环底色

  // 暗色主题覆盖色
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceCard = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);
}
