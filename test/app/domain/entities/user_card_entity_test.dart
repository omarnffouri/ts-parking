import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/domain/entities/user_card_entity.dart';

void main() {
  group('UserCardEntity', () {
    const card = UserCardEntity(
      id: 'card_1',
      brand: 'visa',
      last4: '4242',
      expMonth: 2,
      expYear: 2030,
    );

    test('props equality - same values are equal', () {
      const other = UserCardEntity(
        id: 'card_1',
        brand: 'visa',
        last4: '4242',
        expMonth: 2,
        expYear: 2030,
      );

      expect(card, equals(other));
    });

    test('props inequality - different id is not equal', () {
      const other = UserCardEntity(
        id: 'card_2',
        brand: 'visa',
        last4: '4242',
        expMonth: 2,
        expYear: 2030,
      );

      expect(card, isNot(equals(other)));
    });

    test('copyWith creates new instance with updated isDefault', () {
      final updated = card.copyWith(isDefault: true);

      expect(updated.isDefault, isTrue);
    });

    test('copyWith preserves other fields', () {
      final updated = card.copyWith(isDefault: true);

      expect(updated.id, equals(card.id));
      expect(updated.brand, equals(card.brand));
      expect(updated.last4, equals(card.last4));
      expect(updated.expMonth, equals(card.expMonth));
      expect(updated.expYear, equals(card.expYear));
    });

    test('expiry formatting - single digit month is zero-padded', () {
      expect(card.expiry, equals('02/30'));
    });

    test('expiry formatting - double digit month', () {
      const decCard = UserCardEntity(
        id: 'card_1',
        brand: 'visa',
        last4: '4242',
        expMonth: 12,
        expYear: 2025,
      );

      expect(decCard.expiry, equals('12/25'));
    });

    test('maskedNumber returns masked format with last4', () {
      expect(card.maskedNumber, equals('****  ****  ****  4242'));
    });

    test('isDefault defaults to false', () {
      expect(card.isDefault, isFalse);
    });
  });
}
