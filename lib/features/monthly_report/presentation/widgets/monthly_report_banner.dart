import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/router/route_names.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'monthly_report_banner.g.dart';

/// 월간 리포트 배너 숨김 여부 Provider
@riverpod
class ReportBannerDismissed extends _$ReportBannerDismissed {
  static const _key = 'report_banner_dismissed';

  @override
  bool build() {
    _loadPreference();
    return false;
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedMonth = prefs.getString(_key);
    final currentMonth = '${DateTime.now().year}-${DateTime.now().month}';

    // 이번 달에 숨겼으면 true, 아니면 false (다음 달에는 다시 보여줌)
    state = dismissedMonth == currentMonth;
  }

  Future<void> dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    final currentMonth = '${DateTime.now().year}-${DateTime.now().month}';
    await prefs.setString(_key, currentMonth);
    state = true;
  }
}

/// 월간 리포트 배너 위젯
class MonthlyReportBanner extends ConsumerWidget {
  const MonthlyReportBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDismissed = ref.watch(reportBannerDismissedProvider);

    // 숨김 처리된 경우 표시 안 함
    if (isDismissed) return const SizedBox.shrink();

    // 월초 1~7일만 표시하려면 아래 주석 해제
    // final now = DateTime.now();
    // if (now.day > 7) return const SizedBox.shrink();

    final now = DateTime.now();
    final reportMonth = now.month == 1 ? 12 : now.month - 1;
    final reportYear = now.month == 1 ? now.year - 1 : now.year;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryLight,
            AppColors.primaryPale,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push(
                '${RouteNames.monthlyReport}?year=$reportYear&month=$reportMonth');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                const Text(
                  '📊',
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$reportMonth월 리포트 도착!',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '지난 달 소비를 확인해보세요',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
