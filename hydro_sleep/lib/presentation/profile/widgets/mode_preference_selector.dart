import 'package:flutter/material.dart';

/// 模式偏好选择器
class ModePreferenceSelector extends StatelessWidget {
  const ModePreferenceSelector({super.key});

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
                'Auto',
                style: const TextStyle(fontSize: 13),
              ),
              const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        );
      },
      menuChildren: [
        MenuItemButton(onPressed: () {}, child: const Text('Auto')),
        MenuItemButton(onPressed: () {}, child: const Text('Manual')),
      ],
    );
  }
}
