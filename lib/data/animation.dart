part of '../data.dart';

//*********************************************************************************************************************

/// 根据 Animation.value 创建 Property.
typedef _CreateProperty = Property Function(double value);

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

  _PropertyAnimation.sample() :
        duration = 2000,
        curve = Curves.easeInOut,
        type = _AnimationType.forward,
        runningProperty = ((double value) {
          return Property._sample(value: value);
        }),
        endProperty = ((double value) {
          return Property._();
        });

  _PropertyAnimation.rotateXYIn() :
        duration = 2000,
        curve = Curves.easeInOut,
        type = _AnimationType.forward,
        runningProperty = ((double value) {
          return Property._rotateXYIn(
            value: value,
            rotateYDegree: 270.0,
          );
        }),
        endProperty = ((double value) {
          return Property._();
        });

  final int duration;
  final Curve curve;
  final _AnimationType type;
  final _CreateProperty runningProperty;
  final _CreateProperty endProperty;

  void begin(CardData cardData, VoidCallback onEnd) {
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
      cardData._property = endProperty(curvedAnimation.value);
      cardData._updateAnimationTimestamp();
      animationController.dispose();
      onEnd();
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
}
