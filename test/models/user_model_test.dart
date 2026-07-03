import 'package:flutter_test/flutter_test.dart';
import 'package:bonkano_meet/screens/auth/model/login_response.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  //  UserData
  // ═══════════════════════════════════════════════════════════════════════════
  group('UserData', () {
    test('fromJson parses complete valid JSON', () {
      final json = {
        'id': 42,
        'first_name': 'Jean',
        'last_name': 'Dupont',
        'user_name': 'jeandupont',
        'address': '123 Rue de Paris',
        'mobile': '+33612345678',
        'email': 'jean@example.com',
        'gender': 'male',
        'date_of_birth': '1990-05-15',
        'user_role': ['patient'],
        'api_token': 'abc123token',
        'profile_image': 'https://example.com/photo.jpg',
        'login_type': '',
        'is_social_login': false,
        'user_type': 'user',
        'wallet_amount': 150.50,
        'relation': 'self',
        'dob': '1990-05-15',
        'contactNumber': '+33612345678',
        'full_name': 'Jean Dupont',
      };

      final user = UserData.fromJson(json);

      expect(user.id, 42);
      expect(user.firstName, 'Jean');
      expect(user.lastName, 'Dupont');
      expect(user.userName, 'jeandupont');
      expect(user.address, '123 Rue de Paris');
      expect(user.mobile, '+33612345678');
      expect(user.email, 'jean@example.com');
      expect(user.gender, 'male');
      expect(user.dateOfBirth, '1990-05-15');
      expect(user.userRole, ['patient']);
      expect(user.apiToken, 'abc123token');
      expect(user.profileImage, 'https://example.com/photo.jpg');
      expect(user.loginType, '');
      expect(user.isSocialLogin, false);
      expect(user.userType, 'user');
      expect(user.walletAmount, 150.50);
      expect(user.fullName, 'Jean Dupont');
    });

    test('fromJson handles missing fields with defaults', () {
      final user = UserData.fromJson({});

      expect(user.id, -1);
      expect(user.firstName, '');
      expect(user.lastName, '');
      expect(user.email, '');
      expect(user.userRole, isEmpty);
      expect(user.apiToken, '');
      expect(user.isSocialLogin, false);
      expect(user.walletAmount, 0);
    });

    test('fromJson constructs userName from first+last when user_name missing', () {
      final json = {
        'first_name': 'Jean',
        'last_name': 'Dupont',
      };

      final user = UserData.fromJson(json);
      expect(user.userName, 'Jean Dupont');
    });

    test('fromJson handles wrong types gracefully', () {
      final json = {
        'id': 'not_an_int',
        'first_name': 123,
        'email': null,
        'wallet_amount': 'not_a_number',
        'user_role': 'not_a_list',
        'is_social_login': 1,
      };

      final user = UserData.fromJson(json);

      expect(user.id, -1);
      expect(user.firstName, '');
      expect(user.email, '');
      expect(user.walletAmount, 0);
      expect(user.userRole, isEmpty);
      expect(user.isSocialLogin, false);
    });

    test('isSocialLoginType returns true for Google login', () {
      final user = UserData(loginType: 'google');
      expect(user.isSocialLoginType, true);
    });

    test('isSocialLoginType returns true for Apple login', () {
      final user = UserData(loginType: 'apple');
      expect(user.isSocialLoginType, true);
    });

    test('isSocialLoginType returns true when isSocialLogin flag is set', () {
      final user = UserData(isSocialLogin: true);
      expect(user.isSocialLoginType, true);
    });

    test('isSocialLoginType returns false for normal login', () {
      final user = UserData(loginType: '', isSocialLogin: false);
      expect(user.isSocialLoginType, false);
    });

    test('toJson produces correct map', () {
      final user = UserData(
        id: 1,
        firstName: 'Test',
        lastName: 'User',
        email: 'test@test.com',
        userRole: ['patient', 'user'],
        walletAmount: 100,
      );

      final json = user.toJson();

      expect(json['id'], 1);
      expect(json['first_name'], 'Test');
      expect(json['last_name'], 'User');
      expect(json['email'], 'test@test.com');
      expect(json['user_role'], ['patient', 'user']);
      expect(json['wallet_amount'], 100);
    });

    test('toJson -> fromJson roundtrip preserves core fields', () {
      final user = UserData(
        id: 42,
        firstName: 'Jean',
        lastName: 'Dupont',
        email: 'jean@test.com',
        mobile: '+33612345678',
        gender: 'male',
        apiToken: 'token123',
        walletAmount: 50.75,
      );

      final restored = UserData.fromJson(user.toJson());

      expect(restored.id, user.id);
      expect(restored.firstName, user.firstName);
      expect(restored.lastName, user.lastName);
      expect(restored.email, user.email);
      expect(restored.mobile, user.mobile);
      expect(restored.gender, user.gender);
      expect(restored.apiToken, user.apiToken);
      expect(restored.walletAmount, user.walletAmount);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  UserResponse
  // ═══════════════════════════════════════════════════════════════════════════
  group('UserResponse', () {
    test('fromJson parses complete response', () {
      final json = {
        'status': true,
        'message': 'Login successful',
        'data': {
          'id': 1,
          'first_name': 'Jean',
          'last_name': 'Dupont',
          'email': 'jean@test.com',
        },
      };

      final response = UserResponse.fromJson(json);

      expect(response.status, true);
      expect(response.message, 'Login successful');
      expect(response.userData.id, 1);
      expect(response.userData.firstName, 'Jean');
    });

    test('fromJson handles missing data field', () {
      final json = {
        'status': false,
        'message': 'Error',
      };

      final response = UserResponse.fromJson(json);

      expect(response.status, false);
      expect(response.message, 'Error');
      expect(response.userData.id, -1);
    });

    test('fromJson handles wrong types', () {
      final json = {
        'status': 'not_a_bool',
        'message': 123,
        'data': 'not_a_map',
      };

      final response = UserResponse.fromJson(json);

      expect(response.status, false);
      expect(response.message, '');
      expect(response.userData.id, -1);
    });

    test('toJson produces correct structure', () {
      final response = UserResponse(
        status: true,
        userData: UserData(id: 1, firstName: 'Test'),
        message: 'OK',
      );

      final json = response.toJson();

      expect(json['status'], true);
      expect(json['message'], 'OK');
      expect(json['data'], isA<Map>());
      expect(json['data']['id'], 1);
    });
  });
}
