import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ts_parking/app/core/errors/exceptions.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/data/datasources/auth_local_datasource.dart';
import 'package:ts_parking/app/data/datasources/auth_remote_datasource.dart';
import 'package:ts_parking/app/data/models/login_response_model.dart';
import 'package:ts_parking/app/data/models/user_model.dart';
import 'package:ts_parking/app/data/repositories/auth_repository_impl.dart';
import 'package:ts_parking/app/domain/params/driver_params.dart';
import 'package:ts_parking/app/domain/params/otp_params.dart';
import 'package:ts_parking/app/domain/params/register_params.dart';

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  LoginResponseModel? loginResult;
  Exception? loginError;
  String? sendOtpResult;
  Exception? sendOtpError;
  LoginResponseModel? verifyOtpResult;
  Exception? verifyOtpError;
  Exception? logoutError;
  bool logoutCalled = false;
  bool registerCalled = false;
  Exception? registerError;

  @override
  Future<LoginResponseModel> login(LoginParams params) async {
    if (loginError != null) throw loginError!;
    return loginResult!;
  }

  @override
  Future<String> sendOtp(SendOtpParams params) async {
    if (sendOtpError != null) throw sendOtpError!;
    return sendOtpResult!;
  }

  @override
  Future<LoginResponseModel> verifyOtp(VerifyOtpParams params) async {
    if (verifyOtpError != null) throw verifyOtpError!;
    return verifyOtpResult!;
  }

  @override
  Future<void> register(RegisterParams params) async {
    registerCalled = true;
    if (registerError != null) throw registerError!;
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
    if (logoutError != null) throw logoutError!;
  }

  bool deleteAccountCalled = false;
  Exception? deleteAccountError;

  @override
  Future<void> deleteAccount(int userId) async {
    deleteAccountCalled = true;
    if (deleteAccountError != null) throw deleteAccountError!;
  }
}

class FakeAuthLocalDataSource implements AuthLocalDataSource {
  bool cacheTokenCalled = false;
  String? cachedToken;
  bool cacheUserCalled = false;
  UserModel? cachedUser;
  bool clearCalled = false;
  bool hasValidTokenResult = true;
  UserModel? getCachedUserResult;
  Exception? getCachedUserError;
  String? accessTokenResult;

  @override
  Future<void> cacheToken(String accessToken) async {
    cacheTokenCalled = true;
    cachedToken = accessToken;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    cacheUserCalled = true;
    cachedUser = user;
  }

  @override
  Future<void> clearCachedAuthData() async {
    clearCalled = true;
  }

  @override
  Future<UserModel?> getCachedUser() async {
    if (getCachedUserError != null) throw getCachedUserError!;
    return getCachedUserResult;
  }

  @override
  Future<bool> hasValidToken() async => hasValidTokenResult;
  @override
  Future<String?> getAccessToken() async => accessTokenResult;
}

const _testUser = UserModel(
  id: '1',
  name: 'Test Driver',
  email: 'test@example.com',
  ssNo: 'DRV-001',
  mobileNumber: '1234567890',
);

final _verifiedLoginResponse = LoginResponseModel(
  verified: true,
  user: _testUser,
  accessToken: 'test-access-token',
  tokenType: 'Bearer',
  message: 'Login successful',
);

final _unverifiedLoginResponse = LoginResponseModel(
  verified: false,
  message: 'OTP required',
);

const _loginParams = LoginParams(
  password: 'password123',
  mobileNumber: '1234567890',
  fcmToken: 'test-fcm-token',
);
const _sendOtpParams = SendOtpParams(
  password: 'password123',
  mobileNumber: '1234567890',
);
const _verifyOtpParams = VerifyOtpParams(
  password: 'password123',
  mobileNumber: '1234567890',
  otpCode: '123456',
  requestId: 'test-request-id',
);
const _registerParams = RegisterParams(
  password: 'password123',
  mobileNumber: '0501234567',
  firstName: 'John',
  lastName: 'Doe',
  companyName: 'Test Company',
  email: 'john@test.com',
);

void main() {
  late FakeAuthRemoteDataSource fakeRemote;
  late FakeAuthLocalDataSource fakeLocal;
  late AuthRepositoryImpl repository;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return '.';
        });
    await GetStorage.init();
  });

  setUp(() {
    fakeRemote = FakeAuthRemoteDataSource();
    fakeLocal = FakeAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: fakeRemote,
      localDataSource: fakeLocal,
    );
  });

  group('login', () {
    test('returns Right and caches on verified success', () async {
      fakeRemote.loginResult = _verifiedLoginResponse;
      final result = await repository.login(_loginParams);
      expect(result, isA<Right>());
      result.fold((_) => fail('Expected Right'), (r) {
        expect(r.verified, true);
        expect(r.accessToken, 'test-access-token');
      });
      expect(fakeLocal.cacheTokenCalled, true);
      expect(fakeLocal.cachedToken, 'test-access-token');
      expect(fakeLocal.cacheUserCalled, true);
    });
    test('returns Right but does NOT cache when unverified', () async {
      fakeRemote.loginResult = _unverifiedLoginResponse;
      final result = await repository.login(_loginParams);
      expect(result, isA<Right>());
      expect(fakeLocal.cacheTokenCalled, false);
      expect(fakeLocal.cacheUserCalled, false);
    });
    test('returns Left(ServerFailure) on ServerException', () async {
      fakeRemote.loginError = const ServerException('server down');
      final result = await repository.login(_loginParams);
      expect(result, const Left(ServerFailure('server down')));
    });
    test('returns Left(NetworkFailure) on NetworkException', () async {
      fakeRemote.loginError = const NetworkException('no internet');
      final result = await repository.login(_loginParams);
      expect(result, const Left(NetworkFailure('no internet')));
    });
    test('returns Left(AuthFailure) on AuthException', () async {
      fakeRemote.loginError = const AuthException('invalid creds');
      final result = await repository.login(_loginParams);
      expect(result, const Left(AuthFailure('invalid creds')));
    });
    test('returns Left(ValidationFailure) on ValidationException', () async {
      fakeRemote.loginError = const ValidationException('bad input');
      final result = await repository.login(_loginParams);
      expect(result, const Left(ValidationFailure('bad input')));
    });
    test('returns Left(UnexpectedFailure) on unknown exception', () async {
      fakeRemote.loginError = Exception('unknown');
      final result = await repository.login(_loginParams);
      expect(
        result,
        const Left(UnexpectedFailure('An unexpected error occurred')),
      );
    });
  });

  group('sendOtp', () {
    test('returns Right(requestId) on success', () async {
      fakeRemote.sendOtpResult = 'test-request-id';
      final result = await repository.sendOtp(_sendOtpParams);
      expect(result, const Right('test-request-id'));
    });
    test('returns Left(ServerFailure) on ServerException', () async {
      fakeRemote.sendOtpError = const ServerException('otp failed');
      final result = await repository.sendOtp(_sendOtpParams);
      expect(result, const Left(ServerFailure('otp failed')));
    });
    test('returns Left(NetworkFailure) on NetworkException', () async {
      fakeRemote.sendOtpError = const NetworkException('timeout');
      final result = await repository.sendOtp(_sendOtpParams);
      expect(result, const Left(NetworkFailure('timeout')));
    });
    test('returns Left(AuthFailure) on AuthException', () async {
      fakeRemote.sendOtpError = const AuthException('not authorized');
      final result = await repository.sendOtp(_sendOtpParams);
      expect(result, const Left(AuthFailure('not authorized')));
    });
  });

  group('verifyOtp', () {
    test('returns Right and caches on verified response', () async {
      fakeRemote.verifyOtpResult = _verifiedLoginResponse;
      final result = await repository.verifyOtp(_verifyOtpParams);
      expect(result, isA<Right>());
      expect(fakeLocal.cacheTokenCalled, true);
      expect(fakeLocal.cacheUserCalled, true);
    });
    test('returns Left(ServerFailure) on ServerException', () async {
      fakeRemote.verifyOtpError = const ServerException('verify failed');
      final result = await repository.verifyOtp(_verifyOtpParams);
      expect(result, const Left(ServerFailure('verify failed')));
    });
  });

  group('register', () {
    test('returns Right on success', () async {
      final result = await repository.register(_registerParams);
      expect(result, const Right(null));
      expect(fakeRemote.registerCalled, true);
    });
    test('returns Left(ServerFailure) on ServerException', () async {
      fakeRemote.registerError = const ServerException('register failed');
      final result = await repository.register(_registerParams);
      expect(result, const Left(ServerFailure('register failed')));
    });
    test('returns Left(ValidationFailure) on ValidationException', () async {
      fakeRemote.registerError = const ValidationException('invalid data');
      final result = await repository.register(_registerParams);
      expect(result, const Left(ValidationFailure('invalid data')));
    });
    test('returns Left(NetworkFailure) on NetworkException', () async {
      fakeRemote.registerError = const NetworkException('no internet');
      final result = await repository.register(_registerParams);
      expect(result, const Left(NetworkFailure('no internet')));
    });
  });

  group('logout', () {
    test('clears local cache and returns Right on success', () async {
      final result = await repository.logout();
      expect(result, const Right(null));
      expect(fakeRemote.logoutCalled, true);
      expect(fakeLocal.clearCalled, true);
    });
    test('returns Right even when remote logout fails', () async {
      fakeRemote.logoutError = const ServerException('remote fail');
      final result = await repository.logout();
      expect(result, const Right(null));
      expect(fakeLocal.clearCalled, true);
    });
  });

  group('getCachedUser', () {
    test('returns Right(user) when cached user exists', () async {
      fakeLocal.hasValidTokenResult = true;
      fakeLocal.getCachedUserResult = _testUser;
      final result = await repository.getCachedUser();
      expect(result, isA<Right>());
      result.fold((_) => fail('Expected Right'), (u) {
        expect(u, isNotNull);
        expect(u!.id, '1');
      });
    });
    test('returns Right(null) when no valid token', () async {
      fakeLocal.hasValidTokenResult = false;
      final result = await repository.getCachedUser();
      expect(result, isA<Right>());
      result.fold((_) => fail('Expected Right'), (u) => expect(u, isNull));
    });
    test('returns Left(CacheFailure) on CacheException', () async {
      fakeLocal.hasValidTokenResult = true;
      fakeLocal.getCachedUserError = const CacheException('corrupted');
      final result = await repository.getCachedUser();
      expect(result, const Left(CacheFailure('corrupted')));
    });
  });
}
