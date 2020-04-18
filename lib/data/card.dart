part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 卡片.
abstract class _Card {
  _Card(this.screen, {
    this.zIndex = 1,
    this.visible = true,
    this.dimension = _CardDimension.main,
    this.vice = false,
    this.vicing = false,
    this.rotateX = 0.0,
    this.rotateY = 0.0,
    this.rotateZ = 0.0,
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.mainOpacity = 1.0,
    this.mainMargin = 0.0,
    this.mainElevation = 1.0,
    this.mainRadius = 4.0,
    this.gestureType = _GestureType.normal,
    this.onTap,
    this.onLongPress,
  });

  final _Screen screen;

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

  /// 在 [Stack] 的 [zIndex] 上是否可见.
  ///
  /// [zIndex] 范围 0 ~ 3.
  bool Function(int zIndex) get zIndexVisible {
    return (zIndex) {
      assert(zIndex >= 0 && zIndex <= 3);
      return max(0, min(3, this.zIndex)) == zIndex && visible;
    };
  }

  /// 卡片尺寸.
  /// 
  /// 可能因不同尺寸而变化的值: [rect], [margin], [elevation], [radius].
  _CardDimension dimension;

  /// 值为 false 表示 [screen.viceOpacity] 为 0.0 时显示, 为 1.0 时隐藏, 值为 true 时相反.
  ///
  /// 简单来说, false 表示显示副尺寸卡片时隐藏, true 表示显示副尺寸卡片时显示.
  bool vice;

  /// 值为 true 表示当前正在执行副尺寸动画, [opacity] 始终取 [mainOpacity].
  bool vicing;

  /// 主尺寸定位矩形.
  Rect get mainRect;

  /// 副尺寸定位矩形.
  Rect get viceRect {
    return Metric.get().coreNoPaddingRect;
  }

  /// 全屏尺寸定位矩形.
  Rect get fullRect {
    return Metric.get().screenRect;
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

  /// Matrix4.setEntry(3, 2, value). 数值只与卡片尺寸相关.
  double get matrix4Entry32 {
    // 数值越大, 3d 旋转镜头越近, 效果越明显, 但越容易绘制异常.
    return 0.4 / max(rect.width, rect.height);
  }

  double rotateX;
  double rotateY;
  double rotateZ;
  double translateX;
  double translateY;
  double scaleX;
  double scaleY;

  /// 卡片变换.
  Matrix4 get transform {
    return Matrix4.identity()..setEntry(3, 2, matrix4Entry32)
      ..rotateX(rotateX)
      ..rotateY(rotateY)
      ..rotateZ(rotateZ)
      ..leftTranslate(translateX, translateY)
      ..scale(scaleX, scaleY);
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

  /// 主尺寸外边距.
  double mainMargin;

  /// 渲染外边距.
  double get margin {
    switch (dimension) {
      case _CardDimension.main:
        return mainMargin;
      case _CardDimension.vice:
        return mainMargin;
      case _CardDimension.full:
        return 0.0;
      default:
        throw Exception();
    }
  }

  /// 主尺寸厚度. 建议范围 0.0 ~ 4.0.
  double mainElevation;

  /// 渲染厚度.
  double get elevation {
    switch (dimension) {
      case _CardDimension.main:
        return mainElevation;
      case _CardDimension.vice:
        return mainElevation * 4;
      case _CardDimension.full:
        return mainElevation * 4;
      default:
        throw Exception();
    }
  }

  /// 主尺寸圆角. 建议范围 4.0.
  double mainRadius;

  /// 渲染圆角.
  double get radius {
    switch (dimension) {
      case _CardDimension.main:
        return mainRadius;
      case _CardDimension.vice:
        return mainRadius * 4;
      case _CardDimension.full:
        return mainRadius * 4;
      default:
        throw Exception();
    }
  }

  //*******************************************************************************************************************

  /// 手势类型.
  _GestureType gestureType;

  /// 是否拦截手势.
  bool get absorbPointer {
    return gestureType == _GestureType.absorb;
  }

  /// 是否忽略手势.
  bool get ignorePointer {
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
      onAnimating: (card, value, half) {
        card.rotateY = _ValueCalc.ab(0.0, _VisibleAngle.clockwise360.value).calc(value);
        card.scaleX = _ValueCalc.aba(1.0, 2.0).calc(value);
        card.scaleY = _ValueCalc.aba(1.0, 2.0).calc(value);
        card.mainElevation = _ValueCalc.aba(1.0, 2.0).calc(value);
        card.mainRadius = _ValueCalc.aba(4.0, 8.0).calc(value);
      },
      onBegin: (card) {
        card.zIndex = 2;
      },
      onEnd: (card) {
        card.zIndex = 1;
        card.rotateY = 0.0;
      },
    );
  }

  /// 主尺寸 -> 副尺寸动画.
  ///
  /// 前 0.5 时隐藏其他卡片.
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
      onAnimating: (card, value, half) {
        if (half) {
          card.dimension = _CardDimension.vice;
          card.screen.viceOpacity = 1.0;
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
        card.mainElevation = _ValueCalc.ab(1.0, 4.0).calc(value);
      },
      onBegin: (card) {
        card.zIndex = 2;
        card.vicing = true;
      },
    );
  }

  /// 副尺寸 -> 主尺寸动画.
  ///
  /// 后 0.5 时显示其他卡片.
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
      onAnimating: (card, value, half) {
        if (half) {
          card.dimension = _CardDimension.main;
        }
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
        card.mainElevation = _ValueCalc.ab(4.0, 1.0).calc(value);
      },
      onEnd: (card) {
        card.zIndex = 1;
        card.vicing = false;
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
      onAnimating: (card, value, half) {
        card.rotateY = _ValueCalc.aba(0.0, 1.0 / 8.0 * pi).calc(value);
        card.scaleX = _ValueCalc.aba(1.0, 7.0 / 8.0).calc(value);
        card.scaleY = _ValueCalc.aba(1.0, 7.0 / 8.0).calc(value);
        card.mainElevation = _ValueCalc.aba(1.0, 7.0 / 8.0).calc(value);
      },
      onBegin: (card) {
        card.zIndex = 0;
      },
      onEnd: (card) {
        card.zIndex = 1;
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

/// 通过网格定位的卡片.
class _GridCard extends _Card {
  _GridCard(_Screen screen, {
    int zIndex = 1,
    bool visible = true,
    _CardDimension dimension = _CardDimension.main,
    bool vice = false,
    bool vicing = false,
    double rotateX = 0.0,
    double rotateY = 0.0,
    double rotateZ = 0.0,
    double translateX = 0.0,
    double translateY = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    double mainOpacity = 1.0,
    double mainElevation = 1.0,
    double mainRadius = 4.0,
    _GestureType gestureType = _GestureType.normal,
    void Function(_Card card) onTap,
    void Function(_Card card) onLongPress,
    this.verticalRowGridIndex = 0,
    this.verticalColumnGridIndex = 0,
    this.verticalRowGridSpan = 1,
    this.verticalColumnGridSpan = 1,
    this.horizontalRowGridIndex = 0,
    this.horizontalColumnGridIndex = 0,
    this.horizontalRowGridSpan = 1,
    this.horizontalColumnGridSpan = 1,
  }) : super(screen,
    zIndex: zIndex,
    visible: visible,
    dimension: dimension,
    vice: vice,
    vicing: vicing,
    rotateX: rotateX,
    rotateY: rotateY,
    rotateZ: rotateZ,
    translateX: translateX,
    translateY: translateY,
    scaleX: scaleX,
    scaleY: scaleY,
    mainOpacity: mainOpacity,
    // 不可修改.
    mainMargin: 0.0,
    mainElevation: mainElevation,
    mainRadius: mainRadius,
    gestureType: gestureType,
    onTap: onTap,
    onLongPress: onLongPress,
  );

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
    return Metric.get().isVertical ? verticalRowGridIndex : horizontalRowGridIndex;
  }
  set rowGridIndex(int rowGridIndex) {
    verticalRowGridIndex = rowGridIndex;
    horizontalRowGridIndex = rowGridIndex;
  }

  /// 当前屏幕旋转方向的网格列.
  int get columnGridIndex {
    return Metric.get().isVertical ? verticalColumnGridIndex : horizontalColumnGridIndex;
  }
  set columnGridIndex(int columnGridIndex) {
    verticalColumnGridIndex = columnGridIndex;
    horizontalColumnGridIndex = columnGridIndex;
  }

  /// 当前屏幕旋转方向的网格跨行.
  int get rowGridSpan {
    return Metric.get().isVertical ? verticalRowGridSpan : horizontalRowGridSpan;
  }
  set rowGridSpan(int rowGridSpan) {
    verticalRowGridSpan = rowGridSpan;
    horizontalRowGridSpan = rowGridSpan;
  }

  /// 当前屏幕旋转方向的网格跨列.
  int get columnGridSpan {
    return Metric.get().isVertical ? verticalColumnGridSpan : horizontalColumnGridSpan;
  }
  set columnGridSpan(int columnGridSpan) {
    verticalColumnGridSpan = columnGridSpan;
    horizontalColumnGridSpan = columnGridSpan;
  }

  //*******************************************************************************************************************

  @override
  Rect get mainRect {
    return Rect.fromLTWH(
      Metric.get().safeRect.left + columnGridIndex * Metric.get().gridSize,
      Metric.get().safeRect.top + rowGridIndex * Metric.get().gridSize,
      columnGridSpan * Metric.get().gridSize,
      rowGridSpan * Metric.get().gridSize,
    );
  }

  @override
  double get mainMargin {
    // 60 分之 2.
    Rect rect = this.rect;
    return min(rect.width, rect.height) / Metric.coreNoPaddingGrid * 2.0;
  }
  @override
  set mainMargin(double margin) {
    // 不可修改.
    throw Exception();
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 通过方格定位的卡片.
class _CoreCard extends _GridCard {
  _CoreCard(_Screen screen, {
    int zIndex = 1,
    bool visible = true,
    _CardDimension dimension = _CardDimension.main,
    bool vice = false,
    bool vicing = false,
    double rotateX = 0.0,
    double rotateY = 0.0,
    double rotateZ = 0.0,
    double translateX = 0.0,
    double translateY = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    double mainOpacity = 1.0,
    double mainElevation = 1.0,
    double mainRadius = 4.0,
    _GestureType gestureType = _GestureType.normal,
    void Function(_Card card) onTap,
    void Function(_Card card) onLongPress,
    int rowIndex = 0,
    int columnIndex = 0,
    int rowSpan = 1,
    int columnSpan = 1,
  }) : super(screen,
    zIndex: zIndex,
    visible: visible,
    dimension: dimension,
    vice: vice,
    vicing: vicing,
    rotateX: rotateX,
    rotateY: rotateY,
    rotateZ: rotateZ,
    translateX: translateX,
    translateY: translateY,
    scaleX: scaleX,
    scaleY: scaleY,
    mainOpacity: mainOpacity,
    mainElevation: mainElevation,
    mainRadius: mainRadius,
    gestureType: gestureType,
    onTap: onTap,
    onLongPress: onLongPress,
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
    return (rowGridIndex - Metric.paddingGrid - (Metric.get().isVertical ? Metric.headerFooterGrid : 0)) ~/
        Metric.squareGridMap[screen.square];
  }
  set rowIndex(int rowIndex) {
    super.verticalRowGridIndex = Metric.squareGridMap[screen.square] * rowIndex + Metric.paddingGrid +
        Metric.headerFooterGrid;
    super.horizontalRowGridIndex = Metric.squareGridMap[screen.square] * rowIndex + Metric.paddingGrid;
  }

  /// 列.
  int get columnIndex {
    return (columnGridIndex - Metric.paddingGrid - (Metric.get().isVertical ? 0 : Metric.headerFooterGrid)) ~/
        Metric.squareGridMap[screen.square];
  }
  set columnIndex(int columnIndex) {
    super.verticalColumnGridIndex = Metric.squareGridMap[screen.square] * columnIndex + Metric.paddingGrid;
    super.horizontalColumnGridIndex = Metric.squareGridMap[screen.square] * columnIndex + Metric.paddingGrid +
        Metric.headerFooterGrid;
  }

  /// 跨行.
  int get rowSpan {
    return rowGridSpan ~/ Metric.squareGridMap[screen.square];
  }
  set rowSpan(int rowSpan) {
    super.verticalRowGridSpan = super.horizontalRowGridSpan = Metric.squareGridMap[screen.square] * rowSpan;
  }

  /// 跨列.
  int get columnSpan {
    return columnGridSpan ~/ Metric.squareGridMap[screen.square];
  }
  set columnSpan(int columnSpan) {
    super.verticalColumnGridSpan = super.horizontalColumnGridSpan = Metric.squareGridMap[screen.square] * columnSpan;
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 精灵卡片.
class _SpriteCard extends _CoreCard {
  _SpriteCard(_SpriteScreen screen, {
    int zIndex = 1,
    /// 默认不可见, 通过动画进入.
    bool visible = false,
    _CardDimension dimension = _CardDimension.main,
    bool vicing = false,
    double rotateX = 0.0,
    double rotateY = 0.0,
    double rotateZ = 0.0,
    double translateX = 0.0,
    double translateY = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    double mainOpacity = 1.0,
    double mainElevation = 1.0,
    double mainRadius = 4.0,
    _GestureType gestureType = _GestureType.normal,
    void Function(_Card card) onTap,
    void Function(_Card card) onLongPress,
    int rowIndex = 0,
    int columnIndex = 0,
  }) : super(screen,
    zIndex: zIndex,
    visible: visible,
    dimension: dimension,
    /// 固定为主尺寸卡片.
    vice: false,
    vicing: vicing,
    rotateX: rotateX,
    rotateY: rotateY,
    rotateZ: rotateZ,
    translateX: translateX,
    translateY: translateY,
    scaleX: scaleX,
    scaleY: scaleY,
    mainOpacity: mainOpacity,
    mainElevation: mainElevation,
    mainRadius: mainRadius,
    gestureType: gestureType,
    onTap: onTap,
    onLongPress: onLongPress,
    rowIndex: rowIndex,
    columnIndex: columnIndex,
    /// 固定为 1.
    rowSpan: 1,
    /// 固定为 1.
    columnSpan: 1,
  );

  set vice(bool vice) {
    throw Exception();
  }

  set rowSpan(int rowSpan) {
    throw Exception();
  }

  set columnSpan(int columnSpan) {
    throw Exception();
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
      onAnimating: (card, value, half) {
        if (half) {
          card.rowIndex += direction.y;
          card.columnIndex += direction.x;
        }
        if (value < 0.5) {
          card.translateX = _ValueCalc.ab(0.0, Metric.get().squareSizeMap[card.screen.square] * direction.x)
              .calc(value);
          card.translateY = _ValueCalc.ab(0.0, Metric.get().squareSizeMap[card.screen.square] * direction.y)
              .calc(value);
        } else {
          card.translateX = _ValueCalc.ab(Metric.get().squareSizeMap[card.screen.square] * -direction.x, 0.0)
              .calc(value);
          card.translateY = _ValueCalc.ab(Metric.get().squareSizeMap[card.screen.square] * -direction.y, 0.0)
              .calc(value);
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
      onAnimating: (card, value, half) {
        card.rotateY = _ValueCalc.ab(_InvisibleAngle.clockwise90.value, 0.0).calc(value);
        card.scaleX = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.scaleY = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.mainElevation = _ValueCalc.ab(0.5, 1.0).calc(value);
      },
      onBegin: (card) {
        card.visible = true;
        card.zIndex = 0;
        card.rotateY = _InvisibleAngle.clockwise90.value;
        card.scaleX = 0.5;
        card.scaleY = 0.5;
        card.mainElevation = 0.5;
      },
      onEnd: (card) {
        card.zIndex = 1;
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
  /// 副尺寸. 目前始终为 square * square 大卡片.
  vice,
  /// 全屏尺寸.
  full,
}
