import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: 실제 공유 링크로 교체
const _regularShortcutUrl = 'https://www.icloud.com/shortcuts/f6ccd8d5ecfc46368b9523647947adae';

/// 자동화 설정 가이드 스크린샷 경로
/// TODO: 실제 스크린샷 이미지로 교체
const _automationGuideSteps = [
  _GuideStep(
    imagePath: 'assets/images/automation_guide/step_1.png',
    title: '단축어 앱 → 자동화 탭',
    description: '단축어 앱을 열고 하단의 "자동화" 탭을 선택하세요',
  ),
  _GuideStep(
    imagePath: 'assets/images/automation_guide/step_2.png',
    title: '새 자동화 만들기',
    description: '오른쪽 상단 "+" 버튼을 탭하고 "메시지"를 선택하세요',
  ),
  _GuideStep(
    imagePath: 'assets/images/automation_guide/step_3.png',
    title: '발신자 번호 입력',
    description: '카드사 발신번호를 입력하세요\n(예: 신한 1544-7000, 삼성 1588-8700)',
  ),
  _GuideStep(
    imagePath: 'assets/images/automation_guide/step_4.png',
    title: '단축어 연결',
    description: '"단축어 실행"을 선택하고 설치한 일반 단축어를 선택하세요',
  ),
  _GuideStep(
    imagePath: 'assets/images/automation_guide/step_5.png',
    title: '즉시 실행 설정',
    description: '"실행 전에 묻기"를 끄면 문자 수신 시 자동으로 실행됩니다',
  ),
];

class _GuideStep {
  final String imagePath;
  final String title;
  final String description;

  const _GuideStep({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

/// Step 3: 단축어 설치 화면
class StepInstallShortcut extends StatelessWidget {
  const StepInstallShortcut({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(
            '단축어를 설치하세요',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '아래 단계를 따라 설정해주세요',
            style: TextStyle(
              fontSize: 14,
              color: context.appColors.textSecondary,
            ),
          ),

          const SizedBox(height: 24),

          // 보안 안내
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.appColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.appColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lock_outline,
                  color: context.appColors.warning,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'iPhone 자동화 단축어는 보안 정책으로 인해 공유가 불가능하여 직접 설정이 필요합니다.',
                    style: TextStyle(
                      color: context.appColors.warning,
                      fontSize: 13,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ① 자동화 단축어 섹션
          _buildSectionLabel(context, '1', '자동화 단축어 (직접 설정)'),
          const SizedBox(height: 12),
          _AutomationSetupCard(),

          const SizedBox(height: 28),

          // ② 일반 단축어 섹션
          _buildSectionLabel(context, '2', '일반 단축어 (링크 설치)'),
          const SizedBox(height: 12),
          const _ShortcutInstallCard(
            icon: Icons.build_outlined,
            title: '일반 단축어',
            description: 'SMS 문자를 파싱하여 가계부에 전달하는 단축어',
            url: _regularShortcutUrl,
          ),

          const SizedBox(height: 24),

          // 추가 안내
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.appColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: context.appColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '자동화 설정과 일반 단축어 설치를 모두 완료해야\n정상적으로 작동합니다.',
                    style: TextStyle(
                      color: context.appColors.primary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(
      BuildContext context, String number, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: context.appColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────
// 자동화 설정 카드 + 모달
// ──────────────────────────────────────────────────────

class _AutomationSetupCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appColors.gray200),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.appColors.warning.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.flash_on_outlined,
              color: context.appColors.warning,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '자동화 단축어',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '문자 수신 시 자동으로 실행',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showAutomationGuideModal(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.appColors.warning,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text('설정 방법'),
          ),
        ],
      ),
    );
  }

  void _showAutomationGuideModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AutomationGuideModal(),
    );
  }
}

// ──────────────────────────────────────────────────────
// 자동화 설정 가이드 모달 (스크린샷 슬라이드)
// ──────────────────────────────────────────────────────

class _AutomationGuideModal extends StatefulWidget {
  const _AutomationGuideModal();

  @override
  State<_AutomationGuideModal> createState() => _AutomationGuideModalState();
}

class _AutomationGuideModalState extends State<_AutomationGuideModal> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = _automationGuideSteps.length;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // 핸들 + 헤더
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 12, 0),
            child: Column(
              children: [
                // 드래그 핸들
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.appColors.gray300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '자동화 설정 방법',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: context.appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 슬라이드
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalPages,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final step = _automationGuideSteps[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // 스크린샷 이미지
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: context.appColors.gray50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              step.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 48,
                                      color: context.appColors.gray300,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '스크린샷 ${index + 1}',
                                      style: TextStyle(
                                        color: context.appColors.textTertiary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 설명 텍스트
                      Text(
                        step.title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        step.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: context.appColors.textSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ),

          // 페이지 인디케이터 + 네비게이션
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                children: [
                  // 도트 인디케이터
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalPages, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? context.appColors.primary
                              : context.appColors.gray300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),

                  // 페이지 번호
                  Text(
                    '${_currentPage + 1} / $totalPages',
                    style: TextStyle(
                      fontSize: 13,
                      color: context.appColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 이전/다음 버튼
                  Row(
                    children: [
                      if (_currentPage > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              side:
                                  BorderSide(color: context.appColors.gray300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              '이전',
                              style: TextStyle(
                                color: context.appColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      if (_currentPage > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: _currentPage == 0 ? 1 : 2,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage < totalPages - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.appColors.primary,
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _currentPage < totalPages - 1 ? '다음' : '닫기',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// 일반 단축어 설치 카드
// ──────────────────────────────────────────────────────

class _ShortcutInstallCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final String url;

  const _ShortcutInstallCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.url,
  });

  @override
  State<_ShortcutInstallCard> createState() => _ShortcutInstallCardState();
}

class _ShortcutInstallCardState extends State<_ShortcutInstallCard> {
  bool _isInstalled = false;

  Future<void> _openShortcutUrl() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      setState(() {
        _isInstalled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isInstalled
            ? context.appColors.success.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isInstalled
              ? context.appColors.success
              : context.appColors.gray200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _isInstalled
                  ? context.appColors.success.withValues(alpha: 0.15)
                  : context.appColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _isInstalled ? Icons.check : widget.icon,
              color: _isInstalled
                  ? context.appColors.success
                  : context.appColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isInstalled ? '설치 완료' : widget.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: _isInstalled
                        ? context.appColors.success
                        : context.appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (_isInstalled)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: context.appColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              ),
            )
          else
            ElevatedButton(
              onPressed: _openShortcutUrl,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text('설치'),
            ),
        ],
      ),
    );
  }
}
