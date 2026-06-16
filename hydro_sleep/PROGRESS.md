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

## 待完成

### BLoC 模块完善
- [ ] ThemeCubit（替换当前 ChangeNotifier 实现）
- [ ] DeviceBloc（BLE 设备连接状态管理）
- [ ] SleepDataBloc（睡眠数据加载与缓存）

### 功能开发
- [ ] BLE 连接集成（flutter_blue_plus）
- [ ] 实时数据采集与展示
- [ ] 睡眠数据分析算法
- [ ] 设置项持久化（温度单位、模式偏好、离床关机等）
- [ ] 日期选择器（报告页 DateHeader）

### 平台适配
- [ ] iOS 配置（Info.plist、权限声明）
- [ ] Android 权限配置（蓝牙、位置）
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
| BLE | flutter_blue_plus 2.3.8（预留） |
