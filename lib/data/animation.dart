part of '../data.dart';

//*********************************************************************************************************************

/// 根据 [Animation.value] 计算当前值.
class _AnimationCalc {
  _AnimationCalc(this.calc);

  /// a -> b.
  _AnimationCalc.ab(double a, double b) : this((value) {
    return a + (b - a) * value;
  });

  /// a -> b -> a.
  _AnimationCalc.aba(double a, double b) : this((value) {
    return a + (b - a) * (1.0 - (2.0 * value - 1.0).abs());
  });

  final double Function(double value) calc;
}

//*********************************************************************************************************************

/// 卡片动画.
class _Animation<T extends _Card> {
  _Animation(this.card, {
    this.duration = 0,
    this.beginDelay = 0,
    this.endDelay = 0,
    this.curve = Curves.linear,
    this.onAnimating,
    this.onBegin,
    this.onHalf,
    this.onEnd,
  });

  /// 动画应用到的卡片.
  final T card;
  /// 动画时长.
  final int duration;
  /// [onBegin] 之前延迟.
  final int beginDelay;
  /// [onEnd] 之后延迟.
  final int endDelay;
  final Curve curve;
  /// 动画过程中回调.
  final void Function(T card, double value) onAnimating;
  /// 动画开始时回调 (只会回调一次).
  final void Function(T card) onBegin;
  /// 动画过半时回调 (只会回调一次).
  final void Function(T card) onHalf;
  /// 动画结束时回调 (只会回调一次).
  final void Function(T card) onEnd;

  /// 动画是否过半.
  bool _half = false;

  /// 开始动画.
  ///
  /// [endCallback] 动画结束后, 包括 [endDelay] 延迟后回调.
  void begin({
    VoidCallback endCallback,
  }) {
    Future.delayed(Duration(
      milliseconds: beginDelay,
    ), () {
      AnimationController animationController = AnimationController(
        duration: Duration(
          milliseconds: duration,
        ),
        vsync: card.screen.game.callback,
      );
      CurvedAnimation curvedAnimation = CurvedAnimation(
        parent: animationController,
        curve: curve,
      );
      curvedAnimation
        ..addStatusListener((status) {
          switch (status) {
            case AnimationStatus.dismissed:
              break;
            case AnimationStatus.forward:
              break;
            case AnimationStatus.reverse:
              break;
            case AnimationStatus.completed:
              onEnd?.call(card);
              card.screen.game.callback.notifyStateChanged();
              animationController.dispose();
              Future.delayed(Duration(
                milliseconds: endDelay,
              ), () {
                _half = false;
                endCallback?.call();
              });
              break;
          }
        })
        ..addListener(() {
          if (!_half && curvedAnimation.value >= 0.5) {
            _half = true;
            onHalf?.call(card);
            card.screen.game.callback.notifyStateChanged();
          }
          onAnimating?.call(card, curvedAnimation.value);
          card.screen.game.callback.notifyStateChanged();
        });
      onBegin?.call(card);
      card.screen.game.callback.notifyStateChanged();
      animationController.forward();
    });
  }

  /// 转化为 [_Action].
  _Action action() {
    return _Action((action) {
      begin(endCallback: () {
        action.end();
      },);
    });
  }
}
