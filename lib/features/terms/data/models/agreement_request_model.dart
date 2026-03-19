// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moamoa/features/terms/domain/entities/document_type.dart';

// models
import 'package:moamoa/features/terms/data/models/terms_document_model.dart';

part 'agreement_request_model.freezed.dart';
part 'agreement_request_model.g.dart';

/// 약관 동의 요청 모델
///
/// 회원가입 및 재동의 시 서버로 전송하는 데이터
@freezed
sealed class AgreementRequestModel with _$AgreementRequestModel {
  const AgreementRequestModel._();

  const factory AgreementRequestModel({
    @DocumentTypeConverter() required DocumentType type,
    required String version,
    required bool agreed,
  }) = _AgreementRequestModel;

  factory AgreementRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementRequestModelFromJson(json);
}
