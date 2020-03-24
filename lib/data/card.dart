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
class _IndexCardData extends _CardData {
  _IndexCardData({
    _GameData gameData,
    _Property initProperty = const _Property(),
    this.rowIndex,
    this.columnIndex,
    this.rowSpan = 1,
    this.columnSpan = 1,
  }) : assert(rowIndex != null),
        assert(columnIndex != null),
        assert(rowSpan != null),
        assert(columnSpan != null),
        super(
        gameData: gameData,
        initProperty: initProperty,
      );

  /// 所在行.
  int rowIndex;

  /// 所在列.
  int columnIndex;

  /// 跨行.
  int rowSpan;

  /// 跨列.
  int columnSpan;

  @override
  Rect get rect {
    const double padding = 8.0;
    // 默认网格数. 竖屏时水平方向的网格数, 或横屏时垂直方向的网格数.
    const int defaultGridCount = 60;
    // Header 和 footer 占用的网格数. 竖屏时占用高度, 横屏时占用宽度. 其中 8 格是 header footer 和 body 的间距.
    const int headerFooterGridCount = 48;
    MediaQueryData mediaQueryData = MediaQuery.of(gameData.callback.context);
    Size safeSize = Size(
      mediaQueryData.size.width - mediaQueryData.padding.horizontal - padding * 2.0,
      mediaQueryData.size.height - mediaQueryData.padding.vertical - padding * 2.0,
    );
    // 水平方向网格数量.
    int horizontalGridCount;
    // 垂直方向网格数量.
    int verticalGridCount;
    // 每个卡片占用几个网格.
    int gridPerCard;
    bool isVertical = safeSize.width <= safeSize.height;
    if (isVertical) {
      // 竖屏.
      horizontalGridCount = defaultGridCount;
      gridPerCard = defaultGridCount ~/ gameData.columnCount;
      verticalGridCount = defaultGridCount ~/ gameData.columnCount * gameData.rowCount + headerFooterGridCount;
    } else {
      // 横屏.
      verticalGridCount = defaultGridCount;
      gridPerCard = defaultGridCount ~/ gameData.rowCount;
      horizontalGridCount = defaultGridCount ~/ gameData.rowCount * gameData.columnCount + headerFooterGridCount;
    }
    // 网格宽高.
    double gridSize = min(safeSize.width / horizontalGridCount, safeSize.height / verticalGridCount);
    // 卡片宽高.
    double cardSize = gridSize * gridPerCard;
    // 左边距.
    double spaceLeft = (safeSize.width - cardSize * gameData.columnCount) / 2.0 + padding;
    // 上边距.
    double spaceTop = (safeSize.height - cardSize * gameData.rowCount) / 2.0 + padding;
    return Rect.fromLTWH(
      spaceLeft + cardSize * columnIndex,
      spaceTop + cardSize * rowIndex,
      cardSize * columnSpan,
      cardSize * rowSpan,
    );
  }

  @override
  String toString() {
    return '$rowIndex,$columnIndex,$rowSpan,$columnSpan\n${gameData._cardDataList.indexOf(this)}';
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
    const double padding = 8.0;
    // 默认网格数. 竖屏时水平方向的网格数, 或横屏时垂直方向的网格数.
    const int defaultGridCount = 60;
    // Header 和 footer 占用的网格数. 竖屏时占用高度, 横屏时占用宽度. 其中 8 格是 header footer 和 body 的间距.
    const int headerFooterGridCount = 48;
    MediaQueryData mediaQueryData = MediaQuery.of(gameData.callback.context);
    Size safeSize = Size(
      mediaQueryData.size.width - mediaQueryData.padding.horizontal - padding * 2.0,
      mediaQueryData.size.height - mediaQueryData.padding.vertical - padding * 2.0,
    );
    // 水平方向网格数量.
    int horizontalGridCount;
    // 垂直方向网格数量.
    int verticalGridCount;
    bool isVertical = safeSize.width <= safeSize.height;
    if (isVertical) {
      // 竖屏.
      horizontalGridCount = defaultGridCount;
      verticalGridCount = defaultGridCount ~/ gameData.columnCount * gameData.rowCount + headerFooterGridCount;
    } else {
      // 横屏.
      verticalGridCount = defaultGridCount;
      horizontalGridCount = defaultGridCount ~/ gameData.rowCount * gameData.columnCount + headerFooterGridCount;
    }
    // 网格宽高.
    double gridSize = min(safeSize.width / horizontalGridCount, safeSize.height / verticalGridCount);
    // 左边距.
    double spaceLeft = (safeSize.width - gridSize * horizontalGridCount) / 2.0 + padding;
    // 上边距.
    double spaceTop = (safeSize.height - gridSize * verticalGridCount) / 2.0 + padding;
    return Rect.fromLTWH(
      spaceLeft + gridSize * columnGrid(isVertical),
      spaceTop + gridSize * rowGrid(isVertical),
      gridSize * columnGridSpan(isVertical),
      gridSize * rowGridSpan(isVertical),
    );
  }
}

typedef _GetGrid = int Function(bool isVertical);
