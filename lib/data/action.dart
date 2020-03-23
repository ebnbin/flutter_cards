part of '../data.dart';

//*********************************************************************************************************************
// 事件. 添加一个动画或一个操作到事件队列.

/// 事件管理类.
///
/// 事件队列管理事件. 通过 [add] 添加事件到事件队列, 每个事件结束后从事件队列头部取出事件并处理.
class _ActionManager {
  _ActionManager({
    this.max = -1,
  });

  /// 队列最大数量, 默认为 -1 表示无限制.
  ///
  /// 正在处理的事件已经被移出队列因此不计数. 例如 max = 1 表示除了正在处理的事件外还可以再添加一个事件.
  ///
  /// 改变 max 不会导致已经加入队列的事件被移除. 例如队列中存在 3 个事件时 max = 1 不会移除已经存在的事件.
  int max;

  /// 事件队列.
  final Queue<_Action> actions = Queue();

  /// 是否正在处理事件.
  bool isActing = false;

  /// 尝试从事件队列头部取出事件并处理.
  void handle() {
    if (isActing || actions.isEmpty) {
      return;
    }
    isActing = true;
    actions.removeFirst().begin(this);
  }

  /// 添加事件到事件队列, 并触发一次尝试处理.
  ///
  /// 返回是否成功的添加到队列. 可能因为队列最大数量而无法添加.
  ///
  /// [addFirst] 是否添加到队列头部, 默认为 false 添加到队列尾部.
  bool add(_Action action, {
    bool addFirst = false,
  }) {
    assert(action != null);
    if (max >= 0 && actions.length >= max) {
      return false;
    }
    if (addFirst) {
      actions.addFirst(action);
    } else {
      actions.addLast(action);
    }
    handle();
    return true;
  }

  /// 清除事件队列.
  ///
  /// 正在执行的事件不会被终止.
  ///
  /// 返回被清除的事件数量.
  int clear() {
    int length = actions.length;
    actions.clear();
    return length;
  }
}

/// 事件.
///
/// 事件执行结束时必须调用 [end].
abstract class _Action {
  _ActionManager _actionManager;

  /// 开始执行事件.
  void begin(_ActionManager actionManager) {
    assert(_actionManager == null);
    assert(actionManager != null);
    _actionManager = actionManager;
    onBegin();
  }

  /// 结束执行事件.
  void end() {
    assert(_actionManager != null);
    onEnd();
    _actionManager.isActing = false;
    _actionManager.handle();
    _actionManager = null;
  }

  @protected
  void onBegin() {
  }

  @protected
  void onEnd() {
  }
}

//*********************************************************************************************************************

/// 动画事件.
class _AnimationAction extends _Action {
  _AnimationAction({
    @required
    this.cardData,
    @required
    this.animation,
  }) : assert(cardData != null),
        assert(animation != null),
        super();

  _AnimationAction.sample({
    @required
    CardData cardData,
  }) : cardData = cardData,
        animation = _PropertyAnimation.sample(),
        super();

  _AnimationAction.rotateXYIn({
    @required
    CardData cardData,
  }) : cardData = cardData,
        animation = _PropertyAnimation.rotateXYIn(),
        super();

  final CardData cardData;
  final _PropertyAnimation animation;

  @override
  void onBegin() {
    super.onBegin();
    animation.begin(cardData, () {
      end();
    });
  }
}
