import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/constants/app_constants.dart';

/// 语言选择器
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
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
                'English',
                style: const TextStyle(fontSize: 13),
              ),
              const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        );
      },
      menuChildren: AppConstants.languageOptions.map((language) {
        return MenuItemButton(
          onPressed: () {},
          child: Text(language),
        );
      }).toList(),
    );
  }
}
