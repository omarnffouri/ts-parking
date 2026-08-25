import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/login_response_model.dart';

void main() {
  test('fromJson parses verified response with user and token', () {
    final response = LoginResponseModel.fromJson({
      'verified': true,
      'user': {'id': 7, 'name': 'Test User', 'mobile_number': '555'},
      'access_token': 'test-token-123',
      'token_type': 'Bearer',
    }, message: 'Login successful');

    expect(response.verified, isTrue);
    expect(response.user, isNotNull);
    expect(response.user!.name, 'Test User');
    expect(response.accessToken, 'test-token-123');
    expect(response.tokenType, 'Bearer');
    expect(response.message, 'Login successful');
  });

  test('fromJson returns unverified when verified is false', () {
    final response = LoginResponseModel.fromJson({
      'verified': false,
    }, message: 'OTP required');

    expect(response.verified, isFalse);
    expect(response.user, isNull);
    expect(response.accessToken, isNull);
    expect(response.message, 'OTP required');
  });

  test('fromJson defaults to unverified when verified is null', () {
    final response = LoginResponseModel.fromJson({});

    expect(response.verified, isFalse);
  });
}
