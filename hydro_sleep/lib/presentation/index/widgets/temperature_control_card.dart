import 'package:flutter/material.dart';
import 'package:hydro_sleep/core/constants/app_constants.dart';
import 'package:hydro_sleep/core/theme/app_colors.dart';

/// 温度预设项
class _TemperaturePreset {
  final double temp;
  final String label;
  const _TemperaturePreset(this.temp, this.label);
}

/// 温度控制卡片
class TemperatureControlCard extends StatefulWidget {
  const TemperatureControlCard({super.key});

  @override
  State<TemperatureControlCard> createState() => _TemperatureControlCardState();
}

class _TemperatureControlCardState extends State<TemperatureControlCard> {
  double _targetTemp = 24.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Text(
              '温度',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // 当前温度
            Text(
              '当前温度 22.5°C',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // 滑块
            Row(
              children: [
                const Text('15°', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                Expanded(
                  child: Slider(
                    value: _targetTemp,
                    min: 15.0,
                    max: 30.0,
                    activeColor: AppColors.primary,
                    divisions: 15,
                    label: '${_targetTemp.toInt()}°',
                    onChanged: (value) {
                      setState(() => _targetTemp = value);
                    },
                  ),
                ),
                const Text('30°', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
              ],
            ),
            Center(
              child: Text(
                '目标温度 ${_targetTemp.toInt()}°C',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // 快捷预设网格 2x4
            _presetGrid(theme),
          ],
        ),
      ),
    );
  }

  Widget _presetGrid(ThemeData theme) {
    final presets = List.generate(
      AppConstants.temperaturePresets.length,
      (i) => _TemperaturePreset(
        AppConstants.temperaturePresets[i],
        AppConstants.temperaturePresetNames[i],
      ),
    );

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.2,
      ),
      itemCount: presets.length,
      itemBuilder: (context, index) {
        final preset = presets[index];
        final isSelected = _targetTemp == preset.temp;
        return InkWell(
          onTap: () => setState(() => _targetTemp = preset.temp),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : null,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.divider,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${preset.temp.toInt()}°',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  preset.label,
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
