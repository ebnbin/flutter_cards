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
  const _Property({
    this.matrix4Entry32,
    this.translateX,
    this.translateY,
    this.rotateX,
    this.rotateY,
    this.rotateZ,
    this.scaleX,
    this.scaleY,
    this.elevation,
    this.radius,
    this.opacity,
  });

  /// 非 null 默认值.
  const _Property.def({
    double matrix4Entry32 = 0.004,
    double translateX = 0.0,
    double translateY = 0.0,
    double rotateX = 0.0,
    double rotateY = 0.0,
    double rotateZ = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    double elevation = 1.0,
    double radius = 4.0,
    double opacity = 1.0,
  }) : this(
    matrix4Entry32: matrix4Entry32,
    translateX: translateX,
    translateY: translateY,
    rotateX: rotateX,
    rotateY: rotateY,
    rotateZ: rotateZ,
    scaleX: scaleX,
    scaleY: scaleY,
    elevation: elevation,
    radius: radius,
    opacity: opacity,
  );

  /// Matrix4.setEntry(3, 2, value);
  final double matrix4Entry32;

  final double translateX;
  final double translateY;
  final double rotateX;
  final double rotateY;
  final double rotateZ;
  final double scaleX;
  final double scaleY;

  @override
  Matrix4 get transform => Matrix4.identity()
    ..setEntry(3, 2, matrix4Entry32 ?? 0.0)
    ..translate(translateX ?? 0.0, translateY ?? 0.0)
    ..rotateX(rotateX ?? 0.0)
    ..rotateY(rotateY ?? 0.0)
    ..rotateZ(rotateZ ?? 0.0)
    ..scale(scaleX ?? 1.0, scaleY ?? 1.0);

  @override
  final double elevation;
  @override
  final double radius;
  @override
  final double opacity;

  /// 使用 other 中不为 null 的属性值更新 this 中对应的属性值, 返回新的 _Property.
  _Property update(_Property other) {
    return _Property(
      matrix4Entry32: other?.matrix4Entry32 ?? matrix4Entry32,
      translateX: other?.translateX ?? translateX,
      translateY: other?.translateY ?? translateY,
      rotateX: other?.rotateX ?? rotateX,
      rotateY: other?.rotateY ?? rotateY,
      rotateZ: other?.rotateZ ?? rotateZ,
      scaleX: other?.scaleX ?? scaleX,
      scaleY: other?.scaleY ?? scaleY,
      elevation: other?.elevation ?? elevation,
      radius: other?.radius ?? radius,
      opacity: other?.opacity ?? opacity,
    );
  }
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
    animatingProperty: (value) {
      return _Property(
        rotateY: _PropertyCalc.ab(0.0, 2.0 * pi).calc(value),
        scaleX: _PropertyCalc.aba(1.0, 2.0).calc(value),
        scaleY: _PropertyCalc.aba(1.0, 2.0).calc(value),
        elevation: _PropertyCalc.aba(1.0, 4.0).calc(value),
        radius: _PropertyCalc.aba(4.0, 16.0).calc(value),
      );
    },
    endProperty: (value) {
      return _Property.def();
    },
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
    animatingProperty: (value) {
      return _Property(
        translateX: _PropertyCalc.ab(0.0, x ?? 0.0).calc(value),
        translateY: _PropertyCalc.ab(0.0, y ?? 0.0).calc(value),
      );
    },
  );

  /// 移动网格.
  _PropertyAnimation.moveGrid({
    int beginDelay,
    int endDelay,
    int duration = 1000,
    @required
    Map<Metric, dynamic> metrics,
    int x,
    int y,
  }) : this.move(
    beginDelay: beginDelay,
    endDelay: endDelay,
    duration: duration,
    x: metrics[Metric.gridSize] * (x ?? 0),
    y: metrics[Metric.gridSize] * (y ?? 0),
  );

  /// 移动核心卡片.
  _PropertyAnimation.moveCoreCard({
    int beginDelay,
    int endDelay,
    int duration = 1000,
    @required
    Map<Metric, dynamic> metrics,
    int x,
    int y,
  }) : this.move(
    beginDelay: beginDelay,
    endDelay: endDelay,
    duration: duration,
    x: metrics[Metric.coreCardSize] * (x ?? 0),
    y: metrics[Metric.coreCardSize] * (y ?? 0),
  );

  /// 移动 header footer 卡片.
  _PropertyAnimation.moveHeaderFooterCard({
    int beginDelay,
    int endDelay,
    int duration = 1000,
    @required
    Map<Metric, dynamic> metrics,
    int x,
    int y,
  }) : this.move(
    beginDelay: beginDelay,
    endDelay: endDelay,
    duration: duration,
    x: metrics[Metric.headerFooterCardSize] * (x ?? 0),
    y: metrics[Metric.headerFooterCardSize] * (y ?? 0),
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
    animatingProperty: (value) {
      return _Property(
        rotateX: _PropertyCalc.ab(-_invisibleAngle(angleX), 0.0).calc(value),
        rotateY: _PropertyCalc.ab(-_invisibleAngle(angleY), 0.0).calc(value),
        scaleX: _PropertyCalc.ab(0.5, 1.0).calc(value),
        scaleY: _PropertyCalc.ab(0.5, 1.0).calc(value),
        elevation: _PropertyCalc.ab(0.5, 1.0).calc(value),
      );
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
    animatingProperty: (value) {
      return _Property(
        rotateX: _PropertyCalc.ab(0.0, _invisibleAngle(angleX)).calc(value),
        rotateY: _PropertyCalc.ab(0.0, _invisibleAngle(angleY)).calc(value),
        scaleX: _PropertyCalc.ab(1.0, 0.5).calc(value),
        scaleY: _PropertyCalc.ab(1.0, 0.5).calc(value),
        elevation: _PropertyCalc.ab(1.0, 0.5).calc(value),
      );
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
  final _Property Function(double value) animatingProperty;
  /// 动画结束时设置属性.
  final _Property Function(double value) endProperty;

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
              card.updateProperty(endProperty?.call(curvedAnimation.value));
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
          card.updateProperty(animatingProperty?.call(curvedAnimation.value));
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
