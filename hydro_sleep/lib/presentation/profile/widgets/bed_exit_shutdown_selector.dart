import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/bed_exit/bed_exit_cubit.dart';
import 'package:hydro_sleep/core/constants/app_constants.dart';
import 'package:provider/provider.dart';

/// 离床关机选择器
class BedExitShutdownSelector extends StatelessWidget {
  const BedExitShutdownSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final currentOption = context.watch<BedExitCubit>().state;

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
                currentOption,
                style: const TextStyle(fontSize: 13),
              ),
              const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        );
      },
      menuChildren: AppConstants.bedExitOptions.map((option) {
        return MenuItemButton(
          onPressed: () {
            context.read<BedExitCubit>().setOption(option);
          },
          child: Text(option),
        );
      }).toList(),
    );
  }
}
