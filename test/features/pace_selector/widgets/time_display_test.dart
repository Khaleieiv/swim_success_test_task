import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swim_success/features/pace_selector/presentation/widgets/time_display.dart';

class TestAssetLoader extends AssetLoader {
  const TestAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      "pace_selector": {
        "min": "MIN",
        "sec": "SEC",
        "tap_to_edit": "TAP TO EDIT"
      }
    };
  }
}

Widget createTimeDisplayUnderTest({
  required int minutes,
  required int seconds,
  required ValueChanged<int> onMinutesChanged,
  required ValueChanged<int> onSecondsChanged,
}) {
  return EasyLocalization(
    supportedLocales: const [Locale('en')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    assetLoader: const TestAssetLoader(),
    child: Builder(
      builder: (context) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: Scaffold(
            body: TimeDisplay(
              minutes: minutes,
              seconds: seconds,
              onMinutesChanged: onMinutesChanged,
              onSecondsChanged: onSecondsChanged,
            ),
          ),
        );
      },
    ),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('TimeDisplay renders minutes and seconds correctly', (WidgetTester tester) async {
    int minutesChanged = 0;
    int secondsChanged = 0;

    await tester.pumpWidget(
      createTimeDisplayUnderTest(
        minutes: 2,
        seconds: 45,
        onMinutesChanged: (val) => minutesChanged = val,
        onSecondsChanged: (val) => secondsChanged = val,
      ),
    );
    await tester.pump();

    // Verify 02 and 45 are displayed
    expect(find.text('02'), findsOneWidget);
    expect(find.text('45'), findsOneWidget);

    // Tap on up arrow for minutes
    final upArrows = find.byIcon(Icons.keyboard_arrow_up_rounded);
    expect(upArrows, findsNWidgets(2));

    await tester.tap(upArrows.first); // minutes up arrow
    await tester.pumpAndSettle();
    expect(minutesChanged, 3);

    await tester.tap(upArrows.last); // seconds up arrow
    await tester.pumpAndSettle();
    expect(secondsChanged, 46);
  });
}
