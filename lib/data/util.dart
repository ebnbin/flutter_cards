part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************
// 列表.

extension _ListExtension<E> on List<E> {
  /// 如果 [value] 不为 null 则 [add].
  void addNotNull(E value) {
    if (value != null) {
      this.add(value);
    }
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************

extension _SizeExtension on Size {
  /// [width] [height] 取短边.
  double shortSize() {
    return min(this.width, this.height);
  }

  /// [width] [height] 取长边.
  double longSize() {
    return max(this.width, this.height);
  }
}

extension _RectExtension on Rect {
  /// [width] [height] 取短边.
  double shortSize() {
    return min(this.width, this.height);
  }

  /// [width] [height] 取长边.
  double longSize() {
    return max(this.width, this.height);
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 方向.

extension _AxisDirectionExtension on AxisDirection {
  /// 水平方向值.
  int get x {
    switch (this) {
      case AxisDirection.up:
        return 0;
      case AxisDirection.right:
        return 1;
      case AxisDirection.down:
        return 0;
      case AxisDirection.left:
        return -1;
      default:
        throw Exception();
    }
  }

  /// 垂直方向值.
  int get y {
    switch (this) {
      case AxisDirection.up:
        return -1;
      case AxisDirection.right:
        return 0;
      case AxisDirection.down:
        return 1;
      case AxisDirection.left:
        return 0;
      default:
        throw Exception();
    }
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 旋转角度.

/// 可见的旋转角度. -360, -180, 180, 360.
enum _VisibleAngle {
  counterClockwise360,
  counterClockwise180,
  clockwise180,
  clockwise360,
}

extension _VisibleAngleExtension on _VisibleAngle {
  /// 值.
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
        throw Exception();
    }
  }
}

/// 不可见的旋转角度. -270, -90, 90, 270.
enum _InvisibleAngle {
  counterClockwise270,
  counterClockwise90,
  clockwise90,
  clockwise270,
}

extension _InvisibleAngleExtension on _InvisibleAngle {
  /// 值.
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
        throw Exception();
    }
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 随机数.

/// 随机数.
final Random _random = Random();

extension _RandomExtension on Random {
  /// 包含 [from] 和 [to].
  int nextIntFromTo(int from, int to) {
    return this.nextInt(to - from + 1) + from;
  }

  /// [center] - [range] 到 [center] + [range].
  int nextIntCenterRange(int center, int range) {
    assert(range >= 0);
    return this.nextIntFromTo(center - range, center + range);
  }

  /// 返回列表中随机的一个 item. 如果列表为空则返回 null.
  T nextListItem<T>(List<T> list) {
    if (list == null || list.isEmpty) {
      return null;
    }
    return list[this.nextInt(list.length)];
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 事件.

/// 事件队列.
class _ActionQueue {
  /// 事件队列. List 中的事件同时开始, list 中的最后一个结束的事件结束时整个 list 事件结束.
  final Queue<List<_Action>> _queue = Queue();

  /// 正在执行的事件.
  List<_Action> _actingActions;

  /// 从队列头部取出事件并处理.
  void _handle() {
    if (_actingActions != null || _queue.isEmpty) {
      return;
    }
    _actingActions = _queue.removeFirst();
    List<_Action>.unmodifiable(_actingActions).forEach((element) {
      element._begin(this);
    });
  }

  /// 添加事件并处理.
  ///
  /// [addFirst] 添加到队列头部或尾部.
  void add(List<_Action> actions, {
    bool addFirst = false,
  }) {
    if (actions == null || actions.isEmpty) {
      return;
    }
    if (addFirst) {
      _queue.addFirst(actions);
    } else {
      _queue.addLast(actions);
    }
    _handle();
  }

  /// 延迟到 [_Action] 被执行时可以访问调用者引用.
  ///
  /// [thisRef] 调用者引用.
  ///
  /// [runnable] 执行后自动结束事件.
  void post<T>(T thisRef, void Function(T thisRef, _Action action) runnable) {
    add([
      _Action.run((action) {
        runnable(action._thisRef, action);
        action._thisRef = null;
      }).._thisRef = thisRef,
    ]);
  }

  /// 只能被 [_Action] 调用.
  void _end(_Action action) {
    if (_actingActions == null || !_actingActions.remove(action)) {
      return;
    }
    if (_actingActions.isEmpty) {
      _actingActions = null;
      _handle();
    }
  }
}

/// 事件.
class _Action {
  _Action(this.onBegin);

  /// 执行 [runnable] 后自动结束事件.
  _Action.run(void Function(_Action action) runnable) : this((action) {
    runnable(action);
    action.end();
  });

  /// 事件开始执行回调.
  final void Function(_Action action) onBegin;

  _ActionQueue _actionQueue;

  /// 只能被 [_ActionQueue] 调用.
  dynamic _thisRef;

  /// 只能被 [_ActionQueue] 调用.
  void _begin(_ActionQueue actionQueue) {
    assert(_actionQueue == null && actionQueue != null);
    _actionQueue = actionQueue;
    onBegin(this);
  }

  /// 事件结束时必需调用.
  void end() {
    assert(_actionQueue != null);
    _actionQueue._end(this);
    _actionQueue = null;
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 动画.

/// 根据 [Animation.value] 计算当前值.
class _ValueCalc {
  _ValueCalc(this.calc);

  /// a -> b.
  _ValueCalc.ab(double a, double b) : this((value) {
    return a + (b - a) * value;
  });

  /// a -> b -> a.
  _ValueCalc.aba(double a, double b) : this((value) {
    return a + (b - a) * (1.0 - (2.0 * value - 1.0).abs());
  });

  final double Function(double value) calc;
}

/// 卡片动画.
///
/// TODO 动画 value < 0.0 或 > 1.0 的情况.
class _Animation<T extends _Card> {
  _Animation(this.card, {
    this.duration = 0,
    this.beginDelay = 0,
    this.endDelay = 0,
    this.curve = Curves.linear,
    @required
    this.listener,
  }) : assert(listener != null);

  /// 动画应用到的卡片.
  final T card;
  /// 动画时长.
  final int duration;
  /// [onBegin] 之前延迟.
  final int beginDelay;
  /// [onEnd] 之后延迟.
  final int endDelay;
  final Curve curve;

  /// 动画监听器.
  ///
  /// [first] 第一次调用时为 true, 只会为 true 一次.
  /// 
  /// [half] 第一次过半调用时为 true, 只会为 true 一次.
  /// 
  /// [last] 最后一次调用时为 true, 只会为 true 一次.
  final void Function(T card, double value, bool first, bool half, bool last) listener;

  /// 动画第一次回调.
  bool _first = false;
  /// 动画第一次过半回调.
  bool _half = false;

  /// 动画开始时 [card.gestureType] 被设置为 [_GestureType.absorb] 禁止手势, 动画结束时恢复.
  _GestureType _gestureType;

  /// 开始动画.
  ///
  /// [endCallback] 动画结束后, 包括 [endDelay] 延迟后回调.
  void begin({
    VoidCallback endCallback,
  }) {
    _gestureType = card.gestureType;
    card.gestureType = _GestureType.absorb;
    card.screen.game.callback.notifyStateChanged();
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
              animationController.dispose();
              Future.delayed(Duration(
                milliseconds: endDelay,
              ), () {
                card.gestureType = _gestureType;
                card.screen.game.callback.notifyStateChanged();
                _first = false;
                _half = false;
                _gestureType = null;
                endCallback?.call();
              });
              break;
          }
        })
        ..addListener(() {
          bool first = !_first;
          if (first) {
            _first = true;
          }
          bool half = !_half && curvedAnimation.value >= 0.5;
          if (half) {
            _half = true;
          }
          bool last = curvedAnimation.status == AnimationStatus.completed;
          listener.call(card, curvedAnimation.value, first, half, last);
          card.screen.game.callback.notifyStateChanged();
        });
      animationController.forward();
    });
  }

  /// 转化为 [_Action].
  _Action action() {
    return _Action((action) {
      begin(endCallback: () {
        action.end();
      });
    });
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 手势.

/// 手势类型.
enum _GestureType {
  /// 正常接收处理手势. 下层 Widget 无法处理.
  normal,
  /// 拦截手势. 自己不处理, 下层 Widget 也无法处理.
  absorb,
  /// 忽略手势. 自己不处理, 下层 Widget 可以处理.
  ignore,
}
