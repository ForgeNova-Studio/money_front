import 'package:flutter_test/flutter_test.dart';
import 'package:moamoa/features/auth/data/models/auth_response_model.dart';
import 'package:moamoa/features/auth/data/models/user_model.dart';

void main() {
  group('AuthResponseModel.toNormalizedProfileJson', () {
    test('profileImage 키를 profileImageUrl로 정규화한다', () {
      final model = AuthResponseModel(
        accessToken: 'access',
        refreshToken: 'refresh',
        userId: 'user-1',
        profile: {
          'email': 'test@example.com',
          'nickname': 'tester',
          'profileImage': 'https://cdn.example.com/profile.png',
        },
      );

      final normalized = model.toNormalizedProfileJson();
      final user = UserModel.fromJson(normalized);

      expect(normalized['userId'], 'user-1');
      expect(normalized['profileImageUrl'],
          'https://cdn.example.com/profile.png');
      expect(user.profileImageUrl, 'https://cdn.example.com/profile.png');
    });

    test('이미 profileImageUrl이 있으면 기존 값을 유지한다', () {
      final model = AuthResponseModel(
        accessToken: 'access',
        refreshToken: 'refresh',
        userId: 'user-2',
        profile: {
          'email': 'test2@example.com',
          'nickname': 'tester2',
          'profileImage': 'https://cdn.example.com/legacy.png',
          'profileImageUrl': 'https://cdn.example.com/current.png',
        },
      );

      final normalized = model.toNormalizedProfileJson();

      expect(normalized['profileImageUrl'],
          'https://cdn.example.com/current.png');
    });
  });
}
