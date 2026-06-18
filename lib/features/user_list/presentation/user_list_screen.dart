import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import 'notifiers/user_list_notifier.dart';
import 'widgets/user_card.dart';
import 'widgets/search_bar_widget.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../generated/locale_keys.g.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchQueryProvider.notifier).state = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = ref.watch(filteredUsersProvider);

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Users',
        showBackButton: false,
        showActions: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              SearchBarWidget(
                onChanged: (val) {
                  ref.read(searchQueryProvider.notifier).state = val;
                },
                onClear: () {
                  ref.read(searchQueryProvider.notifier).state = '';
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref.read(userListNotifierProvider.notifier).refresh(),
                  child: filteredUsers.when(
                    data: (users) {
                      if (users.isEmpty) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.people_outline_rounded,
                                    size: 48,
                                    color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No users found',
                                    style: context.textTheme.bodyMedium?.copyWith(
                                      color: context.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return UserCard(
                            user: user,
                            onTap: () {
                              context.push('${AppRouter.userList}/${user.id}');
                            },
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, _) => ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 48,
                                color: context.colorScheme.error,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                error.toString(),
                                textAlign: TextAlign.center,
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.colorScheme.error,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  ref.read(userListNotifierProvider.notifier).refresh();
                                },
                                icon: const Icon(Icons.refresh_rounded),
                                label: Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
