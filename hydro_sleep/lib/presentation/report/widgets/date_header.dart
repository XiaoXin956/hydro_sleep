import 'package:flutter/material.dart';
import 'package:hydro_sleep/l10n/app_localizations.dart';

/// 日期切换头
class DateHeader extends StatefulWidget {
  const DateHeader({super.key});

  @override
  State<DateHeader> createState() => _DateHeaderState();
}

class _DateHeaderState extends State<DateHeader> {
  DateTime _selectedDate = DateTime(2026, 6, 14);

  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: _previousDay,
        ),
        const SizedBox(width: 8),
        Text(
          _formatDate(_selectedDate, l10n),
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.chevron_right, size: 28),
          onPressed: _nextDay,
        ),
      ],
    );
  }
}
