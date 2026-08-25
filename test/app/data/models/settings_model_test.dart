import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/settings_model.dart';

void main() {
  test('fromJson parses all fields', () {
    final settings = SettingsModel.fromJson({
      'currency_code': 'USD',
      'discount_rate': '10.5',
      'tax_rate': '5.0',
      'is_tax_inclusive': true,
      'otp_enabled': false,
    });

    expect(settings.currencyCode, 'USD');
    expect(settings.discountRate, 10.5);
    expect(settings.taxRate, 5.0);
    expect(settings.isTaxInclusive, isTrue);
    expect(settings.otpEnabled, isFalse);
  });

  test('fromJson handles null fields', () {
    final settings = SettingsModel.fromJson({});

    expect(settings.currencyCode, 'USD');
    expect(settings.discountRate, 0.0);
    expect(settings.taxRate, 0.0);
    expect(settings.isTaxInclusive, isFalse);
    expect(settings.otpEnabled, isFalse);
  });
}
