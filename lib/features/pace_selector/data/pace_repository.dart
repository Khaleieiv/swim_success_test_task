import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';

abstract interface class PaceRepository {
  Future<void> submitPace(int totalSeconds);
}

final class PaceRepositoryImpl implements PaceRepository {
  final Dio _dio;

  const PaceRepositoryImpl(this._dio);

  @override
  Future<void> submitPace(int totalSeconds) async {
    await _dio.post('/posts', data: {
      'pace_seconds': totalSeconds,
    });
  }
}

final paceRepositoryProvider = Provider<PaceRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return PaceRepositoryImpl(dio);
});
