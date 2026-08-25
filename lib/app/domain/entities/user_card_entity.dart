import 'package:equatable/equatable.dart';

class UserCardEntity extends Equatable {
  final String id;
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;
  final bool isDefault;

  const UserCardEntity({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    this.isDefault = false,
  });

  UserCardEntity copyWith({bool? isDefault}) {
    return UserCardEntity(
      id: id,
      brand: brand,
      last4: last4,
      expMonth: expMonth,
      expYear: expYear,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get expiry =>
      '${expMonth.toString().padLeft(2, '0')}/${expYear.toString().substring(2)}';

  String get maskedNumber => '****  ****  ****  $last4';

  @override
  List<Object?> get props => [id, brand, last4, expMonth, expYear, isDefault];
}
