import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import 'models/user.dart';

abstract interface class UserRepository {
  Future<List<User>> fetchUsers();
}

final class UserRepositoryImpl implements UserRepository {
  final Dio _dio;

  const UserRepositoryImpl(this._dio);

  @override
  Future<List<User>> fetchUsers() async {
    final response = await _dio.get('/users');
    final data = response.data;
    if (data is List) {
      return data.map((json) => User.fromJson(json as Map<String, dynamic>)).toList();
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      message: 'Invalid data format from users API',
    );
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRepositoryImpl(dio);
});
