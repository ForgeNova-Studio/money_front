import 'package:flutter/material.dart';

import 'package:moamoa/core/constants/app_constants.dart';

// 섹션 제목과 카드 스타일을 묶는 래퍼.
class AccountBookSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const AccountBookSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: context.appColors.textSecondary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.appColors.backgroundWhite,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: context.appColors.border.withOpacity(0.6),
              width: 1,
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}

// 기본 정보 입력: 이름, 유형 선택, 설명.
class AccountBookBasicInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String selectedBookTypeLabel;
  final VoidCallback onSelectBookType;
  final InputDecoration Function(String) inputDecoration;
  final String? Function(String?) validateName;

  const AccountBookBasicInfoSection({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.selectedBookTypeLabel,
    required this.onSelectBookType,
    required this.inputDecoration,
    required this.validateName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: inputDecoration('가계부 이름'),
          validator: validateName,
        ),
        const SizedBox(height: 16),
        AccountBookSelectionField(
          label: '가계부 유형',
          value: selectedBookTypeLabel,
          onTap: onSelectBookType,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: descriptionController,
          decoration: inputDecoration('설명 (선택)'),
          maxLines: 3,
        ),
      ],
    );
  }
}

// 추가 정보 입력: 정산 인원, 커플 ID.
class AccountBookAdditionalInfoSection extends StatelessWidget {
  final TextEditingController memberCountController;
  final TextEditingController coupleIdController;
  final InputDecoration Function(String) inputDecoration;
  final String? Function(String?) validateMemberCount;
  final bool isCoupleBook;

  const AccountBookAdditionalInfoSection({
    super.key,
    required this.memberCountController,
    required this.coupleIdController,
    required this.inputDecoration,
    required this.validateMemberCount,
    this.isCoupleBook = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: memberCountController,
          decoration:
              inputDecoration(isCoupleBook ? '정산 인원 (2명 고정)' : '정산 인원 (선택)'),
          keyboardType: TextInputType.number,
          validator: validateMemberCount,
          enabled: !isCoupleBook, // 커플이면 비활성화
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: coupleIdController,
          decoration: inputDecoration('커플 ID (선택)'),
        ),
      ],
    );
  }
}

// 시작/종료일 기간 선택 입력.
class AccountBookPeriodSection extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;
  final bool isCoupleBook;

  const AccountBookPeriodSection({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartTap,
    required this.onEndTap,
    this.isCoupleBook = false,
  });

  @override
  Widget build(BuildContext context) {
    // 커플 가계부는 기간 설정 불가 -> 비활성화된 UI 또는 안내 메시지 표시
    // 여기서는 기존 필드를 비활성화 처리
    return Row(
      children: [
        Expanded(
          child: AccountBookDatePickerField(
            label: '시작일',
            date: startDate,
            onTap: isCoupleBook ? null : onStartTap, // 커플이면 탭 불가
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AccountBookDatePickerField(
            label: '종료일',
            date: endDate,
            onTap: isCoupleBook ? null : onEndTap, // 커플이면 탭 불가
          ),
        ),
      ],
    );
  }
}

// 탭 가능한 날짜 필드(포맷된 날짜/플레이스홀더 표시).
class AccountBookDatePickerField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback? onTap;

  const AccountBookDatePickerField({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    final textStyle = TextStyle(
      color: isDisabled
          ? context.appColors.textTertiary.withOpacity(0.5)
          : (date == null
              ? context.appColors.textTertiary
              : context.appColors.textPrimary),
      fontWeight: FontWeight.w600,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isDisabled
              ? context.appColors.background.withOpacity(0.5)
              : context.appColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isDisabled
                  ? context.appColors.border.withOpacity(0.5)
                  : context.appColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDisabled
                    ? context.appColors.textSecondary.withOpacity(0.5)
                    : context.appColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              date == null
                  ? (isDisabled ? '기간 없음' : '선택')
                  : '${date!.year}.${date!.month.toString().padLeft(2, '0')}.${date!.day.toString().padLeft(2, '0')}',
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

// 라벨/값/화살표로 구성된 선택 필드.
class AccountBookSelectionField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const AccountBookSelectionField({
    super.key,
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

// 선택 강조와 체크 아이콘이 있는 바텀시트 옵션.
class AccountBookBottomSheetOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AccountBookBottomSheetOption({
    super.key,
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
