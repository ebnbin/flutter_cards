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
  });

  /// Body 卡片网格.
  _CardGrid.body({
    int rowIndex = 0,
    int columnIndex = 0,
    int rowSpan = 1,
    int columnSpan = 1,
  }) {
    bodyRowIndex = rowIndex;
    bodyColumnIndex = columnIndex;
    bodyRowSpan = rowSpan;
    bodyColumnSpan = columnSpan;
  }

  /// 所属卡片.
  _Card card;

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
  // Body 相关.

  /// Body 卡片行.
  int get bodyRowIndex {
    return (rowIndex - _Metric.paddingGrid - (_Metric.get().isVertical ? _Metric.headerFooterGrid : 0)) ~/
        _Metric.get().bodyCardGrid;
  }
  set bodyRowIndex(int bodyRowIndex) {
    verticalRowIndex = _Metric.get().bodyCardGrid * bodyRowIndex + _Metric.paddingGrid + _Metric.headerFooterGrid;
    horizontalRowIndex = _Metric.get().bodyCardGrid * bodyRowIndex + _Metric.paddingGrid;
  }

  /// Body 卡片列.
  int get bodyColumnIndex {
    return (columnIndex - _Metric.paddingGrid - (_Metric.get().isVertical ? 0 : _Metric.headerFooterGrid)) ~/
        _Metric.get().bodyCardGrid;
  }
  set bodyColumnIndex(int bodyColumnIndex) {
    verticalColumnIndex = _Metric.get().bodyCardGrid * bodyColumnIndex + _Metric.paddingGrid;
    horizontalColumnIndex = _Metric.get().bodyCardGrid * bodyColumnIndex + _Metric.paddingGrid +
        _Metric.headerFooterGrid;
  }

  /// Body 卡片跨行.
  int get bodyRowSpan {
    return rowSpan ~/ _Metric.get().bodyCardGrid;
  }
  set bodyRowSpan(int bodyRowSpan) {
    rowSpan = _Metric.get().bodyCardGrid * bodyRowSpan;
  }

  /// Body 卡片跨列.
  int get bodyColumnSpan {
    return columnSpan ~/ _Metric.get().bodyCardGrid;
  }
  set bodyColumnSpan(int bodyColumnSpan) {
    columnSpan = _Metric.get().bodyCardGrid * bodyColumnSpan;
  }

  /// Body 卡片所在行范围. 对于不跨行的卡片, from == to == bodyRowIndex.
  _CardRowColumnRange get bodyRowRange {
    return _CardRowColumnRange(bodyRowIndex, bodyRowIndex + bodyRowSpan - 1);
  }

  /// Body 卡片所在列范围. 对于不跨列的卡片, from == to == bodyColumnIndex.
  _CardRowColumnRange get bodyColumnRange {
    return _CardRowColumnRange(bodyColumnIndex, bodyColumnIndex + bodyColumnSpan - 1);
  }

  /// 从 [_Game.bodyCards] 中返回当前卡片左边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_Card> get bodyLeft {
    int targetColumn = bodyColumnRange.from - 1;
    if (targetColumn < 0) {
      return <_Card>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = bodyRowRange;
    return card.game.bodyCards.where((element) {
      return targetRowRange.contain(element.grid.bodyRowRange) &&
          element.grid.bodyColumnRange.containValue(targetColumn);
    }).toBuiltList();
  }

  /// 从 [_Game.bodyCards] 中返回当前卡片上边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_Card> get bodyTop {
    int targetRow = bodyRowRange.from - 1;
    if (targetRow < 0) {
      return <_Card>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = bodyColumnRange;
    return card.game.bodyCards.where((element) {
      return element.grid.bodyRowRange.containValue(targetRow) &&
          targetColumnRange.contain(element.grid.bodyColumnRange);
    }).toBuiltList();
  }

  /// 从 [_Game.bodyCards] 中返回当前卡片右边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_Card> get bodyRight {
    int targetColumn = bodyColumnRange.to + 1;
    if (targetColumn >= _Metric.get().square) {
      return <_Card>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = bodyRowRange;
    return card.game.bodyCards.where((element) {
      return targetRowRange.contain(element.grid.bodyRowRange) &&
          element.grid.bodyColumnRange.containValue(targetColumn);
    }).toBuiltList();
  }

  /// 从 [_Game.bodyCards] 中返回当前卡片下边的卡片. 当卡片跨多行时可能存在多个符合条件的卡片. 如果没符合条件的卡片则返回空列表.
  BuiltList<_Card> get bodyBottom {
    int targetRow = bodyRowRange.to + 1;
    if (targetRow >= _Metric.get().square) {
      return <_Card>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = bodyColumnRange;
    return card.game.bodyCards.where((element) {
      return element.grid.bodyRowRange.containValue(targetRow) &&
          targetColumnRange.contain(element.grid.bodyColumnRange);
    }).toBuiltList();
  }

  /// 从 [_Game.bodyCards] 中返回当前卡片左边所有的卡片. 第一维度列表表示从右向左的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_Card>> get bodyLeftAll {
    _CardRowColumnRange targetColumnRange = _CardRowColumnRange(0, bodyColumnRange.from - 1);
    if (!targetColumnRange.isValid()) {
      return <BuiltList<_Card>>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = bodyRowRange;
    List<_Card> bodyCards = <_Card>[]..addAll(card.game.bodyCards);
    List<BuiltList<_Card>> list2 = <BuiltList<_Card>>[];
    for (int targetColumn = targetColumnRange.to; targetColumn >= targetColumnRange.from; targetColumn--) {
      List<_Card> list = <_Card>[];
      bodyCards.toBuiltList().forEach((element) {
        if (targetRowRange.contain(element.grid.bodyRowRange) &&
            element.grid.bodyColumnRange.containValue(targetColumn)) {
          list.add(element);
          bodyCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 从 [_Game.bodyCards] 中返回当前卡片上边所有的卡片. 第一维度列表表示从下向上的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_Card>> get bodyTopAll {
    _CardRowColumnRange targetRowRange = _CardRowColumnRange(0, bodyRowRange.from - 1);
    if (!targetRowRange.isValid()) {
      return <BuiltList<_Card>>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = bodyColumnRange;
    List<_Card> bodyCards = <_Card>[]..addAll(card.game.bodyCards);
    List<BuiltList<_Card>> list2 = <BuiltList<_Card>>[];
    for (int targetRow = targetRowRange.to; targetRow >= targetRowRange.from; targetRow--) {
      List<_Card> list = <_Card>[];
      bodyCards.toBuiltList().forEach((element) {
        if (element.grid.bodyRowRange.containValue(targetRow) &&
            targetColumnRange.contain(element.grid.bodyColumnRange)) {
          list.add(element);
          bodyCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 从 [_Game.bodyCards] 中返回当前卡片右边所有的卡片. 第一维度列表表示从左向右的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_Card>> get bodyRightAll {
    _CardRowColumnRange targetColumnRange = _CardRowColumnRange(bodyColumnRange.to + 1, _Metric.get().square - 1);
    if (!targetColumnRange.isValid()) {
      return <BuiltList<_Card>>[].toBuiltList();
    }
    _CardRowColumnRange targetRowRange = bodyRowRange;
    List<_Card> bodyCards = <_Card>[]..addAll(card.game.bodyCards);
    List<BuiltList<_Card>> list2 = <BuiltList<_Card>>[];
    for (int targetColumn = targetColumnRange.from; targetColumn <= targetColumnRange.to; targetColumn++) {
      List<_Card> list = <_Card>[];
      bodyCards.toBuiltList().forEach((element) {
        if (targetRowRange.contain(element.grid.bodyRowRange) &&
            element.grid.bodyColumnRange.containValue(targetColumn)) {
          list.add(element);
          bodyCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 从 [_Game.bodyCards] 中返回当前卡片下边所有的卡片. 第一维度列表表示从上向下的各列, 第二维度列表表示该列符合条件的多个卡片.
  BuiltList<BuiltList<_Card>> get bodyBottomAll {
    _CardRowColumnRange targetRowRange = _CardRowColumnRange(bodyRowRange.to + 1, _Metric.get().square - 1);
    if (!targetRowRange.isValid()) {
      return <BuiltList<_Card>>[].toBuiltList();
    }
    _CardRowColumnRange targetColumnRange = bodyColumnRange;
    List<_Card> bodyCards = <_Card>[]..addAll(card.game.bodyCards);
    List<BuiltList<_Card>> list2 = <BuiltList<_Card>>[];
    for (int targetRow = targetRowRange.from; targetRow <= targetRowRange.to; targetRow++) {
      List<_Card> list = <_Card>[];
      bodyCards.toBuiltList().forEach((element) {
        if (element.grid.bodyRowRange.containValue(targetRow) &&
            targetColumnRange.contain(element.grid.bodyColumnRange)) {
          list.add(element);
          bodyCards.remove(element);
        }
      });
      list2.add(list.toBuiltList());
    }
    return list2.toBuiltList();
  }

  /// 根据 [ltrb] 返回指定方向的所有卡片.
  BuiltList<BuiltList<_Card>> bodyLTRBAll(_LTRB ltrb) {
    switch (ltrb) {
      case _LTRB.left:
        return bodyLeftAll;
      case _LTRB.top:
        return bodyTopAll;
      case _LTRB.right:
        return bodyRightAll;
      case _LTRB.bottom:
        return bodyBottomAll;
    }
  }

  /// 根据 [ltrb] 返回指定方向的所有卡片. 如果指定方向的卡片为空, 返回
  BuiltList<BuiltList<_Card>> bodyLTRBAllFallback(_LTRB ltrb, {
    bool clockwise = false,
  }) {
    for (_LTRB currentLtrb in ltrb.turns(clockwise: clockwise)) {
      BuiltList<BuiltList<_Card>> list = bodyLTRBAll(currentLtrb);
      if (list.isNotEmpty) {
        return list;
      }
    }
    return <BuiltList<_Card>>[].toBuiltList();
  }

  //*******************************************************************************************************************

  @override
  String toString() {
    return '$verticalRowIndex,$verticalColumnIndex,$verticalRowSpan,$verticalColumnSpan\n'
        '$horizontalRowIndex,$horizontalColumnIndex,$horizontalRowSpan,$horizontalColumnSpan';
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
}
