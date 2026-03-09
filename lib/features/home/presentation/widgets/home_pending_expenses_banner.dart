import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/sms_import/presentation/viewmodels/pending_expenses_view_model.dart';
import 'package:moamoa/router/route_names.dart';

/// 대기중인 지출 내역이 있을 때 표시되는 배너 위젯
///
/// SMS 문자 분석을 통해 생성된 대기중인 지출 내역의 개수를 표시하며,
/// 탭하면 SMS 가져오기 화면으로 이동합니다.
///
/// 주요 기능:
/// - 대기중인 지출 건수가 0보다 클 때만 표시 (애니메이션 적용)
/// - 탭 시 SMS 가져오기 화면(`RouteNames.smsImport`)으로 이동
/// - 경고(warning) 색상 테마로 시각적 강조
///
/// 상태 관리:
/// - [pendingExpensesViewModelProvider]를 통해 대기중인 건수 조회
///
/// 사용 예시:
/// ```dart
/// const HomePendingExpensesBanner()
/// ```
class HomePendingExpensesBanner extends ConsumerWidget {
  const HomePendingExpensesBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingState = ref.watch(pendingExpensesViewModelProvider);
    final count = pendingState.count;

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: AnimatedOpacity(
        opacity: count > 0 ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: count > 0
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: GestureDetector(
                  onTap: () => context.push(RouteNames.smsImport),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: context.appColors.warning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.appColors.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 18,
                          color: context.appColors.warning,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '대기중인 지출 $count건이 있습니다',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: context.appColors.warning,
                            ),
                          ),
                        ),
                        Text(
                          '확인하기',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: context.appColors.warning,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: context.appColors.warning,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
