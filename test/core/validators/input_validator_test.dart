import 'package:flutter_test/flutter_test.dart';
import 'package:moneyflow/core/validators/input_validator.dart';

void main() {
  group('InputValidator', () {
    group('isValidEmail', () {
      test('유효한 이메일은 true를 반환해야 한다', () {
        expect(InputValidator.isValidEmail('test@example.com'), true);
        expect(InputValidator.isValidEmail('user.name@example.com'), true);
        expect(InputValidator.isValidEmail('user-name@example.co.kr'), true);
      });

      test('유효하지 않은 이메일은 false를 반환해야 한다', () {
        expect(InputValidator.isValidEmail(''), false);
        expect(InputValidator.isValidEmail('test'), false);
        expect(InputValidator.isValidEmail('test@'), false);
        expect(InputValidator.isValidEmail('@example.com'), false);
        expect(InputValidator.isValidEmail('test@.com'), false);
      });
    });

    group('isValidVerificationCode', () {
      test('6자리 숫자는 true를 반환해야 한다', () {
        expect(InputValidator.isValidVerificationCode('123456'), true);
        expect(InputValidator.isValidVerificationCode('000000'), true);
        expect(InputValidator.isValidVerificationCode('999999'), true);
      });

      test('6자리가 아니거나 숫자가 아니면 false를 반환해야 한다', () {
        expect(InputValidator.isValidVerificationCode(''), false);
        expect(InputValidator.isValidVerificationCode('12345'), false);
        expect(InputValidator.isValidVerificationCode('1234567'), false);
        expect(InputValidator.isValidVerificationCode('12345a'), false);
        expect(InputValidator.isValidVerificationCode('abcdef'), false);
      });
    });

    group('isValidPassword', () {
      test('유효한 비밀번호는 true를 반환해야 한다 (대문자 불필요)', () {
        expect(InputValidator.isValidPassword('password1'), true);
        expect(InputValidator.isValidPassword('test1234'), true);
        expect(InputValidator.isValidPassword('mypassword999'), true);
      });

      test('유효한 비밀번호는 true를 반환해야 한다 (대문자 필요)', () {
        expect(InputValidator.isValidPassword('Password1', requireUppercase: true), true);
        expect(InputValidator.isValidPassword('Test1234', requireUppercase: true), true);
      });

      test('8자 미만이면 false를 반환해야 한다', () {
        expect(InputValidator.isValidPassword('pass1'), false);
        expect(InputValidator.isValidPassword('test12'), false);
      });

      test('소문자가 없으면 false를 반환해야 한다', () {
        expect(InputValidator.isValidPassword('PASSWORD1'), false);
        expect(InputValidator.isValidPassword('12345678'), false);
      });

      test('숫자가 없으면 false를 반환해야 한다', () {
        expect(InputValidator.isValidPassword('password'), false);
        expect(InputValidator.isValidPassword('testtest'), false);
      });

      test('대문자가 필요한데 없으면 false를 반환해야 한다', () {
        expect(
          InputValidator.isValidPassword('password1', requireUppercase: true),
          false,
        );
      });
    });

    group('isValidNickname', () {
      test('2~20자 닉네임은 true를 반환해야 한다', () {
        expect(InputValidator.isValidNickname('홍길동'), true);
        expect(InputValidator.isValidNickname('사용자'), true);
        expect(InputValidator.isValidNickname('가나다라마바사아자차카타파하'), true); // 15자
      });

      test('2자 미만이면 false를 반환해야 한다', () {
        expect(InputValidator.isValidNickname(''), false);
        expect(InputValidator.isValidNickname('홍'), false);
      });

      test('20자 초과하면 false를 반환해야 한다', () {
        expect(InputValidator.isValidNickname('가나다라마바사아자차카타파하가나다라마바사'), false); // 21자
      });
    });

    group('getEmailErrorMessage', () {
      test('빈 이메일은 에러 메시지를 반환해야 한다', () {
        expect(InputValidator.getEmailErrorMessage(''), '이메일을 입력해주세요.');
      });

      test('잘못된 형식은 에러 메시지를 반환해야 한다', () {
        expect(
          InputValidator.getEmailErrorMessage('invalid'),
          '올바른 이메일 형식이 아닙니다.',
        );
      });

      test('유효한 이메일은 빈 문자열을 반환해야 한다', () {
        expect(InputValidator.getEmailErrorMessage('test@example.com'), '');
      });
    });

    group('getPasswordErrorMessage', () {
      test('빈 비밀번호는 에러 메시지를 반환해야 한다', () {
        expect(InputValidator.getPasswordErrorMessage(''), '비밀번호를 입력해주세요.');
      });

      test('8자 미만은 에러 메시지를 반환해야 한다', () {
        expect(
          InputValidator.getPasswordErrorMessage('pass1'),
          '비밀번호는 최소 8자 이상이어야 합니다.',
        );
      });

      test('소문자 없으면 에러 메시지를 반환해야 한다', () {
        expect(
          InputValidator.getPasswordErrorMessage('PASSWORD1'),
          '비밀번호에 소문자를 포함해주세요.',
        );
      });

      test('숫자 없으면 에러 메시지를 반환해야 한다', () {
        expect(
          InputValidator.getPasswordErrorMessage('password'),
          '비밀번호에 숫자를 포함해주세요.',
        );
      });

      test('유효한 비밀번호는 빈 문자열을 반환해야 한다', () {
        expect(InputValidator.getPasswordErrorMessage('password1'), '');
      });
    });

    group('getNicknameErrorMessage', () {
      test('빈 닉네임은 에러 메시지를 반환해야 한다', () {
        expect(InputValidator.getNicknameErrorMessage(''), '닉네임을 입력해주세요.');
      });

      test('2자 미만은 에러 메시지를 반환해야 한다', () {
        expect(
          InputValidator.getNicknameErrorMessage('홍'),
          '닉네임은 최소 2자 이상이어야 합니다.',
        );
      });

      test('20자 초과는 에러 메시지를 반환해야 한다', () {
        expect(
          InputValidator.getNicknameErrorMessage('가나다라마바사아자차카타파하가나다라마바사'),
          '닉네임은 최대 20자 이하여야 합니다.',
        );
      });

      test('유효한 닉네임은 빈 문자열을 반환해야 한다', () {
        expect(InputValidator.getNicknameErrorMessage('홍길동'), '');
      });
    });

    group('getVerificationCodeErrorMessage', () {
      test('빈 인증번호는 에러 메시지를 반환해야 한다', () {
        expect(
          InputValidator.getVerificationCodeErrorMessage(''),
          '인증번호를 입력해주세요.',
        );
      });

      test('6자리 숫자가 아니면 에러 메시지를 반환해야 한다', () {
        expect(
          InputValidator.getVerificationCodeErrorMessage('12345'),
          '인증번호는 6자리 숫자여야 합니다.',
        );
        expect(
          InputValidator.getVerificationCodeErrorMessage('12345a'),
          '인증번호는 6자리 숫자여야 합니다.',
        );
      });

      test('유효한 인증번호는 빈 문자열을 반환해야 한다', () {
        expect(InputValidator.getVerificationCodeErrorMessage('123456'), '');
      });
    });
  });
}
