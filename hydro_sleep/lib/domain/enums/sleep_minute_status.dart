/// 睡眠分钟状态枚举 — 0x94 数据中每分钟的睡眠状态
///
/// 原始协议值（实时 + 解析）映射为 6 个显示状态：
///   离床: 0x01/0x15/0x06/0x16
///   坐起: 0x03
///   清醒: 0x05/0x14
///   REM:  0x13
///   浅睡眠: 0x04/0x12
///   深睡眠: 0x11
enum SleepMinuteStatus {
  outOfBed,   // 离床
  sitting,    // 坐起
  awake,      // 清醒
  rem,        // REM
  lightSleep, // 浅睡眠
  deepSleep;  // 深睡眠

  /// 从协议原始字节值映射到枚举
  static SleepMinuteStatus fromByte(int byte) {
    switch (byte) {
      case 0x01:
      case 0x15:
      case 0x06:
      case 0x16:
        return SleepMinuteStatus.outOfBed;
      case 0x03:
        return SleepMinuteStatus.sitting;
      case 0x05:
      case 0x14:
        return SleepMinuteStatus.awake;
      case 0x13:
        return SleepMinuteStatus.rem;
      case 0x04:
      case 0x12:
        return SleepMinuteStatus.lightSleep;
      case 0x11:
        return SleepMinuteStatus.deepSleep;
      default:
        return SleepMinuteStatus.awake;
    }
  }

  /// 枚举 → 存储用 int 值（与 Isar 兼容）
  int get dbValue => index;

  /// 从 DB int 值恢复枚举
  static SleepMinuteStatus fromDbValue(int value) =>
      SleepMinuteStatus.values[value.clamp(0, SleepMinuteStatus.values.length - 1)];

  /// 中文显示名
  String get displayName {
    switch (this) {
      case SleepMinuteStatus.outOfBed:
        return '离床';
      case SleepMinuteStatus.sitting:
        return '坐起';
      case SleepMinuteStatus.awake:
        return '清醒';
      case SleepMinuteStatus.rem:
        return 'REM';
      case SleepMinuteStatus.lightSleep:
        return '浅睡眠';
      case SleepMinuteStatus.deepSleep:
        return '深睡眠';
    }
  }
}
