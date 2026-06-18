import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/swimmer_levels.dart';
import '../../data/pace_repository.dart';
import '../../domain/swimmer_level.dart';

part 'pace_notifier.g.dart';

class PaceState {
  final int minutes;
  final int seconds;
  final AsyncValue<void> submitStatus;

  const PaceState({
    required this.minutes,
    required this.seconds,
    this.submitStatus = const AsyncValue.data(null),
  });

  int get totalSeconds => minutes * 60 + seconds;

  SwimmerLevel get swimmerLevel => SwimmerLevel.fromSeconds(totalSeconds);

  PaceState copyWith({
    int? minutes,
    int? seconds,
    AsyncValue<void>? submitStatus,
  }) {
    return PaceState(
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
      submitStatus: submitStatus ?? this.submitStatus,
    );
  }
}

@riverpod
class PaceNotifier extends _$PaceNotifier {
  Timer? _debounceTimer;

  @override
  PaceState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return const PaceState(minutes: 1, seconds: 30);
  }

  void updateMinutes(int minutes) {
    final clampedMins = minutes.clamp(PaceConstants.minMinutes, PaceConstants.maxMinutes);
    var newTotal = clampedMins * 60 + state.seconds;
    newTotal = newTotal.clamp(PaceConstants.minTotalSeconds, PaceConstants.maxTotalSeconds);

    state = state.copyWith(
      minutes: newTotal ~/ 60,
      seconds: newTotal % 60,
      submitStatus: const AsyncValue.data(null),
    );
  }

  void updateSeconds(int seconds) {
    final clampedSecs = seconds.clamp(PaceConstants.minSeconds, PaceConstants.maxSeconds);
    var newTotal = state.minutes * 60 + clampedSecs;
    newTotal = newTotal.clamp(PaceConstants.minTotalSeconds, PaceConstants.maxTotalSeconds);

    state = state.copyWith(
      minutes: newTotal ~/ 60,
      seconds: newTotal % 60,
      submitStatus: const AsyncValue.data(null),
    );
  }

  void updateFromSlider(double totalSecondsValue) {
    final totalSeconds = totalSecondsValue.round().clamp(PaceConstants.minTotalSeconds, PaceConstants.maxTotalSeconds);
    final mins = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    state = state.copyWith(
      minutes: mins,
      seconds: secs,
      submitStatus: const AsyncValue.data(null),
    );

    // Debounce API call on slider change
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _submitQuietly();
    });
  }

  Future<void> _submitQuietly() async {
    final repository = ref.read(paceRepositoryProvider);
    try {
      await repository.submitPace(state.totalSeconds);
    } catch (_) {}
  }

  Future<void> submit() async {
    _debounceTimer?.cancel();
    state = state.copyWith(submitStatus: const AsyncValue.loading());

    final repository = ref.read(paceRepositoryProvider);
    try {
      await repository.submitPace(state.totalSeconds);
      state = state.copyWith(submitStatus: const AsyncValue.data(null));
    } catch (e, stackTrace) {
      state = state.copyWith(
        submitStatus: AsyncValue.error(e, stackTrace),
      );
    }
  }
}
