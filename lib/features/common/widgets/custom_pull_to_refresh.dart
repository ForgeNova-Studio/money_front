import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 커스텀 Pull-to-Refresh 위젯
///
/// 당긴 위치에서 로딩 인디케이터가 고정되어 회전하고,
/// 로딩이 완료되면 부드럽게 원래 위치로 복귀하는 기능을 제공합니다.
class CustomPullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final double triggerDistance;

  const CustomPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.triggerDistance = 60.0,
  });

  @override
  State<CustomPullToRefresh> createState() => _CustomPullToRefreshState();
}

class _CustomPullToRefreshState extends State<CustomPullToRefresh>
    with TickerProviderStateMixin {
  double _dragOffset = 0.0;
  bool _isRefreshing = false;
  late AnimationController _resetController;
  late Animation<double> _resetAnimation;
  late AnimationController _snapBackController;
  late Animation<double> _snapBackAnimation;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _resetAnimation = Tween<double>(begin: 0, end: 0).animate(_resetController);

    _snapBackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _snapBackAnimation =
        Tween<double>(begin: 0, end: 0).animate(_snapBackController);

    _snapBackController.addListener(() {
      setState(() {
        _dragOffset = _snapBackAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _resetController.dispose();
    _snapBackController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(ScrollUpdateNotification notification) {
    if (_isRefreshing) return;

    // 리스트 상단에서 더 위로 당길 때만 처리 (OverScroll)
    if (notification.metrics.pixels < 0) {
      // 이미 리프레시 중이면 무시
      if (_isRefreshing) return;

      setState(() {
        // 당기는 거리에 저항감(0.5) 부여 및 최대 거리 제한 (triggerDistance * 2)
        _dragOffset = (-notification.metrics.pixels * 0.5)
            .clamp(0.0, widget.triggerDistance * 2.0);
      });
    } else if (notification.metrics.pixels == 0 && _dragOffset > 0) {
      // 당겼다가 다시 위로 올릴 때
      setState(() {
        _dragOffset = 0;
      });
    }
  }

  Future<void> _handleDragEnd() async {
    if (_isRefreshing) return;

    // 드래그가 끝났을 때 임계값 이상이면 리프레시 수행
    if (_dragOffset >= widget.triggerDistance) {
      if (mounted) {
        setState(() {
          _isRefreshing = true;
        });
      }

      // 현재 위치에서 Trigger 위치로 자연스럽게 이동 (Snap Back)
      _snapBackAnimation = Tween<double>(
        begin: _dragOffset,
        end: widget.triggerDistance,
      ).animate(CurvedAnimation(
        parent: _snapBackController,
        curve: Curves.easeOutBack, // 약간의 반동을 주어 자연스럽게
      ));

      _snapBackController.reset();
      await _snapBackController.forward();

      try {
        await widget.onRefresh();
      } catch (e) {
        debugPrint('Refreshing failed: $e');
      } finally {
        if (mounted) {
          _reset();
        }
      }
    } else if (_dragOffset > 0) {
      // 임계값 미만이면 그냥 초기화
      _reset();
    }
  }

  void _reset() {
    // 혹시 실행 중인 애니메이션 정지
    _snapBackController.stop();

    _resetAnimation = Tween<double>(
      begin: _dragOffset,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _resetController,
      curve: Curves.easeOutCubic,
    ));

    _resetController.reset();
    _resetController.forward().then((_) {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
          _dragOffset = 0;
        });
      }
    });

    _resetController.addListener(() {
      setState(() {
        _dragOffset = _resetAnimation.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.color ?? context.appColors.primary;

    return Listener(
      onPointerUp: (_) => _handleDragEnd(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            // debugPrint('ScrollUpdate: ${notification.metrics.pixels}, delta: ${notification.scrollDelta}');
            _handleDragUpdate(notification);
          }
          return false;
        },
        child: Stack(
          children: [
            // 스크롤 가능한 자식 위젯을 아래로 밀어줌
            Transform.translate(
              offset: Offset(0, _dragOffset),
              child: widget.child,
            ),

            // 로딩 인디케이터 컨테이너
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: _dragOffset,
                alignment: Alignment.center,
                child: Opacity(
                  opacity:
                      (_dragOffset / widget.triggerDistance).clamp(0.0, 1.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        // 항상 indeterminate 상태 유지하여 끊김 없는 느낌 제공
                        value: null,
                        strokeWidth: 2.5,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
