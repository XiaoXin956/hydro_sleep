import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/constants/app_constants.dart';

/// 温度单位选择器
class TemperatureUnitSelector extends StatelessWidget {
  const TemperatureUnitSelector({super.key});

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
                '°C',
                style: const TextStyle(fontSize: 13),
              ),
              const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        );
      },
      menuChildren: AppConstants.temperatureUnitOptions.map((unit) {
        return MenuItemButton(
          onPressed: () {},
          child: Text(unit),
        );
      }).toList(),
    );
  }
}
