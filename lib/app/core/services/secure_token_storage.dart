import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

/// Secure Token Storage Service
/// Provides encrypted storage for authentication tokens using platform-native
/// secure storage (Android Keystore / iOS Keychain).
///
/// This service wraps FlutterSecureStorage and provides async methods for
/// token CRUD operations with proper error handling.
class SecureTokenStorage {
  final FlutterSecureStorage _secureStorage;

  /// Key used to track whether token migration from GetStorage has completed
  static const String _migrationCompletedKey = 'token_migration_completed';

  /// Android options for secure storage configuration
  static const AndroidOptions _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  /// iOS options for secure storage configuration
  static const IOSOptions _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  );

  /// Default storage options for all platforms
  static const _storageOptions = FlutterSecureStorage(
    aOptions: _androidOptions,
    iOptions: _iosOptions,
  );

  SecureTokenStorage({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? _storageOptions;

  /// Get the access token from secure storage
  /// Returns null if no token is stored
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: AppConstants.tokenKey);
    } catch (e) {
      throw CacheException('Failed to read access token: $e');
    }
  }

  /// Store the access token in secure storage
  Future<void> setAccessToken(String token) async {
    try {
      await _secureStorage.write(key: AppConstants.tokenKey, value: token);
    } catch (e) {
      throw CacheException('Failed to write access token: $e');
    }
  }

  /// Get the refresh token from secure storage
  /// Returns null if no token is stored
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to read refresh token: $e');
    }
  }

  /// Store the refresh token in secure storage
  Future<void> setRefreshToken(String token) async {
    try {
      await _secureStorage.write(
        key: AppConstants.refreshTokenKey,
        value: token,
      );
    } catch (e) {
      throw CacheException('Failed to write refresh token: $e');
    }
  }

  /// Clear all authentication tokens from secure storage
  Future<void> clearTokens() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: AppConstants.tokenKey),
        _secureStorage.delete(key: AppConstants.refreshTokenKey),
      ]);
    } catch (e) {
      throw CacheException('Failed to clear tokens: $e');
    }
  }

  /// Check if a valid access token exists in secure storage
  /// Returns true if a non-empty access token is stored
  Future<bool> hasValidToken() async {
    try {
      final token = await _secureStorage.read(key: AppConstants.tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      // If we can't read, assume no valid token
      return false;
    }
  }

  /// Store both access and refresh tokens atomically
  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await Future.wait([
        _secureStorage.write(key: AppConstants.tokenKey, value: accessToken),
        _secureStorage.write(
          key: AppConstants.refreshTokenKey,
          value: refreshToken,
        ),
      ]);
    } catch (e) {
      throw CacheException('Failed to write tokens: $e');
    }
  }

  /// Check if any tokens exist in secure storage
  /// Useful for migration checks
  Future<bool> hasStoredTokens() async {
    try {
      final accessToken = await _secureStorage.read(key: AppConstants.tokenKey);
      return accessToken != null;
    } catch (e) {
      return false;
    }
  }

  /// Migrate tokens from GetStorage to SecureStorage
  ///
  /// This method performs a one-time migration of authentication tokens from
  /// plain-text GetStorage to encrypted SecureStorage. It is idempotent and
  /// safe to call multiple times.
  ///
  /// Migration logic:
  /// 1. Check if migration has already been completed (via flag)
  /// 2. If not completed, check if tokens exist in GetStorage
  /// 3. If tokens exist in GetStorage but not in SecureStorage, migrate them
  /// 4. Optionally clear tokens from GetStorage after successful migration
  /// 5. Set migration completed flag
  ///
  /// [getStorage] - The GetStorage instance to read legacy tokens from
  /// [clearOldTokens] - If true, clears tokens from GetStorage after migration
  ///                    Default is true to remove plaintext token copies
  ///
  /// Returns [MigrationResult] indicating the outcome of the migration
  Future<MigrationResult> migrateFromGetStorage({
    required GetStorage getStorage,
    bool clearOldTokens = true,
  }) async {
    try {
      // Check if migration has already been completed
      final migrationCompleted = await _secureStorage.read(
        key: _migrationCompletedKey,
      );

      if (migrationCompleted == 'true') {
        return MigrationResult.alreadyCompleted;
      }

      // Read tokens from GetStorage (legacy storage)
      final legacyAccessToken = getStorage.read<String>(AppConstants.tokenKey);
      final legacyRefreshToken = getStorage.read<String>(
        AppConstants.refreshTokenKey,
      );

      // Check if there are tokens to migrate
      final hasLegacyTokens =
          (legacyAccessToken != null && legacyAccessToken.isNotEmpty) ||
          (legacyRefreshToken != null && legacyRefreshToken.isNotEmpty);

      if (!hasLegacyTokens) {
        // No tokens to migrate, mark migration as complete
        await _secureStorage.write(key: _migrationCompletedKey, value: 'true');
        return MigrationResult.noTokensToMigrate;
      }

      // Check if SecureStorage already has tokens
      final secureAccessToken = await _secureStorage.read(
        key: AppConstants.tokenKey,
      );

      if (secureAccessToken != null && secureAccessToken.isNotEmpty) {
        // SecureStorage already has tokens, skip migration but mark complete
        await _secureStorage.write(key: _migrationCompletedKey, value: 'true');

        // Optionally clear old GetStorage tokens since we have secure ones
        if (clearOldTokens) {
          _clearLegacyTokens(getStorage);
        }

        return MigrationResult.alreadyHasSecureTokens;
      }

      // Migrate tokens from GetStorage to SecureStorage
      if (legacyAccessToken != null && legacyAccessToken.isNotEmpty) {
        await _secureStorage.write(
          key: AppConstants.tokenKey,
          value: legacyAccessToken,
        );
      }

      if (legacyRefreshToken != null && legacyRefreshToken.isNotEmpty) {
        await _secureStorage.write(
          key: AppConstants.refreshTokenKey,
          value: legacyRefreshToken,
        );
      }

      // Mark migration as complete
      await _secureStorage.write(key: _migrationCompletedKey, value: 'true');

      // Optionally clear old GetStorage tokens
      if (clearOldTokens) {
        _clearLegacyTokens(getStorage);
      }

      return MigrationResult.migrated;
    } catch (e) {
      // Migration failed - don't mark as complete so it can be retried
      throw CacheException('Failed to migrate tokens: $e');
    }
  }

  /// Clear legacy tokens from GetStorage
  void _clearLegacyTokens(GetStorage getStorage) {
    getStorage.remove(AppConstants.tokenKey);
    getStorage.remove(AppConstants.refreshTokenKey);
  }

  /// Check if token migration has been completed
  Future<bool> isMigrationCompleted() async {
    try {
      final migrationCompleted = await _secureStorage.read(
        key: _migrationCompletedKey,
      );
      return migrationCompleted == 'true';
    } catch (e) {
      return false;
    }
  }
}

/// Result of the token migration operation
enum MigrationResult {
  /// Migration completed successfully - tokens were moved to secure storage
  migrated,

  /// Migration was already completed in a previous run
  alreadyCompleted,

  /// No tokens found in GetStorage to migrate
  noTokensToMigrate,

  /// SecureStorage already contains tokens (possibly from a fresh login)
  alreadyHasSecureTokens,
}
