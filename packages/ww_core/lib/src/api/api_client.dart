import 'package:dio/dio.dart';

import '../auth/session_manager.dart';
import '../config/app_config.dart';
import '../util/server_clock.dart';
import 'api_exception.dart';

/// Base options shared by every Dio we create.
BaseOptions _options(AppConfig config) => BaseOptions(
  // The generated client (packages/ww_api) puts `/v1/...` in every path.
  baseUrl: config.apiBaseUrl,
  connectTimeout: const Duration(seconds: 10),
  sendTimeout: const Duration(seconds: 20),
  receiveTimeout: const Duration(seconds: 20),
  headers: {'Accept': 'application/json'},
  contentType: Headers.jsonContentType,
);

/// A plain Dio without auth, for the token refresh call itself.
Dio createRefreshClient(AppConfig config) => Dio(_options(config));

/// Builds the Dio instance every API call goes through (pass it to the generated APIs:
/// `PatientApi(dio)`).
///
/// - adds `Authorization: Bearer <access token>` when logged in
/// - on 401 refreshes the access token once and retries the request (ARCHITECTURE §6.4)
/// - turns every failure into an [ApiException]
Dio createApiClient(AppConfig config, {required SessionManager session, Dio? dio}) {
  final client = dio ?? Dio();
  client.options = _options(config);
  client.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!_isPublic(options.path)) {
          final token = await session.accessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        ServerClock.sync(response.headers.value('date'));
        handler.next(response);
      },
      onError: (error, handler) async {
        final request = error.requestOptions;
        final retried = request.extra['ww.retried'] == true;
        if (error.response?.statusCode == 401 && !retried && !_isPublic(request.path)) {
          if (await session.refresh()) {
            final token = await session.accessToken();
            request.headers['Authorization'] = 'Bearer $token';
            request.extra['ww.retried'] = true;
            try {
              return handler.resolve(await client.fetch<dynamic>(request));
            } on DioException catch (retryError) {
              return handler.reject(_wrap(retryError));
            }
          }
        }
        handler.reject(_wrap(error));
      },
    ),
  );
  return client;
}

/// Login endpoints never carry (or refresh) an access token. Logout does.
bool _isPublic(String path) =>
    path.startsWith('/v1/auth/') && !path.startsWith('/v1/auth/logout') ||
    path.startsWith('/v1/public/') ||
    path == '/v1/health';

DioException _wrap(DioException error) => DioException(
  requestOptions: error.requestOptions,
  response: error.response,
  type: error.type,
  error: ApiException.fromDio(error),
);

/// Unwraps the [ApiException] our interceptor attached to a failed call.
ApiException toApiException(Object error) {
  if (error is ApiException) return error;
  if (error is DioException) {
    final inner = error.error;
    return inner is ApiException ? inner : ApiException.fromDio(error);
  }
  return const ApiException(code: ApiException.unknown, message: '');
}
