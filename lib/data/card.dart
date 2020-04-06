part of '../data.dart';

//*********************************************************************************************************************

/// 卡片.
class _Card implements Card {
  _Card({
    @required
    this.game,
    @required
    this.type,
    this.verticalRowIndex = 0,
    this.verticalColumnIndex = 0,
    this.verticalRowSpan = 1,
    this.verticalColumnSpan = 1,
    this.horizontalRowIndex = 0,
    this.horizontalColumnIndex = 0,
    this.horizontalRowSpan = 1,
    this.horizontalColumnSpan = 1,
    @required
    this.property,
    @required
    this.sprite,
  }) : data = _CardData() {
    property.card = this;
    sprite.card = this;
    data.card = this;
  }

  final _Game game;

  //*******************************************************************************************************************

  /// 卡片类型.
  final _CardType type;

  /// 竖屏行.
  int verticalRowIndex;
  /// 竖屏列.
  int verticalColumnIndex;
  /// 竖屏跨行.
  int verticalRowSpan;
  /// 竖屏跨列.
  int verticalColumnSpan;
  /// 横屏行.
  int horizontalRowIndex;
  /// 横屏列.
  int horizontalColumnIndex;
  /// 横屏跨行.
  int horizontalRowSpan;
  /// 横屏跨列.
  int horizontalColumnSpan;

  /// 当前卡片在 [_Game.cards] 中的 index.
  int get index => game.cards.indexOf(this);

  /// 当前屏幕旋转方向的行.
  int get rowIndex {
    return _Metric.get().isVertical ? verticalRowIndex : horizontalRowIndex;
  }
  set rowIndex(int rowIndex) {
    horizontalRowIndex = rowIndex;
    verticalRowIndex = rowIndex;
  }

  /// 当前屏幕旋转方向的列.
  int get columnIndex {
    return _Metric.get().isVertical ? verticalColumnIndex : horizontalColumnIndex;
  }
  set columnIndex(int columnIndex) {
    horizontalColumnIndex = columnIndex;
    verticalColumnIndex = columnIndex;
  }

  /// 当前屏幕旋转方向的跨行.
  int get rowSpan {
    return _Metric.get().isVertical ? verticalRowSpan : horizontalRowSpan;
  }
  set rowSpan(int rowSpan) {
    horizontalRowSpan = rowSpan;
    verticalRowSpan = rowSpan;
  }

  /// 当前屏幕旋转方向的跨列.
  int get columnSpan {
    return _Metric.get().isVertical ? verticalColumnSpan : horizontalColumnSpan;
  }
  set columnSpan(int columnSpan) {
    horizontalColumnSpan = columnSpan;
    verticalColumnSpan = columnSpan;
  }

  /// 当前屏幕旋转方向的跨行跨列取小值.
  int get minSpan => min(rowSpan, columnSpan);
  /// 当前屏幕旋转方向的跨行跨列取大值.
  int get maxSpan => max(rowSpan, columnSpan);

  /// 网格矩形.
  Rect get rect => Rect.fromLTWH(
    _Metric.get().safeRect.left + columnIndex * _Metric.get().gridSize,
    _Metric.get().safeRect.top + rowIndex * _Metric.get().gridSize,
    columnSpan * _Metric.get().gridSize,
    rowSpan * _Metric.get().gridSize,
  );

  //*******************************************************************************************************************

  final _CardProperty property;

  final _CardSprite sprite;

  @override
  final _CardData data;

  //*******************************************************************************************************************

  @override
  String toString() {
    String result = '$verticalRowIndex,$verticalColumnIndex,$verticalRowSpan,$verticalColumnSpan\n'
        '$horizontalRowIndex,$horizontalColumnIndex,$horizontalRowSpan,$horizontalColumnSpan';
//    if (type == _CardType.core) {
//      result += '\n$coreRowIndex,$coreColumnIndex,$coreRowSpan,$coreColumnSpan';
//    }
    result += '\n$index';
    return result;
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
    _CardProperty property,
    _CardSprite sprite,
  }) : super(
    game: game,
    type: _CardType.core,
    property: property,
    sprite: sprite,
  ) {
    coreRowIndex = rowIndex;
    coreColumnIndex = columnIndex;
    coreRowSpan = rowSpan;
    coreColumnSpan = columnSpan;
  }
  //*******************************************************************************************************************

  /// Core 卡片行.
  int get coreRowIndex {
    return (rowIndex - _Metric.paddingGrid - (_Metric.get().isVertical ? _Metric.headerFooterGrid : 0)) ~/
        _Metric.get().coreCardGrid;
  }
  set coreRowIndex(int coreRowIndex) {
    verticalRowIndex = _Metric.get().coreCardGrid * coreRowIndex + _Metric.paddingGrid + _Metric.headerFooterGrid;
    horizontalRowIndex = _Metric.get().coreCardGrid * coreRowIndex + _Metric.paddingGrid;
  }

  /// Core 卡片列.
  int get coreColumnIndex {
    return (columnIndex - _Metric.paddingGrid - (_Metric.get().isVertical ? 0 : _Metric.headerFooterGrid)) ~/
        _Metric.get().coreCardGrid;
  }
  set coreColumnIndex(int coreColumnIndex) {
    verticalColumnIndex = _Metric.get().coreCardGrid * coreColumnIndex + _Metric.paddingGrid;
    horizontalColumnIndex = _Metric.get().coreCardGrid * coreColumnIndex + _Metric.paddingGrid +
        _Metric.headerFooterGrid;
  }

  /// Core 卡片跨行.
  int get coreRowSpan {
    return rowSpan ~/ _Metric.get().coreCardGrid;
  }
  set coreRowSpan(int coreRowSpan) {
    rowSpan = _Metric.get().coreCardGrid * coreRowSpan;
  }

  /// Core 卡片跨列.
  int get coreColumnSpan {
    return columnSpan ~/ _Metric.get().coreCardGrid;
  }
  set coreColumnSpan(int coreColumnSpan) {
    columnSpan = _Metric.get().coreCardGrid * coreColumnSpan;
  }

  /// Core 卡片所在行范围. 对于不跨行的卡片, from == to == coreRowIndex.
  _CardRowColumnRange get coreRowRange {
    return _CardRowColumnRange(coreRowIndex, coreRowIndex + coreRowSpan - 1);
  }

  /// Core 卡片所在列范围. 对于不跨列的卡片, from == to == coreColumnIndex.
  _CardRowColumnRange get coreColumnRange {
    return _CardRowColumnRange(coreColumnIndex, coreColumnIndex + coreColumnSpan - 1);
  }

  /// 从 [_Game.coreCards] 中返回当前卡片左边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_CoreCard> get coreLeft {
    int targetColumn = coreColumnRange.from - 1;
    if (targetColumn < 0) {
      return <_CoreCard>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = coreRowRange;
    return game.coreCards.where((element) {
      return targetRowRange.contain(element.coreRowRange) && element.coreColumnRange.containValue(targetColumn);
    }).toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片上边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_CoreCard> get coreTop {
    int targetRow = coreRowRange.from - 1;
    if (targetRow < 0) {
      return <_CoreCard>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = coreColumnRange;
    return game.coreCards.where((element) {
      return element.coreRowRange.containValue(targetRow) && targetColumnRange.contain(element.coreColumnRange);
    }).toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片右边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_CoreCard> get coreRight {
    int targetColumn = coreColumnRange.to + 1;
    if (targetColumn >= _Metric.get().square) {
      return <_CoreCard>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = coreRowRange;
    return game.coreCards.where((element) {
      return targetRowRange.contain(element.coreRowRange) && element.coreColumnRange.containValue(targetColumn);
    }).toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片下边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_CoreCard> get coreBottom {
    int targetRow = coreRowRange.to + 1;
    if (targetRow >= _Metric.get().square) {
      return <_CoreCard>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = coreColumnRange;
    return game.coreCards.where((element) {
      return element.coreRowRange.containValue(targetRow) && targetColumnRange.contain(element.coreColumnRange);
    }).toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片左边所有的卡片. 第一维度列表表示从右向左的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_CoreCard>> get coreLeftAll {
    _CardRowColumnRange targetColumnRange = _CardRowColumnRange(0, coreColumnRange.from - 1);
    if (!targetColumnRange.isValid()) {
      return <BuiltList<_CoreCard>>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = coreRowRange;
    List<_CoreCard> coreCards = <_CoreCard>[]..addAll(game.coreCards);
    List<BuiltList<_CoreCard>> list2 = <BuiltList<_CoreCard>>[];
    for (int targetColumn = targetColumnRange.to; targetColumn >= targetColumnRange.from; targetColumn--) {
      List<_CoreCard> list = <_CoreCard>[];
      coreCards.toBuiltList().forEach((element) {
        if (targetRowRange.contain(element.coreRowRange) && element.coreColumnRange.containValue(targetColumn)) {
          list.add(element);
          coreCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片上边所有的卡片. 第一维度列表表示从下向上的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_CoreCard>> get coreTopAll {
    _CardRowColumnRange targetRowRange = _CardRowColumnRange(0, coreRowRange.from - 1);
    if (!targetRowRange.isValid()) {
      return <BuiltList<_CoreCard>>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = coreColumnRange;
    List<_CoreCard> coreCards = <_CoreCard>[]..addAll(game.coreCards);
    List<BuiltList<_CoreCard>> list2 = <BuiltList<_CoreCard>>[];
    for (int targetRow = targetRowRange.to; targetRow >= targetRowRange.from; targetRow--) {
      List<_CoreCard> list = <_CoreCard>[];
      coreCards.toBuiltList().forEach((element) {
        if (element.coreRowRange.containValue(targetRow) && targetColumnRange.contain(element.coreColumnRange)) {
          list.add(element);
          coreCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片右边所有的卡片. 第一维度列表表示从左向右的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_CoreCard>> get coreRightAll {
    _CardRowColumnRange targetColumnRange = _CardRowColumnRange(coreColumnRange.to + 1, _Metric.get().square - 1);
    if (!targetColumnRange.isValid()) {
      return <BuiltList<_CoreCard>>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = coreRowRange;
    List<_CoreCard> coreCards = <_CoreCard>[]..addAll(game.coreCards);
    List<BuiltList<_CoreCard>> list2 = <BuiltList<_CoreCard>>[];
    for (int targetColumn = targetColumnRange.from; targetColumn <= targetColumnRange.to; targetColumn++) {
      List<_CoreCard> list = <_CoreCard>[];
      coreCards.toBuiltList().forEach((element) {
        if (targetRowRange.contain(element.coreRowRange) &&
            element.coreColumnRange.containValue(targetColumn)) {
          list.add(element);
          coreCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片下边所有的卡片. 第一维度列表表示从上向下的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_CoreCard>> get coreBottomAll {
    _CardRowColumnRange targetRowRange = _CardRowColumnRange(coreRowRange.to + 1, _Metric.get().square - 1);
    if (!targetRowRange.isValid()) {
      return <BuiltList<_CoreCard>>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = coreColumnRange;
    List<_CoreCard> coreCards = <_CoreCard>[]..addAll(game.coreCards);
    List<BuiltList<_CoreCard>> list2 = <BuiltList<_CoreCard>>[];
    for (int targetRow = targetRowRange.from; targetRow <= targetRowRange.to; targetRow++) {
      List<_CoreCard> list = <_CoreCard>[];
      coreCards.toBuiltList().forEach((element) {
        if (element.coreRowRange.containValue(targetRow) &&
            targetColumnRange.contain(element.coreColumnRange)) {
          list.add(element);
          coreCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 根据 [ltrb] 返回指定方向的所有卡片.
  BuiltList<BuiltList<_CoreCard>> coreLTRBAll(_LTRB ltrb) {
    switch (ltrb) {
      case _LTRB.left:
        return coreLeftAll;
      case _LTRB.top:
        return coreTopAll;
      case _LTRB.right:
        return coreRightAll;
      case _LTRB.bottom:
        return coreBottomAll;
    }
  }

  /// 根据 [ltrb] 返回指定方向的所有卡片. 如果指定方向的卡片为空, 返回
  BuiltList<BuiltList<_CoreCard>> coreLTRBAllFallback(_LTRB ltrb, {
    bool clockwise = false,
  }) {
    for (_LTRB currentLtrb in ltrb.turns(clockwise: clockwise)) {
      BuiltList<BuiltList<_CoreCard>> list = coreLTRBAll(currentLtrb);
      if (list.isNotEmpty) {
        return list;
      }
    }
    return <BuiltList<_CoreCard>>[].toBuiltList();
  }

  /// 返回 [card] 在当前卡片的相对位置. 如果不在左上右下则返回 null.
  _LTRB coreRelative(_CoreCard card) {
    if (coreLeft.contains(card)) {
      return _LTRB.left;
    }
    if (coreTop.contains(card)) {
      return _LTRB.top;
    }
    if (coreRight.contains(card)) {
      return _LTRB.right;
    }
    if (coreBottom.contains(card)) {
      return _LTRB.bottom;
    }
    return null;
  }
}

//*********************************************************************************************************************

class _CardData implements CardData {
  _Card card;

  @override
  bool get absorbPointer => card.property.absorbPointer;

  @override
  Color get color => Colors.white;

  @override
  double get elevation => card.property.elevation;

  @override
  bool get ignorePointer => card.property.ignorePointer;

  @override
  double get margin => card.property.margin;

  @override
  get onLongPress => card.game.onLongPress(card);

  @override
  get onTap => card.game.onTap(card);

  @override
  double get opacity => card.property.opacity;

  @override
  double get radius => card.property.radius;

  @override
  Rect get rect => card.rect;

  @override
  Matrix4 get transform => card.property.transform;

  @override
  bool Function(int zIndex) get zIndexVisible => card.property.zIndexVisible;

  @override
  String toString() {
    return card.toString();
  }
}
