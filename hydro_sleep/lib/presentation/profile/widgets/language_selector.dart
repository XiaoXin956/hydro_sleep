import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/constants/app_constants.dart';
import 'package:hydro_sleep/core/locale/locale_cubit.dart';
import 'package:provider/provider.dart';

/// 语言选择器
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state;
    final isZh = locale.languageCode == 'zh';
    final currentLabel = isZh ? '中文' : 'English';

    return MenuAnchor(
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentLabel,
                style: const TextStyle(fontSize: 13),
              ),
              const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        );
      },
      menuChildren: AppConstants.languageOptions.map((language) {
        return MenuItemButton(
          onPressed: () {
            final localeCode = language == '中文' ? 'zh' : 'en';
            context.read<LocaleCubit>().setLocale(Locale(localeCode));
          },
          child: Text(language),
        );
      }).toList(),
    );
  }
}
