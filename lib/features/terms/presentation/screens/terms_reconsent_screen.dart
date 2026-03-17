// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// core
import 'package:moamoa/core/utils/toast_utils.dart';

// auth
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';

// router
import 'package:moamoa/router/route_names.dart';

// providers
import 'package:moamoa/features/terms/presentation/providers/terms_reconsent_provider.dart';

// states
import 'package:moamoa/features/terms/presentation/states/terms_reconsent_state.dart';

/// 약관 재동의 화면
///
/// 필수 약관이 업데이트되었을 때 사용자에게 재동의를 받는 화면입니다.
/// - 필수 약관 모두 동의해야 앱 이용 가능
/// - 선택 약관(마케팅)은 스킵 가능
/// - 동의 전까지 뒤로가기 차단
class TermsReconsentScreen extends ConsumerStatefulWidget {
  const TermsReconsentScreen({super.key});

  @override
  ConsumerState<TermsReconsentScreen> createState() =>
      _TermsReconsentScreenState();
}

class _TermsReconsentScreenState extends ConsumerState<TermsReconsentScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 재동의 필요 약관 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReconsentItems();
    });
  }

  Future<void> _loadReconsentItems() async {
    await ref
        .read(termsReconsentViewModelProvider.notifier)
        .checkReconsentRequired();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(termsReconsentViewModelProvider);

    // 에러 메시지 표시
    ref.listen<TermsReconsentState>(
      termsReconsentViewModelProvider,
      (previous, next) {
        if (next.errorMessage != null &&
            next.errorMessage != previous?.errorMessage) {
          context.showErrorToast(next.errorMessage!);
          ref.read(termsReconsentViewModelProvider.notifier).clearError();
        }
      },
    );

    return PopScope(
      canPop: false, // 뒤로가기 차단
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitConfirmDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('약관 변경 안내'),
          centerTitle: true,
          automaticallyImplyLeading: false, // 뒤로가기 버튼 숨김
          actions: [
            // 로그아웃 버튼
            TextButton(
              onPressed: () => _showLogoutConfirmDialog(context),
              child: Text(
                '로그아웃',
                style: TextStyle(
                  color: colorScheme.error,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(context, state),
        bottomNavigationBar: state.isLoading
            ? null
            : _buildBottomBar(context, state),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TermsReconsentState state) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!state.hasItemsToConsent) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              '모든 약관에 동의하셨습니다.',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 안내 메시지
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '약관이 변경되었습니다',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '서비스 이용을 위해 변경된 약관에 동의해 주세요.\n필수 약관에 동의하지 않으시면 서비스 이용이 제한됩니다.',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 전체 동의 체크박스
          _AllAgreeCheckbox(
            isChecked: state.allAgreed,
            onChanged: () {
              ref
                  .read(termsReconsentViewModelProvider.notifier)
                  .toggleAllAgreements();
            },
          ),

          const SizedBox(height: 16),
          Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
          const SizedBox(height: 16),

          // 개별 약관 체크박스
          ...state.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _TermsCheckboxItem(
              item: item,
              onToggle: () {
                ref
                    .read(termsReconsentViewModelProvider.notifier)
                    .toggleAgreement(index);
              },
              onViewDetail: () => _navigateToTermsDetail(context, item),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, TermsReconsentState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: state.allRequiredAgreed && !state.isSubmitting
                ? () => _handleSubmit(context)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              disabledBackgroundColor:
                  colorScheme.onSurface.withValues(alpha: 0.12),
              disabledForegroundColor:
                  colorScheme.onSurface.withValues(alpha: 0.38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.isSubmitting
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : const Text(
                    '동의하고 계속하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    final success = await ref
        .read(termsReconsentViewModelProvider.notifier)
        .submitReconsent();

    if (success) {
      // 재동의 완료 플래그 설정
      ref.read(termsReconsentRequiredProvider.notifier).markCompleted();

      if (!mounted) return;
      // 홈 화면으로 이동
      context.go(RouteNames.home);
    }
  }

  void _navigateToTermsDetail(BuildContext context, TermsReconsentItem item) {
    context.push(
      '/terms/${item.document.type.toServerString()}',
      extra: item.document,
    );
  }

  void _showExitConfirmDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('약관 동의 필요'),
        content: const Text(
          '약관에 동의하지 않으시면 서비스를 이용할 수 없습니다.\n로그아웃 하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '취소',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleLogout(context);
            },
            child: Text(
              '로그아웃',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text(
          '약관에 동의하지 않으면 서비스를 이용할 수 없습니다.\n정말 로그아웃 하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '취소',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleLogout(context);
            },
            child: Text(
              '로그아웃',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    await ref.read(authViewModelProvider.notifier).logout();

    if (!mounted) return;
    context.go(RouteNames.login);
  }
}

/// 전체 동의 체크박스 위젯
class _AllAgreeCheckbox extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onChanged;

  const _AllAgreeCheckbox({
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onChanged,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _CheckboxIcon(isChecked: isChecked, isPrimary: true),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '전체 동의',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 개별 약관 체크박스 아이템 위젯
class _TermsCheckboxItem extends StatelessWidget {
  final TermsReconsentItem item;
  final VoidCallback onToggle;
  final VoidCallback onViewDetail;

  const _TermsCheckboxItem({
    required this.item,
    required this.onToggle,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final document = item.document;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CheckboxIcon(isChecked: item.agreed, isPrimary: false),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // 필수/선택 배지
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: document.isRequired
                                ? colorScheme.error.withValues(alpha: 0.1)
                                : colorScheme.outline.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            document.isRequired ? '필수' : '선택',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: document.isRequired
                                  ? colorScheme.error
                                  : colorScheme.outline,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 약관 제목
                        Expanded(
                          child: Text(
                            document.title,
                            style: TextStyle(
                              fontSize: 15,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 변경 사항 요약
                    if (document.changeSummary != null &&
                        document.changeSummary!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '변경: ${document.changeSummary}',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                    // 버전 정보
                    const SizedBox(height: 2),
                    Text(
                      'v${document.version}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
              // 상세 보기 버튼
              IconButton(
                onPressed: onViewDetail,
                icon: Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 체크박스 아이콘 위젯
class _CheckboxIcon extends StatelessWidget {
  final bool isChecked;
  final bool isPrimary;

  const _CheckboxIcon({
    required this.isChecked,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isChecked
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(isPrimary ? 6 : 4),
        border: isChecked
            ? null
            : Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 1.5,
              ),
      ),
      child: isChecked
          ? Icon(
              Icons.check,
              size: 16,
              color: colorScheme.onPrimary,
            )
          : null,
    );
  }
}
