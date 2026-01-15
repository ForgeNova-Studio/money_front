import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnimatedAmountText extends StatefulWidget {
  final double amount;
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
  late double _previousAmount;

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
      tween: Tween<double>(begin: _previousAmount, end: widget.amount),
      duration: widget.duration,
      curve: widget.curve,
      builder: (context, value, child) {
        final formatted = NumberFormat('#,###').format(value.abs());
        final sign = widget.showSign && value < 0 ? '-' : '';
        return Text(
          '$sign$formatted${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}
