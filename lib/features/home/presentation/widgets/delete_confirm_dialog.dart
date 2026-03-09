// 삭제 확인 다이얼로그
import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 지출/수입 내역 삭제 확인을 위한 커스텀 다이얼로그 위젯
///
/// 사용자의 실수를 방지하기 위해 삭제 전 확인 절차를 제공합니다.
/// 삭제 아이콘, 경고 메시지, 취소/삭제 버튼으로 구성되어 있습니다.
///
/// 주요 기능:
/// - 삭제할 항목의 타이틀([title])을 포함한 경고 메시지 표시
/// - 직관적인 삭제 아이콘 및 붉은색 테마 적용
/// - [Navigator.pop]을 통해 결과값(bool) 반환 (삭제: true, 취소: false)
///
/// 사용 예시:
/// ```dart
/// final shouldDelete = await showDialog<bool>(
///   context: context,
///   builder: (context) => DeleteConfirmDialog(
///     title: '커피 구매',
///   ),
/// );
/// if (shouldDelete == true) {
///   // 삭제 로직 실행
/// }
/// ```
class DeleteConfirmDialog extends StatelessWidget {
  const DeleteConfirmDialog({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: AppColors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 삭제 아이콘
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: colorScheme.error,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),

            // 제목
            Text(
              '내역 삭제',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            // 설명
            Text(
              '"$title" 내역을\n정말 삭제하시겠어요?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // 버튼들
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '삭제',
                      style: TextStyle(
                        fontSize: 15,
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
    );
  }
}
