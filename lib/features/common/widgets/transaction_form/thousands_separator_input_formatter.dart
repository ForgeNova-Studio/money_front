import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// 천 단위 구분 기호 입력 포맷터
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###');
  final int maxDigits;

  ThousandsSeparatorInputFormatter({this.maxDigits = 19});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final sanitized = newValue.text.replaceAll(',', '');

    // 길이 제한 체크
    if (sanitized.length > maxDigits) {
      return oldValue;
    }

    final number = int.tryParse(sanitized);
    if (number == null) {
      return oldValue;
    }

    final formatted = _formatter.format(number);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
