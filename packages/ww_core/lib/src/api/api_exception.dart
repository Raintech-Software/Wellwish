import 'package:dio/dio.dart';

/// Every API failure, mapped from the backend error format (ARCHITECTURE §10.3):
/// `{"error": {"code": "SLOT_TAKEN", "message": "...", "details": {}}}`.
///
/// Screens decide what to show from [code]. For [networkError] / [timeout] show the
/// translated "no internet" text from ww_l10n; otherwise the server [message] is user-ready.
class ApiException implements Exception {
  const ApiException({required this.code, required this.message, this.statusCode, this.details = const {}});

  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(code: timeout, message: '');
      case DioExceptionType.connectionError:
        return const ApiException(code: networkError, message: '');
      case DioExceptionType.cancel:
        return const ApiException(code: cancelled, message: '');
      default:
        break;
    }
    final response = e.response;
    final data = response?.data;
    if (data is Map && data['error'] is Map) {
      final err = data['error'] as Map;
      return ApiException(
        code: (err['code'] ?? unknown).toString(),
        message: (err['message'] ?? '').toString(),
        statusCode: response?.statusCode,
        details: err['details'] is Map ? Map<String, dynamic>.from(err['details'] as Map) : const {},
      );
    }
    return ApiException(code: unknown, message: '', statusCode: response?.statusCode);
  }

  static const networkError = 'NETWORK_ERROR';
  static const timeout = 'TIMEOUT';
  static const cancelled = 'CANCELLED';
  static const unknown = 'UNKNOWN';

  final String code;
  final String message;
  final int? statusCode;
  final Map<String, dynamic> details;

  bool get isConnectivity => code == networkError || code == timeout;
  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => 'ApiException($code, $statusCode)';
}
