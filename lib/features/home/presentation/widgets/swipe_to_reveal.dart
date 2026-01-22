import 'package:flutter/material.dart';

/// 스와이프하면 뒤에 숨겨진 액션 버튼이 나타나는 위젯
class SwipeToReveal extends StatefulWidget {
  const SwipeToReveal({
    super.key,
    required this.child,
    required this.actionButton,
    this.enabled = true,
    this.revealDistance = 72,
  });

  final Widget child;
  final Widget actionButton;
  final bool enabled;
  final double revealDistance;

  @override
  State<SwipeToReveal> createState() => _SwipeToRevealState();
}

class _SwipeToRevealState extends State<SwipeToReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragExtent = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _animation = _controller.drive(Tween<double>(begin: 0, end: 0));
    _controller.addListener(() {
      setState(() => _dragExtent = _animation.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _controller.stop();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;
    setState(() {
      _dragExtent =
          (_dragExtent + delta).clamp(-widget.revealDistance * 1.2, 0);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (velocity < -500) {
      _animateTo(-widget.revealDistance);
      return;
    }

    if (_dragExtent.abs() > widget.revealDistance / 2) {
      _animateTo(-widget.revealDistance);
    } else {
      _animateTo(0);
    }
  }

  void _animateTo(double target) {
    _animation = Tween<double>(
      begin: _dragExtent,
      end: target,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.duration = const Duration(milliseconds: 250);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final revealProgress =
        (_dragExtent.abs() / widget.revealDistance).clamp(0.0, 1.0);

    return GestureDetector(
      onHorizontalDragStart: widget.enabled ? _handleDragStart : null,
      onHorizontalDragUpdate: widget.enabled ? _handleDragUpdate : null,
      onHorizontalDragEnd: widget.enabled ? _handleDragEnd : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 액션 버튼 영역
          Positioned.fill(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: Transform.scale(
                scale: 0.5 + (0.5 * revealProgress),
                child: Opacity(
                  opacity: revealProgress,
                  child: widget.actionButton,
                ),
              ),
            ),
          ),
          // 메인 콘텐츠
          Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
