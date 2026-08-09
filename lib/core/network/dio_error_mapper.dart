import 'package:dio/dio.dart';

/// Represents DioErrorMapper.
class DioErrorMapper {
  const DioErrorMapper._();

  static String map(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return 'The request timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please try again.';
      case DioExceptionType.badResponse:
        return _mapStatusCode(exception.response?.statusCode);
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }

  /// Creates _mapStatusCode instance.
  static String _mapStatusCode(int? statusCode) {
    switch (statusCode) {
      case 429:
        return 'Too many requests right now. Please try again in a moment.';
      case 404:
        return 'The requested item could not be found.';
      case final code? when code >= 500:
        return 'The server is having issues. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
