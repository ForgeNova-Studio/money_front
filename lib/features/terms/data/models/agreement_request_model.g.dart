// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgreementRequestModel _$AgreementRequestModelFromJson(
        Map<String, dynamic> json) =>
    _AgreementRequestModel(
      type: const DocumentTypeConverter().fromJson(json['type'] as String),
      version: json['version'] as String,
      agreed: json['agreed'] as bool,
    );

Map<String, dynamic> _$AgreementRequestModelToJson(
        _AgreementRequestModel instance) =>
    <String, dynamic>{
      'type': const DocumentTypeConverter().toJson(instance.type),
      'version': instance.version,
      'agreed': instance.agreed,
    };
