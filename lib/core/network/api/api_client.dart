import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:solveit/core/network/api/network_info.dart';
import 'package:solveit/core/network/utils/utils.dart';
import 'package:solveit/features/authentication/domain/user_token.dart';
import 'package:solveit/utils/utils/strings.dart';

class ApiClient {
  ApiClient({
    required this.userTokenRepository,
    required this.networkInfo,
  }) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      contentType: Headers.jsonContentType,
      validateStatus: (status) => status != null && (status == 200 || status == 201),
    );

    _dio = Dio(options);
    _setupInterceptors();
  }

  final UserTokenRepository userTokenRepository;
  final NetworkInfo networkInfo;
  late final Dio _dio; // Ensures _dio is always initialized

  // Base URL is kept for fallback, but endpoints from network_routes.dart already have full URLs
  static String baseUrl = "https://backend.solve-it.com.ng/api/v1/";

  /// **Setup Dio Interceptors (for token handling & logging)**
  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = getToken();
        if (token != null) {
          options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // 🔄 Attempt token refresh
          final refreshed = await _refreshToken();
          if (refreshed) {
            // Retry request after refreshing token
            return handler.resolve(await _retryRequest(e.requestOptions));
          }
        }
        return handler.next(e);
      },
    ));

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  /// **Refresh Auth Token**
  Future<bool> _refreshToken() async {
    final newToken = userTokenRepository.getToken();
    if (newToken.token != null) {
      _dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $newToken';
      return true;
    }
    return false;
  }

  /// **Retry failed request after token refresh**
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// **Handles API calls with network check & error handling**
  Future<Response> _handleApiCall(Future<Response> Function() apiCall) async {
    if (!kIsWeb) {
      if (!await networkInfo.isConnected) {
        throw InternetConnectException("No internet connection. Please try again.");
      }
    }

    try {
      return await apiCall();
    } on DioException catch (e) {
      throw ApiException.getException(e);
    } catch (e) {
      log("Unexpected error: $e");
      throw OtherExceptions("An unexpected error occurred.");
    }
  }

  /// **GET Request**
  Future<Response> get(String uri, {Map<String, dynamic>? queryParameters}) async {
    return _handleApiCall(() => _dio.get(uri, queryParameters: queryParameters));
  }

  /// **POST Request**
  Future<Response> post(
    String uri, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extraHeaders,
  }) async {
    return _handleApiCall(() {
      final options = Options(headers: extraHeaders);
      return _dio.post(uri, data: data ?? formData, queryParameters: queryParameters, options: options);
    });
  }

  /// **PUT Request**
  Future<Response> put(String uri, {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters}) async {
    return _handleApiCall(() => _dio.put(uri, data: data, queryParameters: queryParameters));
  }

  /// **PATCH Request**
  Future<Response> patch(String uri, {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters}) async {
    return _handleApiCall(() => _dio.patch(uri, data: data, queryParameters: queryParameters));
  }

  /// **DELETE Request**
  Future<Response> delete(String uri, {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters}) async {
    return _handleApiCall(() => _dio.delete(uri, data: data, queryParameters: queryParameters));
  }

  /// **Get Auth Token**
  String? getToken() {
    return userTokenRepository.getToken().token;
  }
}

extension ResponseExtension on Response {
  bool get isSuccess => statusCode == HttpStatus.ok || statusCode == HttpStatus.created;
}
