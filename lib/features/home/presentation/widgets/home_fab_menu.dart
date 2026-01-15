import 'package:flutter/material.dart';

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
