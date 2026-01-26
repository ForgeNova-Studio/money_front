import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/account_book/presentation/providers/account_book_providers.dart';
import 'package:moamoa/features/couple/presentation/viewmodels/couple_view_model.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';

class CoupleJoinScreen extends ConsumerStatefulWidget {
  const CoupleJoinScreen({super.key});

  @override
  ConsumerState<CoupleJoinScreen> createState() => _CoupleJoinScreenState();
}

class _CoupleJoinScreenState extends ConsumerState<CoupleJoinScreen> {
  final _codeController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(coupleViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;

    // 에러 메시지 표시
    ref.listen<CoupleState>(coupleViewModelProvider, (previous, next) {
      if (next.errorMessage != null && previous?.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(coupleViewModelProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          '초대 코드 입력',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // 아이콘
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.link,
                  color: Colors.pink.shade400,
                  size: 48,
                ),
              ),

              const SizedBox(height: 32),

              // 안내 텍스트
              Text(
                '파트너에게 받은\n초대 코드를 입력하세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 48),

              // 코드 입력 필드
              Container(
                decoration: BoxDecoration(
                  color: context.appColors.gray50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _focusNode.hasFocus
                        ? Colors.pink
                        : context.appColors.border,
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: _codeController,
                  focusNode: _focusNode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                  decoration: InputDecoration(
                    hintText: 'ABC123',
                    hintStyle: TextStyle(
                      color: context.appColors.textTertiary,
                      letterSpacing: 8,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                    LengthLimitingTextInputFormatter(10),
                    _UpperCaseTextFormatter(),
                  ],
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _submit(),
                ),
              ),

              const SizedBox(height: 8),

              // 글자 수 안내
              Text(
                '${_codeController.text.length}/6 자리',
                style: TextStyle(
                  color: context.appColors.textTertiary,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 32),

              // 연동하기 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSubmit() && !_isSubmitting ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.pink.shade200,
                    disabledForegroundColor: Colors.white70,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting || state.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          '연동하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 48),

              // 안내 사항
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.appColors.gray50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.help_outline,
                          color: context.appColors.textTertiary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '초대 코드가 없으신가요?',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '파트너에게 모아모아 앱에서 "파트너 초대하기"를 눌러 초대 코드를 공유해달라고 요청하세요.',
                      style: TextStyle(
                        color: context.appColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canSubmit() {
    return _codeController.text.length >= 6;
  }

  Future<void> _submit() async {
    if (!_canSubmit()) return;

    setState(() => _isSubmitting = true);

    final success = await ref
        .read(coupleViewModelProvider.notifier)
        .joinCouple(_codeController.text.trim());

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      // 가계부 목록 새로고침 (새로 생성된 커플 가계부 반영)
      ref.invalidate(accountBooksProvider);

      // 홈 화면 데이터 새로고침
      ref.read(homeViewModelProvider.notifier).refresh();

      // 성공 시 커플 화면으로 이동
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('커플 연동이 완료되었습니다!\n"우리의 생활비" 가계부가 생성되었어요.'),
          backgroundColor: Colors.green,
        ),
      );
      // 뒤로 두 번 가서 설정 화면으로
      if (context.canPop()) context.pop();
      if (context.canPop()) context.pop();
    }
  }
}

/// 입력 텍스트를 대문자로 변환하는 포맷터
class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
