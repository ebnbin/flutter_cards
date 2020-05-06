part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 卡片.
class _Card {
  /// 根据网格定位.
  _Card.grid(this.screen, {
    this.name,
    this.rotateX = 0.0,
    this.rotateY = 0.0,
    this.rotateZ = 0.0,
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    int verticalRowGridIndex = 0,
    int verticalColumnGridIndex = 0,
    int verticalRowGridSpan = 1,
    int verticalColumnGridSpan = 1,
    int horizontalRowGridIndex = 0,
    int horizontalColumnGridIndex = 0,
    int horizontalRowGridSpan = 1,
    int horizontalColumnGridSpan = 1,
    this.zIndex = 1,
    this.visible = true,
    this.dimension = _CardDimension.main,
    this.detail = false,
    this.mainElevation = 2.0,
    this.radiusType = _CardRadiusType.small,
    this.selfOpacity = 1.0,
    this.gestureType = _GestureType.normal,
    this.mainOnTap,
    this.detailOnTap,
    this.mainOnLongPress,
    this.detailOnLongPress,
  }) : this.isCore = false {
    this.verticalRowGridIndex = verticalRowGridIndex;
    this.verticalColumnGridIndex = verticalColumnGridIndex;
    this.verticalRowGridSpan = verticalRowGridSpan;
    this.verticalColumnGridSpan = verticalColumnGridSpan;
    this.horizontalRowGridIndex = horizontalRowGridIndex;
    this.horizontalColumnGridIndex = horizontalColumnGridIndex;
    this.horizontalRowGridSpan = horizontalRowGridSpan;
    this.horizontalColumnGridSpan = horizontalColumnGridSpan;
  }

  /// 根据方格定位.
  _Card.core(this.screen, {
    this.name,
    this.rotateX = 0.0,
    this.rotateY = 0.0,
    this.rotateZ = 0.0,
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    int rowIndex = 0,
    int columnIndex = 0,
    int rowSpan = 1,
    int columnSpan = 1,
    this.zIndex = 1,
    this.visible = true,
    this.dimension = _CardDimension.main,
    this.detail = false,
    this.mainElevation = 2.0,
    this.radiusType = _CardRadiusType.small,
    this.selfOpacity = 1.0,
    this.gestureType = _GestureType.normal,
    this.mainOnTap,
    this.detailOnTap,
    this.mainOnLongPress,
    this.detailOnLongPress,
  }) : this.isCore = true {
    this.rowIndex = rowIndex;
    this.columnIndex = columnIndex;
    this.rowSpan = rowSpan;
    this.columnSpan = columnSpan;
  }

  final _Screen screen;

  _Game get game {
    return screen.game;
  }

  final bool isCore;

  String name;

  double rotateX;
  double rotateY;
  double rotateZ;
  double translateX;
  double translateY;
  double scaleX;
  double scaleY;

  /// 卡片翻转到背面时不显示内容.
  bool backFace() {
    /// 翻转角度是否在卡片背面.
    bool backFace(double rotate) {
      return rotate < _VisibleAngle.counterClockwise360.value ||
          rotate > _InvisibleAngle.counterClockwise270.value && rotate < _InvisibleAngle.counterClockwise90.value ||
          rotate > _InvisibleAngle.clockwise90.value && rotate < _InvisibleAngle.clockwise270.value ||
          rotate > _VisibleAngle.clockwise360.value;
    }
    return backFace(rotateX) || backFace(rotateY);
  }

  //*******************************************************************************************************************

  /// 竖屏网格行.
  int _verticalRowGridIndex;
  /// 竖屏网格列.
  int _verticalColumnGridIndex;
  /// 竖屏网格跨行.
  int _verticalRowGridSpan;
  /// 竖屏网格跨列.
  int _verticalColumnGridSpan;
  /// 横屏网格行.
  int _horizontalRowGridIndex;
  /// 横屏网格列.
  int _horizontalColumnGridIndex;
  /// 横屏网格跨行.
  int _horizontalRowGridSpan;
  /// 横屏网格跨列.
  int _horizontalColumnGridSpan;

  int get verticalRowGridIndex {
//    if (isCore) {
//      throw Exception();
//    }
    return _verticalRowGridIndex;
  }
  set verticalRowGridIndex(int verticalRowGridIndex) {
    if (isCore) {
      throw Exception();
    }
    _verticalRowGridIndex = verticalRowGridIndex;
  }

  int get verticalColumnGridIndex {
//    if (isCore) {
//      throw Exception();
//    }
    return _verticalColumnGridIndex;
  }
  set verticalColumnGridIndex(int verticalColumnGridIndex) {
    if (isCore) {
      throw Exception();
    }
    _verticalColumnGridIndex = verticalColumnGridIndex;
  }

  int get verticalRowGridSpan {
//    if (isCore) {
//      throw Exception();
//    }
    return _verticalRowGridSpan;
  }
  set verticalRowGridSpan(int verticalRowGridSpan) {
    if (isCore) {
      throw Exception();
    }
    _verticalRowGridSpan = verticalRowGridSpan;
  }

  int get verticalColumnGridSpan {
//    if (isCore) {
//      throw Exception();
//    }
    return _verticalColumnGridSpan;
  }
  set verticalColumnGridSpan(int verticalColumnGridSpan) {
    if (isCore) {
      throw Exception();
    }
    _verticalColumnGridSpan = verticalColumnGridSpan;
  }

  int get horizontalRowGridIndex {
//    if (isCore) {
//      throw Exception();
//    }
    return _horizontalRowGridIndex;
  }
  set horizontalRowGridIndex(int horizontalRowGridIndex) {
    if (isCore) {
      throw Exception();
    }
    _horizontalRowGridIndex = horizontalRowGridIndex;
  }

  int get horizontalColumnGridIndex {
//    if (isCore) {
//      throw Exception();
//    }
    return _horizontalColumnGridIndex;
  }
  set horizontalColumnGridIndex(int horizontalColumnGridIndex) {
    if (isCore) {
      throw Exception();
    }
    _horizontalColumnGridIndex = horizontalColumnGridIndex;
  }

  int get horizontalRowGridSpan {
//    if (isCore) {
//      throw Exception();
//    }
    return _horizontalRowGridSpan;
  }
  set horizontalRowGridSpan(int horizontalRowGridSpan) {
    if (isCore) {
      throw Exception();
    }
    _horizontalRowGridSpan = horizontalRowGridSpan;
  }

  int get horizontalColumnGridSpan {
//    if (isCore) {
//      throw Exception();
//    }
    return _horizontalColumnGridSpan;
  }
  set horizontalColumnGridSpan(int horizontalColumnGridSpan) {
    if (isCore) {
      throw Exception();
    }
    _horizontalColumnGridSpan = horizontalColumnGridSpan;
  }

  /// 当前屏幕旋转方向的网格行.
  int get rowGridIndex {
//    if (isCore) {
//      throw Exception();
//    }
    return _Metric.get().isVertical ? _verticalRowGridIndex : _horizontalRowGridIndex;
  }
  set rowGridIndex(int rowGridIndex) {
    if (isCore) {
      throw Exception();
    }
    _verticalRowGridIndex = rowGridIndex;
    _horizontalRowGridIndex = rowGridIndex;
  }

  /// 当前屏幕旋转方向的网格列.
  int get columnGridIndex {
//    if (isCore) {
//      throw Exception();
//    }
    return _Metric.get().isVertical ? _verticalColumnGridIndex : _horizontalColumnGridIndex;
  }
  set columnGridIndex(int columnGridIndex) {
    if (isCore) {
      throw Exception();
    }
    _verticalColumnGridIndex = columnGridIndex;
    _horizontalColumnGridIndex = columnGridIndex;
  }

  /// 当前屏幕旋转方向的网格跨行.
  int get rowGridSpan {
//    if (isCore) {
//      throw Exception();
//    }
    return _Metric.get().isVertical ? _verticalRowGridSpan : _horizontalRowGridSpan;
  }
  set rowGridSpan(int rowGridSpan) {
    if (isCore) {
      throw Exception();
    }
    _verticalRowGridSpan = rowGridSpan;
    _horizontalRowGridSpan = rowGridSpan;
  }

  /// 当前屏幕旋转方向的网格跨列.
  int get columnGridSpan {
//    if (isCore) {
//      throw Exception();
//    }
    return _Metric.get().isVertical ? _verticalColumnGridSpan : _horizontalColumnGridSpan;
  }
  set columnGridSpan(int columnGridSpan) {
    if (isCore) {
      throw Exception();
    }
    _verticalColumnGridSpan = columnGridSpan;
    _horizontalColumnGridSpan = columnGridSpan;
  }

  //*******************************************************************************************************************

  /// 行.
  int get rowIndex {
    if (!isCore) {
      throw Exception();
    }
    int grid = (rowGridIndex - _Metric.paddingGrid - (_Metric.get().isVertical ? _Metric.headerFooterGrid : 0));
    int square = _Metric.squareGridMap[screen.square];
    assert(grid % square == 0);
    return grid ~/ square;
  }
  set rowIndex(int rowIndex) {
    if (!isCore) {
      throw Exception();
    }
    _verticalRowGridIndex = _Metric.squareGridMap[screen.square] * rowIndex + _Metric.paddingGrid +
        _Metric.headerFooterGrid;
    _horizontalRowGridIndex = _Metric.squareGridMap[screen.square] * rowIndex + _Metric.paddingGrid;
  }

  /// 列.
  int get columnIndex {
    if (!isCore) {
      throw Exception();
    }
    int grid = (columnGridIndex - _Metric.paddingGrid - (_Metric.get().isVertical ? 0 : _Metric.headerFooterGrid));
    int square = _Metric.squareGridMap[screen.square];
    assert(grid % square == 0);
    return grid ~/ square;
  }
  set columnIndex(int columnIndex) {
    if (!isCore) {
      throw Exception();
    }
    _verticalColumnGridIndex = _Metric.squareGridMap[screen.square] * columnIndex + _Metric.paddingGrid;
    _horizontalColumnGridIndex = _Metric.squareGridMap[screen.square] * columnIndex + _Metric.paddingGrid +
        _Metric.headerFooterGrid;
  }

  /// 跨行.
  int get rowSpan {
    if (!isCore) {
      throw Exception();
    }
    int grid = rowGridSpan;
    int square = _Metric.squareGridMap[screen.square];
    assert(grid % square == 0);
    return grid ~/ square;
  }
  set rowSpan(int rowSpan) {
    if (!isCore) {
      throw Exception();
    }
    _verticalRowGridSpan = _horizontalRowGridSpan = _Metric.squareGridMap[screen.square] * rowSpan;
  }

  /// 跨列.
  int get columnSpan {
    if (!isCore) {
      throw Exception();
    }
    int grid = columnGridSpan;
    int square = _Metric.squareGridMap[screen.square];
    assert(grid % square == 0);
    return grid ~/ square;
  }
  set columnSpan(int columnSpan) {
    if (!isCore) {
      throw Exception();
    }
    _verticalColumnGridSpan = _horizontalColumnGridSpan = _Metric.squareGridMap[screen.square] * columnSpan;
  }

  //*******************************************************************************************************************

  /// 当前卡片在 [screen.cards] 中的索引.
  int get index {
    return screen.cards.indexOf(this);
  }

  /// [Stack] 中的索引. 数字越大在越上层. 范围 0 ~ 3.
  ///
  /// 0: 在做下沉动画.
  ///
  /// 1: 默认.
  ///
  /// 2: 在做上升动画.
  ///
  /// 3: 在顶层做动画.
  int zIndex;

  /// 是否可见.
  bool visible;

  //*******************************************************************************************************************

  /// 卡片尺寸.
  /// 
  /// 可能因不同尺寸而变化的值: [rect], [marginA], [marginB], [elevation], [radius].
  _CardDimension dimension;

  /// 值为 true 使用 [screen.mainOpacity] 渲染透明度, 值为 false 使用 [screen.detailOpacity] 渲染透明度.
  ///
  /// 与 [dimension] 的 detail 不同的是, 它通常在初始化后不再修改, 表示卡片以哪种面板做为主态, 而 [dimension] 通常在动画中修改.
  ///
  /// 简单来说, false 表示显示详情尺寸卡片时隐藏, true 表示显示详情尺寸卡片时显示.
  final bool detail;

  /// 值为 true 表示当前正在执行详情尺寸动画, [opacity] 始终取 [selfOpacity].
  ///
  /// 在动画中修改.
  bool detailing = false;

  //*******************************************************************************************************************

  /// 主尺寸定位矩形.
  Rect get mainRect {
    return Rect.fromLTWH(
      _Metric.get().safeRect.left + columnGridIndex * _Metric.get().gridSize,
      _Metric.get().safeRect.top + rowGridIndex * _Metric.get().gridSize,
      columnGridSpan * _Metric.get().gridSize,
      rowGridSpan * _Metric.get().gridSize,
    );
  }

  /// 详情尺寸定位矩形.
  Rect get detailRect {
    return _Metric.get().coreNoPaddingRect;
  }

  /// 全屏尺寸定位矩形.
  Rect get fullRect {
    return _Metric.get().screenRect;
  }

  /// 渲染定位矩形.
  Rect get rect {
    switch (dimension) {
      case _CardDimension.main:
        return mainRect;
      case _CardDimension.detail:
        return detailRect;
      case _CardDimension.full:
        return fullRect;
      default:
        throw Exception();
    }
  }

  //*******************************************************************************************************************

  /// 第一层外边距, Material 外层. 两层外边距是为了能更明显地显示 material 阴影.
  ///
  /// 只与 [rect] 相关, 60 分之 1.5. 全屏尺寸时为 0.
  double get marginA {
    switch (dimension) {
      case _CardDimension.main:
      case _CardDimension.detail:
        Rect rect = this.rect;
        return min(rect.width, rect.height) / _Metric.coreNoPaddingGrid * 1.0;
      case _CardDimension.full:
        return 0.0;
      default:
        throw Exception();
    }
  }

  /// 第二层外边距, Material 内层. 两层外边距是为了能更明显地显示 material 阴影.
  ///
  /// 只与 [rect] 相关, 60 分之 0.5. 全屏尺寸时为 0.
  double get marginB {
    switch (dimension) {
      case _CardDimension.main:
      case _CardDimension.detail:
        Rect rect = this.rect;
        return min(rect.width, rect.height) / _Metric.coreNoPaddingGrid * 1.0;
      case _CardDimension.full:
        return 0.0;
      default:
        throw Exception();
    }
  }

  double get borderWidth {
    switch (dimension) {
      case _CardDimension.main:
      case _CardDimension.detail:
        Rect rect = this.rect;
        return min(rect.width, rect.height) / _Metric.coreNoPaddingGrid * 1.0;
      case _CardDimension.full:
        return 0.0;
      default:
        throw Exception();
    }
  }

  /// 内容矩形.
  Rect get contentRect {
    return Rect.fromCenter(
      center: rect.center,
      width: rect.width - (marginA + marginB) * 2.0,
      height: rect.height - (marginA + marginB) * 2.0,
    );
  }

  /// 主尺寸厚度. 与 [zIndex] 相关.
  ///
  /// 0.0 ~ 2.0: 在做下沉动画.
  ///
  /// 2.0: 默认.
  ///
  /// 2.0 ~ 4.0: 在做上升动画.
  double mainElevation;

  /// 渲染厚度.
  double get elevation {
    switch (dimension) {
      case _CardDimension.main:
        return mainElevation;
      case _CardDimension.detail:
        return mainElevation * 4.0;
      case _CardDimension.full:
        return 0.0;
      default:
        throw Exception();
    }
  }

  /// 卡片圆角类型.
  _CardRadiusType radiusType;

  /// 渲染圆角.
  double get radius {
    switch (dimension) {
      case _CardDimension.main:
      case _CardDimension.detail:
        return radiusType.value(contentRect);
      case _CardDimension.full:
        return 0.0;
      default:
        throw Exception();
    }
  }

  /// 自身透明度.
  double selfOpacity;

  /// 渲染透明度.
  double get opacity {
    if (detailing) {
      return selfOpacity;
    }
    if (detail) {
      return screen.detailOpacity * selfOpacity;
    } else {
      return screen.mainOpacity * selfOpacity;
    }
  }

  //*******************************************************************************************************************

  /// 是否正在动画.
  bool animating = false;

  /// 手势类型.
  _GestureType gestureType;

  /// 是否拦截手势.
  bool get absorbPointer {
    /// 动画时拦截手势.
    if (animating) {
      return true;
    }
    return gestureType == _GestureType.absorb;
  }

  /// 是否忽略手势.
  bool get ignorePointer {
    /// 动画时拦截手势.
    if (animating) {
      return false;
    }
    if (opacity <= 0.0) {
      // 透明时忽略手势.
      return true;
    }
    return gestureType == _GestureType.ignore;
  }

  /// 主尺寸点击事件.
  void Function(_Card card) mainOnTap;

  /// 详情尺寸点击事件.
  void Function(_Card card) detailOnTap;

  /// 主尺寸长按事件.
  void Function(_Card card) mainOnLongPress;

  /// 详情尺寸长按事件.
  void Function(_Card card) detailOnLongPress;

  //*******************************************************************************************************************

  void post<T extends _Card>(void Function(T card) runnable) {
    game.actionQueue.post<T>(this, (thisRef) {
      runnable(thisRef);
    });
  }

  //*******************************************************************************************************************

  /// 演示动画.
  _Animation<_Card> animateSample() {
    return _Animation<_Card>(this,
      duration: 800,
      curve: Curves.easeInOut,
      listener: (card, value, first, half, last) {
        if (first) {
          card.zIndex = 2;
        }
        card.rotateY = _ValueCalc.ab(0.0, _VisibleAngle.clockwise360.value).calc(value);
        card.scaleX = _ValueCalc.aba(1.0, 2.0).calc(value);
        card.scaleY = _ValueCalc.aba(1.0, 2.0).calc(value);
        card.mainElevation = _ValueCalc.aba(2.0, 4.0).calc(value);
        if (last) {
          card.zIndex = 1;
          card.rotateY = 0.0;
        }
      },
    );
  }

  /// 主尺寸 -> 详情尺寸动画.
  ///
  /// 逆时针. 前 0.5 时隐藏其他卡片.
  _Animation<_Card> animateMainToDetail({
    int duration = 400,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_Card>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeInOut,
      listener: (card, value, first, half, last) {
        if (first) {
          card.zIndex = 2;
          card.detailing = true;
        }
        if (value < 0.5) {
          card.rotateX = _ValueCalc.ab(0.0, _VisibleAngle.counterClockwise180.value).calc(value);
          card.translateX = _ValueCalc.ab(0.0, card.detailRect.center.dx - card.mainRect.center.dx).calc(value);
          card.translateY = _ValueCalc.ab(0.0, card.detailRect.center.dy - card.mainRect.center.dy).calc(value);
          card.scaleX = _ValueCalc.ab(1.0, card.detailRect.width / card.mainRect.width).calc(value);
          card.scaleY = _ValueCalc.ab(1.0, card.detailRect.height / card.mainRect.height).calc(value);
          // 改变其他所有卡片透明度.
          card.screen.mainOpacity = _ValueCalc.ab(1.0, 0.0).calc(value * 2.0);
        } else {
          card.rotateX = _ValueCalc.ab(_VisibleAngle.clockwise180.value, 0.0).calc(value);
          card.translateX = _ValueCalc.ab(card.mainRect.center.dx - card.detailRect.center.dx, 0.0).calc(value);
          card.translateY = _ValueCalc.ab(card.mainRect.center.dy - card.detailRect.center.dy, 0.0).calc(value);
          card.scaleX = _ValueCalc.ab(card.mainRect.width / card.detailRect.width, 1.0).calc(value);
          card.scaleY = _ValueCalc.ab(card.mainRect.height / card.detailRect.height, 1.0).calc(value);
          // 改变其他所有卡片透明度.
          card.screen.detailOpacity = _ValueCalc.ab(0.0, 1.0).calc(value * 2.0 - 1.0);
        }
        card.mainElevation = _ValueCalc.ab(2.0, 4.0).calc(value);
        if (half) {
          card.dimension = _CardDimension.detail;
          card.screen.mainOpacity = 0.0;
        }
      },
    );
  }

  /// 详情尺寸 -> 主尺寸动画.
  ///
  /// 顺时针. 后 0.5 时显示其他卡片.
  _Animation<_Card> animateDetailToMain({
    int duration = 400,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_Card>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeInOut,
      listener: (card, value, first, half, last) {
        if (value < 0.5) {
          card.rotateX = _ValueCalc.ab(0.0, _VisibleAngle.clockwise180.value).calc(value);
          card.translateX = _ValueCalc.ab(0.0, card.mainRect.center.dx - card.detailRect.center.dx).calc(value);
          card.translateY = _ValueCalc.ab(0.0, card.mainRect.center.dy - card.detailRect.center.dy).calc(value);
          card.scaleX = _ValueCalc.ab(1.0, card.mainRect.width / card.detailRect.width).calc(value);
          card.scaleY = _ValueCalc.ab(1.0, card.mainRect.height / card.detailRect.height).calc(value);
          // 改变其他所有卡片透明度.
          card.screen.detailOpacity = _ValueCalc.ab(1.0, 0.0).calc(value * 2.0);
        } else {
          card.rotateX = _ValueCalc.ab(_VisibleAngle.counterClockwise180.value, 0.0).calc(value);
          card.translateX = _ValueCalc.ab(card.detailRect.center.dx - card.mainRect.center.dx, 0.0).calc(value);
          card.translateY = _ValueCalc.ab(card.detailRect.center.dy - card.mainRect.center.dy, 0.0).calc(value);
          card.scaleX = _ValueCalc.ab(card.detailRect.width / card.mainRect.width, 1.0).calc(value);
          card.scaleY = _ValueCalc.ab(card.detailRect.height / card.mainRect.height, 1.0).calc(value);
          // 改变其他所有卡片透明度.
          card.screen.mainOpacity = _ValueCalc.ab(0.0, 1.0).calc(value * 2.0 - 1.0);
        }
        card.mainElevation = _ValueCalc.ab(4.0, 2.0).calc(value);
        if (half) {
          card.dimension = _CardDimension.main;
          card.screen.detailOpacity = 0.0;
        }
        if (last) {
          card.zIndex = 1;
          card.detailing = false;
        }
      },
    );
  }

  /// 主尺寸 -> 全屏尺寸动画.
  ///
  /// 逆时针.
  _Animation<_Card> animateMainToFull({
    int duration = 800,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_Card>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeInOut,
      listener: (card, value, first, half, last) {
        if (first) {
          card.zIndex = 3;
        }
        if (value < 0.5) {
          card.rotateX = _ValueCalc.ab(0.0, _VisibleAngle.counterClockwise180.value).calc(value);
          card.translateX = _ValueCalc.ab(0.0, card.fullRect.center.dx - card.mainRect.center.dx).calc(value);
          card.translateY = _ValueCalc.ab(0.0, card.fullRect.center.dy - card.mainRect.center.dy).calc(value);
          card.scaleX = _ValueCalc.ab(1.0, card.fullRect.width / card.mainRect.width).calc(value);
          card.scaleY = _ValueCalc.ab(1.0, card.fullRect.height / card.mainRect.height).calc(value);
        } else {
          card.rotateX = _ValueCalc.ab(_VisibleAngle.clockwise180.value, 0.0).calc(value);
          card.translateX = _ValueCalc.ab(card.mainRect.center.dx - card.fullRect.center.dx, 0.0).calc(value);
          card.translateY = _ValueCalc.ab(card.mainRect.center.dy - card.fullRect.center.dy, 0.0).calc(value);
          card.scaleX = _ValueCalc.ab(card.mainRect.width / card.fullRect.width, 1.0).calc(value);
          card.scaleY = _ValueCalc.ab(card.mainRect.height / card.fullRect.height, 1.0).calc(value);
        }
        if (half) {
          card.dimension = _CardDimension.full;
        }
      },
    );
  }

  /// 全屏尺寸 -> 主尺寸动画.
  ///
  /// 逆时针.
  _Animation<_Card> animateFullToMain({
    int duration = 800,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_Card>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeInOut,
      listener: (card, value, first, half, last) {
        if (value < 0.5) {
          card.rotateX = _ValueCalc.ab(0.0, _VisibleAngle.counterClockwise180.value).calc(value);
          card.translateX = _ValueCalc.ab(0.0, card.mainRect.center.dx - card.fullRect.center.dx).calc(value);
          card.translateY = _ValueCalc.ab(0.0, card.mainRect.center.dy - card.fullRect.center.dy).calc(value);
          card.scaleX = _ValueCalc.ab(1.0, card.mainRect.width / card.fullRect.width).calc(value);
          card.scaleY = _ValueCalc.ab(1.0, card.mainRect.height / card.fullRect.height).calc(value);
        } else {
          card.rotateX = _ValueCalc.ab(_VisibleAngle.clockwise180.value, 0.0).calc(value);
          card.translateX = _ValueCalc.ab(card.fullRect.center.dx - card.mainRect.center.dx, 0.0).calc(value);
          card.translateY = _ValueCalc.ab(card.fullRect.center.dy - card.mainRect.center.dy, 0.0).calc(value);
          card.scaleX = _ValueCalc.ab(card.fullRect.width / card.mainRect.width, 1.0).calc(value);
          card.scaleY = _ValueCalc.ab(card.fullRect.height / card.mainRect.height, 1.0).calc(value);
        }
        if (half) {
          card.dimension = _CardDimension.main;
        }
        if (last) {
          card.zIndex = 1;
        }
      },
    );
  }

  /// 颤抖动画, 用于点击了不可点击的卡片.
  _Animation<_Card> animateTremble({
    int duration = 200,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_Card>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeInOut,
      listener: (card, value, first, half, last) {
        if (first) {
          card.zIndex = 0;
        }
        card.rotateY = _ValueCalc.aba(0.0, 1.0 / 8.0 * pi).calc(value);
        card.scaleX = _ValueCalc.aba(1.0, 7.0 / 8.0).calc(value);
        card.scaleY = _ValueCalc.aba(1.0, 7.0 / 8.0).calc(value);
        card.mainElevation = _ValueCalc.aba(2.0, 0.0).calc(value);
        if (last) {
          card.zIndex = 1;
        }
      },
    );
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 卡片尺寸.
enum _CardDimension {
  /// 主尺寸.
  main,
  /// 详情尺寸. 目前始终为 square * square 大卡片.
  detail,
  /// 全屏尺寸. 内容属于全局, 不属于卡片.
  full,
}

//*********************************************************************************************************************

/// 卡片圆角类型.
enum _CardRadiusType {
  /// 直角.
  none,
  /// 小圆角. 2.0 / 56.0.
  small,
  /// 大圆角. 8.0 / 56.0.
  big,
  /// 圆形.
  round,
}

extension _CardRadiusTypeExtensions on _CardRadiusType {
  /// 根据 [rect] 计算圆角值.
  double value(Rect rect) {
    switch (this) {
      case _CardRadiusType.none:
        return 0.0;
      case _CardRadiusType.small:
        return min(rect.width, rect.height) / 56.0 * 2.0;
      case _CardRadiusType.big:
        return min(rect.width, rect.height) / 56.0 * 8.0;
      case _CardRadiusType.round:
        return min(rect.width, rect.height) / 2.0;
      default:
        throw Exception();
    }
  }
}
