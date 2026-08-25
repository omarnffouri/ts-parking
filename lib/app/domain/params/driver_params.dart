import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  final String password;
  final String mobileNumber;
  final String fcmToken;

  const LoginParams({
    required this.password,
    required this.mobileNumber,
    required this.fcmToken,
  });

  @override
  List<Object?> get props => [password, mobileNumber, fcmToken];
}
