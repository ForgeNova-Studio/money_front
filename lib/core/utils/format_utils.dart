import 'package:intl/intl.dart';

String formatMoneyCompact(num amount) {
  if (amount.abs() < 10000) {
    return NumberFormat('#,###').format(amount);
  }

  // 10,000 이상인 경우 '만' 단위로 변환
  // 소수점 첫째 자리까지 표시 (ex: 12300 -> 1.2만)
  // 소수점 첫째 자리가 0이면 절사 (ex: 10000 -> 1만)
  double manAmount = amount / 10000;

  // 소수점 첫째 자리까지 반올림 또는 절사 처리 (여기서는 소수점 1자리로 포맷팅)
  // 소수점이 .0인 경우 제거하기 위해 NumberFormat 사용
  final formatter = NumberFormat('#.#');
  return '${formatter.format(manAmount)}만';
}
