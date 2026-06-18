import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/navigation_shell_screen.dart';
import '../../features/pace_selector/presentation/pace_selector_screen.dart';
import '../../features/user_list/presentation/user_list_screen.dart';
import '../../features/user_list/presentation/user_detail_screen.dart';

abstract final class AppRouter {
  static const paceSelector = '/';
  static const userList = '/users';
  static const userDetail = '${AppRouter.userList}/:id';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: paceSelector,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return NavigationShellScreen(child: child);
        },
        routes: [
          GoRoute(
            path: paceSelector,
            builder: (context, state) => const PaceSelectorScreen(),
          ),
          GoRoute(
            path: userList,
            builder: (context, state) => const UserListScreen(),
          ),
        ],
      ),
      GoRoute(
        path: userDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final idStr = state.pathParameters['id'];
          final id = int.tryParse(idStr ?? '') ?? 0;
          return UserDetailScreen(userId: id);
        },
      ),
    ],
  );
}
