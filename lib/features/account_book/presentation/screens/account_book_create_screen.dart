import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/account_book/domain/entities/account_book.dart';
import 'package:moamoa/features/account_book/domain/entities/book_type.dart';
import 'package:moamoa/features/account_book/presentation/providers/account_book_providers.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/account_book/presentation/widgets/account_book_create_widgets.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';

class AccountBookCreateScreen extends ConsumerStatefulWidget {
  const AccountBookCreateScreen({super.key});

  @override
  ConsumerState<AccountBookCreateScreen> createState() =>
      _AccountBookCreateScreenState();
}

class _AccountBookCreateScreenState
    extends ConsumerState<AccountBookCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _memberCountController = TextEditingController();
  final _coupleIdController = TextEditingController();

  BookType _selectedBookType = BookType.coupleLiving;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _memberCountController.dispose();
    _coupleIdController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: context.appColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: context.appColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.appColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.appColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.appColors.primary, width: 1.2),
      ),
    );
  }

  Future<void> _showBookTypeSheet() async {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = await showModalBottomSheet<BookType>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '가계부 유형',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                ...BookType.values.where((t) => t != BookType.def).map(
                      (type) => AccountBookBottomSheetOption(
                        label: type.label,
                        isSelected: type == _selectedBookType,
                        onTap: () => Navigator.of(context).pop(type),
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedBookType = selected;
        // 커플 가계부는 인원 2명 고정, 기간 설정 불가(null)
        if (selected == BookType.coupleLiving) {
          _memberCountController.text = '2';
          _startDate = null;
          _endDate = null;
        } else {
          // 다른 타입으로 변경 시 초기화 (필요하면)
          // _memberCountController.clear(); // 사용자가 입력한 값을 유지할지 여부에 따라 결정
          // 여기서는 '2'로 자동 설정된 것이 다른 타입으로 가면 그대로 '2'로 남아있게 됩니다.
          // 사용자 경험상 명시적으로 지워주는게 좋을 수도 있지만,
          // 실수로 타입 바꿨다가 돌아왔을 때 데이터 날아가는 것 방지를 위해 유지할 수도 있습니다.
          // 요청 사항은 "커플일 경우 고정"이므로, 아닌 경우는 자유롭게 놔둡니다.
        }
      });
    }
  }

  Future<void> _selectDate({required bool isStart}) async {
    final now = DateTime.now();
    final initialDate =
        isStart ? (_startDate ?? now) : (_endDate ?? _startDate ?? now);
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('ko', 'KR'),
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = picked;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '가계부 이름을 입력하세요.';
    }
    return null;
  }

  String? _validateMemberCount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final count = int.tryParse(value.trim());
    if (count == null || count <= 0) {
      return '정산 인원은 1 이상이어야 합니다.';
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_startDate != null && _endDate != null) {
      if (_endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('종료일은 시작일보다 빠를 수 없습니다.')),
        );
        return;
      }
    }

    final memberCount = _memberCountController.text.trim().isEmpty
        ? null
        : int.tryParse(_memberCountController.text.trim());
    final coupleId = _coupleIdController.text.trim().isEmpty
        ? null
        : _coupleIdController.text.trim();

    final accountBook = AccountBook(
      name: _nameController.text.trim(),
      bookType: _selectedBookType,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      memberCount: memberCount,
      coupleId: coupleId,
      startDate: _startDate,
      endDate: _endDate,
    );

    setState(() => _isSubmitting = true);

    try {
      final created = await ref
          .read(createAccountBookUseCaseProvider)
          .call(accountBook: accountBook);

      ref.invalidate(accountBooksProvider);
      if (created.accountBookId != null) {
        await ref
            .read(selectedAccountBookViewModelProvider.notifier)
            .setSelectedAccountBookId(created.accountBookId);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('가계부가 생성되었습니다.')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('가계부 생성 실패: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCoupleBook = _selectedBookType == BookType.coupleLiving;

    return DefaultLayout(
      title: '가계부 만들기',
      centerTitle: true,
      canPop: true,
      onPopInvokedWithResult: (_, __) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      leading: IconButton(
        icon: Icon(Icons.close, color: colorScheme.onSurface),
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.of(context).pop();
        },
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AccountBookSectionCard(
                  title: '기본 정보',
                  child: AccountBookBasicInfoSection(
                    nameController: _nameController,
                    descriptionController: _descriptionController,
                    selectedBookTypeLabel: _selectedBookType.label,
                    onSelectBookType: _showBookTypeSheet,
                    inputDecoration: _buildInputDecoration,
                    validateName: _validateName,
                  ),
                ),
                const SizedBox(height: 16),
                AccountBookSectionCard(
                  title: '추가 정보',
                  child: AccountBookAdditionalInfoSection(
                    memberCountController: _memberCountController,
                    coupleIdController: _coupleIdController,
                    inputDecoration: _buildInputDecoration,
                    validateMemberCount: _validateMemberCount,
                    isCoupleBook: isCoupleBook,
                  ),
                ),
                const SizedBox(height: 16),
                AccountBookSectionCard(
                  title: '기간 설정',
                  child: AccountBookPeriodSection(
                    startDate: _startDate,
                    endDate: _endDate,
                    onStartTap: () => _selectDate(isStart: true),
                    onEndTap: () => _selectDate(isStart: false),
                    isCoupleBook: isCoupleBook,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.appColors.primary,
                      foregroundColor: context.appColors.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            '가계부 만들기',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
