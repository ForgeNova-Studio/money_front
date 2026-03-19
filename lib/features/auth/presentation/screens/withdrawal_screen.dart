import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:moamoa/router/route_names.dart';
import 'package:moamoa/core/utils/toast_utils.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';

/// 회원 탈퇴 화면
///
/// 사용자가 계정을 영구 삭제하기 위한 화면입니다.
/// - 이메일 회원은 비밀번호 확인 필요
/// - SNS 회원은 확인 다이얼로그만 표시
class WithdrawalScreen extends ConsumerStatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  ConsumerState<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends ConsumerState<WithdrawalScreen> {
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  String? _selectedReason;
  bool _obscurePassword = true;
  bool _isProcessing = false;

  final List<String> _withdrawalReasons = [
    '서비스를 더 이상 사용하지 않음',
    '다른 서비스를 이용함',
    '개인정보가 걱정됨',
    '사용하기 불편함',
    '기타',
  ];

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleWithdrawal() async {
    // 최종 확인 다이얼로그
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('회원 탈퇴'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '정말로 탈퇴하시겠습니까?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              '탈퇴 시 아래 데이터가 영구 삭제됩니다:',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 8),
            Text(
              '• 모든 지출/수입 내역\n'
              '• 예산 설정\n'
              '• 자산 정보\n'
              '• 커플 연동 정보\n'
              '• 알림 내역',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            SizedBox(height: 12),
            Text(
              '이 작업은 되돌릴 수 없습니다.',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('탈퇴하기'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);

    try {
      await ref.read(authViewModelProvider.notifier).withdrawUser(
            password: _passwordController.text.isNotEmpty
                ? _passwordController.text
                : null,
            reason: _selectedReason,
          );

      if (mounted) {
        context.showToast('회원 탈퇴가 완료되었습니다.');
        context.go(RouteNames.login);
      }
    } catch (e) {
      if (mounted) {
        context.showErrorToast(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Watch auth state to react to changes (e.g., loading state)
    ref.watch(authViewModelProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DefaultLayout(
        title: '회원 탈퇴',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 경고 카드
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red.shade700,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '주의',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '탈퇴 시 모든 데이터가 영구 삭제되며 복구할 수 없습니다.',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 탈퇴 사유 선택
                Text(
                  '탈퇴 사유 (선택)',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedReason,
                      hint: Text(
                        '탈퇴 사유를 선택해주세요',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      isExpanded: true,
                      dropdownColor: colorScheme.surfaceContainerHighest,
                      items: _withdrawalReasons
                          .map((reason) => DropdownMenuItem(
                                value: reason,
                                child: Text(reason),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => _selectedReason = value);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 비밀번호 입력 (이메일 회원용)
                Text(
                  '비밀번호 확인',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '이메일로 가입한 경우 비밀번호를 입력해주세요.\nSNS로 가입한 경우 비워두세요.',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '비밀번호',
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // 탈퇴 버튼
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _handleWithdrawal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            '회원 탈퇴',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // 취소 버튼
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: TextButton(
                    onPressed: _isProcessing ? null : () => context.pop(),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
