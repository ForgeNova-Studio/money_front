// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// entities
import 'package:moamoa/features/account_book/domain/entities/account_book.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/account_book/domain/entities/book_type.dart';

// providers
import 'package:moamoa/features/account_book/presentation/providers/account_book_providers.dart';

// widgets
import 'package:moamoa/features/account_book/presentation/widgets/account_book_create_widgets.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';

class AccountBookEditScreen extends ConsumerStatefulWidget {
  final String accountBookId;

  const AccountBookEditScreen({
    super.key,
    required this.accountBookId,
  });

  @override
  ConsumerState<AccountBookEditScreen> createState() =>
      _AccountBookEditScreenState();
}

class _AccountBookEditScreenState extends ConsumerState<AccountBookEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _memberCountController;

  bool _isInitialized = false;
  bool _isSubmitting = false;
  BookType _selectedBookType = BookType.coupleLiving;
  DateTime? _startDate;
  DateTime? _endDate;
  AccountBook? _originalAccountBook;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _memberCountController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _memberCountController.dispose();
    super.dispose();
  }

  void _initializeData(AccountBook accountBook) {
    if (_isInitialized) return;
    _isInitialized = true;
    _originalAccountBook = accountBook;

    _nameController.text = accountBook.name;
    _descriptionController.text = accountBook.description ?? '';
    _memberCountController.text = accountBook.memberCount.toString();
    _selectedBookType = accountBook.bookType;
    _startDate = accountBook.startDate;
    _endDate = accountBook.endDate;
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
    // 기본 가계부는 유형 변경 불가
    if (_selectedBookType == BookType.def) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기본 가계부의 유형은 변경할 수 없습니다.')),
      );
      return;
    }

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
      setState(() => _selectedBookType = selected);
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

    // 수정된 내용 생성
    final updatedAccountBook = _originalAccountBook!.copyWith(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      memberCount: memberCount ?? _originalAccountBook!.memberCount,
      startDate: _startDate,
      endDate: _endDate,
      // bookType은 변경 불가 (API 스펙: update request에 없음) - 프론트에서 막았지만 혹시 몰라 원본 유지
      // 만약 백엔드에서 bookType 수정을 지원하지 않는다면 여기서 보내도 무시되거나 에러.
      // 현재 백엔드 로직에 bookType 수정은 없음.
    );

    setState(() => _isSubmitting = true);

    try {
      await ref.read(updateAccountBookUseCaseProvider).call(
            accountBookId: widget.accountBookId,
            accountBook: updatedAccountBook,
          );

      ref.invalidate(accountBooksProvider);
      ref.invalidate(accountBookDetailProvider(widget.accountBookId));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('가계부가 수정되었습니다.')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('가계부 수정 실패: $e')),
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
    final accountBookAsync =
        ref.watch(accountBookDetailProvider(widget.accountBookId));

    return DefaultLayout(
      title: '가계부 수정',
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
      child: accountBookAsync.when(
        data: (accountBook) {
          _initializeData(accountBook);
          return GestureDetector(
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
                        coupleIdController: TextEditingController(
                            text: accountBook
                                .coupleId), // 커플 ID는 수정 불가하지만 뷰용으로 전달
                        inputDecoration: _buildInputDecoration,
                        validateMemberCount: _validateMemberCount,
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
                                '수정 완료',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('가계부 정보를 불러오는데 실패했습니다: $error'),
        ),
      ),
    );
  }
}
