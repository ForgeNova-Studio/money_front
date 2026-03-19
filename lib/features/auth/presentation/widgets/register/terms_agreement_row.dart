import 'package:flutter/material.dart';

// core
import 'package:moamoa/core/constants/app_constants.dart';

// entities
import 'package:moamoa/features/terms/domain/entities/document_type.dart';

/// 이용약관 동의 행 위젯
///
/// 회원가입 시 필수적인 약관 동의 체크박스와 약관 상세 보기 링크를 제공합니다.
///
/// **주요 기능 (Key Features):**
/// - 전체 동의 체크박스
/// - 개별 약관 동의 체크박스 (서비스 이용약관, 개인정보 수집·이용, 마케팅 수신)
/// - 약관 상세 보기 링크 연결
///
/// **파라미터 (Parameters):**
/// - [serviceTermsAgreed]: 서비스 이용약관 동의 여부
/// - [privacyCollectionAgreed]: 개인정보 수집·이용 동의 여부
/// - [marketingAgreed]: 마케팅 정보 수신 동의 여부
/// - [isAllAgreed]: 전체 동의 여부
/// - [onToggleAll]: 전체 동의 토글 콜백
/// - [onToggleAgreement]: 개별 약관 토글 콜백
/// - [onViewDetail]: 약관 상세 보기 콜백
class TermsAgreementRow extends StatelessWidget {
  final bool serviceTermsAgreed;
  final bool privacyCollectionAgreed;
  final bool marketingAgreed;
  final bool isAllAgreed;
  final VoidCallback onToggleAll;
  final void Function(DocumentType type) onToggleAgreement;
  final void Function(DocumentType type) onViewDetail;

  const TermsAgreementRow({
    super.key,
    required this.serviceTermsAgreed,
    required this.privacyCollectionAgreed,
    required this.marketingAgreed,
    required this.isAllAgreed,
    required this.onToggleAll,
    required this.onToggleAgreement,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 전체 동의
        _AllAgreementRow(
          isAllAgreed: isAllAgreed,
          onToggle: onToggleAll,
        ),

        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withAlpha(128),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              // 서비스 이용약관
              _AgreementItemRow(
                type: DocumentType.serviceTerms,
                isAgreed: serviceTermsAgreed,
                onToggle: () => onToggleAgreement(DocumentType.serviceTerms),
                onViewDetail: () => onViewDetail(DocumentType.serviceTerms),
              ),

              const SizedBox(height: 4),

              // 개인정보 수집·이용
              _AgreementItemRow(
                type: DocumentType.privacyCollection,
                isAgreed: privacyCollectionAgreed,
                onToggle: () =>
                    onToggleAgreement(DocumentType.privacyCollection),
                onViewDetail: () =>
                    onViewDetail(DocumentType.privacyCollection),
              ),

              const SizedBox(height: 4),

              // 마케팅 정보 수신
              _AgreementItemRow(
                type: DocumentType.marketing,
                isAgreed: marketingAgreed,
                onToggle: () => onToggleAgreement(DocumentType.marketing),
                onViewDetail: () => onViewDetail(DocumentType.marketing),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 전체 동의 행
class _AllAgreementRow extends StatelessWidget {
  final bool isAllAgreed;
  final VoidCallback onToggle;

  const _AllAgreementRow({
    required this.isAllAgreed,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: isAllAgreed,
                onChanged: (_) => onToggle(),
                activeColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: BorderSide(
                  color: colorScheme.outline,
                  width: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '전체 동의',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.appColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 개별 약관 동의 행
class _AgreementItemRow extends StatelessWidget {
  final DocumentType type;
  final bool isAgreed;
  final VoidCallback onToggle;
  final VoidCallback onViewDetail;

  const _AgreementItemRow({
    required this.type,
    required this.isAgreed,
    required this.onToggle,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Checkbox(
                value: isAgreed,
                onChanged: (_) => onToggle(),
                activeColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: BorderSide(
                  color: colorScheme.outline,
                  width: 1.5,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                children: [
                  // 필수/선택 배지
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: type.isRequired
                          ? colorScheme.primary.withAlpha(26)
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      type.isRequired ? '필수' : '선택',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: type.isRequired
                            ? colorScheme.primary
                            : context.appColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 약관 이름
                  Expanded(
                    child: Text(
                      type.displayName,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.appColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 상세보기 버튼
            GestureDetector(
              onTap: onViewDetail,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: context.appColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
