import 'package:equatable/equatable.dart';

import '../../core/enums/user_type.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? ssNo;
  final String? mobileNumber;
  final String? fcmToken;
  final String? profileImageUrl;
  final String? status;
  final UserType userType;
  final int? companyId;
  final DateTime? verifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    this.id,
    this.name,
    this.email,
    this.ssNo,
    this.mobileNumber,
    this.fcmToken,
    this.profileImageUrl,
    this.status,
    this.userType = UserType.unknown,
    this.companyId,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName =>
      (name ?? '').trim().isNotEmpty ? name! : email ?? 'Guest';

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'ss_no': ssNo,
    'mobile_number': mobileNumber,
    'fcm_token': fcmToken,
    'profile_image_url': profileImageUrl,
    'status': status,
    'user_type': userType.apiName,
    'company_id': companyId,
    'verified_at': verifiedAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    ssNo,
    mobileNumber,
    fcmToken,
    profileImageUrl,
    status,
    userType,
    companyId,
    verifiedAt,
    createdAt,
    updatedAt,
  ];
}
