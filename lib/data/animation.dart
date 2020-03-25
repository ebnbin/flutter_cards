part of '../data.dart';

//*********************************************************************************************************************

/// 接收 [Animation.value] 计算当前属性值.
class _PropertyCalc {
  const _PropertyCalc(this.calc) : assert(calc != null);

  /// a -> b.
  _PropertyCalc.ab(double a, double b) : this((double value) {
    return a + (b - a) * value;
  });

  /// a -> b -> a.
  _PropertyCalc.aba(double a, double b) : this((double value) {
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
      matrix4Entry32: other.matrix4Entry32 ?? matrix4Entry32,
      translateX: other.translateX ?? translateX,
      translateY: other.translateY ?? translateY,
      rotateX: other.rotateX ?? rotateX,
      rotateY: other.rotateY ?? rotateY,
      rotateZ: other.rotateZ ?? rotateZ,
      scaleX: other.scaleX ?? scaleX,
      scaleY: other.scaleY ?? scaleY,
      elevation: other.elevation ?? elevation,
      radius: other.radius ?? radius,
      opacity: other.opacity ?? opacity,
    );
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
//*********************************************************************************************************************

/// 根据 Animation.value 创建 Property.
typedef _CreateProperty = _Property Function(double value);

/// 动画类型.
enum _AnimationType {
  /// 正序.
  forward,
  /// 正序逆序.
  forwardReverse,
}

class _PropertyAnimation {
  const _PropertyAnimation({
    this.duration,
    this.curve,
    this.type,
    this.runningProperty,
    this.endProperty,
  }) : assert(duration != null),
        assert(curve != null),
        assert(type != null),
        assert(runningProperty != null),
        assert(endProperty != null);

  /// 用于演示.
  _PropertyAnimation.sample() :
        duration = 1000,
        curve = Curves.easeInOut,
        type = _AnimationType.forward,
        runningProperty = ((double value) {
          return _Property(
            rotateY: _PropertyCalc.ab(0.0, 2.0 * pi).calc(value),
            scaleX: _PropertyCalc.aba(1.0, 2.0).calc(value),
            scaleY: _PropertyCalc.aba(1.0, 2.0).calc(value),
            elevation: _PropertyCalc.aba(1.0, 4.0).calc(value),
            radius: _PropertyCalc.aba(4.0, 16.0).calc(value)
          );
        }),
        endProperty = null;
//        endProperty = ((double value) {
//          return _Property();
//        });

  _PropertyAnimation.rotateXYIn({
    double rotateXDegree = 0.0,
    double rotateYDegree = 0.0,
    double scale0 = 0.5,
    double opacity0 = 1.0,
    double elevation0 = 0.5,
  }) :
        duration = 1000,
        curve = Curves.easeInOut,
        type = _AnimationType.forward,
        runningProperty = ((double value) {
          return _Property(
            rotateX: _PropertyCalc.ab(-rotateXDegree / 180.0 * pi, 0.0).calc(value),
            rotateY: _PropertyCalc.ab(-rotateYDegree / 180.0 * pi, 0.0).calc(value),
            scaleX: _PropertyCalc.ab(scale0, 1.0).calc(value),
            scaleY: _PropertyCalc.ab(scale0, 1.0).calc(value),
            opacity: _PropertyCalc.ab(opacity0, 1.0).calc(value),
            elevation: _PropertyCalc.ab(elevation0, 1.0).calc(value),
          );
        }),
        endProperty = null;
//        endProperty = ((double value) {
//          return _Property();
//        });

  _PropertyAnimation.rotateXYOut({
    double rotateXDegree = 0.0,
    double rotateYDegree = 0.0,
    double scale1 = 0.5,
    double opacity1 = 1.0,
    double elevation1 = 0.5,
  }) :
        duration = 1000,
        curve = Curves.easeInOut,
        type = _AnimationType.forward,
        runningProperty = ((double value) {
          return _Property(
            rotateX: _PropertyCalc.ab(0.0, rotateXDegree / 180.0 * pi).calc(value),
            rotateY: _PropertyCalc.ab(0.0, rotateYDegree / 180.0 * pi).calc(value),
            scaleX: _PropertyCalc.ab(1.0, scale1).calc(value),
            scaleY: _PropertyCalc.ab(1.0, scale1).calc(value),
            opacity: _PropertyCalc.ab(1.0, opacity1).calc(value),
            elevation: _PropertyCalc.ab(1.0, elevation1).calc(value),
          );
        }),
        endProperty = null;
//        endProperty = ((double value) {
//          return _Property();
//        });

  _PropertyAnimation.translateXY({
    double translateX1,
    double translateY1,
  }) :
        duration = 1000,
        curve = Curves.easeInOut,
        type = _AnimationType.forward,
        runningProperty = ((double value) {
          return _Property(
            translateX: _PropertyCalc.ab(0, translateX1).calc(value),
            translateY: _PropertyCalc.ab(0, translateY1).calc(value),
          );
        }),
        endProperty = null;
//        endProperty = ((double value) {
//          return _Property();
//        });

  _PropertyAnimation.translateXYIndex({
    Map<String, dynamic> unit,
    int indexX = 0,
    int indexY = 0,
  }) : this.translateXY(
    translateX1: unit['cardSize'] * indexX,
    translateY1: unit['cardSize'] * indexY,
  );

  _PropertyAnimation.translateLeft({
    Map<String, dynamic> unit,
  }) : this.translateXYIndex(
    unit: unit,
    indexX: -1,
  );

  _PropertyAnimation.translateRight({
    Map<String, dynamic> unit,
  }) : this.translateXYIndex(
    unit: unit,
    indexX: 1,
  );

  _PropertyAnimation.translateTop({
    Map<String, dynamic> unit,
  }) : this.translateXYIndex(
    unit: unit,
    indexY: -1,
  );

  _PropertyAnimation.translateBottom({
    Map<String, dynamic> unit,
  }) : this.translateXYIndex(
    unit: unit,
    indexY: 1,
  );

  final int duration;
  final Curve curve;
  final _AnimationType type;
  final _CreateProperty runningProperty;
  final _CreateProperty endProperty;

  void begin(_CardData cardData, VoidCallback onEnd) {
    AnimationController animationController = AnimationController(
      duration: Duration(
        milliseconds: duration,
      ),
      vsync: cardData.gameData.callback,
    );
    CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: curve,
    );

    void completed() {
      if (endProperty != null) {
        cardData._property = cardData._property.update(endProperty.call(curvedAnimation.value));
      }
//      cardData.updateAnimationTimestamp();
      animationController.dispose();
      onEnd?.call();
      cardData.gameData.callback.setState(() {
      });
    }

    curvedAnimation
      ..addStatusListener((AnimationStatus status) {
        switch (type) {
          case _AnimationType.forward:
            switch (status) {
              case AnimationStatus.dismissed:
                break;
              case AnimationStatus.forward:
                break;
              case AnimationStatus.reverse:
                break;
              case AnimationStatus.completed:
                completed();
                break;
            }
            break;
          case _AnimationType.forwardReverse:
            switch (status) {
              case AnimationStatus.dismissed:
                completed();
                break;
              case AnimationStatus.forward:
                break;
              case AnimationStatus.reverse:
                break;
              case AnimationStatus.completed:
                animationController.reverse();
                break;
            }
            break;
        }
      })
      ..addListener(() {
        cardData._property = cardData._property.update(runningProperty(curvedAnimation.value));
        cardData.gameData.callback.setState(() {
        });
      });
    animationController.forward();
  }

  _Action action(_CardData cardData) {
    return _Action.animation(cardData: cardData, animation: this);
  }

  void act(_CardData cardData, {
    VoidCallback onEnd,
  }) {
    begin(cardData, onEnd);
  }
}
