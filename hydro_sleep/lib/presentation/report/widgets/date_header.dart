import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 28),
              onPressed: _previousDay,
            ),
            Text(
              _formatDate(_selectedDate, l10n),
              style: theme.textTheme.titleMedium,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 28),
              onPressed: _nextDay,
            ),
          ],
        ),
        MenuAnchor(
          builder: (context, controller, child) {
            return GestureDetector(
              onTap: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.dateDay,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            );
          },
          menuChildren: [
            _PeriodMenuItem(l10n.dateDay, () {}),
            _PeriodMenuItem(l10n.dateWeek, () {}),
            _PeriodMenuItem(l10n.dateMonth, () {}),
            _PeriodMenuItem(l10n.dateYear, () {}),
          ],
        ),
      ],
    );
  }
}

class _PeriodMenuItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PeriodMenuItem(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      onPressed: onTap,
      child: Text(label),
    );
  }
}
