import 'package:equatable/equatable.dart';

class SendOtpParams extends Equatable {
  final String password;
  final String mobileNumber;

  const SendOtpParams({required this.password, required this.mobileNumber});

  @override
  List<Object?> get props => [password, mobileNumber];
}

class VerifyOtpParams extends Equatable {
  final String password;
  final String mobileNumber;
  final String otpCode;
  final String requestId;
  final bool isRegistration;
  final String? firstName;
  final String? lastName;

  const VerifyOtpParams({
    required this.password,
    required this.mobileNumber,
    required this.otpCode,
    required this.requestId,
    this.isRegistration = false,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object?> get props => [
    password,
    mobileNumber,
    otpCode,
    requestId,
    isRegistration,
    firstName,
    lastName,
  ];
}

/// Navigation arguments passed to OTP verification page
class OtpVerificationArgs {
  final String password;
  final String mobileNumber;
  final String requestId;
  final bool isRegistration;
  final String? firstName;
  final String? lastName;

  const OtpVerificationArgs({
    required this.password,
    required this.mobileNumber,
    required this.requestId,
    this.isRegistration = false,
    this.firstName,
    this.lastName,
  });
}
