double parseFormattedAmount(String rawText) {
  final numericValue = rawText.replaceAll(RegExp(r'[^0-9]'), '');
  return double.tryParse(numericValue) ?? 0;
}
