import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/domain/entities/user_entity.dart';
import 'package:ts_parking/app/core/enums/user_type.dart';

void main() {
  group('UserEntity', () {
    group('fullName', () {
      test('returns name when present and non-empty', () {
        const user = UserEntity(name: 'John Doe', email: 'john@example.com');

        expect(user.fullName, equals('John Doe'));
      });

      test('returns email when name is null', () {
        const user = UserEntity(email: 'john@example.com');

        expect(user.fullName, equals('john@example.com'));
      });

      test('returns email when name is empty string', () {
        const user = UserEntity(name: '', email: 'john@example.com');

        expect(user.fullName, equals('john@example.com'));
      });

      test('returns Guest when both name and email are null', () {
        const user = UserEntity();

        expect(user.fullName, equals('Guest'));
      });
    });

    group('toMap', () {
      test('includes all fields', () {
        final now = DateTime(2026, 1, 15, 10, 30);
        final user = UserEntity(
          id: 'user_1',
          name: 'John Doe',
          email: 'john@example.com',
          ssNo: '123456789',
          mobileNumber: '+966500000000',
          fcmToken: 'fcm_token_123',
          status: 'active',
          userType: UserType.driver,
          companyId: 1,
          verifiedAt: now,
          createdAt: now,
          updatedAt: now,
        );

        final map = user.toMap();

        expect(map['id'], equals('user_1'));
        expect(map['name'], equals('John Doe'));
        expect(map['email'], equals('john@example.com'));
        expect(map['ss_no'], equals('123456789'));
        expect(map['mobile_number'], equals('+966500000000'));
        expect(map['fcm_token'], equals('fcm_token_123'));
        expect(map['status'], equals('active'));
        expect(map['user_type'], equals('cat_driver'));
        expect(map['company_id'], equals(1));
        expect(map['verified_at'], equals(now.toIso8601String()));
        expect(map['created_at'], equals(now.toIso8601String()));
        expect(map['updated_at'], equals(now.toIso8601String()));
      });

      test('handles null dates', () {
        const user = UserEntity(id: 'user_1', name: 'John Doe');

        final map = user.toMap();

        expect(map['verified_at'], isNull);
        expect(map['created_at'], isNull);
        expect(map['updated_at'], isNull);
      });
    });
  });
}
