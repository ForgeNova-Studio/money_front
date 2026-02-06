// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// constants
import 'package:moamoa/router/route_names.dart';

// viewmodels
import 'package:moamoa/features/account_book/presentation/providers/account_book_providers.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';

// widgets
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/common/widgets/error_state_widget.dart';

class AccountBookListScreen extends ConsumerWidget {
  const AccountBookListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final accountBooksState = ref.watch(accountBooksProvider);
    final selectedAccountBookId =
        ref.watch(selectedAccountBookViewModelProvider).asData?.value;

    return DefaultLayout(
      title: '가계부 관리',
      titleSpacing: 0, // 타이틀을 왼쪽 화살표에 붙이기 위해 유지
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: () => context.push(RouteNames.accountBookCreate),
            icon: Icon(
              Icons.add,
              color: colorScheme.onSurface,
              size: 28,
            ),
          ),
        ),
      ],
      child: accountBooksState.when(
        data: (accountBooks) {
          if (accountBooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 64,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '가계부가 없습니다.',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.push(RouteNames.accountBookCreate),
                    child: const Text('가계부 만들기'),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: accountBooks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final book = accountBooks[index];
              final isSelected = book.accountBookId == selectedAccountBookId;

              return InkWell(
                onTap: () {
                  context.pushNamed(
                    RouteNames.accountBookDetail,
                    pathParameters: {'id': book.accountBookId!},
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.05)
                        : colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(color: colorScheme.primary, width: 1.5)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary.withValues(alpha: 0.1)
                              : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          color: isSelected ? colorScheme.primary : Colors.grey,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            if (book.description != null &&
                                book.description!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                book.description!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: colorScheme.primary,
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorStateWidget(
          error: error,
          onRetry: () => ref.invalidate(accountBooksProvider),
        ),
      ),
    );
  }
}
