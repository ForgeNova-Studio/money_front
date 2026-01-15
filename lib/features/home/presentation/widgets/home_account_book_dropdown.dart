import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moneyflow/features/account_book/domain/entities/account_book.dart';

class HomeAccountBookDropdown extends StatelessWidget {
  final AsyncValue<List<AccountBook>> accountBooksState;
  final AsyncValue<String?> selectedAccountBookState;
  final VoidCallback onCreateAccountBook;
  final ValueChanged<String> onSelectAccountBook;

  const HomeAccountBookDropdown({
    super.key,
    required this.accountBooksState,
    required this.selectedAccountBookState,
    required this.onCreateAccountBook,
    required this.onSelectAccountBook,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outlineVariant.withOpacity(0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: accountBooksState.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('가계부를 불러오지 못했습니다: $error'),
            ),
            data: (books) {
              final selectedId = selectedAccountBookState.asData?.value;
              final activeBooks =
                  books.where((book) => book.isActive != false).toList();

              if (activeBooks.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Text('등록된 가계부가 없습니다.'),
                      ),
                    ),
                    const Divider(height: 1),
                    _CreateAccountBookButton(onTap: onCreateAccountBook),
                  ],
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '가계부 선택',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...activeBooks.map(
                    (book) => _AccountBookMenuItem(
                      book: book,
                      isSelected: book.accountBookId == selectedId,
                      onSelect: onSelectAccountBook,
                    ),
                  ),
                  const Divider(height: 1),
                  _CreateAccountBookButton(onTap: onCreateAccountBook),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AccountBookMenuItem extends StatelessWidget {
  final AccountBook book;
  final bool isSelected;
  final ValueChanged<String> onSelect;

  const _AccountBookMenuItem({
    required this.book,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final bookId = book.accountBookId;
    return InkWell(
      onTap: bookId == null ? null : () => onSelect(bookId),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                  : Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withOpacity(0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                book.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceVariant
                      .withOpacity(0.6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  book.bookType.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (isSelected) ...[
                const SizedBox(height: 8),
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateAccountBookButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CreateAccountBookButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '새로운 가계부 열기',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
