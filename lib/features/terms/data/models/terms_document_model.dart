// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moamoa/features/terms/domain/entities/document_type.dart';

part 'terms_document_model.freezed.dart';
part 'terms_document_model.g.dart';

/// 약관 문서 응답 모델
///
/// API 서버에서 받은 약관 문서 데이터
@freezed
sealed class TermsDocumentModel with _$TermsDocumentModel {
  const TermsDocumentModel._();

  const factory TermsDocumentModel({
    @DocumentTypeConverter() required DocumentType type,
    required String version,
    required String title,
    required String content,
    required DateTime effectiveAt,
    required bool isRequired,
    @Default(false) bool requiresReconsent,
    String? changeSummary,
  }) = _TermsDocumentModel;

  factory TermsDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$TermsDocumentModelFromJson(json);
}

/// DocumentType <-> String 변환을 위한 JsonConverter
class DocumentTypeConverter implements JsonConverter<DocumentType, String> {
  const DocumentTypeConverter();

  @override
  DocumentType fromJson(String json) {
    return DocumentType.fromServerString(json);
  }

  @override
  String toJson(DocumentType type) {
    return type.toServerString();
  }
}
