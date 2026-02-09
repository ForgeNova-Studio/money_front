import 'package:flutter/material.dart';

/// 스와이프하여 숨겨진 액션 버튼을 드러내는 위젯
///
/// 왼쪽으로 스와이프하면 오른쪽에서 액션 버튼이 나타나며,
/// 스와이프 정도에 따라 버튼이 스케일/페이드 애니메이션으로 등장합니다.
///
/// 주요 기능:
/// - 수평 스와이프 제스처 감지
/// - 스냅 애니메이션 (절반 이상 스와이프 시 완전히 열림)
/// - 빠른 스와이프(Fling) 감지
/// - 외부에서 `reset()` 호출하여 닫기 가능 (GlobalKey 사용)
///
/// 파라미터:
/// - [child]: 메인 콘텐츠 위젯
/// - [actionButton]: 스와이프 시 드러나는 액션 버튼 위젯
/// - [enabled]: 스와이프 활성화 여부 (기본값: true)
/// - [revealDistance]: 최대 스와이프 거리 (기본값: 92)
/// - [onRevealActiveChanged]: 스와이프 상태 변경 콜백
///
/// 사용 예시:
/// ```dart
/// final _swipeKey = GlobalKey<SwipeToRevealState>();
///
/// SwipeToReveal(
///   key: _swipeKey,
///   actionButton: IconButton(
///     icon: Icon(Icons.delete),
///     onPressed: () => handleDelete(),
///   ),
///   child: ListTile(title: Text('Item')),
/// )
///
/// // 외부에서 닫기
/// _swipeKey.currentState?.reset();
/// ```
class SwipeToReveal extends StatefulWidget {
  const SwipeToReveal({
    super.key,
    required this.child,
    required this.actionButton,
    this.enabled = true,
    this.revealDistance = 92,
    this.onRevealActiveChanged,
  });

  final Widget child;
  final Widget actionButton;
  final bool enabled;
  final double revealDistance;
  final ValueChanged<bool>? onRevealActiveChanged;

  @override
  State<SwipeToReveal> createState() => SwipeToRevealState();
}

class SwipeToRevealState extends State<SwipeToReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragExtent = 0;
  bool _isRevealActive = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _animation = _controller.drive(Tween<double>(begin: 0, end: 0));
    _controller.addListener(() {
      setState(() => _dragExtent = _animation.value);
      _notifyRevealActive();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 스와이프 상태를 원래 위치로 리셋
  void reset() {
    _animateTo(0);
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
    _notifyRevealActive();
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

  void _notifyRevealActive() {
    final next = _dragExtent.abs() > 1;
    if (next != _isRevealActive) {
      _isRevealActive = next;
      widget.onRevealActiveChanged?.call(next);
    }
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
