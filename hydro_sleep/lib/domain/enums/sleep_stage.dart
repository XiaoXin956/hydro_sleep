/// 睡眠阶段枚举
enum SleepStage {
  outOfBed(1, '离床'),
  tossing(2, '体动'),
  sitting(3, '坐起'),
  sleep(4, '睡眠'),
  awake(5, '清醒'),
  heavy(6, '重物'),
  snoring(7, '打鼾'),
  shallowBreath(8, '弱呼吸'),
  deep(0x11, '深睡'),
  light(0x12, '浅睡'),
  rem(0x13, 'REM'),
  wake(0x14, '清醒'),
  out(0x15, '离床');

  const SleepStage(this.code, this.label);

  final int code;
  final String label;
}

/// 报告页的睡眠阶段展示枚举
enum ReportSleepStage {
  deep('Deep', '深睡'),
  light('Light', '浅睡'),
  rem('REM', 'REM'),
  active('Active', '活跃');

  const ReportSleepStage(this.name, this.nameZh);

  final String name;
  final String nameZh;
}
