import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 숫자가 변경될 때 부드러운 카운팅 애니메이션을 보여주는 텍스트 위젯입니다.
///
/// [TweenAnimationBuilder]를 사용하여 숫자가 이전 값에서 새로운 값으로
/// 변경될 때 점진적으로 증가하거나 감소하는 애니메이션 효과를 제공합니다.
///
/// 주요 기능:
/// - 천단위 콤마(,) 자동 포맷팅 (예: 1,000)
/// - 음수일 경우 마이너스(-) 부호 표시 (옵션)
/// - 접미사(suffix) 지원 (기본값: '원')
///
/// 사용 예시:
/// ```dart
/// AnimatedAmountText(
///   amount: 15000,
///   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
///   duration: Duration(milliseconds: 800),
///   curve: Curves.easeOutQuart,
/// )
/// ```
class AnimatedAmountText extends StatefulWidget {
  final num amount;
  final TextStyle style;
  final Duration duration;
  final Curve curve;
  final bool showSign;
  final String suffix;

  const AnimatedAmountText({
    super.key,
    required this.amount,
    required this.style,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutCubic,
    this.showSign = true,
    this.suffix = '원',
  });

  @override
  State<AnimatedAmountText> createState() => _AnimatedAmountTextState();
}

class _AnimatedAmountTextState extends State<AnimatedAmountText> {
  late num _previousAmount;

  @override
  void initState() {
    super.initState();
    _previousAmount = widget.amount;
  }

  @override
  void didUpdateWidget(covariant AnimatedAmountText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount) {
      _previousAmount = oldWidget.amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: _previousAmount.toDouble(),
        end: widget.amount.toDouble(),
      ),
      duration: widget.duration,
      curve: widget.curve,
      builder: (context, value, child) {
        final formatted = NumberFormat('#,###').format(value.abs().round());
        final sign = widget.showSign && value < 0 ? '-' : '';
        return Text(
          '$sign$formatted${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}
