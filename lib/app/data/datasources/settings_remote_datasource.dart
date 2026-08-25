import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../models/settings_model.dart';

abstract class ISettingsRemoteDataSource {
  Future<SettingsModel> getSettings();
  Future<void> uploadProfileImage(String imagePath);
}

class SettingsRemoteDataSourceImpl implements ISettingsRemoteDataSource {
  final DioClient dioClient;

  SettingsRemoteDataSourceImpl({required this.dioClient});

  Never _handleDioError(DioException e) {
    final message = e.response?.data?['message'];
    final statusCode = e.response?.statusCode;

    if (statusCode == 400 || statusCode == 422) {
      throw ValidationException(message?.toString() ?? 'Invalid request data');
    }
    if (statusCode == 401) {
      throw AuthException(message?.toString() ?? 'Authentication failed');
    }
    if (statusCode == 404) {
      throw ServerException(message?.toString() ?? 'Resource not found');
    }
    throw NetworkException(message?.toString() ?? 'Network error');
  }

  @override
  Future<SettingsModel> getSettings() async {
    try {
      final response = await dioClient.dio.get(AppConstants.settings);
      final data = response.data['data'] as Map<String, dynamic>;
      return SettingsModel.fromJson(data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> uploadProfileImage(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });

      await dioClient.dio.post(AppConstants.profileImage, data: formData);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }
}
