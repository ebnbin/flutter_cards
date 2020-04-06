part of '../data.dart';

//*********************************************************************************************************************

/// 接收 [Animation.value] 计算当前属性值.
class _PropertyCalc {
  const _PropertyCalc(this.calc) : assert(calc != null);

  /// a -> b.
  _PropertyCalc.ab(double a, double b) : this((value) {
    return a + (b - a) * value;
  });

  /// a -> b -> a.
  _PropertyCalc.aba(double a, double b) : this((value) {
    return a + (b - a) * (1.0 - (2.0 * value - 1.0).abs());
  });

  final double Function(double value) calc;
}

//*********************************************************************************************************************

/// 可见的 3d 旋转角度. -360, -180, 180, 360.
enum _VisibleAngle {
  counterClockwise360,
  counterClockwise180,
  clockwise180,
  clockwise360,
}

extension _VisibleAngleExtension on _VisibleAngle {
  double get value {
    switch (this) {
      case _VisibleAngle.counterClockwise360:
        return -2.0 * pi;
      case _VisibleAngle.counterClockwise180:
        return -pi;
      case _VisibleAngle.clockwise180:
        return pi;
      case _VisibleAngle.clockwise360:
        return 2.0 * pi;
      default:
        return 0.0;
    }
  }
}

/// 不可见的 3d 旋转角度. -270, -90, 90, 270.
enum _InvisibleAngle {
  counterClockwise270,
  counterClockwise90,
  clockwise90,
  clockwise270,
}

extension _InvisibleAngleExtension on _InvisibleAngle {
  double get value {
    switch (this) {
      case _InvisibleAngle.counterClockwise270:
        return -1.5 * pi;
      case _InvisibleAngle.counterClockwise90:
        return -0.5 * pi;
      case _InvisibleAngle.clockwise90:
        return 0.5 * pi;
      case _InvisibleAngle.clockwise270:
        return 1.5 * pi;
      default:
        return 0.0;
    }
  }
}

//*********************************************************************************************************************

/// 卡片动画.
class _CardAnimation {
  const _CardAnimation({
    this.beginDelay,
    this.endDelay,
    @required
    this.duration,
    this.curve,
    this.beginProperty,
    this.animatingProperty,
    this.endProperty,
  }) : assert(duration != null && duration >= 0);

  /// 用于演示.
  _CardAnimation.sample() : this(
    duration: 1000,
    curve: Curves.easeInOut,
    animatingProperty: (card, value) {
      card.property.rotateY = _PropertyCalc.ab(0.0, 2.0 * pi).calc(value);
      card.property.scaleX = _PropertyCalc.aba(1.0, 2.0).calc(value);
      card.property.scaleY = _PropertyCalc.aba(1.0, 2.0).calc(value);
      card.property.elevation = _PropertyCalc.aba(1.0, 4.0).calc(value);
      card.property.radius = _PropertyCalc.aba(4.0, 16.0).calc(value);
    },
//    endProperty: (value) {
//      return _Property.def();
//    },
  );

  /// 移动.
  ///
  /// [x] 水平方向偏移量.
  /// [y] 垂直方向偏移量.
  _CardAnimation.move({
    int beginDelay,
    int endDelay,
    int duration = 1000,
    double x,
    double y,
    void Function(_Card card, double value) beginProperty,
    void Function(_Card card, double value) endProperty,
  }) : this(
    beginDelay: beginDelay,
    endDelay: endDelay,
    duration: duration,
    curve: Curves.easeInOut,
    beginProperty: beginProperty,
    animatingProperty: (card, value) {
      card.property.translateX = _PropertyCalc.ab(0.0, x ?? 0.0).calc(value);
      card.property.translateY = _PropertyCalc.ab(0.0, y ?? 0.0).calc(value);
    },
    endProperty: endProperty,
  );

  /// 移动网格.
  _CardAnimation.moveGrid({
    int beginDelay,
    int endDelay,
    int duration = 1000,
    int x,
    int y,
    void Function(_Card card, double value) beginProperty,
    void Function(_Card card, double value) endProperty,
  }) : this(
    beginDelay: beginDelay,
    endDelay: endDelay,
    duration: duration,
    curve: Curves.easeInOut,
    beginProperty: beginProperty,
    animatingProperty: (card, value) {
      card.property.translateX = _PropertyCalc.ab(0.0, _Metric.get().gridSize * (x ?? 0.0)).calc(value);
      card.property.translateY = _PropertyCalc.ab(0.0, _Metric.get().gridSize * (y ?? 0.0)).calc(value);
    },
    endProperty: endProperty,
  );

  /// 移动核心卡片.
  _CardAnimation.moveCoreCard({
    int beginDelay,
    int endDelay,
    int duration = 1000,
    int x,
    int y,
    void Function(_Card card, double value) beginProperty,
    void Function(_Card card, double value) endProperty,
  }) : this(
    beginDelay: beginDelay,
    endDelay: endDelay,
    duration: duration,
    curve: Curves.easeInOut,
    beginProperty: beginProperty,
    animatingProperty: (card, value) {
      card.property.translateX = _PropertyCalc.ab(0.0, _Metric.get().bodyCardSize * (x ?? 0.0)).calc(value);
      card.property.translateY = _PropertyCalc.ab(0.0, _Metric.get().bodyCardSize * (y ?? 0.0)).calc(value);
    },
    endProperty: endProperty,
  );

  /// 翻转进入.
  ///
  /// [angleX] 水平方向翻转角度.
  /// [angleY] 垂直方向翻转角度.
  _CardAnimation.flipIn({
    int beginDelay,
    int endDelay,
    int duration = 1000,
    _InvisibleAngle angleX,
    _InvisibleAngle angleY,
    void Function(_Card card, double value) beginProperty,
    void Function(_Card card, double value) endProperty,
  }) : this(
    beginDelay: beginDelay,
    endDelay: endDelay,
    duration: duration,
    curve: Curves.easeOut,
    beginProperty: beginProperty,
    animatingProperty: (card, value) {
      card.property.rotateX = _PropertyCalc.ab(-angleX.value, 0.0).calc(value);
      card.property.rotateY = _PropertyCalc.ab(-angleY.value, 0.0).calc(value);
      card.property.scaleX = _PropertyCalc.ab(0.5, 1.0).calc(value);
      card.property.scaleY = _PropertyCalc.ab(0.5, 1.0).calc(value);
      card.property.elevation = _PropertyCalc.ab(0.5, 1.0).calc(value);
    },
    endProperty: endProperty,
  );

  /// 翻转退出.
  _CardAnimation.flipOut({
    int beginDelay,
    int endDelay,
    int duration = 1000,
    _InvisibleAngle angleX,
    _InvisibleAngle angleY,
    void Function(_Card card, double value) beginProperty,
    void Function(_Card card, double value) endProperty,
  }) : this(
    beginDelay: beginDelay,
    endDelay: endDelay,
    duration: duration,
    curve: Curves.easeIn,
    beginProperty: beginProperty,
    animatingProperty: (card, value) {
      card.property.rotateX = _PropertyCalc.ab(0.0, angleX.value).calc(value);
      card.property.rotateX = _PropertyCalc.ab(0.0, angleX.value).calc(value);
      card.property.rotateY = _PropertyCalc.ab(0.0, angleY.value).calc(value);
      card.property.scaleX = _PropertyCalc.ab(1.0, 0.5).calc(value);
      card.property.scaleY = _PropertyCalc.ab(1.0, 0.5).calc(value);
      card.property.elevation = _PropertyCalc.ab(1.0, 0.5).calc(value);
    },
    endProperty: endProperty,
  );

  /// 动画开始前延迟.
  final int beginDelay;
  /// 动画结束后延迟.
  final int endDelay;
  /// 动画时长.
  final int duration;
  final Curve curve;
  final void Function(_Card card, double value) beginProperty;
  /// 动画过程中设置属性.
  final void Function(_Card card, double value) animatingProperty;
  /// 动画结束时设置属性.
  final void Function(_Card card, double value) endProperty;

  /// 开始动画.
  void begin(_Card card, {
    VoidCallback endCallback,
  }) {
    assert(card != null);
    Future.delayed(Duration(
      milliseconds: max(0, beginDelay ?? 0),
    ), () {
      AnimationController animationController = AnimationController(
        duration: Duration(
          milliseconds: duration,
        ),
        vsync: card.game.callback,
      );
      CurvedAnimation curvedAnimation = CurvedAnimation(
        parent: animationController,
        curve: curve ?? Curves.linear,
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
              endProperty?.call(card, curvedAnimation.value);
              card.game.callback.setState(() {
              });
              animationController.dispose();
              Future.delayed(Duration(
                milliseconds: max(0, endDelay ?? 0),
              ), () {
                endCallback?.call();
              });
              break;
          }
        })
        ..addListener(() {
          animatingProperty?.call(card, curvedAnimation.value);
          card.game.callback.setState(() {
          });
        });
      beginProperty?.call(card, curvedAnimation.value);
      card.game.callback.setState(() {
      });
      animationController.forward();
    });
  }

  /// 转化为 [_Action].
  _Action action(_Card card) {
    return _Action((action) {
      begin(card, endCallback: () {
        action.end();
      },);
    });
  }
}
