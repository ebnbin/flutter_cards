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

/// 属性.
class _Property implements Property {
  _Property({
    @required
    this.grid,
    this.matrix4Entry32 = 0.004,
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.rotateX = 0.0,
    this.rotateY = 0.0,
    this.rotateZ = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.elevation = 1.0,
    this.radius = 4.0,
    this.opacity = 1.0,
    this.visible = true,
    this.margin = 4.0,
    this.color = Colors.white,
  });

  void reset() {
    translateX = 0.0;
    translateY = 0.0;
    rotateX = 0.0;
    rotateY = 0.0;
    rotateZ = 0.0;
    scaleX = 1.0;
    scaleY = 1.0;
    elevation = 1.0;
    radius = 4.0;
    opacity = 1.0;
  }

  _Grid grid;

  /// Matrix4.setEntry(3, 2, value);
  double matrix4Entry32;

  double translateX;
  double translateY;
  double rotateX;
  double rotateY;
  double rotateZ;
  double scaleX;
  double scaleY;

  @override
  Matrix4 get transform => Matrix4.identity()
    ..setEntry(3, 2, matrix4Entry32 ?? 0.0)
    ..translate(translateX ?? 0.0, translateY ?? 0.0)
    ..rotateX(rotateX ?? 0.0)
    ..rotateY(rotateY ?? 0.0)
    ..rotateZ(rotateZ ?? 0.0)
    ..scale(scaleX ?? 1.0, scaleY ?? 1.0);

  @override
  double elevation;

  /// 范围 0 ~ 5.
  int get zIndex {
    if (elevation < 1.0) {
      return 0;
    }
    if (elevation == 1.0) {
      return 1;
    }
    if (elevation > 4.0) {
      return 5;
    }
    return elevation.ceil();
  }

  @override
  double radius;
  @override
  double opacity;

  bool visible;

  @override
  bool Function(int zIndex) get zIndexVisible {
    assert(zIndex >= 0 && zIndex <= 5);
    return (zIndex) {
      return visible && this.zIndex == zIndex;
    };
  }

  @override
  double margin;

  @override
  Color color;
}

//*********************************************************************************************************************

/// 可见的 3d 旋转角度. -360, -180, 180, 360.
enum _VisibleAngle {
  counterClockwise360,
  counterClockwise180,
  clockwise180,
  clockwise360,
}

double _visibleAngle(_VisibleAngle visibleAngle) {
  switch (visibleAngle) {
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

/// 不可见的 3d 旋转角度. -270, -90, 90, 270.
enum _InvisibleAngle {
  counterClockwise270,
  counterClockwise90,
  clockwise90,
  clockwise270,
}

double _invisibleAngle(_InvisibleAngle invisibleAngle) {
  switch (invisibleAngle) {
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

//*********************************************************************************************************************

/// 属性动画.
class _PropertyAnimation {
  const _PropertyAnimation({
    this.beginDelay,
    this.endDelay,
    @required
    this.duration,
    this.curve,
    this.animatingProperty,
    this.endProperty,
  }) : assert(duration != null && duration >= 0);

  /// 用于演示.
  _PropertyAnimation.sample() : this(
    duration: 1000,
    curve: Curves.easeInOut,
    animatingProperty: (property, value) {
      property.rotateY = _PropertyCalc.ab(0.0, 2.0 * pi).calc(value);
      property.scaleX = _PropertyCalc.aba(1.0, 2.0).calc(value);
      property.scaleY = _PropertyCalc.aba(1.0, 2.0).calc(value);
      property.elevation = _PropertyCalc.aba(1.0, 4.0).calc(value);
      property.radius = _PropertyCalc.aba(4.0, 16.0).calc(value);
    },
//    endProperty: (value) {
//      return _Property.def();
//    },
  );

  /// 移动.
  ///
  /// [x] 水平方向偏移量.
  /// [y] 垂直方向偏移量.
  _PropertyAnimation.move({
    int beginDelay,
    int endDelay,
    int duration = 1000,
    double x,
    double y,
  }) : this(
    beginDelay: beginDelay,
    endDelay: endDelay,
    duration: duration,
    curve: Curves.easeInOut,
    animatingProperty: (property, value) {
      property.translateX = _PropertyCalc.ab(0.0, x ?? 0.0).calc(value);
      property.translateY = _PropertyCalc.ab(0.0, y ?? 0.0).calc(value);
    },
  );

  /// 移动网格.
  _PropertyAnimation.moveGrid({
    int beginDelay,
    int endDelay,
    int duration = 1000,
    @required
    _Metric metric,
    int x,
    int y,
  }) : this.move(
    beginDelay: beginDelay,
    endDelay: endDelay,
    duration: duration,
    x: metric.gridSize * (x ?? 0),
    y: metric.gridSize * (y ?? 0),
  );

  /// 移动核心卡片.
  _PropertyAnimation.moveCoreCard({
    int beginDelay,
    int endDelay,
    int duration = 1000,
    @required
    _Metric metric,
    int x,
    int y,
  }) : this.move(
    beginDelay: beginDelay,
    endDelay: endDelay,
    duration: duration,
    x: metric.coreCardSize * (x ?? 0),
    y: metric.coreCardSize * (y ?? 0),
  );

  /// 翻转进入.
  ///
  /// [angleX] 水平方向翻转角度.
  /// [angleY] 垂直方向翻转角度.
  _PropertyAnimation.flipIn({
    int beginDelay,
    int endDelay,
    int duration = 1000,
    _InvisibleAngle angleX,
    _InvisibleAngle angleY,
  }) : this(
    beginDelay: beginDelay,
    endDelay: endDelay,
    duration: duration,
    curve: Curves.easeOut,
    animatingProperty: (property, value) {
      property.rotateX = _PropertyCalc.ab(-_invisibleAngle(angleX), 0.0).calc(value);
      property.rotateY = _PropertyCalc.ab(-_invisibleAngle(angleY), 0.0).calc(value);
      property.scaleX = _PropertyCalc.ab(0.5, 1.0).calc(value);
      property.scaleY = _PropertyCalc.ab(0.5, 1.0).calc(value);
      property.elevation = _PropertyCalc.ab(0.5, 1.0).calc(value);
    },
  );

  /// 翻转退出.
  _PropertyAnimation.flipOut({
    int beginDelay,
    int endDelay,
    int duration = 1000,
    _InvisibleAngle angleX,
    _InvisibleAngle angleY,
  }) : this(
    beginDelay: beginDelay,
    endDelay: endDelay,
    duration: duration,
    curve: Curves.easeIn,
    animatingProperty: (property, value) {
      property.rotateX = _PropertyCalc.ab(0.0, _invisibleAngle(angleX)).calc(value);
      property.rotateX = _PropertyCalc.ab(0.0, _invisibleAngle(angleX)).calc(value);
      property.rotateY = _PropertyCalc.ab(0.0, _invisibleAngle(angleY)).calc(value);
      property.scaleX = _PropertyCalc.ab(1.0, 0.5).calc(value);
      property.scaleY = _PropertyCalc.ab(1.0, 0.5).calc(value);
      property.elevation = _PropertyCalc.ab(1.0, 0.5).calc(value);
    },
  );

  /// 动画开始前延迟.
  final int beginDelay;
  /// 动画结束后延迟.
  final int endDelay;
  /// 动画时长.
  final int duration;
  final Curve curve;
  /// 动画过程中设置属性.
  final void Function(_Property property, double value) animatingProperty;
  /// 动画结束时设置属性.
  final void Function(_Property property, double value) endProperty;

  /// 开始动画.
  void begin(_Card card, {
    VoidCallback endCallback,
  }) {
    assert(card != null);
    Future.delayed(Duration(
      milliseconds: max(0, endDelay ?? 0),
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
              endProperty?.call(card._property, curvedAnimation.value);
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
          animatingProperty?.call(card._property, curvedAnimation.value);
          card.game.callback.setState(() {
          });
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
