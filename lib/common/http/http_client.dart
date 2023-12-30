import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gonggam/common/constants.dart';
import 'package:gonggam/common/http/interceptor/auth_interceptor.dart';

import 'interceptor/logger_interceptor.dart';

class GongGamHttpClient {
  late Dio _dio;

  final storage = const FlutterSecureStorage();

  GongGamHttpClient() {
    _dio = Dio(
        BaseOptions(
          baseUrl: SERVER_URL,
          connectTimeout: const Duration(milliseconds: 9000),
        )
    )..interceptors.addAll([
      CustomLogInterceptor(),
      AuthInterceptor()
    ]);
  }

  Future<Response> getRequest(String url, Map<String, dynamic>? data) async {
    Response response = await _dio.get(url, queryParameters: data);
    return response;
  }

  Future<Response> postRequest(String url, Object? data) async {
    Response response = await _dio.post(url, data: data);
    return response;
  }

  Future<Response> putRequest(String url, Object? data) async {
    Response response = await _dio.put(url, data: data);
    return response;
  }

  Future<Response> deleteRequest(String url, Object? data) async {
    Response response = await _dio.delete(url, data: data);
    return response;
  }
}