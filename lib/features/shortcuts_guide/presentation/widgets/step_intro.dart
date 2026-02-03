import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// Step 1: 소개 화면
class StepIntro extends StatelessWidget {
  const StepIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // 메인 일러스트
          Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.appColors.primary.withValues(alpha: 0.1),
                    context.appColors.primary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 80,
                color: context.appColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // 제목
          Center(
            child: Text(
              '카드 결제하면\n자동으로 가계부에 기록돼요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.4,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              'iOS 단축어를 활용해 카드 결제 문자가 오면\n자동으로 지출을 기록합니다',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: context.appColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 48),

          // 특징 목록
          _FeatureItem(
            icon: Icons.shield_outlined,
            title: '개인정보 보호',
            description: '문자 내용이 서버로 전송되지 않아요',
          ),
          const SizedBox(height: 16),
          _FeatureItem(
            icon: Icons.touch_app_outlined,
            title: '간편한 설정',
            description: '한 번만 설정하면 자동으로 기록돼요',
          ),
          const SizedBox(height: 16),
          _FeatureItem(
            icon: Icons.credit_card_outlined,
            title: '다양한 카드사 지원',
            description: '주요 카드사의 결제 문자를 인식해요',
          ),

          const SizedBox(height: 32),

          // 안내 박스
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.appColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: context.appColors.warning,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'iOS 16 이상에서만 지원됩니다',
                    style: TextStyle(
                      color: context.appColors.warning,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.gray50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.appColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: context.appColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}
