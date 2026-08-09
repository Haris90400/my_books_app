import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Build dio client.
Dio buildDioClient() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false));
  }

  return dio;
}
