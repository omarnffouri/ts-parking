import 'package:equatable/equatable.dart';
import 'user_entity.dart';

class LoginResponse extends Equatable {
  final bool verified;
  final UserEntity? user;
  final String? accessToken;
  final String? tokenType;
  final String? message;

  const LoginResponse({
    required this.verified,
    this.user,
    this.accessToken,
    this.tokenType,
    this.message,
  });

  @override
  List<Object?> get props => [verified, user, accessToken, tokenType, message];
}
