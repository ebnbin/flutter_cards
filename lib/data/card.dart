part of '../data.dart';

//*********************************************************************************************************************
// 游戏中所有元素都由卡片组成.

abstract class _Card implements Card {
  _Card({
    this.game,
    _Property initProperty = const _Property.def(),
  }) : assert(game != null),
        assert(initProperty != null) {
    _property = initProperty;
  }

  //*******************************************************************************************************************

  final _Game game;

  //*******************************************************************************************************************

  Color _color = Colors.white;
  @override
  Color get color => _color;

  //*******************************************************************************************************************

  int get index => game._cards.indexOf(this);

  //*******************************************************************************************************************
  // 位置.

  /// 在 Stack 中的位置. Positioned.fromRect().
  @override
  Rect get rect;

  //*******************************************************************************************************************
  // 属性.

  /// 属性.
  @override
  Property get property => _property;
  _Property _property;

  void updateProperty(_Property property) {
    _property = _property.update(property);
  }

  //*******************************************************************************************************************

  @override
  GestureTapCallback get onTap => game.onTap(card: this);

  @override
  GestureLongPressCallback get onLongPress => game.onLongPress(card: this);
}

//*********************************************************************************************************************

/// 按照网格定位的卡片, 可以根据横竖屏控制不同的行列.
class _GridCard extends _Card {
  _GridCard({
    _Game game,
    _Property initProperty = const _Property.def(),
    this.gridColumnIndex,
    this.gridRowIndex,
    this.gridColumnSpan,
    this.gridRowSpan,
  }) : assert(gridColumnIndex != null),
        assert(gridRowIndex != null),
        assert(gridColumnSpan != null),
        assert(gridRowSpan != null),
        super(
        game: game,
        initProperty: initProperty,
      );

  /// 所在网格列.
  _OrientationGrid gridColumnIndex;

  /// 所在网格行.
  _OrientationGrid gridRowIndex;

  /// 网格跨列.
  _OrientationGrid gridColumnSpan;

  /// 网格跨行.
  _OrientationGrid gridRowSpan;

  @override
  Rect get rect {
    return game._metric.gridRect(gridColumnIndex, gridRowIndex, gridColumnSpan, gridRowSpan);
  }

  @override
  String toString() {
//    return '${rowGrid(map['isVertical'])},${columnGrid(map['isVertical'])},${rowGridSpan(map['isVertical'])},${columnGridSpan(map['isVertical'])}\n${game._cards.indexOf(this)}';
    return super.toString();
  }
}

typedef _GetGrid = int Function(bool isVertical);

//*********************************************************************************************************************

/// 按照索引定位的卡片, 不能根据横竖屏控制不同的行列.
class _IndexCard extends _GridCard {
  _IndexCard({
    _Game game,
    _Property initProperty = const _Property.def(),
    int rowIndex,
    int columnIndex,
    int rowSpan = 1,
    int columnSpan = 1,
  }) : assert(rowIndex != null),
        assert(columnIndex != null),
        assert(rowSpan != null),
        assert(columnSpan != null),
        super(
        game: game,
        initProperty: initProperty,
        gridColumnIndex: game._metric.columnIndexToGridColumnIndex(columnIndex),
        gridRowIndex: game._metric.rowIndexToGridRowIndex(rowIndex),
        gridColumnSpan: game._metric.columnSpanToGridColumnSpan(columnSpan),
        gridRowSpan: game._metric.rowSpanToGridRowSpan(rowSpan),
      );

  /// 所在列.
  int get columnIndex {
    return game._metric.gridColumnIndexToColumnIndex(gridColumnIndex);
  }
  set columnIndex(int columnIndex) {
    gridColumnIndex = game._metric.columnIndexToGridColumnIndex(columnIndex);
  }

  /// 所在行.
  int get rowIndex {
    return game._metric.gridRowIndexToRowIndex(gridRowIndex);
  }
  set rowIndex(int rowIndex) {
    gridRowIndex = game._metric.rowIndexToGridRowIndex(rowIndex);
  }

  /// 跨列.
  int get columnSpan {
    return game._metric.gridColumnSpanToColumnSpan(gridColumnSpan);
  }
  set columnSpan(int columnSpan) {
    gridColumnSpan = game._metric.columnSpanToGridColumnSpan(columnSpan);
  }

  /// 跨行.
  int get rowSpan {
    return game._metric.gridRowSpanToRowSpan(gridRowSpan);
  }
  set rowSpan(int rowSpan) {
    gridRowSpan = game._metric.rowSpanToGridRowSpan(rowSpan);
  }

  void left() {
    if (columnIndex > 0) {
      columnIndex--;
    }
  }

  void right() {
    if (columnIndex < game.size - 1) {
      columnIndex++;
    }
  }

  void top() {
    if (rowIndex > 0) {
      rowIndex--;
    }
  }

  void bottom() {
    if (rowIndex < game.size - 1) {
      rowIndex++;
    }
  }

  _Card get leftCard {
    return game._cards.firstWhere((element) {
      if (element is! _IndexCard) {
        return false;
      }
      int r = rowIndex;
      int c = columnIndex;
      int r2 = (element as _IndexCard).rowIndex;
      int c2 = (element as _IndexCard).columnIndex;
      return r == r2 && c - 1 == c2;
    }, orElse: () => null);
  }

  _Card get rightCard {
    return game._cards.firstWhere((element) {
      if (element is! _IndexCard) {
        return false;
      }
      int r = rowIndex;
      int c = columnIndex;
      int r2 = (element as _IndexCard).rowIndex;
      int c2 = (element as _IndexCard).columnIndex;
      return r == r2 && c + 1 == c2;
    }, orElse: () => null);
  }

  _Card get topCard {
    return game._cards.firstWhere((element) {
      if (element is! _IndexCard) {
        return false;
      }
      int r = rowIndex;
      int c = columnIndex;
      int r2 = (element as _IndexCard).rowIndex;
      int c2 = (element as _IndexCard).columnIndex;
      return r - 1 == r2 && c == c2;
    }, orElse: () => null);
  }

  _Card get bottomCard {
    return game._cards.firstWhere((element) {
      if (element is! _IndexCard) {
        return false;
      }
      int r = rowIndex;
      int c = columnIndex;
      int r2 = (element as _IndexCard).rowIndex;
      int c2 = (element as _IndexCard).columnIndex;
      return r + 1 == r2 && c == c2;
    }, orElse: () => null);
  }

  @override
  String toString() {
    return '${super.toString()}\n$rowIndex,$columnIndex,$rowSpan,$columnSpan';
  }
}
