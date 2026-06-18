import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'language_selector_dropdown.dart';
import 'theme_toggle_button.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showActions;
  final VoidCallback? onBack;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showActions = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: true,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
                  padding: EdgeInsets.zero,
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                ),
              ),
            )
          : null,
      actions: showActions
          ? const [
              ThemeToggleButton(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: LanguageSelectorDropdown(),
              ),
            ]
          : null,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
