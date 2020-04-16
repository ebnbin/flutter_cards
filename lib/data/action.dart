part of '../data.dart';

//*********************************************************************************************************************

/// 事件队列.
class _ActionQueue {
  _ActionQueue({
    this.max = -1,
  });

  /// 队列最大数量. -1 表示不限制. 正在处理的事件已经被移出队列因此不计数.
  final int max;

  /// 事件队列. List 中的事件会被同时执行, list 中的最后一个结束的事件结束时整个 list 事件结束.
  final Queue<List<_Action>> queue = Queue();
  
  /// 正在处理的事件.
  List<_Action> actingActions;
  
  /// 从事件队列头部取出事件并处理.
  void handle() {
    if (actingActions != null || queue.isEmpty) {
      return;
    }
    actingActions = queue.removeFirst();
    List.unmodifiable(actingActions).forEach((element) {
      element.begin(this);
    });
  }

  /// 添加事件, 并尝试处理事件.
  ///
  /// 返回是否成功的添加到队列, 如果事件为空或超过队列最大数量限制则添加失败.
  ///
  /// [addFirst] 添加到队列头部或尾部.
  bool addList(List<_Action> actions, {
    bool addFirst = false,
  }) {
    if (actions == null || actions.isEmpty) {
      return false;
    }
    if (!canAdd()) {
      return false;
    }
    if (addFirst) {
      queue.addFirst(actions);
    } else {
      queue.addLast(actions);
    }
    handle();
    return true;
  }

  bool add(_Action action, {
    bool addFirst = false,
  }) {
    return addList([action],
      addFirst: addFirst,
    );
  }

  /// 只能被 [_Action] 调用.
  void end(_Action action) {
    if (!actingActions.remove(action)) {
      return;
    }
    if (actingActions.isEmpty) {
      actingActions = null;
      handle();
    }
  }

  /// 清除事件队列. 正在执行的事件不会被终止.
  ///
  /// 返回被清除的 list 数量.
  int clear() {
    int length = queue.length;
    queue.clear();
    return length;
  }

  bool canAdd() {
    return max < 0 || queue.length < max;
  }
}

//*********************************************************************************************************************

/// 事件.
class _Action {
  _Action(this.beginCallback);

  /// 执行 [runnable] 后立即结束事件.
  _Action.run(void Function(_Action action) runnable) : this((action) {
    runnable.call(action);
    action.end();
  });

  /// 事件开始执行回调.
  final void Function(_Action action) beginCallback;

  _ActionQueue actionQueue;

  /// 只能被 [_ActionQueue] 调用.
  void begin(_ActionQueue actionQueue) {
    assert(this.actionQueue == null && actionQueue != null);
    this.actionQueue = actionQueue;
    beginCallback?.call(this);
  }

  /// 事件结束时必需调用.
  void end() {
    assert(this.actionQueue != null);
    actionQueue.end(this);
    actionQueue = null;
  }
}
