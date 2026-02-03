import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/sms_import/domain/entities/parsed_expense.dart';
import 'package:uuid/uuid.dart';

part 'pending_expense.freezed.dart';

/// 대기 중인 지출 데이터
/// SMS에서 파싱된 후 사용자 확인을 기다리는 지출 항목
@freezed
sealed class PendingExpense with _$PendingExpense {
  const PendingExpense._();

  const factory PendingExpense({
    /// 고유 식별자 (UUID)
    required String id,

    /// 원본 파싱 데이터
    required ParsedExpense parsedExpense,

    /// 사용자가 수정한 카테고리 (null이면 미분류)
    String? category,

    /// 사용자가 수정한 메모
    String? memo,

    /// 사용자가 수정한 가맹점명 (null이면 파싱 원본 사용)
    String? merchantOverride,

    /// 생성 시간
    required DateTime createdAt,
  }) = _PendingExpense;

  /// 새 PendingExpense 생성 헬퍼
  factory PendingExpense.fromParsedExpense(ParsedExpense expense) {
    return PendingExpense(
      id: const Uuid().v4(),
      parsedExpense: expense,
      createdAt: DateTime.now(),
    );
  }

  /// 금액 (편의 getter)
  int get amount => parsedExpense.amount;

  /// 가맹점 (편의 getter) - 사용자 수정값 우선
  String get merchant => merchantOverride ?? parsedExpense.merchant;

  /// 결제일 (편의 getter)
  DateTime get date => parsedExpense.date;

  /// 카드사 ID (편의 getter)
  String get cardCompanyId => parsedExpense.cardCompanyId;
}
