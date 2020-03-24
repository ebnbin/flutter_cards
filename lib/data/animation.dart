part of '../data.dart';

//*********************************************************************************************************************
// 属性. 描述 Widget 属性在动画时如何变化.

/// 属性计算. 根据 [doubles] 中的多个数据和 Animation.value 计算当前值.
typedef _PropertyCalc = double Function(double value);

/// 属性数据.
///
/// [doubles] 关键帧数据.
///
/// [propertyCalc] 属性计算.
class _PropertyData {
  const _PropertyData({
    this.propertyCalc,
  });

  _PropertyData.calc01({
    double double0 = 0.0,
    double double1 = 0.0,
  }) : this(
    propertyCalc: (double value) {
      return double0 + (double1 - double0) * value;
    },
  );

  _PropertyData.calc010({
    double double0 = 0.0,
    double double1 = 0.0,
  }) : this(
    propertyCalc: (double value) {
      return double0 + (double1 - double0) * (1.0 - (2.0 * value - 1.0).abs());
    },
  );

  final _PropertyCalc propertyCalc;
}

/// 根据 Animation.value 计算属性.
class _Property implements Property {
  const _Property({
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.translateZ = 0.0,
    this.rotateX = 0.0,
    this.rotateY = 0.0,
    this.rotateZ = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.opacity = 1.0,
    this.elevation = 1.0,
    this.radius = 4.0,
  });

  /// Matrix4.setEntry(3, 2, value).
  static final double matrix4Entry32 = 0.005;

  final double translateX;
  final double translateY;
  final double translateZ;
  final double rotateX;
  final double rotateY;
  final double rotateZ;
  final double scaleX;
  final double scaleY;

  @override
  final double opacity;
  @override
  final double elevation;
  @override
  final double radius;

  /// Transform.
  @override
  Matrix4 get transform => Matrix4.identity()
    ..setEntry(3, 2, matrix4Entry32)
    ..translate(translateX, translateY, translateZ)
    ..rotateX(rotateX)
    ..rotateY(rotateY)
    ..rotateZ(rotateZ)
    ..scale(scaleX, scaleY);
}

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
              rotateY: _PropertyData.calc01(
                double0: 0.0,
                double1: 2.0 * pi,
              ).propertyCalc(value),
              scaleX: _PropertyData.calc010(
                double0: 1.0,
                double1: 2.0,
              ).propertyCalc(value),
              scaleY: _PropertyData.calc010(
                double0: 1.0,
                double1: 2.0,
              ).propertyCalc(value),
              elevation: _PropertyData.calc010(
                double0: 1.0,
                double1: 4.0,
              ).propertyCalc(value),
              radius: _PropertyData.calc010(
                double0: 4.0,
                double1: 16.0,
              ).propertyCalc(value)
          );
        }),
        endProperty = ((double value) {
          return _Property();
        });

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
            rotateX: _PropertyData.calc01(
              double0: -rotateXDegree / 180.0 * pi,
              double1: 0.0,
            ).propertyCalc(value),
            rotateY: _PropertyData.calc01(
              double0: -rotateYDegree / 180.0 * pi,
              double1: 0.0,
            ).propertyCalc(value),
            scaleX: _PropertyData.calc01(
              double0: scale0,
              double1: 1.0,
            ).propertyCalc(value),
            scaleY: _PropertyData.calc01(
              double0: scale0,
              double1: 1.0,
            ).propertyCalc(value),
            opacity: _PropertyData.calc01(
              double0: opacity0,
              double1: 1.0,
            ).propertyCalc(value),
            elevation: _PropertyData.calc01(
              double0: elevation0,
              double1: 1.0,
            ).propertyCalc(value),
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
            rotateX: _PropertyData.calc01(
              double0: 0.0,
              double1: rotateXDegree / 180.0 * pi,
            ).propertyCalc(value),
            rotateY: _PropertyData.calc01(
              double0: 0.0,
              double1: rotateYDegree / 180.0 * pi,
            ).propertyCalc(value),
            scaleX: _PropertyData.calc01(
              double0: 1.0,
              double1: scale1,
            ).propertyCalc(value),
            scaleY: _PropertyData.calc01(
              double0: 1.0,
              double1: scale1,
            ).propertyCalc(value),
            opacity: _PropertyData.calc01(
              double0: 1.0,
              double1: opacity1,
            ).propertyCalc(value),
            elevation: _PropertyData.calc01(
              double0: 1.0,
              double1: elevation1,
            ).propertyCalc(value),
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
            translateX: _PropertyData.calc01(
              double0: 0,
              double1: translateX1,
            ).propertyCalc(value),
            translateY: _PropertyData.calc01(
              double0: 0,
              double1: translateY1,
            ).propertyCalc(value),
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
        cardData._property = endProperty.call(curvedAnimation.value);
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
        cardData._property = runningProperty(curvedAnimation.value);
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
