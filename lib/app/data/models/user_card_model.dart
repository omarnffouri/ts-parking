import '../../domain/entities/user_card_entity.dart';

class UserCardModel extends UserCardEntity {
  const UserCardModel({
    required super.id,
    required super.brand,
    required super.last4,
    required super.expMonth,
    required super.expYear,
    super.isDefault,
  });

  factory UserCardModel.fromJson(Map<String, dynamic> json) {
    return UserCardModel(
      id: json['id']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      last4: json['last4']?.toString() ?? '',
      expMonth: json['exp_month'] as int? ?? 1,
      expYear: json['exp_year'] as int? ?? 2030,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }
}
