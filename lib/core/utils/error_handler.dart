import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';
import '../../generated/locale_keys.g.dart';

class ConfigurationException implements Exception {
  const ConfigurationException(this.message);
  final String message;

  @override
  String toString() => 'ConfigurationException: $message';
}

abstract final class ErrorHandler {
  static String getLocalizedMessage(Object error) {
    if (_isConnectivityError(error)) {
      return LocaleKeys.errors_no_internet.tr();
    }
    if (error is DioException) {
      return LocaleKeys.errors_network_error.tr();
    }
    if (error is ConfigurationException) {
      assert(false, error.message);
      return LocaleKeys.errors_unknown.tr();
    }
    return LocaleKeys.errors_unknown.tr();
  }

  static bool _isConnectivityError(Object error) {
    if (error is SocketException) return true;
    if (error is DioException) {
      const timeoutTypes = {
        DioExceptionType.connectionError,
        DioExceptionType.connectionTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.sendTimeout,
      };
      return timeoutTypes.contains(error.type) || error.error is SocketException;
    }
    return false;
  }
}
