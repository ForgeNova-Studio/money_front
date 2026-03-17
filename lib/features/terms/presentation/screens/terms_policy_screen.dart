// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// core
import 'package:moamoa/core/utils/toast_utils.dart';

// widgets
import 'package:moamoa/features/common/widgets/default_layout.dart';

// entities
import 'package:moamoa/features/terms/domain/entities/document_type.dart';

// providers
import 'package:moamoa/features/terms/presentation/providers/terms_provider.dart';
import 'package:moamoa/features/terms/presentation/providers/terms_policy_view_model.dart';

/// 약관 및 정책 화면
///
/// 설정에서 진입하는 약관 관리 화면입니다.
/// - 각 약관 전문 보기
/// - 마케팅 수신 동의 토글
class TermsPolicyScreen extends ConsumerWidget {
  const TermsPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeTermsAsync = ref.watch(getActiveTermsProvider);
    final myAgreementsAsync = ref.watch(getMyAgreementsProvider);
    final viewModelState = ref.watch(termsPolicyViewModelProvider);

    return DefaultLayout(
      title: '약관 및 정책',
      child: activeTermsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                '약관 정보를 불러올 수 없습니다.',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(getActiveTermsProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (terms) {
          return myAgreementsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildContent(
              context,
              ref,
              terms,
              null,
              viewModelState.isMarketingAgreed,
              viewModelState.isUpdating,
            ),
            data: (agreements) {
              // 마케팅 동의 상태 초기화 (최초 1회)
              final marketingAgreement = agreements
                  .where((a) => a.documentType == DocumentType.marketing)
                  .firstOrNull;

              // 초기 상태 설정
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!viewModelState.isInitialized) {
                  ref
                      .read(termsPolicyViewModelProvider.notifier)
                      .initialize(marketingAgreement?.agreed ?? false);
                }
              });

              return _buildContent(
                context,
                ref,
                terms,
                agreements,
                viewModelState.isMarketingAgreed,
                viewModelState.isUpdating,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List terms,
    List? agreements,
    bool isMarketingAgreed,
    bool isUpdating,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // 약관 전문 보기 섹션
          _SectionHeader(title: '약관 전문'),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _TermsItem(
                  title: DocumentType.serviceTerms.displayName,
                  onTap: () => _navigateToTermsDetail(
                    context,
                    DocumentType.serviceTerms,
                    terms,
                  ),
                ),
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                _TermsItem(
                  title: DocumentType.privacyCollection.displayName,
                  onTap: () => _navigateToTermsDetail(
                    context,
                    DocumentType.privacyCollection,
                    terms,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 마케팅 수신 동의 섹션
          _SectionHeader(title: '마케팅 정보 수신'),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _MarketingToggleItem(
                  isAgreed: isMarketingAgreed,
                  isUpdating: isUpdating,
                  onChanged: (value) => _handleMarketingToggle(
                    context,
                    ref,
                    value,
                  ),
                ),
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                _TermsItem(
                  title: '마케팅 정보 수신 동의 내용',
                  onTap: () => _navigateToTermsDetail(
                    context,
                    DocumentType.marketing,
                    terms,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 안내 문구
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '마케팅 정보 수신에 동의하시면 이벤트, 할인 정보 등 유용한 소식을 받아보실 수 있습니다.',
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _navigateToTermsDetail(
    BuildContext context,
    DocumentType type,
    List terms,
  ) {
    final document = terms
        .where((t) => t.documentType == type)
        .firstOrNull;

    context.push(
      '/terms/${type.toServerString()}',
      extra: document,
    );
  }

  Future<void> _handleMarketingToggle(
    BuildContext context,
    WidgetRef ref,
    bool value,
  ) async {
    try {
      await ref
          .read(termsPolicyViewModelProvider.notifier)
          .updateMarketingConsent(value);

      if (context.mounted) {
        context.showToast(
          value ? '마케팅 정보 수신에 동의하였습니다.' : '마케팅 정보 수신 동의를 철회하였습니다.',
        );
      }
    } catch (e) {
      if (context.mounted) {
        context.showErrorToast('설정 변경에 실패했습니다.');
      }
    }
  }
}

/// 섹션 헤더 위젯
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// 약관 아이템 위젯
class _TermsItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _TermsItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// 마케팅 토글 아이템 위젯
class _MarketingToggleItem extends StatelessWidget {
  final bool isAgreed;
  final bool isUpdating;
  final ValueChanged<bool> onChanged;

  const _MarketingToggleItem({
    required this.isAgreed,
    required this.isUpdating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '마케팅 정보 수신 동의',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 15,
              ),
            ),
          ),
          if (isUpdating)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Switch.adaptive(
              value: isAgreed,
              onChanged: onChanged,
              activeTrackColor: colorScheme.primary,
              activeThumbColor: colorScheme.onPrimary,
            ),
        ],
      ),
    );
  }
}
