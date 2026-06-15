# SmartSleep 界面设计

**日期:** 2026-06-15
**包名:** `com.xiaoxin.hydro_sleep`
**框架:** Flutter

## 技术栈

| 关注点 | 库 |
|---|---|
| 状态管理 | `flutter_bloc: ^9.1.1` |
| 值相等 | `equatable: ^2.0.8` |
| 图表 | `fl_chart: ^1.2.0` |
| 本地存储 | `isar_community: ^3.3.2` |
| 安全存储 | `flutter_secure_storage: ^10.3.1` |
| 路由 | `go_router: ^17.3.0` |
| 蓝牙（预留） | `flutter_blue_plus: ^2.3.8`（暂不实现逻辑） |

所有层级均为 Repository + Bloc + UI，零 `setState`。

## 主题

- 亮色主题：蓝色主色（`#1976D2`），白色/浅灰背景
- 暗色主题：深灰表面，保留蓝色强调色
- 通过 `ChangeNotifierProvider` 包装 `MaterialApp` 实现主题切换

## 项目结构

```
lib/
├── main.dart                          # 入口，ThemeProvider 初始化
├── app/
│   └── app.dart                       # MaterialApp + GoRouter 配置
├── core/
│   ├── theme/
│   │   ├── app_theme.dart             # 亮色主题
│   │   ├── dark_theme.dart            # 暗色主题
│   │   └── app_colors.dart            # 色板
│   ├── constants/
│   │   └── app_constants.dart         # 应用名称、版本等常量
│   └── utils/
│       └── mock_data.dart             # 图表和卡片的测试数据
├── data/
│   ├── local/
│   │   ├── isar_database.dart         # Isar 数据库实例
│   │   └── models/
│   │       ├── sleep_session.model.dart
│   │       ├── sleep_minute.model.dart
│   │       └── sleep_report.model.dart
│   ├── repositories/
│   │   ├── sleep_data_repository.dart
│   │   └── device_repository.dart     # 设备状态 + 配置
│   └── storage/
│       └── secure_storage_service.dart
├── domain/
│   ├── models/
│   └── enums/
│       └── sleep_stage.dart           # 离床、体动、坐起、睡眠、清醒、重物、
│                                        打鼾、弱呼吸、深睡、浅睡、REM
├── presentation/
│   ├── startup/
│   │   └── startup_page.dart          # 2秒启动页 → 首页
│   ├── home/
│   │   ├── home_page.dart
│   │   ├── bloc/home_bloc.dart
│   │   ├── bloc/home_event.dart
│   │   ├── bloc/home_state.dart
│   │   └── widgets/
│   │       ├── connection_status_card.dart
│   │       ├── mode_selection_card.dart
│   │       ├── temperature_control_card.dart
│   │       └── schedule_card.dart
│   ├── report/
│   │   ├── report_page.dart
│   │   ├── bloc/report_bloc.dart
│   │   ├── bloc/report_event.dart
│   │   ├── bloc/report_state.dart
│   │   └── widgets/
│   │       ├── date_header.dart
│   │       ├── sleep_score_card.dart
│   │       ├── sleep_stages_summary.dart
│   │       ├── sleep_temp_curve.dart
│   │       └── heart_rate_chart.dart
│   ├── profile/
│   │   ├── profile_page.dart
│   │   ├── bloc/profile_bloc.dart
│   │   ├── bloc/profile_event.dart
│   │   ├── bloc/profile_state.dart
│   │   └── widgets/
│   │       ├── profile_card.dart
│   │       ├── device_list_card.dart
│   │       ├── language_selector.dart
│   │       ├── temperature_unit_selector.dart
│   │       ├── mode_preference_selector.dart
│   │       └── bed_exit_shutdown_selector.dart
│   └── device_search/
│       ├── device_search_page.dart
│       ├── bloc/device_search_bloc.dart
│       ├── bloc/device_search_event.dart
│       ├── bloc/device_search_state.dart
│       └── widgets/
│           └── device_list_tile.dart
└── routing/
    └── app_router.dart                # GoRouter 路由定义
```

## 页面

### 1. 启动页
- 白色/浅色背景，显示应用 Logo/名称
- 2 秒后自动跳转到首页
- 通过 `flutter_secure_storage` 持久化上次连接的设备 ID
- 若 BLE 连接成功 → 首页显示绿色状态；否则显示红色/断开

### 2. 首页（三个 Tab 中的第 1 个）

顶部栏：左侧 "SmartSleep" 标题，右侧用户头像图标。

1. **连接状态卡片** — 根据设备历史分三种状态显示：
   - **从未连接过**：显示"添加设备"按钮，点击跳转到搜索设备页
   - **已连接过但当前无法连接**：红色 "Not Connected"，下方提供两个按钮 — "重新连接"（跳转到搜索设备页）和 "连接新设备"
   - **已连接成功**：绿色 "Connected"

2. **模式选择卡片**
   - 左右排列：自动模式 / 手动模式

3. **温度控制卡片**
   - 当前温度显示
   - 下方目标温度，水平滑块（最小 20，最大 30）
   - 快捷预设行1：18° 22° 25° 28°
   - 预设行2：Cal、Cambridge、Normal、Hot

4. **日程卡片**
   - 默认：23:00 – 06:00
   - "睡眠中自动调节" 开关（默认 ON）
   - 可编辑

### 3. 报告页（三个 Tab 中的第 2 个）

顶部栏：左侧 "Sleep Report" 标题 + 日期副标题，右侧日期导航按钮（← →），右上角 `MenuAnchor` 显示日/周/月/年切换下拉。

1. **睡眠评分卡片**
   - 左侧：圆形进度环（0-100分，绿色填充，浅灰底色）
   - 中间：数字分数
   - 右侧列（从上到下）：
     - 睡眠时长："7h 40m"
     - "Total Sleep" 标签
     - 入睡时间 → 起床时间

2. **睡眠阶段汇总**（一行4项）
   - 深睡：蓝色圆点 · Deep · 2h 15m · 29%
   - 浅睡：浅绿色 · Light · 3h 18m · 40%
   - REM：紫色 · REM · 1h 20m · 18%
   - 活跃：黄色 · Active · 15m · 3%

3. **睡眠 & 温度曲线卡片**
   - 双折线图：睡眠（蓝色）+ 温度（橙色/红色）
   - X 轴：入睡时间到起床时间

4. **心率卡片**
   - 摘要行：平均心率 / 最低心率 / 最高心率
   - 折线图：入睡到起床的心率数据（测试数据）

### 4. 我的页面（三个 Tab 中的第 3 个）

1. **个人档案卡片**
   - 头像、姓名、设备 ID

2. **我的设备卡片**
   - 设备列表：左侧头像占位，右侧设备名称 + 连接状态（绿色/红色）

3. **设置项**（标签 + MenuAnchor 右侧下拉）：
   - 语言：English / 中文
   - 温度单位：°C / °F
   - 模式偏好：Auto
   - 离床关机：10min / 20min / 30min

4. **设备区域**
   - "恢复出厂设置"（黄色文字，右侧箭头，点击后箭头旋转加载 → 完成恢复）

5. **底部信息**：居中显示 "SmartSleep v0.0.1"

### 5. 搜索设备页（独立页面，不在 Tab 栏中）
- 页面顶部：如果有历史连接过的设备，显示"以往连接过的设备"区域，列出可重新连接的设备（每个设备一个连接按钮）；如果没有历史记录，此区域不显示
- BLE 设备列表：扫描附近设备，左侧设备名称，副标题为设备 ID，右侧信号强度
- 点击连接 → 连接成功后自动返回上一页
- 从首页"添加设备"或"连接新设备"按钮进入时，首页连接状态卡片同步更新

## 数据层

### Isar 模型（为未来 BLE 数据接入预留）
- `SleepSession`：开始时间、结束时间、评分、时长、阶段汇总
- `SleepMinute`：时间戳、状态、心率、呼吸率、体动、打鼾、AHI
- `SleepReport`：日报摘要（评分、效率、AHI、打鼾次数等）

### 安全存储
- 历史连接过的设备列表（deviceId、设备名称、连接时间等）
- 用户偏好（语言、温度单位、主题、日程）

### 仓储模式（Repository）
- `SleepDataRepository` → 封装 Isar 查询
- `DeviceRepository` → 封装安全存储 +（未来的）BLE 操作

### BLoC 模式
- 每个页面对应独立的 Bloc + Event + State
- Bloc 消费 Repository，绝不直接操作存储
- UI 层仅使用 `BlocBuilder` / `BlocListener`

## 导航

```
GoRouter 路由：
  /                  → StartupPage
  /home              → HomePage（ShellNavigator，3个 Tab）
  /report            → ReportPage
  /profile           → ProfilePage
  /search            → DeviceSearchPage
```

首页使用 `ShellNavigator`，Tab 为：首页 | 报告 | 我的。

## 验证方式

1. `flutter create hydro_sleep --org com.xiaoxin --platforms android,ios`
2. 将所有依赖添加到 `pubspec.yaml`
3. `flutter pub get`
4. `flutter analyze` → 无错误/警告
5. 在模拟器运行 → 验证 5 个页面均正常渲染，导航工作正常
6. 主题切换 → 验证亮色/暗色切换正常
7. 报告页图表 → 验证 fl_chart 正确渲染测试数据
