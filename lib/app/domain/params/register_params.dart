import 'package:equatable/equatable.dart';

class RegisterParams extends Equatable {
  final String password;
  final String mobileNumber;
  final String firstName;
  final String lastName;
  final String companyName;
  final String email;
  final String? ssn;
  final String? companyLicensePath;

  const RegisterParams({
    required this.password,
    required this.mobileNumber,
    required this.firstName,
    required this.lastName,
    required this.companyName,
    required this.email,
    this.ssn,
    this.companyLicensePath,
  });

  @override
  List<Object?> get props => [
    password,
    mobileNumber,
    firstName,
    lastName,
    companyName,
    email,
    ssn,
    companyLicensePath,
  ];
}
