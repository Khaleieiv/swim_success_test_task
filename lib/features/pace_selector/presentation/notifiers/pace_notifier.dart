import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/swimmer_levels.dart';
import '../../data/pace_repository.dart';
import '../../domain/swimmer_level.dart';

part 'pace_notifier.g.dart';

const _secondsPerMinute = 60;

class PaceState {
  final int minutes;
  final int seconds;
  final AsyncValue<void> submitStatus;

  const PaceState({
    required this.minutes,
    required this.seconds,
    this.submitStatus = const AsyncValue.data(null),
  });

  int get totalSeconds => minutes * _secondsPerMinute + seconds;

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
  static const _defaultMinutes = 1;
  static const _defaultSeconds = 30;
  static const _submitDebounce = Duration(milliseconds: 500);

  Timer? _debounceTimer;

  @override
  PaceState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return const PaceState(minutes: _defaultMinutes, seconds: _defaultSeconds);
  }

  void updateMinutes(int minutes) {
    final clampedMins = minutes.clamp(PaceConstants.minMinutes, PaceConstants.maxMinutes);
    _updateTotalSeconds(clampedMins * _secondsPerMinute + state.seconds);
  }

  void updateSeconds(int seconds) {
    final clampedSecs = seconds.clamp(PaceConstants.minSeconds, PaceConstants.maxSeconds);
    _updateTotalSeconds(state.minutes * _secondsPerMinute + clampedSecs);
  }

  void _updateTotalSeconds(int totalSeconds) {
    final clamped = totalSeconds.clamp(
      PaceConstants.minTotalSeconds,
      PaceConstants.maxTotalSeconds,
    );
    state = state.copyWith(
      minutes: clamped ~/ _secondsPerMinute,
      seconds: clamped % _secondsPerMinute,
      submitStatus: const AsyncValue.data(null),
    );
  }

  void updateFromSlider(double totalSecondsValue) {
    final totalSeconds = totalSecondsValue.round().clamp(PaceConstants.minTotalSeconds, PaceConstants.maxTotalSeconds);
    final mins = totalSeconds ~/ _secondsPerMinute;
    final secs = totalSeconds % _secondsPerMinute;
    state = state.copyWith(
      minutes: mins,
      seconds: secs,
      submitStatus: const AsyncValue.data(null),
    );

    // Debounce API call on slider change
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_submitDebounce, () {
      _submitQuietly();
    });
  }

  Future<void> _submitQuietly() async {
    final repository = ref.read(paceRepositoryProvider);
    try {
      await repository.submitPace(state.totalSeconds);
    } catch (e) {
      debugPrint('Debounced pace submit failed: $e');
    }
  }

  Future<void> submit() async {
    _debounceTimer?.cancel();
    state = state.copyWith(submitStatus: const AsyncValue.loading());

    try {
      final repository = ref.read(paceRepositoryProvider);
      await repository.submitPace(state.totalSeconds);
      state = state.copyWith(submitStatus: const AsyncValue.data(null));
    } catch (e, stackTrace) {
      state = state.copyWith(
        submitStatus: AsyncValue.error(e, stackTrace),
      );
    }
  }
}
