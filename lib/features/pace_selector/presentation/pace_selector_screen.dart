import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/top_notification.dart';
import '../../../generated/locale_keys.g.dart';
import 'notifiers/pace_notifier.dart';
import 'widgets/level_badge.dart';
import 'widgets/pace_slider.dart';
import 'widgets/time_display.dart';

class PaceSelectorScreen extends ConsumerWidget {
  const PaceSelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paceState = ref.watch(paceNotifierProvider);
    final paceNotifier = ref.read(paceNotifierProvider.notifier);
    // Listen to submission status for showing toast
    ref.listen<AsyncValue<void>>(
      paceNotifierProvider.select((s) => s.submitStatus),
      (previous, next) {
        next.whenOrNull(
          data: (_) {
            showTopNotification(
              context,
              'Pace submitted successfully!',
            );
          },
          error: (err, _) {
            showTopNotification(
              context,
              '${'Network error occurred!'}: $err',
              isError: true,
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Pace',
        showBackButton: false,
        showActions: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'What\'s your fastest 100m freestyle?',
                          style: context.textTheme.headlineMedium?.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This helps us build a more accurate plan for you.',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 32),
                        TimeDisplay(
                          minutes: paceState.minutes,
                          seconds: paceState.seconds,
                          onMinutesChanged: paceNotifier.updateMinutes,
                          onSecondsChanged: paceNotifier.updateSeconds,
                        ),
                        const SizedBox(height: 24),
                        LevelBadge(activeLevel: paceState.swimmerLevel),
                        const SizedBox(height: 24),
                        PaceSlider(
                          totalSeconds: paceState.totalSeconds,
                          onChanged: paceNotifier.updateFromSlider,
                        ),
                        const Spacer(),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: paceState.submitStatus.isLoading ? null : paceNotifier.submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colorScheme.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(56),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(28)),
                            ),
                            elevation: 0,
                          ),
                          child: paceState.submitStatus.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Continue',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      ),
    );
  }
}
