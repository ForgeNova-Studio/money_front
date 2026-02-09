import 'package:flutter/material.dart';

/// 홈 화면 우측 하단에 위치하는 확장형 FAB(Floating Action Button) 메뉴 위젯
///
/// 탭하면 수입/지출/영수증 스캔 메뉴가 확장되어 나타나며,
/// 다시 탭하면 메뉴가 접힙니다.
///
/// 주요 기능:
/// - 확장/축소 토글 애니메이션
/// - 수입 추가 (`onAddIncome`)
/// - 지출 추가 (`onAddExpense`)
/// - 영수증 스캔 (`onScanReceipt`)
///
/// 파라미터:
/// - [isExpanded]: 메뉴 확장 여부. 부모 위젯에서 상태 관리
/// - [onToggle]: FAB 버튼 클릭 시 호출되는 확장/축소 토글 콜백
/// - [onAddIncome]: "수입" 메뉴 선택 시 호출
/// - [onAddExpense]: "지출" 메뉴 선택 시 호출
/// - [onScanReceipt]: "영수증 스캔" 메뉴 선택 시 호출
///
/// 사용 예시:
/// ```dart
/// HomeFabMenu(
///   isExpanded: _isFabExpanded,
///   onToggle: () => setState(() => _isFabExpanded = !_isFabExpanded),
///   onAddIncome: () => context.push('/income/add'),
///   onAddExpense: () => context.push('/expense/add'),
///   onScanReceipt: () => context.push('/receipt/scan'),
/// )
/// ```
class HomeFabMenu extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onAddIncome;
  final VoidCallback onAddExpense;
  final VoidCallback onScanReceipt;

  const HomeFabMenu({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.onAddIncome,
    required this.onAddExpense,
    required this.onScanReceipt,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isExpanded) ...[
          SizedBox(
            width: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: colorScheme.inverseSurface,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FabMenuItem(
                      icon: Icons.arrow_downward,
                      label: '수입',
                      color: Colors.blue,
                      onTap: onAddIncome,
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colorScheme.outlineVariant,
                    ),
                    _FabMenuItem(
                      icon: Icons.arrow_upward,
                      label: '지출',
                      color: Colors.orange,
                      onTap: onAddExpense,
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colorScheme.outlineVariant,
                    ),
                    _FabMenuItem(
                      icon: Icons.document_scanner,
                      label: '영수증 스캔',
                      color: Colors.green,
                      onTap: onScanReceipt,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          width: 80,
          height: 35,
          child: FloatingActionButton(
            onPressed: onToggle,
            backgroundColor:
                isExpanded ? colorScheme.inverseSurface : colorScheme.primary,
            foregroundColor: isExpanded
                ? colorScheme.onInverseSurface
                : colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isExpanded ? Icons.close : Icons.add,
                key: ValueKey(isExpanded),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FabMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FabMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onInverseSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
