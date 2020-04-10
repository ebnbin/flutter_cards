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

/// 可见的 rotateX, rotateY 旋转角度. -360, -180, 180, 360.
enum _VisibleRotateXY {
  counterClockwise360,
  counterClockwise180,
  clockwise180,
  clockwise360,
}

extension _VisibleRotateXYExtension on _VisibleRotateXY {
  double get value {
    switch (this) {
      case _VisibleRotateXY.counterClockwise360:
        return -2.0 * pi;
      case _VisibleRotateXY.counterClockwise180:
        return -pi;
      case _VisibleRotateXY.clockwise180:
        return pi;
      case _VisibleRotateXY.clockwise360:
        return 2.0 * pi;
      default:
        return 0.0;
    }
  }
}

/// 不可见的 rotateX, rotateY 旋转角度. -270, -90, 90, 270.
enum _InvisibleRotateXY {
  counterClockwise270,
  counterClockwise90,
  clockwise90,
  clockwise270,
}

extension _InvisibleRotateXYExtension on _InvisibleRotateXY {
  double get value {
    switch (this) {
      case _InvisibleRotateXY.counterClockwise270:
        return -1.5 * pi;
      case _InvisibleRotateXY.counterClockwise90:
        return -0.5 * pi;
      case _InvisibleRotateXY.clockwise90:
        return 0.5 * pi;
      case _InvisibleRotateXY.clockwise270:
        return 1.5 * pi;
      default:
        return 0.0;
    }
  }
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
    this.endCallback,
  });

  /// 用于演示.
  static _Animation<_GridCard> sample(_GridCard card) {
    return _Animation<_GridCard>(card,
      duration: 1000,
      curve: Curves.easeInOut,
      onAnimating: (card, value) {
        card.rotateY = _AnimationCalc.ab(0.0, _VisibleRotateXY.clockwise360.value).calc(value);
        card.scaleX = _AnimationCalc.aba(1.0, 2.0).calc(value);
        card.scaleY = _AnimationCalc.aba(1.0, 2.0).calc(value);
        card.elevation = _AnimationCalc.aba(1.0, 4.0).calc(value);
        card.radius = _AnimationCalc.aba(4.0, 16.0).calc(value);
      },
      onEnd: (card) {
        card.rotateY = 0.0;
      },
    );
  }

  /// 精灵卡片移动.
  static _Animation<_SpriteCard> spriteMove(_SpriteCard card, {
    int beginDelay = 0,
    int endDelay = 0,
    @required
    _LTRB ltrb,
  }) {
    return _Animation<_SpriteCard>(card,
      duration: 500,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeInOut,
      onAnimating: (card, value) {
        if (value < 0.5) {
          card.translateX = _AnimationCalc.ab(0.0, _Metric.get().coreCardSize * ltrb.x).calc(value);
          card.translateY = _AnimationCalc.ab(0.0, _Metric.get().coreCardSize * ltrb.y).calc(value);
        } else {
          card.translateX = _AnimationCalc.ab(-_Metric.get().coreCardSize * ltrb.x, 0.0).calc(value);
          card.translateY = _AnimationCalc.ab(-_Metric.get().coreCardSize * ltrb.y, 0.0).calc(value);
        }
      },
      onHalf: (card) {
        card.rowIndex += ltrb.y;
        card.columnIndex += ltrb.x;
        card.translateX = _AnimationCalc.ab(-_Metric.get().coreCardSize * ltrb.x, 0.0).calc(0.5);
        card.translateY = _AnimationCalc.ab(-_Metric.get().coreCardSize * ltrb.y, 0.0).calc(0.5);
      },
    );
  }

  /// 精灵卡片进入.
  static _Animation<_SpriteCard> spriteEnter(_SpriteCard card, {
    int duration = 500,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_SpriteCard>(card,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeIn,
      onAnimating: (card, value) {
        card.rotateY = _AnimationCalc.ab(_InvisibleRotateXY.clockwise90.value, 0.0).calc(value);
        card.scaleX = _AnimationCalc.ab(0.5, 1.0).calc(value);
        card.scaleY = _AnimationCalc.ab(0.5, 1.0).calc(value);
        card.elevation = _AnimationCalc.ab(0.5, 1.0).calc(value);
      },
      onBegin: (card) {
        card.visible = true;
        card.rotateY = _InvisibleRotateXY.clockwise90.value;
        card.scaleX = 0.5;
        card.scaleY = 0.5;
        card.elevation = 0.5;
      },
    );
  }

  /// 精灵卡片退出.
  static _Animation<_SpriteCard> spriteExit(_SpriteCard card, {
    int duration = 500,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_SpriteCard>(card,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeOut,
      onAnimating: (card, value) {
        card.rotateY = _AnimationCalc.ab(0.0, _InvisibleRotateXY.counterClockwise90.value).calc(value);
        card.scaleX = _AnimationCalc.ab(1.0, 0.5).calc(value);
        card.scaleY = _AnimationCalc.ab(1.0, 0.5).calc(value);
        card.elevation = _AnimationCalc.ab(1.0, 0.5).calc(value);
      },
      onEnd: (card) {
        card.visible = false;
        card.rotateY = _InvisibleRotateXY.counterClockwise90.value;
        card.scaleX = 0.5;
        card.scaleY = 0.5;
        card.elevation = 0.5;
      },
    );
  }

  /// 精灵卡片第一次进入.
  static _Animation<_SpriteCard> spriteFirstEnter(_SpriteCard card) {
    double rotateY = _random.nextListItem(<double>[
      _InvisibleRotateXY.clockwise90.value,
      _InvisibleRotateXY.clockwise270.value,
    ]);
    return _Animation<_SpriteCard>(card,
      duration: _random.nextIntFromTo(500, 1000),
      beginDelay: _random.nextIntFromTo(0, 500),
      curve: Curves.easeOut,
      onAnimating: (card, value) {
        card.rotateY = _AnimationCalc.ab(rotateY, 0.0).calc(value);
        card.scaleX = _AnimationCalc.ab(0.5, 1.0).calc(value);
        card.scaleY = _AnimationCalc.ab(0.5, 1.0).calc(value);
        card.elevation = _AnimationCalc.ab(0.5, 1.0).calc(value);
      },
      onBegin: (card) {
        card.visible = true;
        card.rotateY = rotateY;
        card.scaleX = 0.5;
        card.scaleY = 0.5;
        card.elevation = 0.5;
      },
    );
  }

  /// 精灵卡片最后一次退出.
  static _Animation<_SpriteCard> spriteLastExit(_SpriteCard card, {
    VoidCallback endCallback,
  }) {
    double rotateY = _random.nextListItem(<double>[
      _InvisibleRotateXY.counterClockwise90.value,
      _InvisibleRotateXY.counterClockwise270.value,
    ]);
    return _Animation<_SpriteCard>(card,
      duration: _random.nextIntFromTo(500, 1000),
      beginDelay: _random.nextIntFromTo(0, 500),
      curve: Curves.easeIn,
      onAnimating: (card, value) {
        card.rotateY = _AnimationCalc.ab(0.0, rotateY).calc(value);
        card.scaleX = _AnimationCalc.ab(1.0, 0.5).calc(value);
        card.scaleY = _AnimationCalc.ab(1.0, 0.5).calc(value);
        card.elevation = _AnimationCalc.ab(1.0, 0.5).calc(value);
      },
      onEnd: (card) {
        card.visible = false;
        card.rotateY = rotateY;
        card.scaleX = 0.5;
        card.scaleY = 0.5;
        card.elevation = 0.5;
      },
      endCallback: endCallback,
    );
  }

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
  /// 动画结束后, 包括 [endDelay] 延迟后回调.
  final VoidCallback endCallback;

  /// 动画是否过半.
  bool _half = false;

  /// 开始动画.
  void begin() {
    Future.delayed(Duration(
      milliseconds: beginDelay,
    ), () {
      AnimationController animationController = AnimationController(
        duration: Duration(
          milliseconds: duration,
        ),
        vsync: _Game.get().callback,
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
              _Game.get().callback.setState(() {
              });
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
            _Game.get().callback.setState(() {
            });
          }
          onAnimating?.call(card, curvedAnimation.value);
          _Game.get().callback.setState(() {
          });
        });
      onBegin?.call(card);
      _Game.get().callback.setState(() {
      });
      animationController.forward();
    });
  }
}
