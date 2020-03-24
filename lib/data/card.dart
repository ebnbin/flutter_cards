part of '../data.dart';

//*********************************************************************************************************************
// 游戏中所有元素都由卡片组成.

abstract class _CardData implements CardData {
  _CardData({
    this.gameData,
    _Property initProperty = const _Property(),
  }) : assert(gameData != null),
        assert(initProperty != null) {
    _property = initProperty;
  }

  //*******************************************************************************************************************

  final _GameData gameData;

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

  //*******************************************************************************************************************

  @override
  GestureTapCallback get onTap => gameData.onTap(cardData: this);

  @override
  GestureLongPressCallback get onLongPress => gameData.onLongPress(cardData: this);
}

//*********************************************************************************************************************

/// 按照索引定位的卡片, 不能根据横竖屏控制不同的行列.
class _IndexCardData extends _GridCardData {
  _IndexCardData({
    _GameData gameData,
    _Property initProperty = const _Property(),
    int rowIndex,
    int columnIndex,
    int rowSpan = 1,
    int columnSpan = 1,
  }) : assert(rowIndex != null),
        assert(columnIndex != null),
        assert(rowSpan != null),
        assert(columnSpan != null),
        super(
        gameData: gameData,
        initProperty: initProperty,
        rowGrid: (isVertical) => isVertical
            ? (rowIndex * gameData.calcMap['gridPerCard']) + 24
            : (rowIndex * gameData.calcMap['gridPerCard']) + 0,
        columnGrid: (isVertical) => isVertical
            ? (columnIndex * gameData.calcMap['gridPerCard']) + 0
            : (columnIndex * gameData.calcMap['gridPerCard']) + 24,
        rowGridSpan: (isVertical) => isVertical
            ? rowSpan * gameData.calcMap['gridPerCard']
            : rowSpan * gameData.calcMap['gridPerCard'],
        columnGridSpan: (isVertical) => isVertical
            ? columnSpan * gameData.calcMap['gridPerCard']
            : columnSpan * gameData.calcMap['gridPerCard'],
      );

  /// 所在行.
  int get rowIndex => gameData.calcMap['isVertical']
      ? (rowGrid(true) - 24) ~/ gameData.calcMap['gridPerCard']
      : (rowGrid(false) - 0) ~/ gameData.calcMap['gridPerCard'];

  /// 所在列.
  int get columnIndex => gameData.calcMap['isVertical']
      ? (columnGrid(true) - 0) ~/ gameData.calcMap['gridPerCard']
      : (columnGrid(false) - 24) ~/ gameData.calcMap['gridPerCard'];

  /// 跨行.
  int get rowSpan => gameData.calcMap['isVertical']
      ? rowGridSpan(true) ~/ gameData.calcMap['gridPerCard']
      : rowGridSpan(false) ~/ gameData.calcMap['gridPerCard'];

  /// 跨列.
  int get columnSpan => gameData.calcMap['isVertical']
      ? columnGridSpan(true) ~/ gameData.calcMap['gridPerCard']
      : columnGridSpan(false) ~/ gameData.calcMap['gridPerCard'];

  @override
  String toString() {
    return '${super.toString()}\n$rowIndex,$columnIndex,$rowSpan,$columnSpan';
  }
}

//*********************************************************************************************************************

/// 按照网格定位的卡片, 可以根据横竖屏控制不同的行列.
class _GridCardData extends _CardData {
  _GridCardData({
    _GameData gameData,
    _Property initProperty = const _Property(),
    this.rowGrid,
    this.columnGrid,
    this.rowGridSpan,
    this.columnGridSpan,
  }) : assert(rowGrid != null),
        assert(columnGrid != null),
        assert(rowGridSpan != null),
        assert(columnGridSpan != null),
        super(
        gameData: gameData,
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
    Map<String, dynamic> map = gameData.calcMap;
    return Rect.fromLTWH(
      map['gridCardSpaceLeft'] + map['gridSize'] * columnGrid(map['isVertical']),
      map['gridCardSpaceTop'] + map['gridSize'] * rowGrid(map['isVertical']),
      map['gridSize'] * columnGridSpan(map['isVertical']),
      map['gridSize'] * rowGridSpan(map['isVertical']),
    );
  }

  @override
  String toString() {
    Map<String, dynamic> map = gameData.calcMap;
    return '${rowGrid(map['isVertical'])},${columnGrid(map['isVertical'])},${rowGridSpan(map['isVertical'])},${columnGridSpan(map['isVertical'])}\n${gameData._cardDataList.indexOf(this)}';
  }
}

typedef _GetGrid = int Function(bool isVertical);
