import 'package:flutter/material.dart';
import 'package:swim_success/core/constants/app_colors.dart';
import 'package:swim_success/core/constants/swimmer_levels.dart';
import 'package:swim_success/features/pace_selector/domain/swimmer_level.dart';
import '../../../../core/theme/app_theme.dart';

class SliderSegment {
  const SliderSegment({
    required this.startSeconds,
    required this.endSeconds,
    required this.sliderStart,
    required this.sliderEnd,
    required this.level,
    required this.label,
  });

  final double startSeconds;
  final double endSeconds;
  final double sliderStart;
  final double sliderEnd;
  final SwimmerLevel level;

  final String? label;

  bool containsSeconds(double seconds) =>
      seconds >= startSeconds && seconds < endSeconds;

  bool containsSliderValue(double value) =>
      value >= sliderStart && value <= sliderEnd;

  double secondsToSliderValue(double seconds) {
    final ratio = (seconds - startSeconds) / (endSeconds - startSeconds);
    return sliderStart + (sliderEnd - sliderStart) * ratio;
  }

  double sliderValueToSeconds(double value) {
    final ratio = (value - sliderStart) / (sliderEnd - sliderStart);
    return startSeconds + (endSeconds - startSeconds) * ratio;
  }

  Color get color => switch (level) {
    SwimmerLevel.elite => AppColors.levelElite,
    SwimmerLevel.advanced => AppColors.levelAdvanced,
    SwimmerLevel.intermediate => AppColors.levelIntermediate,
    SwimmerLevel.beginner => AppColors.levelBeginner,
  };
}

class PaceSlider extends StatelessWidget {
  const PaceSlider({
    super.key,
    required this.totalSeconds,
    required this.onChanged,
  });

  final int totalSeconds;
  final ValueChanged<double> onChanged;

  static final List<SliderSegment> segments = [
    SliderSegment(
      startSeconds: PaceConstants.minTotalSeconds.toDouble(),
      endSeconds: SwimmerLevelThresholds.eliteMax.toDouble(),
      sliderStart: 0.00,
      sliderEnd: 0.15,
      level: SwimmerLevel.elite,
      label: '1:10',
    ),
    SliderSegment(
      startSeconds: SwimmerLevelThresholds.eliteMax.toDouble(),
      endSeconds: SwimmerLevelThresholds.advancedMax.toDouble(),
      sliderStart: 0.15,
      sliderEnd: 0.50,
      level: SwimmerLevel.advanced,
      label: '1:30',
    ),
    SliderSegment(
      startSeconds: SwimmerLevelThresholds.advancedMax.toDouble(),
      endSeconds: SwimmerLevelThresholds.intermediateMax.toDouble(),
      sliderStart: 0.50,
      sliderEnd: 0.75,
      level: SwimmerLevel.intermediate,
      label: '2:00',
    ),
    SliderSegment(
      startSeconds: SwimmerLevelThresholds.intermediateMax.toDouble(),
      endSeconds: PaceConstants.maxTotalSeconds.toDouble(),
      sliderStart: 0.75,
      sliderEnd: 1.00,
      level: SwimmerLevel.beginner,
      label: null,
    ),
  ];

  static _segmentForSeconds(double seconds) =>
      segments.firstWhere((s) => s.containsSeconds(seconds),
        orElse: () => segments.last,
      );

  static _segmentForSliderValue(double value) =>
      segments.firstWhere((s) => s.containsSliderValue(value),
        orElse: () => segments.last,
      );

  static secondsToSliderValue(double seconds) => _segmentForSeconds(seconds)
      .secondsToSliderValue(seconds)
      .clamp(0.0, 1.0);

  static sliderValueToSeconds(double value) =>
      _segmentForSliderValue(value).sliderValueToSeconds(value);

  @override
  Widget build(BuildContext context) {
    final activeSegment = _segmentForSeconds(totalSeconds.toDouble());

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: context.theme.sliderTheme.copyWith(
            trackHeight: 6,
            trackShape: SegmentedSliderTrackShape(
              segments: segments,
              activeSegment: activeSegment,
            ),
          ),
          child: Slider(
            value: secondsToSliderValue(totalSeconds.toDouble()),
            min: 0.0,
            max: 1.0,
            onChanged: (val) => onChanged(sliderValueToSeconds(val)),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Stack(
            children: [
              const SizedBox(height: 18, width: double.infinity),
              for (final segment in segments)
                if (segment.label != null)
                  Align(
                    alignment: Alignment(secondsToSliderValue(segment.endSeconds) * 2 - 1, -1),
                    child: _SliderLabel(
                      label: segment.label!,
                      isActive: totalSeconds >= segment.startSeconds.toInt(),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class SegmentedSliderTrackShape extends RoundedRectSliderTrackShape {
  const SegmentedSliderTrackShape({
    required this.segments,
    required this.activeSegment,
  });

  final List<SliderSegment> segments;
  final SliderSegment activeSegment;

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required TextDirection textDirection,
        required Offset thumbCenter,
        Offset? secondaryOffset,
        bool isEnabled = false,
        bool isDiscrete = false,
        double additionalActiveTrackHeight = 2.0,
      }) {
    final trackHeight = sliderTheme.trackHeight;
    if (trackHeight == null || trackHeight <= 0) return;

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final radius = Radius.circular(trackHeight / 2);

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, radius),
      Paint()
        ..color = sliderTheme.inactiveTrackColor ?? Colors.grey.shade800
        ..style = PaintingStyle.fill,
    );

    final segStartX =
        trackRect.left + trackRect.width * activeSegment.sliderStart;
    final segEndX =
        trackRect.left + trackRect.width * activeSegment.sliderEnd;

    if (segEndX > segStartX) {
      context.canvas
        ..save()
        ..clipRRect(RRect.fromRectAndRadius(trackRect, radius))
        ..drawRect(
          Rect.fromLTRB(segStartX, trackRect.top, segEndX, trackRect.bottom),
          Paint()
            ..color = activeSegment.color
            ..style = PaintingStyle.fill,
        )
        ..restore();
    }

    final tickPaint = Paint()
      ..color =
      (sliderTheme.inactiveTrackColor ?? Colors.grey.shade800).withValues(alpha: 0.5)
      ..strokeWidth = 1.5;

    for (final segment in segments) {
      if (segment.label == null) continue;
      final tickX = trackRect.left + trackRect.width * segment.sliderEnd;
      context.canvas.drawLine(
        Offset(tickX, trackRect.top - 2),
        Offset(tickX, trackRect.bottom + 2),
        tickPaint,
      );
    }
  }
}

class _SliderLabel extends StatelessWidget {
  const _SliderLabel({
    required this.label,
    required this.isActive,
  });

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.theme.textTheme.bodyMedium?.copyWith(
        fontSize: 12,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        color: isActive
            ? context.colorScheme.onSurface
            : context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }
}
