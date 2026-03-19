import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:moamoa/core/constants/app_constants.dart';

// entities
import 'package:moamoa/features/terms/domain/entities/document_type.dart';

// models
import 'package:moamoa/features/terms/data/models/models.dart';

/// 약관 상세 화면
///
/// 대기업 앱 스타일의 깔끔한 약관 상세 화면입니다.
/// 카카오, 토스, 네이버 등의 UI 스타일을 참고하여 구현되었습니다.
///
/// **주요 기능:**
/// - 약관 제목 및 버전 표시
/// - 스크롤 가능한 약관 본문
/// - 하단 동의 버튼 (회원가입 플로우에서 사용 시)
class TermsDetailScreen extends ConsumerWidget {
  final DocumentType type;
  final TermsDocumentModel? document;
  final bool showAgreeButton;
  final VoidCallback? onAgree;

  const TermsDetailScreen({
    super.key,
    required this.type,
    this.document,
    this.showAgreeButton = false,
    this.onAgree,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: _buildContent(context),
          ),
          if (showAgreeButton) _buildBottomButton(context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: colorScheme.onSurface,
          size: 20,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        type.displayName,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 약관 헤더 (버전 정보)
            _buildHeader(context),

            const SizedBox(height: 24),

            // 약관 본문
            _buildTermsContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final version = document?.version ?? '1.0.0';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.backgroundGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.appColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconForType(type),
              color: context.appColors.primaryDark,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.displayName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.appColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildInfoChip(
                      context,
                      type.isRequired ? '필수' : '선택',
                      type.isRequired
                          ? context.appColors.primary
                          : context.appColors.gray400,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '버전 $version',
                      style: TextStyle(
                        fontSize: 13,
                        color: context.appColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTermsContent(BuildContext context) {
    final content = document?.content ?? _getDefaultContent(type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _parseContent(context, content),
    );
  }

  List<Widget> _parseContent(BuildContext context, String content) {
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 12));
        continue;
      }

      // 제목 스타일 (## 또는 **로 시작)
      if (line.startsWith('## ') || line.startsWith('**')) {
        final text = line
            .replaceAll('## ', '')
            .replaceAll('**', '');
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.appColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        );
      }
      // 소제목 스타일 (숫자. 로 시작)
      else if (RegExp(r'^\d+\.').hasMatch(line.trim())) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 6),
            child: Text(
              line.trim(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.appColors.textPrimary,
                height: 1.6,
              ),
            ),
          ),
        );
      }
      // 목록 스타일 (- 또는 • 로 시작)
      else if (line.trim().startsWith('-') || line.trim().startsWith('•')) {
        final text = line.trim().substring(1).trim();
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.appColors.textTertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.appColors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // 일반 본문
      else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              line.trim(),
              style: TextStyle(
                fontSize: 14,
                color: context.appColors.textSecondary,
                height: 1.7,
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  Widget _buildBottomButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: context.appColors.divider,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              onAgree?.call();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: context.appColors.textPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
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

  IconData _getIconForType(DocumentType type) {
    switch (type) {
      case DocumentType.serviceTerms:
        return Icons.description_outlined;
      case DocumentType.privacyCollection:
        return Icons.security_outlined;
      case DocumentType.marketing:
        return Icons.campaign_outlined;
    }
  }

  String _getDefaultContent(DocumentType type) {
    switch (type) {
      case DocumentType.serviceTerms:
        return _serviceTermsContent;
      case DocumentType.privacyCollection:
        return _privacyCollectionContent;
      case DocumentType.marketing:
        return _marketingContent;
    }
  }
}

// ============================================================================
// 기본 약관 내용 (서버에서 content가 없을 경우 표시)
// ============================================================================

const String _serviceTermsContent = '''
## 제1조 (목적)

이 약관은 ${AppConstants.appName} (이하 "서비스")의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

## 제2조 (정의)

1. "서비스"라 함은 회사가 제공하는 가계부 및 재무관리 관련 모든 서비스를 의미합니다.

2. "이용자"라 함은 이 약관에 따라 서비스를 이용하는 회원 및 비회원을 말합니다.

3. "회원"이라 함은 서비스에 가입하여 이용자 아이디(ID)를 부여받은 자를 말합니다.

## 제3조 (약관의 효력 및 변경)

1. 이 약관은 서비스 화면에 게시하거나 기타의 방법으로 이용자에게 공지함으로써 효력을 발생합니다.

2. 회사는 필요한 경우 관련 법령을 위반하지 않는 범위에서 이 약관을 변경할 수 있습니다.

3. 변경된 약관은 공지 후 7일이 경과한 날부터 효력이 발생합니다.

## 제4조 (서비스의 제공)

회사는 다음과 같은 서비스를 제공합니다:

- 수입/지출 기록 및 관리
- 예산 설정 및 분석
- 가계부 통계 및 리포트
- 커플 공유 가계부
- 자산 관리

## 제5조 (회원가입)

1. 이용자는 회사가 정한 가입 양식에 따라 회원정보를 기입한 후 이 약관에 동의한다는 의사표시를 함으로써 회원가입을 신청합니다.

2. 회사는 제1항과 같이 회원으로 가입할 것을 신청한 이용자 중 다음 각 호에 해당하지 않는 한 회원으로 등록합니다:
- 가입신청자가 이 약관에 의하여 이전에 회원자격을 상실한 적이 있는 경우
- 등록 내용에 허위, 기재누락, 오기가 있는 경우
- 기타 회원으로 등록하는 것이 서비스 운영에 현저히 지장이 있다고 판단되는 경우

## 제6조 (회원 탈퇴 및 자격 상실)

1. 회원은 언제든지 서비스 내 설정 메뉴를 통해 탈퇴를 요청할 수 있으며, 회사는 즉시 회원탈퇴를 처리합니다.

2. 탈퇴 시 회원의 개인정보 및 서비스 이용 기록은 관련 법령에 따라 일정 기간 보관 후 파기됩니다.

## 제7조 (개인정보 보호)

회사는 이용자의 개인정보를 보호하기 위해 개인정보처리방침을 수립하고 이를 준수합니다.

## 제8조 (면책조항)

1. 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다.

2. 회사는 이용자의 귀책사유로 인한 서비스 이용의 장애에 대하여는 책임을 지지 않습니다.

## 부칙

이 약관은 2026년 1월 1일부터 시행합니다.
''';

const String _privacyCollectionContent = '''
## 개인정보 수집·이용 동의

${AppConstants.appName}는 서비스 제공을 위해 아래와 같이 개인정보를 수집·이용합니다.

## 1. 수집하는 개인정보 항목

**필수 수집 항목:**
- 이메일 주소
- 비밀번호 (암호화 저장)
- 닉네임
- 성별

**선택 수집 항목:**
- 프로필 이미지
- 커플 연동 정보

**자동 수집 항목:**
- 기기 정보 (OS 버전, 기기 모델)
- 앱 사용 기록
- IP 주소

## 2. 개인정보 수집·이용 목적

- 회원 가입 및 관리
- 서비스 제공 및 개선
- 가계부 데이터 저장 및 동기화
- 커플 공유 기능 제공
- 고객 문의 응대
- 서비스 이용 통계 분석

## 3. 개인정보 보유 및 이용 기간

- 회원 탈퇴 시까지 보유
- 단, 관계 법령에 의해 보존이 필요한 경우 해당 기간 동안 보존

**법령에 따른 보존 기간:**
- 계약 또는 청약철회 등에 관한 기록: 5년
- 소비자 불만 또는 분쟁처리에 관한 기록: 3년
- 접속 기록: 3개월

## 4. 동의 거부권 및 불이익

귀하는 개인정보 수집·이용에 대한 동의를 거부할 권리가 있습니다. 다만, 필수 항목에 대한 동의를 거부하실 경우 회원가입이 불가능합니다.

## 5. 개인정보 처리 위탁

회사는 서비스 향상을 위해 아래와 같이 개인정보 처리업무를 위탁하고 있습니다:

- 클라우드 서버 운영: Amazon Web Services
- 이메일 발송: SendGrid

## 6. 개인정보 보호책임자

- 성명: 개인정보보호팀
- 이메일: privacy@moamoa.com

## 7. 권리 행사 방법

이용자는 언제든지 자신의 개인정보를 조회하거나 수정할 수 있으며, 가입 해지를 요청할 수 있습니다. 설정 > 계정 관리 메뉴에서 직접 처리하거나, 고객센터를 통해 요청하실 수 있습니다.
''';

const String _marketingContent = '''
## 마케팅 정보 수신 동의

${AppConstants.appName}의 다양한 혜택과 소식을 받아보실 수 있습니다.

## 1. 수신 정보 내용

**수신하실 수 있는 정보:**
- 신규 기능 안내
- 이벤트 및 프로모션 정보
- 서비스 이용 팁
- 맞춤형 재무 관리 조언
- 설문조사 참여 안내

## 2. 전송 방법

- 푸시 알림 (앱 알림)
- 이메일

## 3. 수신 동의 변경

마케팅 정보 수신 동의는 선택사항이며, 동의하지 않으셔도 서비스 이용에 제한이 없습니다.

수신 동의 후에도 언제든지 아래 방법으로 수신을 거부하실 수 있습니다:
- 앱 내 설정 > 알림 설정에서 변경
- 이메일 하단의 수신 거부 링크 클릭

## 4. 개인정보 이용

마케팅 목적으로 수집된 개인정보는 수신 동의 철회 시 또는 동의일로부터 3년간 이용되며, 이후 지체 없이 파기됩니다.

## 5. 문의

마케팅 수신과 관련한 문의사항은 고객센터(support@moamoa.com)로 연락해 주시기 바랍니다.
''';
