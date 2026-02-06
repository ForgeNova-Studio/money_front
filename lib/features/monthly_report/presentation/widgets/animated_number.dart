import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 애니메이션 숫자 위젯 (카운트업 효과)
class AnimatedNumber extends StatefulWidget {
  final int value;
  final TextStyle style;
  final String prefix;
  final Duration duration;

  const AnimatedNumber({
    super.key,
    required this.value,
    required this.style,
    this.prefix = '',
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<AnimatedNumber> createState() => _AnimatedNumberState();
}

class _AnimatedNumberState extends State<AnimatedNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentValue = (widget.value * _animation.value).round();
        return Text(
          '${widget.prefix}${formatter.format(currentValue)}',
          style: widget.style,
        );
      },
    );
  }
}
