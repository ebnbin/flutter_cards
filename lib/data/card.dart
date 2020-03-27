part of '../data.dart';

//*********************************************************************************************************************
// 游戏中所有元素都由卡片组成.

/// 按照网格定位的卡片, 可以根据横竖屏控制不同的行列.
class _Card implements Card {
  _Card({
    this.game,
    @required
    _Property initProperty,
    this.grid,
  }) : assert(game != null),
        assert(initProperty != null) {
    _property = initProperty;
  }

  //*******************************************************************************************************************

  final _Game game;

  //*******************************************************************************************************************

  int get index => game._cards.indexOf(this);

  //*******************************************************************************************************************

  _OrientationGrid grid;

  //*******************************************************************************************************************
  // 位置.

  /// 在 Stack 中的位置. Positioned.fromRect().
  @override
  Rect get rect {
    return game._metric.gridRect(grid);
  }

  //*******************************************************************************************************************
  // 属性.

  /// 属性.
  @override
  Property get property => _property;
  _Property _property;

  //*******************************************************************************************************************

  @override
  GestureTapCallback get onTap => game.onTap(card: this);

  @override
  GestureLongPressCallback get onLongPress => game.onLongPress(card: this);

  //*******************************************************************************************************************

  @override
  String toString() {
    return '${grid(game._metric.isVertical)}\n$index';
  }
}

//*********************************************************************************************************************

/// 按照索引定位的卡片, 不能根据横竖屏控制不同的行列.
class _CoreCard extends _Card {
  _CoreCard({
    _Game game,
    @required
    _Property initProperty,
    _Grid coreCardGrid,
  }) : assert(coreCardGrid != null),
        super(
        game: game,
        initProperty: initProperty,
        grid: game._metric.coreCardGridToGrid(coreCardGrid),
      );

  _Grid get coreCardGrid {
    return game._metric.gridToCoreCardGrid(grid);
  }
  set coreCardGrid(_Grid coreCardGrid) {
    grid = game._metric.coreCardGridToGrid(coreCardGrid);
  }

  void left() {
    coreCardGrid = coreCardGrid.left();
  }

  void right() {
    coreCardGrid = coreCardGrid.right();
  }

  void top() {
    coreCardGrid = coreCardGrid.top();
  }

  void bottom() {
    coreCardGrid = coreCardGrid.bottom();
  }

  _Card get leftCard {
    return game._cards.firstWhere((element) {
      if (element is! _CoreCard) {
        return false;
      }
      int r = coreCardGrid.rowIndex;
      int c = coreCardGrid.columnIndex;
      int r2 = (element as _CoreCard).coreCardGrid.rowIndex;
      int c2 = (element as _CoreCard).coreCardGrid.columnIndex;
      return r == r2 && c - 1 == c2;
    }, orElse: () => null);
  }

  _Card get rightCard {
    return game._cards.firstWhere((element) {
      if (element is! _CoreCard) {
        return false;
      }
      int r = coreCardGrid.rowIndex;
      int c = coreCardGrid.columnIndex;
      int r2 = (element as _CoreCard).coreCardGrid.rowIndex;
      int c2 = (element as _CoreCard).coreCardGrid.columnIndex;
      return r == r2 && c + 1 == c2;
    }, orElse: () => null);
  }

  _Card get topCard {
    return game._cards.firstWhere((element) {
      if (element is! _CoreCard) {
        return false;
      }
      int r = coreCardGrid.rowIndex;
      int c = coreCardGrid.columnIndex;
      int r2 = (element as _CoreCard).coreCardGrid.rowIndex;
      int c2 = (element as _CoreCard).coreCardGrid.columnIndex;
      return r - 1 == r2 && c == c2;
    }, orElse: () => null);
  }

  _Card get bottomCard {
    return game._cards.firstWhere((element) {
      if (element is! _CoreCard) {
        return false;
      }
      int r = coreCardGrid.rowIndex;
      int c = coreCardGrid.columnIndex;
      int r2 = (element as _CoreCard).coreCardGrid.rowIndex;
      int c2 = (element as _CoreCard).coreCardGrid.columnIndex;
      return r + 1 == r2 && c == c2;
    }, orElse: () => null);
  }

  @override
  String toString() {
    return '${super.toString()}\n$coreCardGrid';
  }
}
