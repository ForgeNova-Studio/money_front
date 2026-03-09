import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 인트로 카드 - "1월 리포트 도착!"
class ReportIntroCard extends StatelessWidget {
  final int year;
  final int month;

  const ReportIntroCard({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryPale, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 컨페티 이모지
          const Text(
            '🎉',
            style: TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 24),
          
          // 메인 타이틀
          Text(
            '$month월이 끝났어요!',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          
          // 서브 타이틀
          Text(
            '$year년 $month월\n소비 리포트',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 40),
          
          // 스와이프 힌트
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '스와이프해서 확인하기',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
