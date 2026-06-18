import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';
import '../../../generated/locale_keys.g.dart';

class _NavItem {
  const _NavItem({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.labelKey,
    this.exactMatch = false,
  });

  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String labelKey;
  final bool exactMatch;

  bool matches(String path) => exactMatch ? path == route : path.startsWith(route);
}

class NavigationShellScreen extends StatelessWidget {
  const NavigationShellScreen({
    super.key,
    required this.child,
  });

  final Widget child;

  static const _items = [
    _NavItem(
      exactMatch: true,
      route: AppRouter.paceSelector,
      icon: Icons.timer_outlined,
      activeIcon: Icons.timer,
      labelKey: LocaleKeys.pace_selector_tab_title,
    ),
    _NavItem(
      route: AppRouter.userList,
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_rounded,
      labelKey: LocaleKeys.user_list_tab_title,
    ),
  ];

  int _selectedIndex(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final index = _items.indexWhere((item) => item.matches(path));
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: context.colorScheme.onSurface.withValues(alpha: 0.08),
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => context.go(_items[index].route),
          backgroundColor: context.colorScheme.surface,
          selectedItemColor: context.colorScheme.primary,
          unselectedItemColor: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: _items.map((tab) {
            return BottomNavigationBarItem(
              icon: Icon(tab.icon),
              activeIcon: Icon(tab.activeIcon),
              label: tab.labelKey.tr(),
            );
          }).toList(),
        ),
      ),
    );
  }
}
