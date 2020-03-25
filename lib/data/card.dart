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

  /// 是否可见.
  @override
  bool zIndexVisible(int zIndex) {
    if (!_visible) {
      return false;
    }
    int elevationInt;
    if (property.elevation < 1.0) {
      elevationInt = 0;
    } else if (property.elevation == 1.0) {
      elevationInt = 1;
    } else if (property.elevation > 4.0) {
      elevationInt = 5;
    } else {
      elevationInt = property.elevation.ceil();
    }
    return elevationInt == zIndex;
  }
  bool _visible = true;

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
    this.rowGrid,
    this.columnGrid,
    this.rowGridSpan,
    this.columnGridSpan,
  }) : assert(rowGrid != null),
        assert(columnGrid != null),
        assert(rowGridSpan != null),
        assert(columnGridSpan != null),
        super(
        game: game,
        initProperty: initProperty,
      );

  /// 所在网格行.
  _GetGrid rowGrid;

  /// 所在网格列.
  _GetGrid columnGrid;

  /// 网格跨行.
  _GetGrid rowGridSpan;

  /// 网格跨列.
  _GetGrid columnGridSpan;

  @override
  Rect get rect {
    Map<String, dynamic> map = game.calcMap;
    return Rect.fromLTWH(
      map['gridCardSpaceLeft'] + map['gridSize'] * columnGrid(map['isVertical']),
      map['gridCardSpaceTop'] + map['gridSize'] * rowGrid(map['isVertical']),
      map['gridSize'] * columnGridSpan(map['isVertical']),
      map['gridSize'] * rowGridSpan(map['isVertical']),
    );
  }

  @override
  String toString() {
    Map<String, dynamic> map = game.calcMap;
    return '${rowGrid(map['isVertical'])},${columnGrid(map['isVertical'])},${rowGridSpan(map['isVertical'])},${columnGridSpan(map['isVertical'])}\n${game._cards.indexOf(this)}';
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
        rowGrid: rowIndexToRowGrid(game, rowIndex),
        columnGrid: columnIndexToColumnGrid(game, columnIndex),
        rowGridSpan: rowSpanToRowGridSpan(game, rowSpan),
        columnGridSpan: columnSpanToColumnGridSpan(game, columnSpan),
      );

  static _GetGrid rowIndexToRowGrid(_Game game, int rowIndex) {
    return (isVertical) => isVertical
        ? (rowIndex * game.calcMap['gridPerCard']) + 24
        : (rowIndex * game.calcMap['gridPerCard']) + 0;
  }

  static _GetGrid columnIndexToColumnGrid(_Game game, int columnIndex) {
    return (isVertical) => isVertical
        ? (columnIndex * game.calcMap['gridPerCard']) + 0
        : (columnIndex * game.calcMap['gridPerCard']) + 24;
  }

  static _GetGrid rowSpanToRowGridSpan(_Game game, int rowSpan) {
    return (isVertical) => isVertical
        ? rowSpan * game.calcMap['gridPerCard']
        : rowSpan * game.calcMap['gridPerCard'];
  }

  static _GetGrid columnSpanToColumnGridSpan(_Game game, int columnSpan) {
    return (isVertical) => isVertical
        ? columnSpan * game.calcMap['gridPerCard']
        : columnSpan * game.calcMap['gridPerCard'];
  }

  /// 所在行.
  int get rowIndex => game.calcMap['isVertical']
      ? (rowGrid(true) - 24) ~/ game.calcMap['gridPerCard']
      : (rowGrid(false) - 0) ~/ game.calcMap['gridPerCard'];
  set rowIndex(int rowIndex) {
    rowGrid = rowIndexToRowGrid(game, rowIndex);
  }

  /// 所在列.
  int get columnIndex => game.calcMap['isVertical']
      ? (columnGrid(true) - 0) ~/ game.calcMap['gridPerCard']
      : (columnGrid(false) - 24) ~/ game.calcMap['gridPerCard'];
  set columnIndex(int columnIndex) {
    columnGrid = columnIndexToColumnGrid(game, columnIndex);
  }

  /// 跨行.
  int get rowSpan => game.calcMap['isVertical']
      ? rowGridSpan(true) ~/ game.calcMap['gridPerCard']
      : rowGridSpan(false) ~/ game.calcMap['gridPerCard'];
  set rowSpan(int rowSpan) {
    rowGridSpan = rowSpanToRowGridSpan(game, rowSpan);
  }

  /// 跨列.
  int get columnSpan => game.calcMap['isVertical']
      ? columnGridSpan(true) ~/ game.calcMap['gridPerCard']
      : columnGridSpan(false) ~/ game.calcMap['gridPerCard'];
  set columnSpan(int columnSpan) {
    columnGridSpan = columnSpanToColumnGridSpan(game, columnSpan);
  }

  void left() {
    if (columnIndex > 0) {
      columnIndex--;
    }
  }

  void right() {
    if (columnIndex < game.columnCount - 1) {
      columnIndex++;
    }
  }

  void top() {
    if (rowIndex > 0) {
      rowIndex--;
    }
  }

  void bottom() {
    if (rowIndex < game.rowCount - 1) {
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
