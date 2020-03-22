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
    this.setState,
    @required
    this.tickerProvider,
    @required
    this.duration,
    @required
    this.curve,
    @required
    this.type,
    @required
    this.createProperty,
  }) : assert(cardData != null),
        assert(setState != null),
        assert(tickerProvider != null),
        assert(duration != null),
        assert(curve != null),
        assert(type != null),
        assert(createProperty != null),
        super();

  _AnimationAction.sample({
    @required
    CardData cardData,
    @required
    SetState setState,
    @required
    TickerProvider tickerProvider,
  }) : cardData = cardData,
        setState = setState,
        tickerProvider = tickerProvider,
        duration = 1000,
        curve = Curves.easeInOut,
        type = _AnimationType.forward,
        createProperty = ((double value) {
          return _SampleProperty(value: value);
        }),
        super();

  final CardData cardData;
  final SetState setState;
  final TickerProvider tickerProvider;
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
      vsync: tickerProvider,
    );

    void completed() {
      cardData._resetProperty();
      cardData._updateAnimationTimestamp();
      animationController.dispose();
      end();
      setState();
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
        setState();
      });
    animationController.forward();
  }
}
