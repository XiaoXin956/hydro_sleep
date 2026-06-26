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

## 待完成

### BLoC 模块完善
- [ ] ThemeCubit（替换当前 ChangeNotifier 实现）
- [ ] SleepDataBloc（睡眠数据加载与缓存）

### BLE 数据通信
- [ ] BleFrameParser — BLE 帧解析（粘包/拆包处理，帧头 0xA5 0x5A，校验和验证）
- [ ] BleDataCubit — BLE 数据状态管理（服务发现 → 通知订阅 → 帧解析 → 数据分发）
- [ ] BleCmd — BLE 命令类型常量（0x81~0x94）
- [ ] 扩展 BleService 添加数据通信方法（discoverServices/enableNotify/writeData）

### 功能开发
- [ ] 实时数据采集与展示（首页数据卡片填充）
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
