import 'package:flutter/material.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 报告周期类型
enum DatePeriod { day, week, month, year }

/// 日期切换头，根据 [DatePeriod] 显示不同格式
class DateHeader extends StatefulWidget {
  const DateHeader({
    super.key,
    required this.period,
    this.onPeriodChanged,
  });

  final DatePeriod period;
  final ValueChanged<DateTime>? onPeriodChanged;

  @override
  State<DateHeader> createState() => _DateHeaderState();
}

class _DateHeaderState extends State<DateHeader> {
  late DateTime _selected;
  late final DateTime _today;
  // 1 = 向左滑出（点右箭头），-1 = 向右滑出（点左箭头）
  int _direction = 1;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _selected = _today;
  }

  // ──────────────────── 左箭头 ────────────────────

  void _previous() {
    setState(() {
      _direction = -1;
      switch (widget.period) {
        case DatePeriod.day:
          _selected = _selected.subtract(const Duration(days: 1));
        case DatePeriod.week:
          _selected = _selected.subtract(const Duration(days: 7));
        case DatePeriod.month:
          _selected = DateTime(_selected.year, _selected.month - 1, 1);
        case DatePeriod.year:
          _selected = DateTime(_selected.year - 1, 1, 1);
      }
    });
    widget.onPeriodChanged?.call(_selected);
  }

  // ──────────────────── 右箭头（含上限判断） ────────────────────

  void _next() {
    if (!_canGoNext) return;
    setState(() {
      _direction = 1;
      switch (widget.period) {
        case DatePeriod.day:
          _selected = _selected.add(const Duration(days: 1));
        case DatePeriod.week:
          _selected = _selected.add(const Duration(days: 7));
        case DatePeriod.month:
          _selected = DateTime(_selected.year, _selected.month + 1, 1);
        case DatePeriod.year:
          _selected = DateTime(_selected.year + 1, 1, 1);
      }
    });
    widget.onPeriodChanged?.call(_selected);
  }

  bool get _canGoNext {
    switch (widget.period) {
      case DatePeriod.day:
        return !_isSameDay(_selected, _today) && _selected.isBefore(_today);
      case DatePeriod.week:
        final end = _weekEnd(_selected);
        return end.isBefore(_today) || _isSameDay(end, _today);
      case DatePeriod.month:
        return _selected.year < _today.year ||
            (_selected.year == _today.year && _selected.month < _today.month);
      case DatePeriod.year:
        return _selected.year < _today.year;
    }
  }

  // ──────────────────── 显示文本 ────────────────────

  String _displayText(AppLocalizations l10n) {
    final m = l10n;
    switch (widget.period) {
      case DatePeriod.day:
        return _formatDay(_selected);
      case DatePeriod.week:
        return _formatWeek(_selected);
      case DatePeriod.month:
        return _formatMonth(_selected, m);
      case DatePeriod.year:
        return '${_selected.year}';
    }
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _fullMonths = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  /// "Jun 14, 2026"
  String _formatDay(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

  /// "Jun 8 – 14, 2026"  (周日 → 周六)
  String _formatWeek(DateTime d) {
    final start = _weekStart(d);
    final end = _weekEnd(d);
    if (start.year == end.year) {
      return '${_months[start.month - 1]} ${start.day}'
          ' – '
          '${_months[end.month - 1]} ${end.day}, ${end.year}';
    }
    return '${_months[start.month - 1]} ${start.day}, ${start.year}'
        ' – '
        '${_months[end.month - 1]} ${end.day}, ${end.year}';
  }

  /// "June 2026"
  String _formatMonth(DateTime d, AppLocalizations _) =>
      '${_fullMonths[d.month - 1]} ${d.year}';

  // ──────────────────── 周计算（周日起） ────────────────────

  static DateTime _weekStart(DateTime d) {
    // dart weekday: Mon=1 … Sun=7
    final daysSinceSunday = d.weekday % 7;
    return DateTime(d.year, d.month, d.day - daysSinceSunday);
  }

  static DateTime _weekEnd(DateTime d) => _weekStart(d).add(const Duration(days: 6));

  // ──────────────────── 辅助 ────────────────────

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ──────────────────── Build ────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = _displayText(AppLocalizations.of(context)!);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: _previous,
        ),
        const SizedBox(width: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, anim) {
            final offset = child.key == ValueKey(text)
                ? Offset(_direction * 0.4, 0)   // 新文字：从方向侧滑入
                : Offset(-_direction * 0.4, 0);  // 旧文字：向方向侧滑出
            return SlideTransition(
              position: Tween(begin: offset, end: Offset.zero).animate(anim),
              child: FadeTransition(opacity: anim, child: child),
            );
          },
          child: Text(
            text,
            key: ValueKey(text),
            style: theme.textTheme.titleMedium,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            Icons.chevron_right,
            size: 28,
            color: _canGoNext ? null : theme.disabledColor,
          ),
          onPressed: _canGoNext ? _next : null,
        ),
      ],
    );
  }
}
