import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/user_card_model.dart';

void main() {
  test('fromJson parses all fields', () {
    final card = UserCardModel.fromJson({
      'id': 'pm_123',
      'brand': 'visa',
      'last4': '4242',
      'exp_month': 3,
      'exp_year': 2027,
      'is_default': true,
    });

    expect(card.id, 'pm_123');
    expect(card.brand, 'visa');
    expect(card.last4, '4242');
    expect(card.expMonth, 3);
    expect(card.expYear, 2027);
    expect(card.isDefault, isTrue);
  });

  test('fromJson handles null fields with defaults', () {
    final card = UserCardModel.fromJson({});

    expect(card.id, '');
    expect(card.brand, '');
    expect(card.last4, '');
    expect(card.expMonth, 1);
    expect(card.expYear, 2030);
    expect(card.isDefault, isFalse);
  });
}
