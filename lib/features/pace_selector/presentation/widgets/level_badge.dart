import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../domain/swimmer_level.dart';

class LevelBadge extends StatelessWidget {
  final SwimmerLevel activeLevel;

  const LevelBadge({
    super.key,
    required this.activeLevel,
  });

  Color _getLevelColor(SwimmerLevel level) {
    return switch (level) {
      SwimmerLevel.elite => AppColors.levelElite,
      SwimmerLevel.advanced => AppColors.levelAdvanced,
      SwimmerLevel.intermediate => AppColors.levelIntermediate,
      SwimmerLevel.beginner => AppColors.levelBeginner,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          LocaleKeys.pace_selector_level_prefix.tr(),
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 11,
            letterSpacing: 1.5,
            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: Text(
            activeLevel.translationKey.tr(),
            key: ValueKey<SwimmerLevel>(activeLevel),
            style: context.textTheme.headlineMedium?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: _getLevelColor(activeLevel),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: SwimmerLevel.values.map((level) {
              final isActive = level == activeLevel;
              final color = _getLevelColor(level);
              return Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isActive ? 1.0 : 0.3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        level.translationKey.tr(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 10,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive ? color : context.colorScheme.onSurface,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: isActive ? 24 : 8,
                        height: 3,
                        decoration: BoxDecoration(
                          color: isActive ? color : context.colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
