import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/error_handler.dart';

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = dotenv.env['API_BASE_URL'];
  if (baseUrl == null || baseUrl.trim().isEmpty) {
    throw const ConfigurationException(
      'API Base URL is not configured. Please add API_BASE_URL to your .env file.',
    );
  }

  return Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
});
