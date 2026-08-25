import 'package:dio/dio.dart';
import 'package:ts_parking/app/core/network/dio_client.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/params/driver_params.dart';
import '../../domain/params/otp_params.dart';
import '../../domain/params/register_params.dart';
import '../models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginParams params);
  Future<String> sendOtp(SendOtpParams params);
  Future<LoginResponseModel> verifyOtp(VerifyOtpParams params);

  Future<void> register(RegisterParams params);
  Future<void> logout();
  Future<void> deleteAccount(int userId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  Never _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data['message'];
    if (statusCode == 401) {
      throw AuthException(message ?? 'Authentication failed');
    } else if (statusCode == 400) {
      throw ValidationException(message ?? 'Validation failed');
    }
    throw NetworkException(message ?? 'Network error occurred');
  }

  @override
  Future<LoginResponseModel> login(LoginParams params) async {
    try {
      final response = await dioClient.dio.post(
        AppConstants.driverLogin,
        data: {
          'password': params.password,
          'mobile_number': params.mobileNumber,
          'fcm_token': params.fcmToken,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return LoginResponseModel.fromJson(
        data,
        message: response.data['message'],
      );
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException('Failed to login');
    }
  }

  @override
  Future<String> sendOtp(SendOtpParams params) async {
    try {
      final response = await dioClient.dio.post(
        AppConstants.sendOtp,
        data: {
          'password': params.password,
          'mobile_number': params.mobileNumber,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>?;
      final requestId = data?['request_id'];
      if (requestId is! String || requestId.isEmpty) {
        throw ServerException('Invalid request_id from server');
      }
      return requestId;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException('Failed to send OTP');
    }
  }

  @override
  Future<LoginResponseModel> verifyOtp(VerifyOtpParams params) async {
    try {
      final response = await dioClient.dio.post(
        AppConstants.verifyOtp,
        data: {
          'password': params.password,
          'mobile_number': params.mobileNumber,
          'code': params.otpCode,
          'request_id': params.requestId,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      return LoginResponseModel.fromJson(
        data,
        message: response.data['message'],
      );
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException('Failed to verify OTP');
    }
  }

  @override
  Future<void> register(RegisterParams params) async {
    try {
      final formData = FormData.fromMap({
        'first_name': params.firstName,
        'last_name': params.lastName,
        'password': params.password,
        'mobile_number': params.mobileNumber,
        'company': params.companyName,
        'email': params.email,
        if (params.ssn != null) 'ss_no': params.ssn,
        if (params.companyLicensePath != null) ...{
          'documents[0]': await MultipartFile.fromFile(
            params.companyLicensePath!,
          ),
          'document_types[0]': 'company_license',
        },
      });

      await dioClient.dio.post(AppConstants.driverRegister, data: formData);
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException('Failed to register');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dioClient.dio.post(AppConstants.driverLogout);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> deleteAccount(int userId) async {
    try {
      await dioClient.dio.delete('${AppConstants.driverDelete}/$userId');
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }
}
