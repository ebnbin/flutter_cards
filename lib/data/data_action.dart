part of 'data.dart';

//*********************************************************************************************************************
// 事件. 添加一个动画或一个操作到事件队列.

/// 根据 Animation.value 创建 Property.
typedef _CreateProperty = Property Function(double value);

/// 动画类型.
enum _AnimationType {
  /// 正序.
  forward,
  /// 正序逆序.
  forwardReverse,
}

/// 动画事件.
class _AnimationAction extends util.Action {
  _AnimationAction({
    @required
    this.cardData,
    @required
    this.duration,
    @required
    this.curve,
    @required
    this.type,
    @required
    this.createProperty,
  }) : assert(cardData != null),
        assert(duration != null),
        assert(curve != null),
        assert(type != null),
        assert(createProperty != null),
        super();

  _AnimationAction.sample({
    @required
    CardData cardData,
  }) : cardData = cardData,
        duration = 2000,
        curve = Curves.easeInOut,
        type = _AnimationType.forward,
        createProperty = ((double value) {
          return Property._sample(value: value);
//            return Property._rotateXYIn(
//              value: value,
//              rotateYDegree: 270.0,
//            );
        }),
        super();

  final CardData cardData;
  final int duration;
  final Curve curve;
  final _AnimationType type;
  final _CreateProperty createProperty;

  @override
  void onBegin() {
    super.onBegin();
    AnimationController animationController = AnimationController(
      duration: Duration(
        milliseconds: duration,
      ),
      vsync: cardData.gameData.callback,
    );

    void completed() {
      cardData._resetProperty();
      cardData._updateAnimationTimestamp();
      animationController.dispose();
      end();
      cardData.gameData.callback.setState(() {
      });
    }

    CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: curve,
    );
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
        cardData._property = createProperty(curvedAnimation.value);
        cardData.gameData.callback.setState(() {
        });
      });
    animationController.forward();
  }
}
