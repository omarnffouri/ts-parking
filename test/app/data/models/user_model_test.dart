import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/user_model.dart';
import 'package:ts_parking/app/core/enums/user_type.dart';

void main() {
  test('fromJson parses user with userable', () {
    final user = UserModel.fromJson({
      'id': 7,
      'name': 'Darrell Harris',
      'email': 'darrell@test.com',
      'ss_no': 'DRV-001',
      'mobile_number': '1234567890',
      'profile_image_url': 'https://example.com/img.jpg',
      'status': 'active',
      'userable': {
        'status': 'approved',
        'user_type': 'cat_driver',
        'company_id': 5,
      },
      'created_at': '2026-01-01T00:00:00.000000Z',
    });

    expect(user.id, '7');
    expect(user.name, 'Darrell Harris');
    expect(user.email, 'darrell@test.com');
    expect(user.status, 'approved');
    expect(user.userType, UserType.driver);
    expect(user.companyId, 5);
  });

  test('fromDriverJson skips status fallback', () {
    final user = UserModel.fromDriverJson({
      'id': 1,
      'name': 'Test',
      'status': 'active',
    });

    expect(user.status, isNull);
  });

  test('fromJson handles all null fields', () {
    final user = UserModel.fromJson({});

    expect(user.id, isNull);
    expect(user.name, isNull);
    expect(user.userType, UserType.unknown);
  });

  test('toJson round-trips correctly', () {
    final user = UserModel.fromJson({
      'id': 1,
      'name': 'Test User',
      'email': 'test@example.com',
      'ss_no': 'SSN123',
      'mobile_number': '555',
    });

    final json = user.toJson();
    expect(json['id'], '1');
    expect(json['name'], 'Test User');
    expect(json['email'], 'test@example.com');
  });
}
