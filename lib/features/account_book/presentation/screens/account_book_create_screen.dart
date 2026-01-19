import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/features/account_book/domain/entities/account_book.dart';
import 'package:moneyflow/features/account_book/domain/entities/book_type.dart';
import 'package:moneyflow/features/account_book/presentation/providers/account_book_providers.dart';
import 'package:moneyflow/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';

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

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: context.appColors.backgroundWhite,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: context.appColors.border.withOpacity(0.6),
        width: 1,
      ),
    );
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
                ...BookType.values.map(
                  (type) => _BottomSheetOption(
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
      setState(() => _selectedBookType = selected);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: context.appColors.textSecondary,
        ),
      ),
    );
  }

  Future<void> _selectDate({required bool isStart}) async {
    final now = DateTime.now();
    final initialDate = isStart
        ? (_startDate ?? now)
        : (_endDate ?? _startDate ?? now);
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

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '가계부 만들기',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        surfaceTintColor: context.appColors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('기본 정보'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _buildCardDecoration(),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: _buildInputDecoration('가계부 이름'),
                      validator: _validateName,
                    ),
                    const SizedBox(height: 16),
                    _SelectionField(
                      label: '가계부 유형',
                      value: _selectedBookType.label,
                      onTap: _showBookTypeSheet,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: _buildInputDecoration('설명 (선택)'),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('추가 정보'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _buildCardDecoration(),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _memberCountController,
                      decoration: _buildInputDecoration('정산 인원 (선택)'),
                      keyboardType: TextInputType.number,
                      validator: _validateMemberCount,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _coupleIdController,
                      decoration: _buildInputDecoration('커플 ID (선택)'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('기간 설정'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _buildCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _DatePickerField(
                            label: '시작일',
                            date: _startDate,
                            onTap: () => _selectDate(isStart: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DatePickerField(
                            label: '종료일',
                            date: _endDate,
                            onTap: () => _selectDate(isStart: false),
                          ),
                        ),
                      ],
                    ),
                  ],
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
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: date == null
          ? context.appColors.textTertiary
          : context.appColors.textPrimary,
      fontWeight: FontWeight.w600,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: context.appColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: context.appColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              date == null
                  ? '선택'
                  : '${date!.year}.${date!.month.toString().padLeft(2, '0')}.${date!.day.toString().padLeft(2, '0')}',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _SelectionField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: context.appColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.appColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: context.appColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSheetOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomSheetOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.08)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary.withOpacity(0.2)
                : colorScheme.outlineVariant.withOpacity(0.6),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
