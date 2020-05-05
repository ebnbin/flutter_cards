part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 卡片. 根据网格定位.
class _Card {
  _Card(this.screen, {
    this.name,
    this.rotateX = 0.0,
    this.rotateY = 0.0,
    this.rotateZ = 0.0,
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.verticalRowGridIndex = 0,
    this.verticalColumnGridIndex = 0,
    this.verticalRowGridSpan = 1,
    this.verticalColumnGridSpan = 1,
    this.horizontalRowGridIndex = 0,
    this.horizontalColumnGridIndex = 0,
    this.horizontalRowGridSpan = 1,
    this.horizontalColumnGridSpan = 1,
    this.zIndex = 1,
    this.visible = true,
    this.dimension = _CardDimension.main,
    this.vice = false,
    this.vicing = false,
    this.mainElevation = 2.0,
    this.radiusType = _CardRadiusType.small,
    this.mainOpacity = 1.0,
    this.gestureType = _GestureType.normal,
    this.onTap,
    this.onLongPress,
  });

  final _Screen screen;

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
  int verticalRowGridIndex;
  /// 竖屏网格列.
  int verticalColumnGridIndex;
  /// 竖屏网格跨行.
  int verticalRowGridSpan;
  /// 竖屏网格跨列.
  int verticalColumnGridSpan;
  /// 横屏网格行.
  int horizontalRowGridIndex;
  /// 横屏网格列.
  int horizontalColumnGridIndex;
  /// 横屏网格跨行.
  int horizontalRowGridSpan;
  /// 横屏网格跨列.
  int horizontalColumnGridSpan;

  /// 当前屏幕旋转方向的网格行.
  int get rowGridIndex {
    return _Metric.get().isVertical ? verticalRowGridIndex : horizontalRowGridIndex;
  }
  set rowGridIndex(int rowGridIndex) {
    verticalRowGridIndex = rowGridIndex;
    horizontalRowGridIndex = rowGridIndex;
  }

  /// 当前屏幕旋转方向的网格列.
  int get columnGridIndex {
    return _Metric.get().isVertical ? verticalColumnGridIndex : horizontalColumnGridIndex;
  }
  set columnGridIndex(int columnGridIndex) {
    verticalColumnGridIndex = columnGridIndex;
    horizontalColumnGridIndex = columnGridIndex;
  }

  /// 当前屏幕旋转方向的网格跨行.
  int get rowGridSpan {
    return _Metric.get().isVertical ? verticalRowGridSpan : horizontalRowGridSpan;
  }
  set rowGridSpan(int rowGridSpan) {
    verticalRowGridSpan = rowGridSpan;
    horizontalRowGridSpan = rowGridSpan;
  }

  /// 当前屏幕旋转方向的网格跨列.
  int get columnGridSpan {
    return _Metric.get().isVertical ? verticalColumnGridSpan : horizontalColumnGridSpan;
  }
  set columnGridSpan(int columnGridSpan) {
    verticalColumnGridSpan = columnGridSpan;
    horizontalColumnGridSpan = columnGridSpan;
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

  /// 值为 false 表示 [screen.viceOpacity] 为 0.0 时显示, 为 1.0 时隐藏, 值为 true 时相反.
  ///
  /// 简单来说, false 表示显示副尺寸卡片时隐藏, true 表示显示副尺寸卡片时显示.
  bool vice;

  /// 值为 true 表示当前正在执行副尺寸动画, [opacity] 始终取 [mainOpacity].
  bool vicing;

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

  /// 副尺寸定位矩形.
  Rect get viceRect {
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
      case _CardDimension.vice:
        return viceRect;
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
      case _CardDimension.vice:
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
      case _CardDimension.vice:
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
      case _CardDimension.vice:
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
      case _CardDimension.vice:
        return radiusType.value(contentRect);
      case _CardDimension.full:
        return 0.0;
      default:
        throw Exception();
    }
  }

  /// 自身透明度.
  double mainOpacity;

  /// 渲染透明度.
  double get opacity {
    if (vicing) {
      return mainOpacity;
    }
    return (vice ? screen.viceOpacity : (1.0 - screen.viceOpacity)) * mainOpacity;
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

  /// 点击事件.
  void Function(_Card card) onTap;

  /// 长按事件.
  void Function(_Card card) onLongPress;

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

  /// 主尺寸 -> 副尺寸动画.
  ///
  /// 逆时针. 前 0.5 时隐藏其他卡片.
  _Animation<_Card> animateMainToVice({
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
          card.vicing = true;
        }
        if (value < 0.5) {
          card.rotateX = _ValueCalc.ab(0.0, _VisibleAngle.counterClockwise180.value).calc(value);
          card.translateX = _ValueCalc.ab(0.0, card.viceRect.center.dx - card.mainRect.center.dx).calc(value);
          card.translateY = _ValueCalc.ab(0.0, card.viceRect.center.dy - card.mainRect.center.dy).calc(value);
          card.scaleX = _ValueCalc.ab(1.0, card.viceRect.width / card.mainRect.width).calc(value);
          card.scaleY = _ValueCalc.ab(1.0, card.viceRect.height / card.mainRect.height).calc(value);
          // 改变其他所有卡片透明度.
          card.screen.viceOpacity = _ValueCalc.ab(0.0, 1.0).calc(value * 2.0);
        } else {
          card.rotateX = _ValueCalc.ab(_VisibleAngle.clockwise180.value, 0.0).calc(value);
          card.translateX = _ValueCalc.ab(card.mainRect.center.dx - card.viceRect.center.dx, 0.0).calc(value);
          card.translateY = _ValueCalc.ab(card.mainRect.center.dy - card.viceRect.center.dy, 0.0).calc(value);
          card.scaleX = _ValueCalc.ab(card.mainRect.width / card.viceRect.width, 1.0).calc(value);
          card.scaleY = _ValueCalc.ab(card.mainRect.height / card.viceRect.height, 1.0).calc(value);
        }
        card.mainElevation = _ValueCalc.ab(2.0, 4.0).calc(value);
        if (half) {
          card.dimension = _CardDimension.vice;
          card.screen.viceOpacity = 1.0;
        }
      },
    );
  }

  /// 副尺寸 -> 主尺寸动画.
  ///
  /// 顺时针. 后 0.5 时显示其他卡片.
  _Animation<_Card> animateViceToMain({
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
          card.translateX = _ValueCalc.ab(0.0, card.mainRect.center.dx - card.viceRect.center.dx).calc(value);
          card.translateY = _ValueCalc.ab(0.0, card.mainRect.center.dy - card.viceRect.center.dy).calc(value);
          card.scaleX = _ValueCalc.ab(1.0, card.mainRect.width / card.viceRect.width).calc(value);
          card.scaleY = _ValueCalc.ab(1.0, card.mainRect.height / card.viceRect.height).calc(value);
        } else {
          card.rotateX = _ValueCalc.ab(_VisibleAngle.counterClockwise180.value, 0.0).calc(value);
          card.translateX = _ValueCalc.ab(card.viceRect.center.dx - card.mainRect.center.dx, 0.0).calc(value);
          card.translateY = _ValueCalc.ab(card.viceRect.center.dy - card.mainRect.center.dy, 0.0).calc(value);
          card.scaleX = _ValueCalc.ab(card.viceRect.width / card.mainRect.width, 1.0).calc(value);
          card.scaleY = _ValueCalc.ab(card.viceRect.height / card.mainRect.height, 1.0).calc(value);
          // 改变其他所有卡片透明度.
          card.screen.viceOpacity = _ValueCalc.ab(1.0, 0.0).calc(value * 2.0 - 1.0);
        }
        card.mainElevation = _ValueCalc.ab(4.0, 2.0).calc(value);
        if (half) {
          card.dimension = _CardDimension.main;
        }
        if (last) {
          card.zIndex = 1;
          card.vicing = false;
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

  //*******************************************************************************************************************

  @override
  String toString() {
    return '$index';
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 通过方格定位的卡片.
class _CoreCard extends _Card {
  _CoreCard(_Screen screen, {
    String name,
    double rotateX = 0.0,
    double rotateY = 0.0,
    double rotateZ = 0.0,
    double translateX = 0.0,
    double translateY = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    int zIndex = 1,
    bool visible = true,
    _CardDimension dimension = _CardDimension.main,
    bool vice = false,
    bool vicing = false,
    double mainOpacity = 1.0,
    _GestureType gestureType = _GestureType.normal,
    void Function(_Card card) onTap,
    void Function(_Card card) onLongPress,
    int rowIndex = 0,
    int columnIndex = 0,
    int rowSpan = 1,
    int columnSpan = 1,
    double mainElevation = 2.0,
    _CardRadiusType radiusType = _CardRadiusType.small,
  }) : super(screen,
    name: name,
    rotateX: rotateX,
    rotateY: rotateY,
    rotateZ: rotateZ,
    translateX: translateX,
    translateY: translateY,
    scaleX: scaleX,
    scaleY: scaleY,
    zIndex: zIndex,
    visible: visible,
    dimension: dimension,
    vice: vice,
    vicing: vicing,
    mainOpacity: mainOpacity,
    gestureType: gestureType,
    onTap: onTap,
    onLongPress: onLongPress,
    mainElevation: mainElevation,
    radiusType: radiusType,
  ) {
    this.rowIndex = rowIndex;
    this.columnIndex = columnIndex;
    this.rowSpan = rowSpan;
    this.columnSpan = columnSpan;
  }

  set verticalRowGridIndex(int verticalRowGridIndex) {
    throw Exception();
  }
  set verticalColumnGridIndex(int verticalColumnGridIndex) {
    throw Exception();
  }
  set verticalRowGridSpan(int verticalRowGridSpan) {
    throw Exception();
  }
  set verticalColumnGridSpan(int verticalColumnGridSpan) {
    throw Exception();
  }
  set horizontalRowGridIndex(int horizontalRowGridIndex) {
    throw Exception();
  }
  set horizontalColumnGridIndex(int horizontalColumnGridIndex) {
    throw Exception();
  }
  set horizontalRowGridSpan(int horizontalRowGridSpan) {
    throw Exception();
  }
  set horizontalColumnGridSpan(int horizontalColumnGridSpan) {
    throw Exception();
  }

  /// 行.
  int get rowIndex {
    int grid = (rowGridIndex - _Metric.paddingGrid - (_Metric.get().isVertical ? _Metric.headerFooterGrid : 0));
    int square = _Metric.squareGridMap[screen.square];
    assert(grid % square == 0);
    return grid ~/ square;
  }
  set rowIndex(int rowIndex) {
    super.verticalRowGridIndex = _Metric.squareGridMap[screen.square] * rowIndex + _Metric.paddingGrid +
        _Metric.headerFooterGrid;
    super.horizontalRowGridIndex = _Metric.squareGridMap[screen.square] * rowIndex + _Metric.paddingGrid;
  }

  /// 列.
  int get columnIndex {
    int grid = (columnGridIndex - _Metric.paddingGrid - (_Metric.get().isVertical ? 0 : _Metric.headerFooterGrid));
    int square = _Metric.squareGridMap[screen.square];
    assert(grid % square == 0);
    return grid ~/ square;
  }
  set columnIndex(int columnIndex) {
    super.verticalColumnGridIndex = _Metric.squareGridMap[screen.square] * columnIndex + _Metric.paddingGrid;
    super.horizontalColumnGridIndex = _Metric.squareGridMap[screen.square] * columnIndex + _Metric.paddingGrid +
        _Metric.headerFooterGrid;
  }

  /// 跨行.
  int get rowSpan {
    int grid = rowGridSpan;
    int square = _Metric.squareGridMap[screen.square];
    assert(grid % square == 0);
    return grid ~/ square;
  }
  set rowSpan(int rowSpan) {
    super.verticalRowGridSpan = super.horizontalRowGridSpan = _Metric.squareGridMap[screen.square] * rowSpan;
  }

  /// 跨列.
  int get columnSpan {
    int grid = columnGridSpan;
    int square = _Metric.squareGridMap[screen.square];
    assert(grid % square == 0);
    return grid ~/ square;
  }
  set columnSpan(int columnSpan) {
    super.verticalColumnGridSpan = super.horizontalColumnGridSpan = _Metric.squareGridMap[screen.square] * columnSpan;
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 精灵卡片.
class _SpriteCard extends _CoreCard {
  _SpriteCard(_SpriteScreen screen, {
    String name,
    double rotateX = 0.0,
    double rotateY = 0.0,
    double rotateZ = 0.0,
    double translateX = 0.0,
    double translateY = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    int zIndex = 1,
    /// 默认不可见, 通过动画进入.
    bool visible = false,
    _CardDimension dimension = _CardDimension.main,
    bool vicing = false,
    double mainOpacity = 1.0,
    _GestureType gestureType = _GestureType.normal,
//    void Function(_Card card) onTap,
//    void Function(_Card card) onLongPress,
    @required
    int rowIndex,
    @required
    int columnIndex,
    double mainElevation = 2.0,
    _CardRadiusType radiusType = _CardRadiusType.small,
    @required
    _Sprite Function(_SpriteCard card) createSprite,
  }) : super(screen,
    name: name,
    rotateX: rotateX,
    rotateY: rotateY,
    rotateZ: rotateZ,
    translateX: translateX,
    translateY: translateY,
    scaleX: scaleX,
    scaleY: scaleY,
    zIndex: zIndex,
    visible: visible,
    dimension: dimension,
    /// 固定为主尺寸卡片.
    vice: false,
    vicing: vicing,
    mainOpacity: mainOpacity,
    gestureType: gestureType,
    onTap: (card) {
      _SpriteCard spriteCard = card;
      spriteCard.screen.game.actionQueue.post<_SpriteCard>(spriteCard, (thisRef, action) {
        if (thisRef.index < 0) {
          return;
        }
        switch (thisRef.dimension) {
          case _CardDimension.main:
            spriteCard.sprite.onTap();
            break;
          case _CardDimension.vice:
            break;
          case _CardDimension.full:
            break;
          default:
            break;
        }
      });
    },
    onLongPress: (card) {
      _SpriteCard spriteCard = card;
      spriteCard.screen.game.actionQueue.post<_SpriteCard>(spriteCard, (thisRef, action) {
        if (thisRef.index < 0) {
          return;
        }
        switch (thisRef.dimension) {
          case _CardDimension.main:
            thisRef.screen.game.actionQueue.add(<_Action>[
              thisRef.animateMainToVice().action(),
            ]);
            break;
          case _CardDimension.vice:
            thisRef.screen.game.actionQueue.add(<_Action>[
              thisRef.animateViceToMain().action(),
            ]);
            break;
          case _CardDimension.full:
            break;
          default:
            break;
        }
      });
    },
    rowIndex: rowIndex,
    columnIndex: columnIndex,
    /// 固定为 1.
    rowSpan: 1,
    /// 固定为 1.
    columnSpan: 1,
    mainElevation: mainElevation,
    radiusType: radiusType,
  ) {
    sprite = createSprite(this);
  }

  /// 玩家.
  factory _SpriteCard.player(_SpriteScreen screen) {
    /// 随机非边缘位置.
    ///
    /// 3 * 3 始终在中间一格, 4 * 4 中间 4 格之一随机, 5 * 5 中间 9 格之一随机.
    int _randomRowColumnIndex() {
      return _random.nextIntFromTo(1, screen.square - 2);
    }

    return _SpriteCard(screen,
      name: 'Player',
      rowIndex: _randomRowColumnIndex(),
      columnIndex: _randomRowColumnIndex(),
      zIndex: 3,
      visible: true,
      dimension: _CardDimension.full,
      createSprite: (card) {
        return _PlayerSprite(card);
      },
    );
  }

  /// 随机.
  factory _SpriteCard.next(_SpriteScreen screen, {
    @required
    int rowIndex,
    @required
    int columnIndex,
  }) {
    return _SpriteCard(screen,
      rowIndex: rowIndex,
      columnIndex: columnIndex,
      createSprite: (card) {
        int random = _random.nextIntFromTo(0, 2);
        if (random == 0) {
          return _DiamondSwordSprite(card,
            amount: _random.nextIntFromTo(1, 99),
          );
        } else if (random == 1) {
          return _GoldNuggetSprite(card,
            amount: _random.nextIntFromTo(1, 99),
          );
        } else if (random == 2) {
          return _ZombieSprite(card,
            healthValue: _random.nextIntFromTo(1, 99),
          );
        }
        return _Sprite(card);
      },
    );
  }

  /// 强转为 [_SpriteScreen].
  _SpriteScreen get spriteScreen {
    return screen as _SpriteScreen;
  }

  /// 是否在指定方向边缘.
  bool edge(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.up:
        return rowIndex <= 0;
      case AxisDirection.right:
        return columnIndex >= screen.square - 1;
      case AxisDirection.down:
        return rowIndex >= screen.square - 1;
      case AxisDirection.left:
        return columnIndex <= 0;
      default:
        throw Exception();
    }
  }

  /// 返回在指定方向上与当前卡片相邻的卡片. 如果没有符合条件的卡片则返回 null. 不会返回 [visible] 为 false 的卡片.
  ///
  /// 例如 direction = left 表示返回当前卡片左边相邻的卡片.
  _SpriteCard adjacentCard(AxisDirection direction) {
    assert(direction != null);
    if (edge(direction)) {
      return null;
    }
    return spriteScreen.spriteCards(
      exceptCard: this,
      exceptInvisible: true,
    ).singleWhere((element) {
      switch (direction) {
        case AxisDirection.up:
          return element.rowIndex == rowIndex - 1 && element.columnIndex == columnIndex;
        case AxisDirection.right:
          return element.rowIndex == rowIndex && element.columnIndex == columnIndex + 1;
        case AxisDirection.down:
          return element.rowIndex == rowIndex + 1 && element.columnIndex == columnIndex;
        case AxisDirection.left:
          return element.rowIndex == rowIndex && element.columnIndex == columnIndex - 1;
        default:
          throw Exception();
      }
    }, orElse: () => null);
  }

  /// 返回指定卡片与当前卡片的相对相邻位置. 如果不相邻则返回 null.
  ///
  /// 例如指定卡片在当前卡片的左边相邻则返回 left.
  AxisDirection adjacentDirection(_SpriteCard card) {
    assert(card != null);
    if (identical(card, adjacentCard(AxisDirection.up))) {
      return AxisDirection.up;
    }
    if (identical(card, adjacentCard(AxisDirection.right))) {
      return AxisDirection.right;
    }
    if (identical(card, adjacentCard(AxisDirection.down))) {
      return AxisDirection.down;
    }
    if (identical(card, adjacentCard(AxisDirection.left))) {
      return AxisDirection.left;
    }
    return null;
  }

  /// 返回当前卡片指定方向上的所有卡片. 如果没有符合条件的卡片则返回空列表. 不会返回 [visible] 为 false 的卡片.
  ///
  /// 例如 direction = left 表示返回当前卡片左边一格, 左边两格, 左边三格... 的列表.
  List<_SpriteCard> adjacentCardAll(AxisDirection direction) {
    assert(direction != null);
    if (edge(direction)) {
      return List<_SpriteCard>.unmodifiable(<_SpriteCard>[]);
    }

    List<_SpriteCard> result = <_SpriteCard>[];
    List<_SpriteCard> spriteCards = spriteScreen.spriteCards(
      exceptCard: this,
      exceptInvisible: true,
    );

    /// 添加 [spriteCards] 中指定行列的卡片到 [result] 中.
    void addSpriteCard(int targetRowIndex, int targetColumnIndex) {
      result.addNotNull(spriteCards.singleWhere((element) {
        return element.rowIndex == targetRowIndex && element.columnIndex == targetColumnIndex;
      }, orElse: () => null));
    }

    switch (direction) {
      case AxisDirection.up:
        for (int targetRowIndex = rowIndex - 1; targetRowIndex >= 0; targetRowIndex--) {
          addSpriteCard(targetRowIndex, columnIndex);
        }
        break;
      case AxisDirection.right:
        for (int targetColumnIndex = columnIndex + 1; targetColumnIndex <= screen.square - 1; targetColumnIndex++) {
          addSpriteCard(rowIndex, targetColumnIndex);
        }
        break;
      case AxisDirection.down:
        for (int targetRowIndex = rowIndex + 1; targetRowIndex <= screen.square - 1; targetRowIndex++) {
          addSpriteCard(targetRowIndex, columnIndex);
        }
        break;
      case AxisDirection.left:
        for (int targetColumnIndex = columnIndex - 1; targetColumnIndex >= 0; targetColumnIndex--) {
          addSpriteCard(rowIndex, targetColumnIndex);
        }
        break;
      default:
        throw Exception();
    }
    return List<_SpriteCard>.unmodifiable(result);
  }

  /// 按照 [clockwise] 顺时针或逆时针方向从当前方向依次寻找下一个不是边缘的方向, 不会返回与 [direction] 相反的方向.
  ///
  /// 例如: direction = left, clockwise = false, 当前卡片在左下角, 则按照 left (在边缘), down (在边缘), right (与 left 相反),
  /// up 顺序, 返回第一个符合条件的方向 up.
  AxisDirection nextNonEdgeDirection(AxisDirection direction, {
    bool clockwise = false,
  }) {
    assert(direction != null);
    List<AxisDirection> directions = clockwise
        ? AxisDirection.values
        : List.unmodifiable(AxisDirection.values.reversed);
    int start = directions.indexOf(direction);
    for (AxisDirection nextDirection in (directions + directions).sublist(start, start + directions.length)) {
      if (nextDirection != flipAxisDirection(direction) && !edge(nextDirection)) {
        return nextDirection;
      }
    }
    throw Exception();
  }

  //*******************************************************************************************************************

  /// 精灵卡片移动动画.
  ///
  /// [direction] 移动方向.
  _Animation<_SpriteCard> animateSpriteMove({
    int duration = 400,
    int beginDelay = 0,
    int endDelay = 0,
    @required
    AxisDirection direction,
  }) {
    return _Animation<_SpriteCard>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeInOut,
      listener: (card, value, first, half, last) {
        if (value < 0.5) {
          card.translateX = _ValueCalc.ab(0.0, _Metric.get().squareSizeMap[card.screen.square] * direction.x)
              .calc(value);
          card.translateY = _ValueCalc.ab(0.0, _Metric.get().squareSizeMap[card.screen.square] * direction.y)
              .calc(value);
        } else {
          card.translateX = _ValueCalc.ab(_Metric.get().squareSizeMap[card.screen.square] * -direction.x, 0.0)
              .calc(value);
          card.translateY = _ValueCalc.ab(_Metric.get().squareSizeMap[card.screen.square] * -direction.y, 0.0)
              .calc(value);
        }
        if (half) {
          card.rowIndex += direction.y;
          card.columnIndex += direction.x;
        }
      },
    );
  }

  /// 精灵卡片进入动画.
  _Animation<_SpriteCard> animateSpriteEnter({
    int duration = 400,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_SpriteCard>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeIn,
      listener: (card, value, first, half, last) {
        if (first) {
          card.zIndex = 0;
          card.visible = true;
        }
        card.rotateY = _ValueCalc.ab(_InvisibleAngle.clockwise90.value, 0.0).calc(value);
        card.scaleX = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.scaleY = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.mainElevation = _ValueCalc.ab(0.0, 2.0).calc(value);
        if (last) {
          card.zIndex = 1;
        }
      },
    );
  }

  /// 精灵卡片退出动画.
  _Animation<_SpriteCard> animateSpriteExit({
    int duration = 400,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_SpriteCard>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeOut,
      listener: (card, value, first, half, last) {
        if (first) {
          card.zIndex = 0;
        }
        card.rotateY = _ValueCalc.ab(0.0, _InvisibleAngle.counterClockwise90.value).calc(value);
        card.scaleX = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.scaleY = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.mainElevation = _ValueCalc.ab(2.0, 0.0).calc(value);
        if (last) {
          card.visible = false;
        }
      },
    );
  }

  /// 精灵卡片第一次进入动画.
  _Animation<_SpriteCard> animateSpriteFirstEnter({
    int durationRandomCenter = 600,
    int durationRandomRange = 200,
    int beginDelayRandomCenter = 200,
    int beginDelayRandomRange = 200,
    int endDelay = 0,
  }) {
    double rotateYA = _random.nextListItem(<_InvisibleAngle>[
      _InvisibleAngle.clockwise90,
      _InvisibleAngle.clockwise270,
    ]).value;
    return _Animation<_SpriteCard>(this,
      duration: _random.nextIntCenterRange(durationRandomCenter, durationRandomRange),
      beginDelay: _random.nextIntCenterRange(beginDelayRandomCenter, beginDelayRandomRange),
      endDelay: endDelay,
      curve: Curves.easeIn,
      listener: (card, value, first, half, last) {
        if (first) {
          card.zIndex = 0;
          card.visible = true;
        }
        card.rotateY = _ValueCalc.ab(rotateYA, 0.0).calc(value);
        card.scaleX = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.scaleY = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.mainElevation = _ValueCalc.ab(0.0, 2.0).calc(value);
        if (last) {
          card.zIndex = 1;
        }
      },
    );
  }

  /// 精灵卡片最后一次退出动画.
  _Animation<_SpriteCard> animateSpriteLastExit({
    int durationRandomCenter = 600,
    int durationRandomRange = 200,
    int beginDelayRandomCenter = 200,
    int beginDelayRandomRange = 200,
    int endDelay = 0,
  }) {
    double rotateYB = _random.nextListItem(<_InvisibleAngle>[
      _InvisibleAngle.counterClockwise90,
      _InvisibleAngle.counterClockwise270,
    ]).value;
    return _Animation<_SpriteCard>(this,
      duration: _random.nextIntCenterRange(durationRandomCenter, durationRandomRange),
      beginDelay: _random.nextIntCenterRange(beginDelayRandomCenter, beginDelayRandomRange),
      endDelay: endDelay,
      curve: Curves.easeOut,
      listener: (card, value, first, half, last) {
        if (first) {
          card.zIndex = 0;
        }
        card.rotateY = _ValueCalc.ab(0.0, rotateYB).calc(value);
        card.scaleX = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.scaleY = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.mainElevation = _ValueCalc.ab(2.0, 0.0).calc(value);
        if (last) {
          card.visible = false;
        }
      },
    );
  }

  //*******************************************************************************************************************

  /// 精灵. 不为 null.
  _Sprite sprite;
}

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 卡片尺寸.
enum _CardDimension {
  /// 主尺寸.
  main,
  /// 副尺寸. 目前始终为 square * square 大卡片.
  vice,
  /// 全屏尺寸.
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
