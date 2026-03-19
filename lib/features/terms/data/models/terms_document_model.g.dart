// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TermsDocumentModel _$TermsDocumentModelFromJson(Map<String, dynamic> json) =>
    _TermsDocumentModel(
      type: const DocumentTypeConverter().fromJson(json['type'] as String),
      version: json['version'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      effectiveAt: DateTime.parse(json['effectiveAt'] as String),
      isRequired: json['isRequired'] as bool,
      requiresReconsent: json['requiresReconsent'] as bool? ?? false,
      changeSummary: json['changeSummary'] as String?,
    );

Map<String, dynamic> _$TermsDocumentModelToJson(_TermsDocumentModel instance) =>
    <String, dynamic>{
      'type': const DocumentTypeConverter().toJson(instance.type),
      'version': instance.version,
      'title': instance.title,
      'content': instance.content,
      'effectiveAt': instance.effectiveAt.toIso8601String(),
      'isRequired': instance.isRequired,
      'requiresReconsent': instance.requiresReconsent,
      'changeSummary': instance.changeSummary,
    };
