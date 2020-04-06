part of '../data.dart';

//*********************************************************************************************************************

/// 卡片网格.
class _CardGrid {
  _CardGrid({
    this.verticalRowIndex = 0,
    this.verticalColumnIndex = 0,
    this.verticalRowSpan = 1,
    this.verticalColumnSpan = 1,
    this.horizontalRowIndex = 0,
    this.horizontalColumnIndex = 0,
    this.horizontalRowSpan = 1,
    this.horizontalColumnSpan = 1,
    @required
    this.type,
  });

  /// Core 卡片网格.
  _CardGrid.core({
    int rowIndex = 0,
    int columnIndex = 0,
    int rowSpan = 1,
    int columnSpan = 1,
  }) : this.type = _CardType.core {
    coreRowIndex = rowIndex;
    coreColumnIndex = columnIndex;
    coreRowSpan = rowSpan;
    coreColumnSpan = columnSpan;
  }

  /// 所属卡片.
  _Card card;

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

  /// 当前卡片在对应类型卡片列表中的 index.
  int get index {
    switch (type) {
      case _CardType.core:
        return card.game.coreCards.indexOf(card);
      case _CardType.headerFooter:
        return card.game.headerFooterCards.indexOf(card);
      default:
        throw Exception();
    }
  }

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
  // Core 相关.

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
  BuiltList<_Card> get coreLeft {
    int targetColumn = coreColumnRange.from - 1;
    if (targetColumn < 0) {
      return <_Card>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = coreRowRange;
    return card.game.coreCards.where((element) {
      return targetRowRange.contain(element.grid.coreRowRange) &&
          element.grid.coreColumnRange.containValue(targetColumn);
    }).toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片上边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_Card> get coreTop {
    int targetRow = coreRowRange.from - 1;
    if (targetRow < 0) {
      return <_Card>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = coreColumnRange;
    return card.game.coreCards.where((element) {
      return element.grid.coreRowRange.containValue(targetRow) &&
          targetColumnRange.contain(element.grid.coreColumnRange);
    }).toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片右边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_Card> get coreRight {
    int targetColumn = coreColumnRange.to + 1;
    if (targetColumn >= _Metric.get().square) {
      return <_Card>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = coreRowRange;
    return card.game.coreCards.where((element) {
      return targetRowRange.contain(element.grid.coreRowRange) &&
          element.grid.coreColumnRange.containValue(targetColumn);
    }).toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片下边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_Card> get coreBottom {
    int targetRow = coreRowRange.to + 1;
    if (targetRow >= _Metric.get().square) {
      return <_Card>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = coreColumnRange;
    return card.game.coreCards.where((element) {
      return element.grid.coreRowRange.containValue(targetRow) &&
          targetColumnRange.contain(element.grid.coreColumnRange);
    }).toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片左边所有的卡片. 第一维度列表表示从右向左的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_Card>> get coreLeftAll {
    _CardRowColumnRange targetColumnRange = _CardRowColumnRange(0, coreColumnRange.from - 1);
    if (!targetColumnRange.isValid()) {
      return <BuiltList<_Card>>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = coreRowRange;
    List<_Card> coreCards = <_Card>[]..addAll(card.game.coreCards);
    List<BuiltList<_Card>> list2 = <BuiltList<_Card>>[];
    for (int targetColumn = targetColumnRange.to; targetColumn >= targetColumnRange.from; targetColumn--) {
      List<_Card> list = <_Card>[];
      coreCards.toBuiltList().forEach((element) {
        if (targetRowRange.contain(element.grid.coreRowRange) &&
            element.grid.coreColumnRange.containValue(targetColumn)) {
          list.add(element);
          coreCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片上边所有的卡片. 第一维度列表表示从下向上的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_Card>> get coreTopAll {
    _CardRowColumnRange targetRowRange = _CardRowColumnRange(0, coreRowRange.from - 1);
    if (!targetRowRange.isValid()) {
      return <BuiltList<_Card>>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = coreColumnRange;
    List<_Card> coreCards = <_Card>[]..addAll(card.game.coreCards);
    List<BuiltList<_Card>> list2 = <BuiltList<_Card>>[];
    for (int targetRow = targetRowRange.to; targetRow >= targetRowRange.from; targetRow--) {
      List<_Card> list = <_Card>[];
      coreCards.toBuiltList().forEach((element) {
        if (element.grid.coreRowRange.containValue(targetRow) &&
            targetColumnRange.contain(element.grid.coreColumnRange)) {
          list.add(element);
          coreCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片右边所有的卡片. 第一维度列表表示从左向右的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_Card>> get coreRightAll {
    _CardRowColumnRange targetColumnRange = _CardRowColumnRange(coreColumnRange.to + 1, _Metric.get().square - 1);
    if (!targetColumnRange.isValid()) {
      return <BuiltList<_Card>>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = coreRowRange;
    List<_Card> coreCards = <_Card>[]..addAll(card.game.coreCards);
    List<BuiltList<_Card>> list2 = <BuiltList<_Card>>[];
    for (int targetColumn = targetColumnRange.from; targetColumn <= targetColumnRange.to; targetColumn++) {
      List<_Card> list = <_Card>[];
      coreCards.toBuiltList().forEach((element) {
        if (targetRowRange.contain(element.grid.coreRowRange) &&
            element.grid.coreColumnRange.containValue(targetColumn)) {
          list.add(element);
          coreCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 从 [_Game.coreCards] 中返回当前卡片下边所有的卡片. 第一维度列表表示从上向下的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_Card>> get coreBottomAll {
    _CardRowColumnRange targetRowRange = _CardRowColumnRange(coreRowRange.to + 1, _Metric.get().square - 1);
    if (!targetRowRange.isValid()) {
      return <BuiltList<_Card>>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = coreColumnRange;
    List<_Card> coreCards = <_Card>[]..addAll(card.game.coreCards);
    List<BuiltList<_Card>> list2 = <BuiltList<_Card>>[];
    for (int targetRow = targetRowRange.from; targetRow <= targetRowRange.to; targetRow++) {
      List<_Card> list = <_Card>[];
      coreCards.toBuiltList().forEach((element) {
        if (element.grid.coreRowRange.containValue(targetRow) &&
            targetColumnRange.contain(element.grid.coreColumnRange)) {
          list.add(element);
          coreCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 根据 [ltrb] 返回指定方向的所有卡片.
  BuiltList<BuiltList<_Card>> coreLTRBAll(_LTRB ltrb) {
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
  BuiltList<BuiltList<_Card>> coreLTRBAllFallback(_LTRB ltrb, {
    bool clockwise = false,
  }) {
    for (_LTRB currentLtrb in ltrb.turns(clockwise: clockwise)) {
      BuiltList<BuiltList<_Card>> list = coreLTRBAll(currentLtrb);
      if (list.isNotEmpty) {
        return list;
      }
    }
    return <BuiltList<_Card>>[].toBuiltList();
  }

  /// 返回 [card] 在当前卡片的相对位置. 如果不在左上右下则返回 null.
  _LTRB coreRelative(_Card card) {
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

  //*******************************************************************************************************************

  @override
  String toString() {
    String result = '$verticalRowIndex,$verticalColumnIndex,$verticalRowSpan,$verticalColumnSpan\n'
        '$horizontalRowIndex,$horizontalColumnIndex,$horizontalRowSpan,$horizontalColumnSpan';
    if (type == _CardType.core) {
      result += '\n$coreRowIndex,$coreColumnIndex,$coreRowSpan,$coreColumnSpan';
    }
    result += '\n$index';
    return result;
  }
}

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
