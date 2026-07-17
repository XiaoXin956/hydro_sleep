# SmartSleep 开发进度

## 已完成

### 2026-06-14
- [x] 初始化 Flutter 项目代码
- [x] UI 设计文档（中文版）

### 2026-06-15
- [x] 首页 UI（设备连接状态、模式选择、温度控制、日程卡片）
- [x] 报告页 UI（睡眠评分、阶段汇总、睡眠温度曲线、心率图表）
- [x] 我的页面 UI（个人档案、设备列表、设置项、恢复出厂设置）
- [x] 设备搜索页 UI
- [x] fl_chart 双 Y 轴图表（睡眠阶段 + 温度）
- [x] 心率图表（动态 Y 轴范围，23:00→07:00 数据）
- [x] 恢复出厂设置按钮加载动画（AnimatedSwitcher）

### 2026-06-16
- [x] 国际化支持（flutter_localizations + intl 0.20.2）
  - ARB 文件：英文（默认）+ 中文，65+ 条翻译
  - LocaleCubit（BLoC）管理语言状态，持久化到 SecureStorageService
  - 替换所有页面硬编码字符串（16 个文件）
  - LanguageSelector 支持真正的语言切换并即时刷新
- [x] 「我的」页面 BLoC 模块完善
  - FactoryResetCubit：确认弹框 → 5s 模拟恢复流程，3 阶段状态（initial/loading/success）
  - TempUnitCubit：°C/°F 温度单位切换，本地持久化
  - BedExitCubit：离床关机时间选择，本地持久化
  - DeviceListCubit：设备列表展开/收起，默认显示前 3 条，本地持久化
  - SecureStorageService 新增 bedExit shutdown 存储方法
  - 补充 l10n 字符串：factoryReset/showMore/showLess

### 2026-06-17
- [x] BLE 扫描功能（flutter_blue_plus 2.3.8）
  - BleService：封装 FlutterBluePlus 静态 API（权限、扫描、结果流）
  - BleScanCubit：扫描状态管理（idle/scanning/results），Android 动态权限处理
  - ScannedDevice 模型（remoteId, name, rssi, connectable）
  - DeviceSearchPage 接入 BleScanCubit，实时展示扫描设备列表
- [x] BLE 连接与自动重连
  - BleConnectCubit：连接生命周期（idle → connecting → connected → disconnected/reconnecting/failed）
  - 断开检测：stream 监听 + 3s 定时轮询双保险
  - 自动重连：maxRetries=3，autoConnect: true（后台重连），20s 超时，10s 间隔
  - 蓝牙关闭自动清理所有连接状态
  - 连接成功自动保存 HistoryDevice 到本地
  - DeviceSearchPage 连接对话框（进度指示 → 连接成功/失败反馈）
  - 首页 ConnectionStatusCard 同步显示 BLE 连接状态
  - 修复 autoConnect 时 mtu 不兼容断言错误（mtu: autoConnect ? null : 247）

### 2026-06-18
- [x] BLE 数据通信层（BleDataCubit + BleService 扩展）
  - BleService 新增：discoverServices / findNotifyCharacteristic / findWriteCharacteristic / enableNotify / disableNotify / writeData
  - BleDataCubit：服务发现 → 通知订阅 → 数据流 → 按 `bytes[1]` 数据类型分发
  - DeviceInfo 模型：A5 5A 帧头解析（11字节设备信息）
  - 首页温度、模式同步 BleDataCubit 真实数据
- [x] BLE 重连 GATT 缓存修复
  - 原因：`autoConnect: true` 不调用 `gatt.close()`，Android 保留旧服务缓存
  - 修复：`_autoReconnect` 每次 `connect()` 前先 `disconnect()` 强制清除 GATT
- [x] Completer 重复完成异常修复
  - `_cancelReconnect` 三处 `.complete()` 调用均加 `isCompleted` 保护
- [x] 蓝牙关闭即时清理 UI
  - `BleDataCubit` 监听 `adapterState`，蓝牙 off 时立即取消订阅、清理缓冲区、重置状态

### 2026-06-28
- [x] 恢复出厂设置 BLE 协议（0x17 / 0x97）
  - `FactoryResetCubit` 注入 `BleDataCubit`，发送 `[0x17]` 命令，等待 `0x97` 响应
  - profile_page 成功/失败 SnackBar 反馈，3s 自动重置状态
  - l10n 新增：factoryResetSuccess / factoryResetFailed / deviceNotConnected
- [x] 重传协议 — 120秒（0x01 / 0x81）
  - 发送 15 字节命令 `7D 01 0F 00 55 4E 43 4F 4E 46 49 47 45 44 0D`
  - 0x81 响应：缓冲多包数据（跳过帧头+类型 2 字节），500ms 无新包或满 30 组后解析
  - RetransmitRecord 模型（12字节/组：序列号、Unix时间戳LE、状态、心率、呼吸率、SDATA、PDATA）
  - RetransmitTestCard：报告页手动触发测试卡片
- [x] 重传协议 — 30分钟（0x02 / 0x82）
  - 0x82 响应：30组×15字节记录，同样多包缓冲策略
  - Retransmit30Record 模型（15字节/组：序列号、时间戳LE、状态、心率、呼吸率、体动、打鼾次数、呼吸障碍、PTHD、温度）
  - Retransmit30TestCard 测试卡片
- [x] 停止指令（0x03 / 0x83）
  - 无内容响应，设备进入待机模式。StopCommandTestCard（橙色强制停止按钮）
- [x] 工作模式设定（0x04 / 0x84）+ 实时数据流（0x85 / 0x86）
  - 发送 16 字节命令（14字节前缀 + 模式字节 + 0x0D），支持 0x20（监控模式）和 0x30（调试模式）
  - 0x84 响应：确认字节 0x00~0x04（成功/不支持/未就绪/长度错误/参数错误）
  - 0x85 实时秒数据（每秒12字节，环形缓冲120条），0x86 实时分钟数据（每分钟15字节，环形缓冲30条）
  - BleDataState 新增 latestSecondRecord/secondRecords/latestMinuteRecord/minuteRecords 字段
  - ModeCommandTestCard 测试卡片
- [x] 设备状态查询（0x07 / 0x87）
  - 0x87 响应：6字节（模式1+错误码1+时间戳4LE），DeviceStatus 模型
  - DeviceStatusTestCard 测试卡片（模式标签+错误+校准时间）
- [x] 心跳应答（0x08 / 0x88）
  - 无内容响应，建议每分钟发送，超5分钟未收到设备重启WiFi
  - HeartbeatTestCard 测试卡片（手动+自动1分钟定时，计数器）
- [x] 压力校准指令（0x09 / 0x89）
  - 0x89 响应：结果字节（0x00=校准完成），约4秒返回
  - PressureCalibrateTestCard 测试卡片
- [x] 参数管理指令（0x0A / 0x8A）
  - 3个子命令：01复位/02读取/03设置，帧长16字节
  - 0x8A 读取响应：64字节（16个float LE），DeviceParameters 模型
  - 16个参数：离入床动态阈值、体动阈值、打鼾灵敏度等
  - ParameterTestCard 测试卡片（读取/复位，显示16参数及默认值对比）
- [x] 校准时钟指令（0x0B / 0x8B）
  - 发送16字节命令（14字节前缀 + 4字节Unix时间戳LE + 0x0D）
  - 0x8B 响应：无内容。ClockCalibrateTestCard 测试卡片
- [x] 固件版本查询（0x0C / 0x8C）
  - 连接成功后自动发送 `7D 0C 0F 00 55 4E 43 4F 4E 46 49 47 45 44 0D`
  - 0x8C 响应：`bytes[2..]` 为字符串，如 `UiSleep_Pro_BLE_HVER810_FVER180`
  - BleDataState 新增 `firmwareVersion` 字段，profile_page 实时显示
- [x] 数据类型分发修正
  - 响应帧结构：`bytes[0]` = 帧头，`bytes[1]` = 数据类型（A5 5A 设备信息除外）
- [x] 我的页面固件版本显示
  - 通用设置新增"固件版本"行，BlocBuilder 实时同步 BleDataCubit.firmwareVersion
- [x] 报表查询协议（0x13 / 0x93）
  - `sendReportQueryCommand()` 发送 0x13，设备回复 0x93：15组×26字节 ReportSummary（分3批，每批5组，500ms间隔）
  - ReportSummary 模型：startTime(4B)、sleepLen(1B)、duration(2B)、startPulse(2B)、startBreath(2B)、endPulse(2B)、endBreath(2B)、spo2(1B)、avgHR(1B)、avgBR(1B)
  - ReportQueryTestCard 测试卡片（查询+列表展示，点击条目跳转数据读取）
- [x] 数据读取协议（0x14 / 0x94）
  - `sendSleepDataReadCommand(startTime, seq)` 发送 0x14，设备回复 0x94：30组×4字节 SleepMinuteRecord
  - SleepMinuteRecord 模型：mode(1B)、heartRate(1B)、breathRate(1B)、bodyMove(1B)
  - seq 范围 0~47（48包×30分钟 = 24小时），用 startTime 作为报表标识
  - ReportDetailTestCard 测试卡片（显示单报表各 seq 的分钟数据）
- [x] 设备版本测试卡片（FirmwareVersionTestCard）
  - 显示 A5 5A 自动推送的设备信息（电源/模式/功率/时间/目标温度/低水位/实际温度）
  - 手动查询按钮触发 0x0C，显示固件版本字符串

### 2026-07-07
- [x] DeviceInfo 字段重构
  - `workTemp` → `targetTemp`（[6] 目标温度），`ntcValue` → `actualTemp`（[8] 实际温度，单字节）
  - BleDataCubit `sendDeviceControlCommand` 同步更新
- [x] 首页 BLE 设备控制功能
  - ConnectionStatusCard：电源开关按钮（power=0/1），固定 40×40 布局防止切换抖动
  - ModeSelectionCard：三模式选择（自动0/制冷1/制热2），发送 `sendDeviceControlCommand(mode:)`
  - TemperatureControlCard：滑块 `onChangeEnd` + 预设点击发送 `sendDeviceControlCommand(targetTemp:)`，同步设备状态，固定 16×16 spinner 位置
  - sendDeviceControlCommand：读取当前 DeviceInfo 状态，覆盖指定字段后发送 11 字节控制帧
- [x] 首页 ScheduleCard 简化
  - 标题改为"工作时间"，删除"睡眠期间自动调节"开关，只显示一个时间 chip
- [x] 通用设置 BlocBuilder 重构
  - ModePreferenceSelector 改用 BlocBuilder 实时同步设备 workMode 状态
- [x] 首页卡片关机灰化 + 电源按钮始终可用
  - 温度/模式/水位/工作时间卡片：未连接 或 deviceInfo==null 或 关机 → 灰化（Opacity+IgnorePointer+onChanged:null）
  - 电源按钮：HitTestBehavior.opaque，始终可点击（未收到 A5 5A 时灰色图标）
- [x] A5 5A 协议扩展：controlMode[9] + 本地参数缓存 + 校验和
  - controlMode 字节 [9]：0=自动，1=手动（制冷/制热触发），关机再开机恢复自动
  - 设备参数本地缓存：每次收到 A5 5A 后 `unawaited()` 写入 SecureStorage
  - info==null 时 fallback：SecureStorage 缓存 → 默认值（mode=0, target=30, actual=30, time=8）
  - 帧末字节为 bytes[2..9] 十进制求和后转十六进制校验和
- [x] DeviceStatus 新增 asciiId（bytes[4..13] 原始字节 List<int>）
- [x] 报告页 MockData 移除
  - SleepTempCurve / HeartRateChart 无数据时显示"暂无数据"，不再使用 MockData
  - 新增 l10n key `noData`（中："暂无数据"，英："No Data"）
- [x] 0x87 响应保存 asciiId 到 SecureStorage（key=device_ascii_id_{remoteId}）
- [x] 0x13/0x14 命令帧 ID 替换：bytes[4..13] 使用 SecureStorage 缓存的 asciiId，无缓存时 fallback 为 "UNCONFIGED"

### 2026-07-16
- [x] ReportSummary 字节序修正
  - 时间戳：大端序 → **小端序**（`(t3<<24)|(t2<<16)|(t1<<8)|t0`），`*1000` 转毫秒，去掉手动 +28800 时区偏移
  - uint16 数据字段：小端序 → **大端序**（`_u16LE` → `_u16BE`）
  - 0x93 帧解析偏移条件：`offset + 26 <= bytes.length - 1` → `offset + 26 <= bytes.length`（修复末尾记录被跳过）
- [x] SleepMinuteRecord 字段扩展
  - 新增字段：dateTime、snoreCount、respiratoryObstruction、pthd、temp
  - 新增工厂方法 `fromRetransmit30Bytes()`（从 0x82 的 15 字节解析）
  - 所有字段添加详细注释（字节来源、含义、单位）
  - 新增字段均为 nullable，0x94 解析不受影响
- [x] 发送数据记录卡片 SentDataLogCard 长数据显示修复
  - 删除 `overflow: TextOverflow.ellipsis`，改为 `softWrap: true`，长 hex 数据完整换行显示

### 2026-07-17
- [x] SleepMinuteRecord 新增 `fromBytesWithTime` 工厂方法（0x86 专用，15字节，含全部扩展字段）
- [x] 0x86 实时分钟数据解析升级
  - `BleDataState.minuteRecords` 类型：`List<Retransmit30Record>` → `List<SleepMinuteRecord>`
  - 0x86 处理改用 `SleepMinuteRecord.fromBytesWithTime`，等待 0x0D 尾帧后解析
  - 每条记录自动存入 Isar DB（`SleepDataRepository.saveSleepMinuteData`）
- [x] 首页 RealtimeDataCard（0x85 实时秒数据卡片）
  - 位于 ModeSelectionCard 上方，每秒更新：时间、状态、心率、呼吸率
  - BlocBuilder 监听 `BleDataState.latestSecondRecord`
- [x] ReportSummary 新增 `dataLoaded` 字段
  - 标记 0x14 详细分钟数据是否已拉取，Isar 保存时保留已有状态

## 待完成

### BLoC 模块完善
- [ ] ThemeCubit（替换当前 ChangeNotifier 实现）
- [ ] SleepDataBloc（睡眠数据加载与缓存）

### BLE 数据通信
- [x] BleDataCubit — BLE 数据状态管理（服务发现 → 通知订阅 → 按 bytes[1] 数据类型分发）
- [x] BleService 扩展 — discoverServices / enableNotify / writeData
- [x] DeviceInfo 模型 — A5 5A 帧头解析
- [x] BLE 协议命令实现 — 15个命令/响应对（0x01~0x0C, 0x13, 0x14, 0x17）+ 实时数据流（0x85/0x86）
- [x] 首页设备控制 — sendDeviceControlCommand（电源/模式/温度），BlocBuilder 实时同步
- [ ] BleFrameParser — 完整帧解析（校验和验证、粘包/拆包处理）

### 功能开发
- [ ] 实时数据采集与展示（首页数据卡片完善）
- [ ] 睡眠数据分析算法
- [ ] 日期选择器（报告页 DateHeader）

### 平台适配
- [ ] iOS 配置（Info.plist、权限声明）
- [ ] 推送通知

## 技术栈

| 模块 | 技术 |
|------|------|
| UI | Flutter 3.44.1 / Material Design |
| 状态管理 | provider + flutter_bloc |
| 路由 | go_router 17.3.0 |
| 图表 | fl_chart 1.2.0 |
| 本地存储 | isar_community 3.3.0 |
| 安全存储 | flutter_secure_storage 10.3.1 |
| 国际化 | flutter_localizations + intl 0.20.2 |
| BLE | flutter_blue_plus 2.3.8 |
| 权限 | permission_handler 11.4.0 |
