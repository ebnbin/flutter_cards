part of '../data.dart';

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

/// 绘制 debug 图层.
class _DebugPainter extends CustomPainter {
  _DebugPainter(this._onPaint);

  final void Function(Canvas canvas, Size size, Paint paint) _onPaint;

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    _onPaint(canvas, size, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 网格标尺.

/// 网格标尺.
class _Metric {
  /// Padding 网格数.
  static const int paddingGrid = 1;
  /// Core 网格数 (不包含 padding).
  static const int coreNoPaddingGrid = 60;
  /// Header footer 网格数 (不包含 padding).
  static const int headerFooterNoPaddingGrid = 15;
  /// Core 网格数.
  static const int coreGrid = coreNoPaddingGrid + paddingGrid * 2;
  /// Header footer 网格数.
  static const int headerFooterGrid = headerFooterNoPaddingGrid + paddingGrid * 2;
  /// 安全网格数.
  static const int safeGrid = coreGrid + headerFooterGrid * 2;
  /// 方格数 to 方格网格数.
  ///
  /// Key 范围 3, 4, 5.
  static final Map<int, int> squareGridMap = Map<int, int>.unmodifiable({
    3: coreNoPaddingGrid ~/ 3,
    4: coreNoPaddingGrid ~/ 4,
    5: coreNoPaddingGrid ~/ 5,
  });

  const _Metric(
      this.screenRect,
      this.safeScreenRect,
      this.isVertical,
      this.horizontalSafeGrid,
      this.verticalSafeGrid,
      this.gridSize,
      this.safeRect,
      this.coreRect,
      this.coreNoPaddingRect,
      this.headerRect,
      this.footerRect,
      this.headerUnsafeRect,
      this.footerUnsafeRect,
      this.squareSizeMap,
      this.debugPainter,
      this.debugForegroundPainter,
      );

  final Rect screenRect;
  final Rect safeScreenRect;
  final bool isVertical;
  final int horizontalSafeGrid;
  final int verticalSafeGrid;
  final double gridSize;
  final Rect safeRect;
  final Rect coreRect;
  final Rect coreNoPaddingRect;
  final Rect headerRect;
  final Rect footerRect;
  final Rect headerUnsafeRect;
  final Rect footerUnsafeRect;
  final Map<int, double> squareSizeMap;
  final CustomPainter debugPainter;
  final CustomPainter debugForegroundPainter;

  /// 在 [_Game.build] 中调用.
  static void build(_Game game, BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    if (game.metricSizeCache == mediaQueryData.size && game.metricPaddingCache == mediaQueryData.padding) {
      return;
    }

    /// 屏幕矩形.
    Rect screenRect = Rect.fromLTWH(
      0.0,
      0.0,
      mediaQueryData.size.width,
      mediaQueryData.size.height,
    );
    /// 安全屏幕矩形.
    Rect safeScreenRect = Rect.fromLTRB(
      screenRect.left + mediaQueryData.padding.left,
      screenRect.top + mediaQueryData.padding.top,
      screenRect.right - mediaQueryData.padding.right,
      screenRect.bottom - mediaQueryData.padding.bottom,
    );
    /// 是否竖屏.
    ///
    /// [MediaQueryData.orientation].
    bool isVertical = screenRect.width <= screenRect.height;
    /// 水平方向安全网格数.
    int horizontalSafeGrid = isVertical ? coreGrid : safeGrid;
    /// 垂直方向安全网格数.
    int verticalSafeGrid = isVertical ? safeGrid : coreGrid;
    /// 网格尺寸.
    double gridSize = min(safeScreenRect.width / horizontalSafeGrid, safeScreenRect.height / verticalSafeGrid);
    /// 安全矩形.
    Rect safeRect = Rect.fromCenter(
      center: safeScreenRect.center,
      width: horizontalSafeGrid * gridSize,
      height: verticalSafeGrid * gridSize,
    );
    /// Core 矩形.
    Rect coreRect = Rect.fromCenter(
      center: safeRect.center,
      width: coreGrid * gridSize,
      height: coreGrid * gridSize,
    );
    /// Core 矩形 (不包含 padding).
    Rect coreNoPaddingRect = Rect.fromLTRB(
      coreRect.left + paddingGrid * gridSize,
      coreRect.top + paddingGrid * gridSize,
      coreRect.right - paddingGrid * gridSize,
      coreRect.bottom - paddingGrid * gridSize,
    );
    /// Header 矩形.
    Rect headerRect = Rect.fromLTWH(
      safeRect.left,
      safeRect.top,
      isVertical ? safeRect.width : (coreRect.left - safeRect.left),
      isVertical ? (coreRect.top - safeRect.top) : safeRect.height,
    );
    /// Footer 矩形.
    Rect footerRect = Rect.fromLTWH(
      isVertical ? headerRect.left : coreRect.right,
      isVertical ? coreRect.bottom : headerRect.top,
      headerRect.width,
      headerRect.height,
    );
    /// Header 矩形 (包含屏幕不安全区域).
    Rect headerUnsafeRect = Rect.fromLTWH(
      screenRect.left,
      screenRect.top,
      isVertical ? screenRect.width : (coreRect.left - screenRect.left),
      isVertical ? (coreRect.top - screenRect.top) : screenRect.height,
    );
    /// Footer 矩形 (包含屏幕不安全区域).
    Rect footerUnsafeRect = Rect.fromLTWH(
      isVertical ? headerUnsafeRect.left : coreRect.right,
      isVertical ? coreRect.bottom : headerUnsafeRect.top,
      isVertical ? headerUnsafeRect.width : (screenRect.right - coreRect.right),
      isVertical ? (screenRect.bottom - coreRect.bottom) : headerUnsafeRect.height,
    );
    /// 方格数 to 方格尺寸.
    ///
    /// Key 范围 3, 4, 5.
    Map<int, double> squareSizeMap = Map<int, double>.unmodifiable({
      3: squareGridMap[3] * gridSize,
      4: squareGridMap[4] * gridSize,
      5: squareGridMap[5] * gridSize,
    });
    /// 绘制 debug 背景.
    CustomPainter debugPainter = _DebugPainter((canvas, size, paint) {
      paint.style = PaintingStyle.fill;
      paint.color = Colors.blue;
      canvas.drawRect(screenRect, paint);
      paint.color = Colors.green;
      canvas.drawRect(safeRect, paint);
      paint.color = Colors.red;
      canvas.drawRect(coreRect, paint);
    });
    /// 绘制 debug 前景.
    CustomPainter debugForegroundPainter = _DebugPainter((canvas, size, paint) {
      paint.style = PaintingStyle.stroke;
      paint.color = Colors.cyan;
      // 行.
      for (int rowIndex = 0; rowIndex <= verticalSafeGrid; rowIndex++) {
        canvas.drawLine(
          Offset(safeRect.left, safeRect.top + rowIndex * gridSize),
          Offset(safeRect.right, safeRect.top + rowIndex * gridSize),
          paint,
        );
      }
      // 列.
      for (int columnIndex = 0; columnIndex <= horizontalSafeGrid; columnIndex++) {
        canvas.drawLine(
          Offset(safeRect.left + columnIndex * gridSize, safeRect.top),
          Offset(safeRect.left + columnIndex * gridSize, safeRect.bottom),
          paint,
        );
      }
      Map<int, Color> colorMap = {
        3: Colors.yellow,
        4: Colors.purple,
        5: Colors.white,
      };
      for (int square = 3; square <= 5; square++) {
        paint.color = colorMap[square];
        // 行.
        for (int rowIndex = 0; rowIndex <= square; rowIndex++) {
          canvas.drawLine(
            Offset(coreNoPaddingRect.left, coreNoPaddingRect.top + rowIndex * squareSizeMap[square]),
            Offset(coreNoPaddingRect.right, coreNoPaddingRect.top + rowIndex * squareSizeMap[square]),
            paint,
          );
        }
        // 列.
        for (int columnIndex = 0; columnIndex <= square; columnIndex++) {
          canvas.drawLine(
            Offset(coreNoPaddingRect.left + columnIndex * squareSizeMap[square], coreNoPaddingRect.top),
            Offset(coreNoPaddingRect.left + columnIndex * squareSizeMap[square], coreNoPaddingRect.bottom),
            paint,
          );
        }
      }
    });

    game.metricSizeCache = mediaQueryData.size;
    game.metricPaddingCache = mediaQueryData.padding;
    game.metric = _Metric(
      screenRect,
      safeScreenRect,
      isVertical,
      horizontalSafeGrid,
      verticalSafeGrid,
      gridSize,
      safeRect,
      coreRect,
      coreNoPaddingRect,
      headerRect,
      footerRect,
      headerUnsafeRect,
      footerUnsafeRect,
      squareSizeMap,
      debugPainter,
      debugForegroundPainter,
    );
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
class _Animation<T extends _Card> {
  _Animation(this.card, {
    this.duration = 0,
    this.beginDelay = 0,
    this.endDelay = 0,
    this.curve = Curves.linear,
    this.onAnimating,
    this.onBegin,
    this.onHalf,
    this.onEnd,
  });

  /// 动画应用到的卡片.
  final T card;
  /// 动画时长.
  final int duration;
  /// [onBegin] 之前延迟.
  final int beginDelay;
  /// [onEnd] 之后延迟.
  final int endDelay;
  final Curve curve;
  /// 动画过程中回调
  final void Function(T card, double value) onAnimating;
  /// 动画开始时回调 (只会回调一次).
  final void Function(T card) onBegin;
  /// 动画过半时回调 (只会回调一次).
  final void Function(T card) onHalf;
  /// 动画结束时回调 (只会回调一次).
  final void Function(T card) onEnd;

  /// 动画是否过半.
  bool _half = false;

  /// 开始动画.
  ///
  /// [endCallback] 动画结束后, 包括 [endDelay] 延迟后回调.
  void begin({
    VoidCallback endCallback,
  }) {
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
              onEnd?.call(card);
              card.screen.game.callback.notifyStateChanged();
              animationController.dispose();
              Future.delayed(Duration(
                milliseconds: endDelay,
              ), () {
                _half = false;
                endCallback?.call();
              });
              break;
          }
        })
        ..addListener(() {
          if (!_half && curvedAnimation.value >= 0.5) {
            _half = true;
            onHalf?.call(card);
            card.screen.game.callback.notifyStateChanged();
          }
          onAnimating?.call(card, curvedAnimation.value);
          card.screen.game.callback.notifyStateChanged();
        });
      onBegin?.call(card);
      card.screen.game.callback.notifyStateChanged();
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
