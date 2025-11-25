import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:solveit/utils/utils/strings.dart';

/// Custom exception class for handling API errors.
class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  /// Extracts and returns the appropriate exception from a Dio error.
  static ApiException getException(dynamic err) {
    if (err is! DioException) return OtherExceptions(kDefaultError);

    debugPrint('DioError: ${err.message}');
    debugPrint('DioError Response: ${err.response?.data}, ${err.type}');

    switch (err.type) {
      /// Request was cancelled
      case DioExceptionType.cancel:
        return OtherExceptions(kRequestCancelledError);

      /// Timeout errors (connect, send, receive)
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return InternetConnectException(kTimeOutError);

      /// Network-related issues (e.g., no internet, server down)
      case DioExceptionType.unknown:
        if (err.error is SocketException) {
          return InternetConnectException("No internet connection. Try again.");
        }
        if (err.error is FormatException) {
          return FormatException();
        }
        return OtherExceptions(kDefaultError);

      /// Server response errors (HTTP status codes)
      case DioExceptionType.badResponse:
        return _handleResponseError(err);

      /// Default case (fallback error)
      default:
        return OtherExceptions(kDefaultError);
    }
  }

  /// Extracts custom error messages from API responses.
  static ApiException _handleResponseError(DioException err) {
    try {
      final responseData = err.response?.data;

      if (responseData is Map<String, dynamic> && (responseData.containsKey('message') || responseData.containsKey('statusMessage'))) {
        final message = responseData['message'] ?? responseData['statusMessage'];

        if (message is Map && message.containsKey('message')) {
          return OtherExceptions(message['message']);
        }
        return OtherExceptions(message.toString());
      }

      /// Handle status codes when there's no payload.
      switch (err.response?.statusCode) {
        case 500:
          return InternalServerException();
        case 404:
        case 502:
          return OtherExceptions(responseData['code'] ?? kNotFoundError);
        case 400:
          return OtherExceptions(kBadRequestError);
        case 403:
        case 401:
          return UnAuthorizedException();
        default:
          return OtherExceptions(kDefaultError);
      }
    } catch (e) {
      log("Error parsing API response: $e");
      return OtherExceptions(kDefaultError);
    }
  }
}

/// Custom exception classes
class OtherExceptions implements ApiException {
  OtherExceptions(this.newMessage);
  final String newMessage;

  @override
  String get message => newMessage;

  @override
  String toString() => message;
}

class FormatException implements ApiException {
  @override
  String get message => kFormatError;

  @override
  String toString() => message;
}

class InternetConnectException implements ApiException {
  InternetConnectException(this.newMessage);
  final String newMessage;

  @override
  String get message => newMessage;

  @override
  String toString() => message;
}

class InternalServerException implements ApiException {
  @override
  String get message => kServerError;

  @override
  String toString() => message;
}

class UnAuthorizedException implements ApiException {
  @override
  String get message => kUnAuthorizedError;

  @override
  String toString() => message;
}

class CacheException implements Exception {
  CacheException(this.message);
  final String message;

  @override
  String toString() => message;
}
