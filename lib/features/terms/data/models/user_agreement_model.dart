// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moamoa/features/terms/domain/entities/document_type.dart';

// models
import 'package:moamoa/features/terms/data/models/terms_document_model.dart';

part 'user_agreement_model.freezed.dart';
part 'user_agreement_model.g.dart';

/// 사용자 약관 동의 이력 응답 모델
@freezed
sealed class UserAgreementModel with _$UserAgreementModel {
  const UserAgreementModel._();

  const factory UserAgreementModel({
    @DocumentTypeConverter() required DocumentType documentType,
    required String documentVersion,
    required bool agreed,
    required DateTime agreedAt,
  }) = _UserAgreementModel;

  factory UserAgreementModel.fromJson(Map<String, dynamic> json) =>
      _$UserAgreementModelFromJson(json);
}
