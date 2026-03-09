/// 월별 통계 캐시 키 (가계부 + yyyyMM)
class StatisticsCacheKey {
  final int monthKey;
  final String? accountBookId;

  const StatisticsCacheKey({
    required this.monthKey,
    required this.accountBookId,
  });

  /// month/accountBook 조합이 동일하면 같은 캐시 키로 취급한다.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatisticsCacheKey &&
        other.monthKey == monthKey &&
        other.accountBookId == accountBookId;
  }

  /// Map key로 사용하기 위한 해시값.
  @override
  int get hashCode => Object.hash(monthKey, accountBookId);
}
