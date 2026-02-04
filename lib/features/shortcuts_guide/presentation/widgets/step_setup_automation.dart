import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

/// Step 4: 자동화 설정 안내 화면
class StepSetupAutomation extends StatelessWidget {
  const StepSetupAutomation({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(
            '자동화를 설정하세요',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '문자가 오면 자동으로 단축어가 실행되도록 설정합니다',
            style: TextStyle(
              fontSize: 14,
              color: context.appColors.textSecondary,
            ),
          ),

          const SizedBox(height: 32),

          // 단계별 안내
          _AutomationStep(
            stepNumber: 1,
            title: '단축어 앱 열기',
            description: '"자동화" 탭으로 이동하세요',
            imagePlaceholder: Icons.apps,
          ),

          const SizedBox(height: 16),

          _AutomationStep(
            stepNumber: 2,
            title: '새 자동화 만들기',
            description: '오른쪽 상단 "+" 버튼을 탭하세요',
            imagePlaceholder: Icons.add_circle_outline,
          ),

          const SizedBox(height: 16),

          _AutomationStep(
            stepNumber: 3,
            title: '메시지 트리거 선택',
            description: '"메시지"를 선택하고 카드사 발신번호를 입력하세요',
            imagePlaceholder: Icons.message_outlined,
          ),

          const SizedBox(height: 16),

          _AutomationStep(
            stepNumber: 4,
            title: '단축어 연결',
            description: '"단축어 실행"을 선택하고 설치한 단축어를 선택하세요',
            imagePlaceholder: Icons.play_circle_outline,
          ),

          const SizedBox(height: 16),

          _AutomationStep(
            stepNumber: 5,
            title: '"즉시 실행" 설정',
            description: '"실행 전에 묻기"를 끄면 자동으로 실행됩니다',
            imagePlaceholder: Icons.flash_on,
          ),

          const SizedBox(height: 32),

          // 단축어 앱 열기 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _openShortcutsApp(),
              icon: const Icon(Icons.launch),
              label: const Text('단축어 앱 열기'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: context.appColors.primary),
                foregroundColor: context.appColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 주요 카드사 발신번호 안내
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
                      Icons.phone_android,
                      color: context.appColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '카드사 발신번호',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCardNumber(context, '신한카드', '1544-7000'),
                _buildCardNumber(context, '삼성카드', '1588-8700'),
                _buildCardNumber(context, 'KB국민카드', '1588-1688'),
                _buildCardNumber(context, '현대카드', '1577-6000'),
                _buildCardNumber(context, '롯데카드', '1588-8100'),
                _buildCardNumber(context, '우리카드', '1588-9955'),
                _buildCardNumber(context, '하나카드', '1800-1111'),
                _buildCardNumber(context, 'NH농협카드', '1644-4000'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 완료 안내
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.appColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  color: context.appColors.success,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '설정 완료!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: context.appColors.success,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '이제 카드 결제 문자가 오면 자동으로 가계부에 기록됩니다.',
                        style: TextStyle(
                          color: context.appColors.success,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardNumber(
      BuildContext context, String cardName, String number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            cardName,
            style: TextStyle(
              fontSize: 14,
              color: context.appColors.textSecondary,
            ),
          ),
          Text(
            number,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openShortcutsApp() async {
    final uri = Uri.parse('shortcuts://');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _AutomationStep extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;
  final IconData imagePlaceholder;

  const _AutomationStep({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.imagePlaceholder,
  });

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
          // Step number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: context.appColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Icon placeholder (could be screenshot later)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.appColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              imagePlaceholder,
              color: context.appColors.primary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
