import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/constants/app_constants.dart';

/// 离床关机选择器
class BedExitShutdownSelector extends StatelessWidget {
  const BedExitShutdownSelector({super.key});

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
                '10min',
                style: const TextStyle(fontSize: 13),
              ),
              const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        );
      },
      menuChildren: AppConstants.bedExitOptions.map((option) {
        return MenuItemButton(
          onPressed: () {},
          child: Text(option),
        );
      }).toList(),
    );
  }
}
