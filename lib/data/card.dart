part of '../data.dart';

//*********************************************************************************************************************

/// 卡片.
class _Card implements Card {
  _Card({
    @required
    this.game,
    @required
    this.type,
    this.verticalRowGridIndex = 0,
    this.verticalColumnGridIndex = 0,
    this.verticalRowGridSpan = 1,
    this.verticalColumnGridSpan = 1,
    this.horizontalRowGridIndex = 0,
    this.horizontalColumnGridIndex = 0,
    this.horizontalRowGridSpan = 1,
    this.horizontalColumnGridSpan = 1,
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.rotateX = 0.0,
    this.rotateY = 0.0,
    this.rotateZ = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.elevation = 1.0,
    this.radius = 4.0,
    this.opacity = 1.0,
    this.visible = true,
    this.touchable = true,
    this.gestureType = _CardGestureType.normal,
    @required
    this.sprite,
  }) : data = _CardData() {
    sprite.card = this;
    data.card = this;
  }

  final _Game game;

  //*******************************************************************************************************************

  /// 卡片类型.
  final _CardType type;

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
  set rowGridIndex(int rowIndex) {
    horizontalRowGridIndex = rowIndex;
    verticalRowGridIndex = rowIndex;
  }

  /// 当前屏幕旋转方向的网格列.
  int get columnGridIndex {
    return _Metric.get().isVertical ? verticalColumnGridIndex : horizontalColumnGridIndex;
  }
  set columnGridIndex(int columnIndex) {
    horizontalColumnGridIndex = columnIndex;
    verticalColumnGridIndex = columnIndex;
  }

  /// 当前屏幕旋转方向的网格跨行.
  int get rowGridSpan {
    return _Metric.get().isVertical ? verticalRowGridSpan : horizontalRowGridSpan;
  }
  set rowGridSpan(int rowSpan) {
    horizontalRowGridSpan = rowSpan;
    verticalRowGridSpan = rowSpan;
  }

  /// 当前屏幕旋转方向的网格跨列.
  int get columnGridSpan {
    return _Metric.get().isVertical ? verticalColumnGridSpan : horizontalColumnGridSpan;
  }
  set columnGridSpan(int columnSpan) {
    horizontalColumnGridSpan = columnSpan;
    verticalColumnGridSpan = columnSpan;
  }

  /// 当前屏幕旋转方向的网格跨行跨列取小值.
  int get minGridSpan => min(rowGridSpan, columnGridSpan);
  /// 当前屏幕旋转方向的网格跨行跨列取大值.
  int get maxGridSpan => max(rowGridSpan, columnGridSpan);

  /// 网格矩形.
  Rect get rect => Rect.fromLTWH(
    _Metric.get().safeRect.left + columnGridIndex * _Metric.get().gridSize,
    _Metric.get().safeRect.top + rowGridIndex * _Metric.get().gridSize,
    columnGridSpan * _Metric.get().gridSize,
    rowGridSpan * _Metric.get().gridSize,
  );

  //*******************************************************************************************************************

  /// Matrix4.setEntry(3, 2, value);
  double get matrix4Entry32 {
    return _Metric.coreNoPaddingGrid / maxGridSpan / 800.0;
  }

  double translateX;
  double translateY;
  double rotateX;
  double rotateY;
  double rotateZ;
  double scaleX;
  double scaleY;

  Matrix4 get transform => Matrix4.identity()
    ..setEntry(3, 2, matrix4Entry32)
    ..translate(translateX, translateY)
    ..rotateX(rotateX)
    ..rotateY(rotateY)
    ..rotateZ(rotateZ)
    ..scale(scaleX, scaleY);

  /// Z 方向高度. 建议范围 0.0 ~ 4.0.
  double elevation;

  /// 范围 0 ~ 5.
  int get zIndex {
    if (elevation < 1.0) {
      return 0;
    }
    if (elevation == 1.0) {
      return 1;
    }
    if (elevation > 4.0) {
      return 5;
    }
    return elevation.ceil();
  }

  /// 圆角.
  double radius;

  /// 透明度.
  double opacity;

  /// 是否可见.
  bool visible;

  /// 在 [zIndex] 上是否可见.
  ///
  /// [zIndex] 范围 0 ~ 5.
  bool Function(int zIndex) get zIndexVisible => (zIndex) {
    assert(zIndex >= 0 && zIndex <= 5);
    return visible && this.zIndex == zIndex;
  };

  double get margin {
    return 2.0 / (_Metric.coreNoPaddingGrid / minGridSpan) * _Metric.get().gridSize;
  }

  /// 是否可点击 (卡片是否可交互). 初始化后不可改变.
  final bool touchable;

  /// 手势类型.
  _CardGestureType gestureType;

  /// 是否拦截手势.
  bool get absorbPointer {
    if (!touchable) {
      return false;
    }
    return gestureType == _CardGestureType.absorb;
  }

  /// 是否忽略手势.
  bool get ignorePointer {
    if (!touchable) {
      return true;
    }
    return gestureType == _CardGestureType.ignore;
  }

  //*******************************************************************************************************************

  final _CardSprite sprite;

  @override
  final _CardData data;

  //*******************************************************************************************************************

  @override
  String toString() {
    return '$verticalRowGridIndex,$verticalColumnGridIndex,$verticalRowGridSpan,$verticalColumnGridSpan\n'
        '$horizontalRowGridIndex,$horizontalColumnGridIndex,$horizontalRowGridSpan,$horizontalColumnGridSpan';
  }
}

//*********************************************************************************************************************

/// Core 卡片.
class _CoreCard extends _Card {
  _CoreCard({
    @required
    _Game game,
    int rowIndex = 0,
    int columnIndex = 0,
    int rowSpan = 1,
    int columnSpan = 1,
    double translateX = 0.0,
    double translateY = 0.0,
    double rotateX = 0.0,
    double rotateY = 0.0,
    double rotateZ = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    double elevation = 1.0,
    double radius = 4.0,
    double opacity = 1.0,
    bool visible = true,
    bool touchable = true,
    _CardGestureType gestureType = _CardGestureType.normal,
    _CardSprite sprite,
  }) : super(
    game: game,
    type: _CardType.core,
    translateX: translateX,
    translateY: translateY,
    rotateX: rotateX,
    rotateY: rotateY,
    rotateZ: rotateZ,
    scaleX: scaleX,
    scaleY: scaleY,
    elevation: elevation,
    radius: radius,
    opacity: opacity,
    visible: visible,
    touchable: touchable,
    gestureType: gestureType,
    sprite: sprite,
  ) {
    this.rowIndex = rowIndex;
    this.columnIndex = columnIndex;
    this.rowSpan = rowSpan;
    this.columnSpan = columnSpan;
  }

  //*******************************************************************************************************************

  /// 当前卡片在 [_Game.coreCards] 中的 index.
  int get index => game.coreCards.indexOf(this);

  //*******************************************************************************************************************

  /// 行.
  int get rowIndex {
    return (rowGridIndex - _Metric.paddingGrid - (_Metric.get().isVertical ? _Metric.headerFooterGrid : 0)) ~/
        _Metric.get().coreCardGrid;
  }
  set rowIndex(int coreRowIndex) {
    verticalRowGridIndex = _Metric.get().coreCardGrid * coreRowIndex + _Metric.paddingGrid + _Metric.headerFooterGrid;
    horizontalRowGridIndex = _Metric.get().coreCardGrid * coreRowIndex + _Metric.paddingGrid;
  }

  /// 列.
  int get columnIndex {
    return (columnGridIndex - _Metric.paddingGrid - (_Metric.get().isVertical ? 0 : _Metric.headerFooterGrid)) ~/
        _Metric.get().coreCardGrid;
  }
  set columnIndex(int coreColumnIndex) {
    verticalColumnGridIndex = _Metric.get().coreCardGrid * coreColumnIndex + _Metric.paddingGrid;
    horizontalColumnGridIndex = _Metric.get().coreCardGrid * coreColumnIndex + _Metric.paddingGrid +
        _Metric.headerFooterGrid;
  }

  /// 跨行.
  int get rowSpan {
    return rowGridSpan ~/ _Metric.get().coreCardGrid;
  }
  set rowSpan(int coreRowSpan) {
    rowGridSpan = _Metric.get().coreCardGrid * coreRowSpan;
  }

  /// 跨列.
  int get columnSpan {
    return columnGridSpan ~/ _Metric.get().coreCardGrid;
  }
  set columnSpan(int coreColumnSpan) {
    columnGridSpan = _Metric.get().coreCardGrid * coreColumnSpan;
  }

  /// 所在行范围. 对于不跨行的卡片, from == to == rowIndex.
  _CardRowColumnRange get rowRange {
    return _CardRowColumnRange(rowIndex, rowIndex + rowSpan - 1);
  }

  /// 所在列范围. 对于不跨列的卡片, from == to == columnIndex.
  _CardRowColumnRange get columnRange {
    return _CardRowColumnRange(columnIndex, columnIndex + columnSpan - 1);
  }

  /// 从 [_Game.coreCards] 中返回当前卡片左边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_CoreCard> get left {
    int targetColumn = columnRange.from - 1;
    if (targetColumn < 0) {
      return <_CoreCard>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = rowRange;
    return game.coreCards.where((element) {
      return targetRowRange.contain(element.rowRange) && element.columnRange.containValue(targetColumn);
    }).toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片上边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_CoreCard> get top {
    int targetRow = rowRange.from - 1;
    if (targetRow < 0) {
      return <_CoreCard>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = columnRange;
    return game.coreCards.where((element) {
      return element.rowRange.containValue(targetRow) && targetColumnRange.contain(element.columnRange);
    }).toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片右边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_CoreCard> get right {
    int targetColumn = columnRange.to + 1;
    if (targetColumn >= _Metric.get().square) {
      return <_CoreCard>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = rowRange;
    return game.coreCards.where((element) {
      return targetRowRange.contain(element.rowRange) && element.columnRange.containValue(targetColumn);
    }).toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片下边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_CoreCard> get bottom {
    int targetRow = rowRange.to + 1;
    if (targetRow >= _Metric.get().square) {
      return <_CoreCard>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = columnRange;
    return game.coreCards.where((element) {
      return element.rowRange.containValue(targetRow) && targetColumnRange.contain(element.columnRange);
    }).toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片左边所有的卡片. 第一维度列表表示从右向左的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_CoreCard>> get leftAll {
    _CardRowColumnRange targetColumnRange = _CardRowColumnRange(0, columnRange.from - 1);
    if (!targetColumnRange.isValid()) {
      return <BuiltList<_CoreCard>>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = rowRange;
    List<_CoreCard> coreCards = <_CoreCard>[]..addAll(game.coreCards);
    List<BuiltList<_CoreCard>> list2 = <BuiltList<_CoreCard>>[];
    for (int targetColumn = targetColumnRange.to; targetColumn >= targetColumnRange.from; targetColumn--) {
      List<_CoreCard> list = <_CoreCard>[];
      coreCards.toBuiltList().forEach((element) {
        if (targetRowRange.contain(element.rowRange) && element.columnRange.containValue(targetColumn)) {
          list.add(element);
          coreCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片上边所有的卡片. 第一维度列表表示从下向上的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_CoreCard>> get topAll {
    _CardRowColumnRange targetRowRange = _CardRowColumnRange(0, rowRange.from - 1);
    if (!targetRowRange.isValid()) {
      return <BuiltList<_CoreCard>>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = columnRange;
    List<_CoreCard> coreCards = <_CoreCard>[]..addAll(game.coreCards);
    List<BuiltList<_CoreCard>> list2 = <BuiltList<_CoreCard>>[];
    for (int targetRow = targetRowRange.to; targetRow >= targetRowRange.from; targetRow--) {
      List<_CoreCard> list = <_CoreCard>[];
      coreCards.toBuiltList().forEach((element) {
        if (element.rowRange.containValue(targetRow) && targetColumnRange.contain(element.columnRange)) {
          list.add(element);
          coreCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片右边所有的卡片. 第一维度列表表示从左向右的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_CoreCard>> get rightAll {
    _CardRowColumnRange targetColumnRange = _CardRowColumnRange(columnRange.to + 1, _Metric.get().square - 1);
    if (!targetColumnRange.isValid()) {
      return <BuiltList<_CoreCard>>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = rowRange;
    List<_CoreCard> coreCards = <_CoreCard>[]..addAll(game.coreCards);
    List<BuiltList<_CoreCard>> list2 = <BuiltList<_CoreCard>>[];
    for (int targetColumn = targetColumnRange.from; targetColumn <= targetColumnRange.to; targetColumn++) {
      List<_CoreCard> list = <_CoreCard>[];
      coreCards.toBuiltList().forEach((element) {
        if (targetRowRange.contain(element.rowRange) &&
            element.columnRange.containValue(targetColumn)) {
          list.add(element);
          coreCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片下边所有的卡片. 第一维度列表表示从上向下的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_CoreCard>> get bottomAll {
    _CardRowColumnRange targetRowRange = _CardRowColumnRange(rowRange.to + 1, _Metric.get().square - 1);
    if (!targetRowRange.isValid()) {
      return <BuiltList<_CoreCard>>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = columnRange;
    List<_CoreCard> coreCards = <_CoreCard>[]..addAll(game.coreCards);
    List<BuiltList<_CoreCard>> list2 = <BuiltList<_CoreCard>>[];
    for (int targetRow = targetRowRange.from; targetRow <= targetRowRange.to; targetRow++) {
      List<_CoreCard> list = <_CoreCard>[];
      coreCards.toBuiltList().forEach((element) {
        if (element.rowRange.containValue(targetRow) &&
            targetColumnRange.contain(element.columnRange)) {
          list.add(element);
          coreCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 根据 [ltrb] 返回指定方向的所有卡片.
  BuiltList<BuiltList<_CoreCard>> ltrbAll(_LTRB ltrb) {
    switch (ltrb) {
      case _LTRB.left:
        return leftAll;
      case _LTRB.top:
        return topAll;
      case _LTRB.right:
        return rightAll;
      case _LTRB.bottom:
        return bottomAll;
      default:
        throw Exception();
    }
  }

  /// 根据 [ltrb] 返回指定方向的所有卡片. 如果指定方向的卡片为空, 按 [clockwise] 顺序返回第一个有效方向的卡片.
  BuiltList<BuiltList<_CoreCard>> ltrbAllFallback(_LTRB ltrb, {
    bool clockwise = false,
  }) {
    for (_LTRB currentLtrb in ltrb.turns(clockwise: clockwise)) {
      BuiltList<BuiltList<_CoreCard>> list = ltrbAll(currentLtrb);
      if (list.isNotEmpty) {
        return list;
      }
    }
    return <BuiltList<_CoreCard>>[].toBuiltList();
  }

  /// 返回 [card] 在当前卡片的相对位置. 如果不在左上右下则返回 null.
  _LTRB relative(_CoreCard card) {
    if (left.contains(card)) {
      return _LTRB.left;
    }
    if (top.contains(card)) {
      return _LTRB.top;
    }
    if (right.contains(card)) {
      return _LTRB.right;
    }
    if (bottom.contains(card)) {
      return _LTRB.bottom;
    }
    return null;
  }

  //*******************************************************************************************************************

  @override
  String toString() {
    return '${super.toString()}\n$rowIndex,$columnIndex,$rowSpan,$columnSpan\n$index';
  }
}

//*********************************************************************************************************************

/// 卡片行列范围. 包含 [from] 和 [to]. [to] 必须大等于 [from], 否则 [isValid] 为 false.
class _CardRowColumnRange {
  _CardRowColumnRange(this.from, this.to);

  final int from;
  final int to;

  bool contain(_CardRowColumnRange other) {
    for (int i = from; i <= to; i++) {
      for (int j = other.from; j <= other.to; j++) {
        if (i == j) {
          return true;
        }
      }
    }
    return false;
  }

  bool containValue(int value) {
    return value >= from && value <= to;
  }

  bool isValid() {
    return to >= from;
  }
}

enum _LTRB {
  left,
  top,
  right,
  bottom,
}

extension _LTRBExtension on _LTRB {
  /// 按照 [clockwise] 顺时针或逆时针顺序依次返回从当前方向开始的四个方向列表.
  BuiltList<_LTRB> turns({
    bool clockwise = false,
  }) {
    List<_LTRB> list = _LTRB.values + _LTRB.values;
    if (!clockwise) {
      list = list.reversed.toList();
    }
    int start = list.indexOf(this);
    return list.sublist(start, start + _LTRB.values.length).toBuiltList();
  }

  int get x {
    switch (this) {
      case _LTRB.left:
        return -1;
      case _LTRB.top:
        return 0;
      case _LTRB.right:
        return 1;
      case _LTRB.bottom:
        return 0;
      default:
        throw Exception();
    }
  }

  int get y {
    switch (this) {
      case _LTRB.left:
        return 0;
      case _LTRB.top:
        return -1;
      case _LTRB.right:
        return 0;
      case _LTRB.bottom:
        return 1;
      default:
        throw Exception();
    }
  }
}

/// 卡片类型.
enum _CardType {
  core,
  headerFooter,
}

//*********************************************************************************************************************

/// 卡片手势类型.
enum _CardGestureType {
  /// 正常接收处理手势.
  normal,
  /// 拦截手势, 自己不处理, 下层 Widget 也无法处理.
  absorb,
  /// 忽略手势, 自己不处理, 下层 Widget 可以处理.
  ignore,
}

//*********************************************************************************************************************

class _CardData implements CardData {
  _Card card;

  @override
  bool get absorbPointer => card.absorbPointer;

  @override
  Color get color => Colors.white;

  @override
  double get elevation => card.elevation;

  @override
  bool get ignorePointer => card.ignorePointer;

  @override
  double get margin => card.margin;

  @override
  get onLongPress => card.game.onLongPress(card);

  @override
  get onTap => card.game.onTap(card);

  @override
  double get opacity => card.opacity;

  @override
  double get radius => card.radius;

  @override
  Rect get rect => card.rect;

  @override
  Matrix4 get transform => card.transform;

  @override
  bool Function(int zIndex) get zIndexVisible => card.zIndexVisible;

  @override
  String toString() {
    return card.toString();
  }
}
