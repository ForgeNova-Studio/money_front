import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moamoa/core/models/card_company.dart';

part 'recent_card_service.g.dart';

/// 최근 사용한 카드사 관리 서비스
/// SharedPreferences에 최근 사용 카드사 ID를 저장하고 정렬된 목록을 제공
@riverpod
class RecentCardService extends _$RecentCardService {
  static const String _prefsKey = 'recent_card_ids';
  static const int _maxRecentCards = 3;

  @override
  List<String> build() {
    _loadRecentCards();
    return [];
  }

  /// SharedPreferences에서 최근 카드사 목록 로드
  Future<void> _loadRecentCards() async {
    final prefs = await SharedPreferences.getInstance();
    final recentIds = prefs.getStringList(_prefsKey) ?? [];
    state = recentIds;
  }

  /// 카드사 사용 기록 저장
  /// 이미 있으면 최상단으로 이동, 최대 3개 유지
  Future<void> saveRecentCard(String cardId) async {
    final updated = List<String>.from(state);

    // 이미 있으면 제거 후 맨 앞에 추가 (최신순)
    updated.remove(cardId);
    updated.insert(0, cardId);

    // 최대 개수 제한
    if (updated.length > _maxRecentCards) {
      updated.removeRange(_maxRecentCards, updated.length);
    }

    // SharedPreferences에 저장
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, updated);

    state = updated;
  }

  /// 최근 사용 순으로 정렬된 카드사 목록 반환
  /// 최근 사용 카드사가 앞에, 나머지는 기본 순서대로
  List<CardCompany> getSortedCardCompanies() {
    final recentIds = state;

    if (recentIds.isEmpty) {
      return List.from(supportedCardCompanies);
    }

    final recentCards = <CardCompany>[];
    final otherCards = <CardCompany>[];

    // 최근 사용 카드사 먼저 수집
    for (final id in recentIds) {
      final card = supportedCardCompanies.firstWhere(
        (c) => c.id == id,
        orElse: () => supportedCardCompanies.first,
      );
      if (supportedCardCompanies.any((c) => c.id == id)) {
        recentCards.add(card);
      }
    }

    // 나머지 카드사
    for (final card in supportedCardCompanies) {
      if (!recentIds.contains(card.id)) {
        otherCards.add(card);
      }
    }

    return [...recentCards, ...otherCards];
  }

  /// 최근 사용 카드사 목록만 반환
  List<CardCompany> getRecentCardCompanies() {
    return state
        .where((id) => supportedCardCompanies.any((c) => c.id == id))
        .map((id) => supportedCardCompanies.firstWhere((c) => c.id == id))
        .toList();
  }
}
