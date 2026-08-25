import '../../domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  const SettingsModel({
    required super.currencyCode,
    required super.discountRate,
    required super.taxRate,
    required super.isTaxInclusive,
    required super.otpEnabled,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      currencyCode: (json['currency_code'] ?? 'USD').toString(),
      discountRate:
          double.tryParse(json['discount_rate']?.toString() ?? '') ?? 0.0,
      taxRate: double.tryParse(json['tax_rate']?.toString() ?? '') ?? 0.0,
      isTaxInclusive: json['is_tax_inclusive'] == true,
      otpEnabled: json['otp_enabled'] == true,
    );
  }
}
