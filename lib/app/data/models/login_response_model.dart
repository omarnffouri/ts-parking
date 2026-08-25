import '../../domain/entities/login_response.dart';
import 'user_model.dart';

class LoginResponseModel extends LoginResponse {
  const LoginResponseModel({
    required super.verified,
    super.user,
    super.accessToken,
    super.tokenType,
    super.message,
  });

  factory LoginResponseModel.fromJson(
    Map<String, dynamic> json, {
    String? message,
  }) {
    final verified = json['verified'] as bool? ?? false;

    if (!verified) {
      return LoginResponseModel(verified: false, message: message);
    }

    return LoginResponseModel(
      verified: true,
      user: UserModel.fromDriverJson(json['user']),
      accessToken: json['access_token'],
      tokenType: json['token_type'] ?? 'Bearer',
      message: message,
    );
  }
}
