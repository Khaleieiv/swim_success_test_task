import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/user.dart';
import '../../data/user_repository.dart';

part 'user_list_notifier.g.dart';

@riverpod
class UserListNotifier extends _$UserListNotifier {
  @override
  Future<List<User>> build() {
    return ref.read(userRepositoryProvider).fetchUsers();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final users = await ref.read(userRepositoryProvider).fetchUsers();
      state = AsyncValue.data(users);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredUsersProvider = Provider<AsyncValue<List<User>>>((ref) {
  final usersAsync = ref.watch(userListNotifierProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return usersAsync.whenData((users) {
    if (query.isEmpty) return users;
    return users.where((u) => u.name.toLowerCase().contains(query)).toList();
  });
});
