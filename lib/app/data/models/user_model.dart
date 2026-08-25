import '../../domain/entities/user_entity.dart';
import '../../core/enums/user_type.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.name,
    super.email,
    super.ssNo,
    super.mobileNumber,
    super.fcmToken,
    super.profileImageUrl,
    super.status,
    super.userType,
    super.companyId,
    super.verifiedAt,
    super.createdAt,
    super.updatedAt,
  });

  /// Parse from driver login response: `data.user`
  factory UserModel.fromDriverJson(Map<String, dynamic> json) =>
      _fromMap(json, fallbackStatus: false);

  /// Parse from user profile endpoint
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _fromMap(json, fallbackStatus: true);

  static UserModel _fromMap(
    Map<String, dynamic> json, {
    required bool fallbackStatus,
  }) {
    final userable = json['userable'] is Map<String, dynamic>
        ? _Userable.fromJson(json['userable'] as Map<String, dynamic>)
        : null;

    return UserModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      ssNo: json['ss_no']?.toString(),
      mobileNumber: json['mobile_number']?.toString(),
      fcmToken: json['fcm_token']?.toString(),
      profileImageUrl: json['profile_image_url']?.toString(),
      status:
          userable?.status ??
          (fallbackStatus ? json['status']?.toString() : null),
      userType: UserTypeX.fromApiName(userable?.userType),
      companyId: userable?.companyId,
      verifiedAt: _parseDateTime(json['verified_at']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() => {
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
}

// ---------------------------------------------------------------------------
// Nested JSON objects
// ---------------------------------------------------------------------------

class _Userable {
  final String? status;
  final String? userType;
  final int? companyId;

  const _Userable({this.status, this.userType, this.companyId});

  factory _Userable.fromJson(Map<String, dynamic> json) {
    return _Userable(
      status: json['status']?.toString(),
      userType: json['user_type']?.toString(),
      companyId: json['company_id'] as int?,
    );
  }
}
