import '../../../core/constants/swimmer_levels.dart';

enum SwimmerLevel {
  elite(translationKey: 'pace_selector.levels.elite'),
  advanced(translationKey: 'pace_selector.levels.advanced'),
  intermediate(translationKey: 'pace_selector.levels.intermediate'),
  beginner(translationKey: 'pace_selector.levels.beginner');

  final String translationKey;

  const SwimmerLevel({required this.translationKey});

  static SwimmerLevel fromSeconds(int seconds) {
    if (seconds < SwimmerLevelThresholds.eliteMax) return SwimmerLevel.elite;
    if (seconds < SwimmerLevelThresholds.advancedMax) return SwimmerLevel.advanced;
    if (seconds < SwimmerLevelThresholds.intermediateMax) return SwimmerLevel.intermediate;
    return SwimmerLevel.beginner;
  }
}
