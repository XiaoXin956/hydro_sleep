import 'package:isar_community/isar.dart';

part 'report_summary_record.g.dart';

/// 设备存储报表概要 — 0x93 响应解析后持久化
///
/// 每条记录对应一次完整睡眠的统计数据，由 0x13 命令触发设备上报。
/// 复合唯一约束：(deviceId, startTime)，相同设备相同开始时间覆盖更新。
@collection
class ReportSummaryRecord {
  /// Isar 内部自增主键，无业务含义
  Id id = Isar.autoIncrement;

  /// BLE 设备 MAC 地址（如 "AA:BB:CC:DD:EE:FF"）
  /// 与 startTime 构成复合索引，保证同一设备同一次睡眠记录唯一
  @Index(composite: [CompositeIndex('startTime')])
  late String deviceId;

  /// 0x93 响应帧中 bytes[4..13] 的 10 字节 ASCII 标识
  /// 用于区分不同固件/设备返回的帧来源，原样存储便于调试
  late String asciiId;

  /// 睡眠开始时间（Unix 时间戳，秒级，转为 DateTime 存储）
  /// 原始协议为 4 字节小端序，0xFFFFFFFF / 0x00000000 表示无效记录
  /// 单独索引，支持跨设备按日期范围查询
  @Index()
  late DateTime startTime;

  /// 睡眠总时长（分钟），对应协议字段 offset +4，uint16 LE
  late int totalSleepMinutes;

  /// 睡眠效率（0~100%），实际睡眠时间占卧床时间的百分比
  /// 对应协议字段 offset +6，uint16 LE
  late int sleepEfficiency;

  /// 睡眠质量评分（0~100 分），设备算法综合评估结果
  /// 对应协议字段 offset +8，uint16 LE
  late int sleepQuality;

  /// 翻身次数，整晚睡眠中的身体翻转总次数
  /// 对应协议字段 offset +10，uint16 LE
  late int turnOverCount;

  /// 入睡潜时（分钟），从上床到实际入睡的等待时间
  /// 对应协议字段 offset +12，uint16 LE
  late int sleepLatencyMinutes;

  /// 离床次数，整晚离开床垫的总次数
  /// 对应协议字段 offset +14，uint16 LE
  late int leaveBedCount;

  /// 睡眠节律相位，设备算法计算的睡眠周期阶段标识
  /// 对应协议字段 offset +16，uint16 LE
  late int sleepRhythmPhase;

  /// 预留字段（slop1），协议保留，暂未使用
  /// 对应协议字段 offset +18，uint16 LE
  late int reserved1;

  /// 最长连续睡眠段的开始分钟点（0~1440，相对当天 00:00 的分钟偏移）
  /// 用于定位整晚中最深、最长的连续睡眠区间
  /// 对应协议字段 offset +20，uint16 LE
  late int longestSleepStartMinute;

  /// 呼吸障碍指数 AHI（Apnea-Hypopnea Index）
  /// 每小时呼吸暂停+低通气次数，数值越高表示呼吸问题越严重
  /// 对应协议字段 offset +22，uint16 LE
  late int ahiIndex;

  /// 打鼾总次数，整晚检测到的打鼾事件累计
  /// 对应协议字段 offset +24，uint16 LE
  late int snoreTotalCount;

  /// 0x14 详细分钟数据是否已拉取
  /// false = 仅有概要统计，true = 已通过 0x14 命令获取分钟级详细数据
  bool dataLoaded = false;

  /// 本次从设备同步数据的时间（本地时间），用于判断数据新鲜度
  late DateTime syncedAt;
}
