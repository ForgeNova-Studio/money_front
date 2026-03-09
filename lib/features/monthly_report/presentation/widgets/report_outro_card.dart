import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/monthly_report/domain/entities/monthly_report_entity.dart';
import 'package:moamoa/features/monthly_report/presentation/widgets/monthly_report_banner.dart';

/// 마무리 카드
class ReportOutroCard extends ConsumerStatefulWidget {
  final MonthlyReportEntity report;

  const ReportOutroCard({super.key, required this.report});

  @override
  ConsumerState<ReportOutroCard> createState() => _ReportOutroCardState();
}

class _ReportOutroCardState extends ConsumerState<ReportOutroCard> {
  bool _isDontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    final nextMonth = widget.report.month == 12 ? 1 : widget.report.month + 1;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryLight, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowAccent,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 16),
      child: Column(
        children: [
          // 스크롤 가능한 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '✨',
                    style: TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    '$nextMonth월도 화이팅!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 가장 많이 간 곳
                  if (widget.report.topMerchant != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundAccentTint,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '이번 달 가장 많이 간 곳',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '☕',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${widget.report.topMerchant!.name} (${widget.report.topMerchant!.visitCount}회)',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // 팁
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          '💡',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _getTip(widget.report),
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.info,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 해시태그
                  Text(
                    '#나의소비리포트 #${widget.report.month}월결산 #모아모아',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 하단 고정 체크박스
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              setState(() {
                _isDontShowAgain = !_isDontShowAgain;
                if (_isDontShowAgain) {
                  ref.read(reportBannerDismissedProvider.notifier).dismiss();
                }
              });
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isDontShowAgain
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    size: 20,
                    color: _isDontShowAgain
                        ? AppColors.primary
                        : AppColors.gray400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '이번 달 배너 그만 보기',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTip(MonthlyReportEntity report) {
    if (report.categoryBreakdown.isEmpty) {
      return '다음 달에는 더 많은 기록을 남겨보세요!';
    }

    final topCategory = report.categoryBreakdown.first;
    final savingAmount = (topCategory.amount * 0.1).round();

    if (topCategory.category == 'FOOD' ||
        topCategory.category == 'CAFE_SNACK') {
      return '${_getCategoryName(topCategory.category)} 지출 10% 줄이면 월 ₩${_formatNumber(savingAmount)} 절약!';
    } else if (topCategory.category == 'SHOPPING') {
      return '충동구매 줄이면 월 ₩${_formatNumber(savingAmount)} 절약 가능해요!';
    } else {
      return '${_getCategoryName(topCategory.category)} 지출을 체크해보세요!';
    }
  }

  String _getCategoryName(String code) {
    const names = {
      'FOOD': '식비',
      'CAFE_SNACK': '카페/간식',
      'SHOPPING': '쇼핑',
      'TRANSPORT': '교통',
      'CULTURE': '문화생활',
      'HEALTH': '건강',
      'EDUCATION': '교육',
      'TRAVEL': '여행',
    };
    return names[code] ?? '기타';
  }

  String _formatNumber(int number) {
    if (number >= 10000) {
      return '${(number / 10000).toStringAsFixed(1)}만';
    }
    return number.toString();
  }
}
