// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_agreement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserAgreementModel _$UserAgreementModelFromJson(Map<String, dynamic> json) =>
    _UserAgreementModel(
      documentType: const DocumentTypeConverter()
          .fromJson(json['documentType'] as String),
      documentVersion: json['documentVersion'] as String,
      agreed: json['agreed'] as bool,
      agreedAt: DateTime.parse(json['agreedAt'] as String),
    );

Map<String, dynamic> _$UserAgreementModelToJson(_UserAgreementModel instance) =>
    <String, dynamic>{
      'documentType':
          const DocumentTypeConverter().toJson(instance.documentType),
      'documentVersion': instance.documentVersion,
      'agreed': instance.agreed,
      'agreedAt': instance.agreedAt.toIso8601String(),
    };
