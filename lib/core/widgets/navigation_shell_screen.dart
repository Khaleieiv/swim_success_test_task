import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';
import '../../../generated/locale_keys.g.dart';

class NavigationShellScreen extends StatelessWidget {
  final Widget child;

  const NavigationShellScreen({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRouter.userList)) return 1;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRouter.paceSelector);
        break;
      case 1:
        context.go(AppRouter.userList);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: context.colorScheme.onSurface.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
          backgroundColor: context.colorScheme.surface,
          selectedItemColor: context.colorScheme.primary,
          unselectedItemColor: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.timer_outlined),
              activeIcon: const Icon(Icons.timer),
              label: 'Pace',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_outline_rounded),
              activeIcon: const Icon(Icons.people_rounded),
              label: 'Users',
            ),
          ],
        ),
      ),
    );
  }
}
