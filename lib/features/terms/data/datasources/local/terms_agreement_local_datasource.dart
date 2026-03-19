import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:moamoa/features/terms/data/models/models.dart';

abstract class TermsAgreementLocalDataSource {
  Future<List<UserAgreementModel>> getAgreements(String userId);

  Future<void> saveAcceptedAgreements(
    String userId,
    List<AgreementRequestModel> agreements,
  );

  Future<void> saveUserAgreements(
    String userId,
    List<UserAgreementModel> agreements,
  );
}

class TermsAgreementLocalDataSourceImpl
    implements TermsAgreementLocalDataSource {
  TermsAgreementLocalDataSourceImpl({required this.secureStorage});

  final FlutterSecureStorage secureStorage;

  static const String _storageKeyPrefix = 'terms_agreements_cache_v1_';

  @override
  Future<List<UserAgreementModel>> getAgreements(String userId) async {
    if (userId.isEmpty) return const [];

    try {
      final jsonString = await secureStorage.read(key: _storageKey(userId));
      if (jsonString == null || jsonString.isEmpty) {
        return const [];
      }

      final decoded = jsonDecode(jsonString);
      if (decoded is! List) {
        return const [];
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(UserAgreementModel.fromJson)
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> saveAcceptedAgreements(
    String userId,
    List<AgreementRequestModel> agreements,
  ) async {
    if (userId.isEmpty) return;

    final acceptedAgreements = agreements
        .where((agreement) => agreement.agreed)
        .map(
          (agreement) => UserAgreementModel(
            documentType: agreement.type,
            documentVersion: agreement.version,
            agreed: true,
            agreedAt: DateTime.now(),
          ),
        )
        .toList(growable: false);

    await saveUserAgreements(userId, acceptedAgreements);
  }

  @override
  Future<void> saveUserAgreements(
    String userId,
    List<UserAgreementModel> agreements,
  ) async {
    if (userId.isEmpty || agreements.isEmpty) return;

    try {
      final existing = await getAgreements(userId);
      final merged = _mergeAgreements(existing, agreements);

      final jsonString = jsonEncode(
        merged.map((agreement) => agreement.toJson()).toList(growable: false),
      );

      await secureStorage.write(
        key: _storageKey(userId),
        value: jsonString,
      );
    } catch (_) {
      // 로컬 캐시 저장 실패는 약관 동의 자체를 막지 않는다.
    }
  }

  String _storageKey(String userId) => '$_storageKeyPrefix$userId';

  List<UserAgreementModel> _mergeAgreements(
    List<UserAgreementModel> existing,
    List<UserAgreementModel> incoming,
  ) {
    final merged = <String, UserAgreementModel>{};

    for (final agreement in existing.where((item) => item.agreed)) {
      merged[_agreementKey(agreement.documentType.toServerString(),
          agreement.documentVersion)] = agreement;
    }

    for (final agreement in incoming.where((item) => item.agreed)) {
      merged[_agreementKey(agreement.documentType.toServerString(),
          agreement.documentVersion)] = agreement;
    }

    final items = merged.values.toList(growable: false);
    items.sort((a, b) {
      final typeCompare = a.documentType
          .toServerString()
          .compareTo(b.documentType.toServerString());
      if (typeCompare != 0) return typeCompare;
      return a.documentVersion.compareTo(b.documentVersion);
    });
    return items;
  }

  String _agreementKey(String type, String version) => '$type::$version';
}
