import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/services/secure_token_storage.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String accessToken);
  Future<void> cacheUser(UserModel user);
  Future<void> clearCachedAuthData();
  Future<UserModel?> getCachedUser();
  Future<bool> hasValidToken();
  Future<String?> getAccessToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final GetStorage storage;
  final SecureTokenStorage secureTokenStorage;

  AuthLocalDataSourceImpl({
    required this.storage,
    required this.secureTokenStorage,
  });

  @override
  Future<void> cacheToken(String accessToken) async {
    try {
      await secureTokenStorage.setTokens(
        accessToken: accessToken,
        refreshToken: '',
      );
    } catch (e) {
      throw CacheException('Failed to cache token');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await storage.write(AppConstants.userKey, json.encode(user.toJson()));
    } catch (e) {
      throw CacheException('Failed to cache user data');
    }
  }

  @override
  Future<void> clearCachedAuthData() async {
    try {
      await secureTokenStorage.clearTokens();
      await storage.remove(AppConstants.userKey);
    } catch (e) {
      throw CacheException('Failed to clear cached auth data');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userDataString = storage.read(AppConstants.userKey);
      if (userDataString != null) {
        final userData = json.decode(userDataString);
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached user data');
    }
  }

  @override
  Future<bool> hasValidToken() async {
    return await secureTokenStorage.hasValidToken();
  }

  @override
  Future<String?> getAccessToken() async {
    return await secureTokenStorage.getAccessToken();
  }
}
