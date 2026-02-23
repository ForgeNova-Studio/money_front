double parseFormattedAmount(String rawText) {
  final numericValue = rawText.replaceAll(RegExp(r'[^0-9]'), '');
  return double.tryParse(numericValue) ?? 0;
}

double parseSignedFormattedAmount({
  required String rawText,
  required bool isNegative,
}) {
  final amount = parseFormattedAmount(rawText);
  return isNegative ? -amount : amount;
}

String buildBudgetMonthKey(DateTime month) {
  return '${month.year}-${month.month.toString().padLeft(2, '0')}';
}
