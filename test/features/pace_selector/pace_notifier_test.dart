import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swim_success/core/network/dio_client.dart';
import 'package:swim_success/features/pace_selector/domain/swimmer_level.dart';
import 'package:swim_success/features/pace_selector/presentation/notifiers/pace_notifier.dart';

class MockDio extends Mock implements Dio {}
class MockResponse extends Mock implements Response<dynamic> {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('SwimmerLevel Tests', () {
    test('fromSeconds maps ranges correctly', () {
      expect(SwimmerLevel.fromSeconds(60), SwimmerLevel.elite);
      expect(SwimmerLevel.fromSeconds(69), SwimmerLevel.elite);
      expect(SwimmerLevel.fromSeconds(70), SwimmerLevel.advanced);
      expect(SwimmerLevel.fromSeconds(89), SwimmerLevel.advanced);
      expect(SwimmerLevel.fromSeconds(90), SwimmerLevel.intermediate);
      expect(SwimmerLevel.fromSeconds(119), SwimmerLevel.intermediate);
      expect(SwimmerLevel.fromSeconds(120), SwimmerLevel.beginner);
      expect(SwimmerLevel.fromSeconds(240), SwimmerLevel.beginner);
    });
  });

  group('PaceNotifier Tests', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
    });

    ProviderContainer createContainer({List<Override> overrides = const []}) {
      final container = ProviderContainer(overrides: overrides);
      addTearDown(container.dispose);
      return container;
    }

    test('Initial state is 1 minute 30 seconds', () {
      final container = createContainer();
      final state = container.read(paceNotifierProvider);
      expect(state.minutes, 1);
      expect(state.seconds, 30);
      expect(state.totalSeconds, 90);
      expect(state.swimmerLevel, SwimmerLevel.intermediate);
    });

    test('updateMinutes limits correctly', () {
      final container = createContainer();
      final notifier = container.read(paceNotifierProvider.notifier);

      notifier.updateMinutes(3);
      expect(container.read(paceNotifierProvider).minutes, 3);

      notifier.updateMinutes(5); // should clamp to 4:00 (since 4m 30s is > 240s)
      expect(container.read(paceNotifierProvider).minutes, 4);
      expect(container.read(paceNotifierProvider).seconds, 0);

      notifier.updateMinutes(-2); // should clamp to 0:45 (since 0m 30s is < 45s)
      expect(container.read(paceNotifierProvider).minutes, 0);
      expect(container.read(paceNotifierProvider).seconds, 45);
    });

    test('updateSeconds limits correctly', () {
      final container = createContainer();
      final notifier = container.read(paceNotifierProvider.notifier);

      notifier.updateSeconds(45);
      expect(container.read(paceNotifierProvider).seconds, 45);

      notifier.updateSeconds(75); // should clamp to 59
      expect(container.read(paceNotifierProvider).seconds, 59);

      notifier.updateSeconds(-10); // should clamp to 0
      expect(container.read(paceNotifierProvider).seconds, 0);
    });

    test('updateFromSlider updates minutes and seconds correctly', () {
      final container = createContainer();
      final notifier = container.read(paceNotifierProvider.notifier);

      notifier.updateFromSlider(75); // 1:15
      final state = container.read(paceNotifierProvider);
      expect(state.minutes, 1);
      expect(state.seconds, 15);
      expect(state.swimmerLevel, SwimmerLevel.advanced);
    });

    test('submit post call success updates submitStatus to AsyncData', () async {
      final mockResponse = MockResponse();
      when(() => mockResponse.requestOptions).thenReturn(RequestOptions(path: '/posts'));
      when(() => mockResponse.data).thenReturn({'id': 101});

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => mockResponse);

      final container = createContainer(overrides: [
        dioProvider.overrideWithValue(mockDio),
      ]);

      final notifier = container.read(paceNotifierProvider.notifier);

      await notifier.submit();

      final state = container.read(paceNotifierProvider);
      expect(state.submitStatus.isLoading, false);
      expect(state.submitStatus.hasError, false);
      verify(() => mockDio.post('/posts', data: {'pace_seconds': 90})).called(1);
    });

    test('submit post call error updates submitStatus to AsyncError', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/posts'),
        type: DioExceptionType.connectionTimeout,
        message: 'Timeout error',
      );

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
          )).thenThrow(dioException);

      final container = createContainer(overrides: [
        dioProvider.overrideWithValue(mockDio),
      ]);

      final notifier = container.read(paceNotifierProvider.notifier);

      await notifier.submit();

      final state = container.read(paceNotifierProvider);
      expect(state.submitStatus.isLoading, false);
      expect(state.submitStatus.hasError, true);
      expect(state.submitStatus.error, dioException);
    });
  });
}
