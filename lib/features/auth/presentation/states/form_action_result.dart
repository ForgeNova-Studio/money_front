/// 폼 액션(전송/검증/제출) 실행 결과를 표현하는 공통 타입
class FormActionResult {
  final bool success;
  final String? message;

  const FormActionResult._({
    required this.success,
    this.message,
  });

  const FormActionResult.success() : this._(success: true);

  const FormActionResult.failure([String? message])
      : this._(success: false, message: message);
}
