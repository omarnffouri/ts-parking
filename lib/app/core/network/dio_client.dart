import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/app_constants.dart';
import '../services/secure_token_storage.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  static DioClient get instance => _instance;

  late final Dio _dio;
  final GetStorage _storage = GetStorage();

  /// Secure token storage for encrypted token operations
  /// This is set after dependency injection is complete
  SecureTokenStorage? secureTokenStorage;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  Dio get dio => _dio;

  // ---------------------------------------------------------------------------
  // Interceptors
  // ---------------------------------------------------------------------------

  void _setupInterceptors() {
    // Use QueuedInterceptorsWrapper to properly handle async operations
    // This ensures token reading from SecureTokenStorage is awaited correctly
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(onRequest: _onRequest, onError: _onError),
    );

    // Uncomment to enable Dio request/response logging in debug mode:
    // if (!kReleaseMode) {
    //   _dio.interceptors.add(
    //     LogInterceptor(requestBody: true, responseBody: true),
    //   );
    // }
  }

  // ---------------------------------------------------------------------------
  // Request
  // ---------------------------------------------------------------------------

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_requiresAuth(options)) {
      // Read access token from SecureTokenStorage only
      String? token;
      if (secureTokenStorage != null) {
        try {
          token = await secureTokenStorage!.getAccessToken();
        } catch (_) {
          // Silently fail - no token will be attached
        }
      }

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  bool _requiresAuth(RequestOptions options) {
    const publicEndpoints = [
      '/register',
      '/verify',
      '/create-password',
      '/otp/send',
      '/otp/verify',
      '/drivers/login',
    ];
    return !publicEndpoints.any(options.path.endsWith);
  }

  // ---------------------------------------------------------------------------
  // Error / Refresh Logic
  // ---------------------------------------------------------------------------

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = error.response?.statusCode;

    if (statusCode == 401 && _requiresAuth(error.requestOptions)) {
      await _clearAuthData();
    }

    handler.reject(error);
  }

  // ---------------------------------------------------------------------------
  // Auth Utilities
  // ---------------------------------------------------------------------------

  /// Update access token in secure storage
  Future<void> updateToken(String token) async {
    if (secureTokenStorage == null) {
      throw StateError('SecureTokenStorage not initialized');
    }
    await secureTokenStorage!.setAccessToken(token);
  }

  /// Update both access and refresh tokens in secure storage
  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    if (secureTokenStorage == null) {
      throw StateError('SecureTokenStorage not initialized');
    }
    await secureTokenStorage!.setTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  /// Clear all authentication data
  /// Tokens cleared from SecureTokenStorage, user data from GetStorage
  Future<void> _clearAuthData() async {
    // Clear tokens from SecureTokenStorage
    if (secureTokenStorage != null) {
      try {
        await secureTokenStorage!.clearTokens();
      } catch (_) {
        // Continue with user data cleanup even if token clear fails
      }
    }

    // Clear non-sensitive user data from GetStorage
    _storage.remove(AppConstants.userKey);
  }
}
