import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moamoa/features/account_book/domain/entities/account_book.dart';

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
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .outlineVariant
                  .withValues(alpha: 0.4),
              width: 1.2,
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.12)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                  : Theme.of(context)
                      .colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  book.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
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
