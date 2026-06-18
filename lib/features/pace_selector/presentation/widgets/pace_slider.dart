import 'package:flutter/material.dart';
import 'package:swim_success/core/constants/swimmer_levels.dart';
import '../../../../core/theme/app_theme.dart';

class PaceSlider extends StatelessWidget {
  final int totalSeconds;
  final ValueChanged<double> onChanged;

  const PaceSlider({
    super.key,
    required this.totalSeconds,
    required this.onChanged,
  });

  static double get minSeconds => PaceConstants.minTotalSeconds.toDouble();
  static double get maxSeconds => PaceConstants.maxTotalSeconds.toDouble();

  @override
  Widget build(BuildContext context) {
    const swimmerLevelEliteMax = '1:10';
    const swimmerLevelAdvancedMax = '1:30';
    const swimmerLevelIntermediateMax = '2:00';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: context.theme.sliderTheme.copyWith(
            trackHeight: 4,
          ),
          child: Slider(
            value: totalSeconds.toDouble().clamp(minSeconds, maxSeconds),
            min: minSeconds,
            max: maxSeconds,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              const SizedBox(height: 24, width: double.infinity),
              Align(
                alignment: Alignment(((SwimmerLevelThresholds.eliteMax - minSeconds) / (maxSeconds - minSeconds)) * 2 - 1, -1),
                child: _SliderLabel(
                  label: swimmerLevelEliteMax,
                  isActive: totalSeconds >= SwimmerLevelThresholds.eliteMax,
                ),
              ),
              Align(
                alignment: Alignment(((SwimmerLevelThresholds.advancedMax - minSeconds) / (maxSeconds - minSeconds)) * 2 - 1, -1),
                child: _SliderLabel(
                  label: swimmerLevelAdvancedMax,
                  isActive: totalSeconds >= SwimmerLevelThresholds.advancedMax,
                ),
              ),
              Align(
                alignment: Alignment(((SwimmerLevelThresholds.intermediateMax - minSeconds) / (maxSeconds - minSeconds)) * 2 - 1, -1),
                child: _SliderLabel(
                  label: swimmerLevelIntermediateMax,
                  isActive: totalSeconds >= SwimmerLevelThresholds.intermediateMax,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SliderLabel extends StatelessWidget {
  final String label;
  final bool isActive;

  const _SliderLabel({
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 2,
          height: 6,
          child: ColoredBox(
            color: isActive
                ? context.colorScheme.primary.withValues(alpha: 0.8)
                : context.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive
                ? context.colorScheme.primary
                : context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
