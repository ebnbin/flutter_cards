part of 'data.dart';

//*********************************************************************************************************************

abstract class GameCallback implements TickerProvider {
  BuildContext get context;

  void setState(VoidCallback fn);
}

//*********************************************************************************************************************

/// 游戏数据.
///
/// 有效行列范围: 2 ~ 6. Header footer 固定都是 2 * 6. 网格粒度 60. 2, 3, 4, 5, 6 都是 60 的约数.
class GameData {
  GameData({
    this.callback,
  }) {
    _initCardDataList();
  }

  final GameCallback callback;

  void _initCardDataList() {
    for (int rowIndex = 0; rowIndex < _rowCount; rowIndex++) {
      for (int columnIndex = 0; columnIndex < _columnCount; columnIndex++) {
        if (rowIndex == 2 && (columnIndex == 1 || columnIndex == 2)) {
          continue;
        }
        _cardDataList.add(IndexCardData(
          gameData: this,
          rowIndex: rowIndex,
          columnIndex: columnIndex,
          rowSpan: 1,
          columnSpan: 1,
        ));
      }
    }
    _cardDataList.add(IndexCardData(
      gameData: this,
      rowIndex: 2,
      columnIndex: 1,
      rowSpan: 1,
      columnSpan: 2,
    ));
    _cardDataList.add(GridCardData(
      gameData: this,
      rowGrid: (isVertical) => isVertical ? 0 : 0,
      columnGrid: (isVertical) => isVertical ? 0 : 0,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cardDataList.add(GridCardData(
      gameData: this,
      rowGrid: (isVertical) => isVertical ? 10 : 30,
      columnGrid: (isVertical) => isVertical ? 20 : 0,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 20 : 20,
    ));
    _cardDataList.add(GridCardData(
      gameData: this,
      rowGrid: (isVertical) => isVertical ? 88 : 0,
      columnGrid: (isVertical) => isVertical ? 0 : 88,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cardDataList.add(GridCardData(
      gameData: this,
      rowGrid: (isVertical) => isVertical ? 88 : 10,
      columnGrid: (isVertical) => isVertical ? 10 : 88,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cardDataList.add(GridCardData(
      gameData: this,
      rowGrid: (isVertical) => isVertical ? 88 : 20,
      columnGrid: (isVertical) => isVertical ? 20 : 88,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cardDataList.add(GridCardData(
      gameData: this,
      rowGrid: (isVertical) => isVertical ? 88 : 30,
      columnGrid: (isVertical) => isVertical ? 30 : 88,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cardDataList.add(GridCardData(
      gameData: this,
      rowGrid: (isVertical) => isVertical ? 88 : 40,
      columnGrid: (isVertical) => isVertical ? 40 : 88,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cardDataList.add(GridCardData(
      gameData: this,
      rowGrid: (isVertical) => isVertical ? 88 : 50,
      columnGrid: (isVertical) => isVertical ? 50 : 88,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 10 : 10,
    ));
  }

  //*******************************************************************************************************************

  /// 行数. 不包括 header footer.
  int _rowCount = 4;
  /// 列数. 不包括 header footer.
  int _columnCount = 4;

  //*******************************************************************************************************************

  /// 存储所有卡片.
  List<CardData> _cardDataList = [];
  BuiltList<CardData> get cardDataList {
    // 每次 build 时排序.
    _cardDataList.sort();
    return _cardDataList.build();
  }

  //*******************************************************************************************************************

  /// 安全矩形.
  Rect safeRect(BuildContext context) {
    const double padding = 8.0;
    // 默认网格数. 竖屏时水平方向的网格数, 或横屏时垂直方向的网格数.
    const int defaultGridCount = 60;
    // Header 和 footer 占用的网格数. 竖屏时占用高度, 横屏时占用宽度. 其中 8 格是 header footer 和 body 的间距.
    const int headerFooterGridCount = 48;
    Size safeSize = _safeSize(context,
      padding: padding,
    );
    // 水平方向网格数量.
    int horizontalGridCount;
    // 垂直方向网格数量.
    int verticalGridCount;
    bool isVertical = safeSize.width <= safeSize.height;
    if (isVertical) {
      // 竖屏.
      horizontalGridCount = defaultGridCount;
      verticalGridCount = defaultGridCount ~/ _columnCount * _rowCount + headerFooterGridCount;
    } else {
      // 横屏.
      verticalGridCount = defaultGridCount;
      horizontalGridCount = defaultGridCount ~/ _rowCount * _columnCount + headerFooterGridCount;
    }
    // 网格宽高.
    double gridSize = min(safeSize.width / horizontalGridCount, safeSize.height / verticalGridCount);
    return Rect.fromLTWH(
      (safeSize.width - gridSize * horizontalGridCount) / 2.0,
      (safeSize.height - gridSize * verticalGridCount) / 2.0,
      gridSize * horizontalGridCount + padding * 2.0,
      gridSize * verticalGridCount + padding * 2.0,
    );
  }

  /// 游戏面板矩形.
  Rect boardRect(BuildContext context) {
    const double padding = 8.0;
    // 默认网格数. 竖屏时水平方向的网格数, 或横屏时垂直方向的网格数.
    const int defaultGridCount = 60;
    // Header 和 footer 占用的网格数. 竖屏时占用高度, 横屏时占用宽度. 其中 8 格是 header footer 和 body 的间距.
    const int headerFooterGridCount = 48;
    Size safeSize = _safeSize(context,
      padding: padding,
    );
    // 水平方向网格数量.
    int horizontalGridCount;
    // 垂直方向网格数量.
    int verticalGridCount;
    // 游戏面板水平方向网格数量.
    int boardHorizontalGridCount;
    // 游戏面板垂直方向网格数量.
    int boardVerticalGridCount;
    bool isVertical = safeSize.width <= safeSize.height;
    if (isVertical) {
      // 竖屏.
      horizontalGridCount = defaultGridCount;
      verticalGridCount = defaultGridCount ~/ _columnCount * _rowCount + headerFooterGridCount;
      boardHorizontalGridCount = horizontalGridCount;
      boardVerticalGridCount = verticalGridCount - headerFooterGridCount;
    } else {
      // 横屏.
      verticalGridCount = defaultGridCount;
      horizontalGridCount = defaultGridCount ~/ _rowCount * _columnCount + headerFooterGridCount;
      boardHorizontalGridCount = horizontalGridCount - headerFooterGridCount;
      boardVerticalGridCount = verticalGridCount;
    }
    // 网格宽高.
    double gridSize = min(safeSize.width / horizontalGridCount, safeSize.height / verticalGridCount);
    return Rect.fromLTWH(
      (safeSize.width - gridSize * boardHorizontalGridCount) / 2.0,
      (safeSize.height - gridSize * boardVerticalGridCount) / 2.0,
      gridSize * boardHorizontalGridCount + padding * 2.0,
      gridSize * boardVerticalGridCount + padding * 2.0,
    );
  }

  //*******************************************************************************************************************

  /// 事件管理.
  final _ActionManager _actionManager = _ActionManager(
    max: 1,
  );

  //*******************************************************************************************************************
  // 用户操作.

  Function onTap({
    @required
    CardData cardData,
  }) {
    assert(cardData != null);
    return () {
      _actionManager.add(_AnimationAction.sample(
        cardData: cardData,
      ));
    };
  }

  Function onLongPress({
    @required
    CardData cardData,
  }) {
    assert(cardData != null);
    return null;
  }
}
