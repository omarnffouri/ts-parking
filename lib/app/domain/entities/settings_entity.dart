import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final String currencyCode;
  final double discountRate;
  final double taxRate;
  final bool isTaxInclusive;
  final bool otpEnabled;

  const SettingsEntity({
    required this.currencyCode,
    required this.discountRate,
    required this.taxRate,
    required this.isTaxInclusive,
    required this.otpEnabled,
  });

  @override
  List<Object?> get props => [
    currencyCode,
    discountRate,
    taxRate,
    isTaxInclusive,
    otpEnabled,
  ];
}
