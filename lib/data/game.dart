part of '../data.dart';

//*********************************************************************************************************************

/// 游戏数据.
///
/// 有效行列范围: 2 ~ 6. Header footer 固定都是 2 * 6. 网格粒度 60. 2, 3, 4, 5, 6 都是 60 的约数.
class _Game implements Game {
  _Game({
    this.callback,
  });

  final GameCallback callback;

  //*******************************************************************************************************************

  /// 行列数. 不包括 header footer.
  int size = 4;

  //*******************************************************************************************************************

  void initCards() {
//    print(calcMap['gridPerCard']);
    for (int rowIndex = 0; rowIndex < size; rowIndex++) {
      for (int columnIndex = 0; columnIndex < size; columnIndex++) {
//        if (rowIndex == 2 && (columnIndex == 1 || columnIndex == 2)) {
//          continue;
//        }
        _CoreCard card = _CoreCard(
          game: this,
          initProperty: _Property(),
          coreCardGrid: _Grid(rowIndex: rowIndex, columnIndex: columnIndex, rowSpan: 1, columnSpan: 1),
        );
        _cards.add(card);
      }
    }
//    _cards.add(_IndexCard(
//      game: this,
//      rowIndex: 2,
//      columnIndex: 1,
//      rowSpan: 1,
//      columnSpan: 2,
//    ));
    _cards.add(_Card(
      game: this,
      initProperty: _Property(),
      grid: (isVertical) => isVertical
          ? _Grid(rowIndex: 2, columnIndex: 2, rowSpan: 15, columnSpan: 15)
          : _Grid(rowIndex: 2, columnIndex: 2, rowSpan: 15, columnSpan: 15),
    ));
    _cards.add(_Card(
      game: this,
      initProperty: _Property(),
      grid: (isVertical) => isVertical
          ? _Grid(rowIndex: 17, columnIndex: 2, rowSpan: 15, columnSpan: 30)
          : _Grid(rowIndex: 17, columnIndex: 2, rowSpan: 15, columnSpan: 30),
    ));
    _cards.add(_Card(
      game: this,
      initProperty: _Property(),
      grid: (isVertical) => isVertical
          ? _Grid(rowIndex: 160, columnIndex: 2, rowSpan: 20, columnSpan: 20)
          : _Grid(rowIndex: 2, columnIndex: 160, rowSpan: 20, columnSpan: 20),
    ));
    _cards.add(_Card(
      game: this,
      initProperty: _Property(),
      grid: (isVertical) => isVertical
          ? _Grid(rowIndex: 160, columnIndex: 22, rowSpan: 20, columnSpan: 20)
          : _Grid(rowIndex: 22, columnIndex: 160, rowSpan: 20, columnSpan: 20),
    ));
    _cards.add(_Card(
      game: this,
      initProperty: _Property(),
      grid: (isVertical) => isVertical
          ? _Grid(rowIndex: 160, columnIndex: 42, rowSpan: 20, columnSpan: 20)
          : _Grid(rowIndex: 42, columnIndex: 160, rowSpan: 20, columnSpan: 20),
    ));
    _cards.add(_Card(
      game: this,
      initProperty: _Property(),
      grid: (isVertical) => isVertical
          ? _Grid(rowIndex: 160, columnIndex: 62, rowSpan: 20, columnSpan: 20)
          : _Grid(rowIndex: 62, columnIndex: 160, rowSpan: 20, columnSpan: 20),
    ));
    _cards.add(_Card(
      game: this,
      initProperty: _Property(),
      grid: (isVertical) => isVertical
          ? _Grid(rowIndex: 160, columnIndex: 82, rowSpan: 20, columnSpan: 20)
          : _Grid(rowIndex: 82, columnIndex: 160, rowSpan: 20, columnSpan: 20),
    ));
    _cards.add(_Card(
      game: this,
      initProperty: _Property(),
      grid: (isVertical) => isVertical
          ? _Grid(rowIndex: 160, columnIndex: 102, rowSpan: 20, columnSpan: 20)
          : _Grid(rowIndex: 102, columnIndex: 160, rowSpan: 20, columnSpan: 20),
    ));
  }

  //*******************************************************************************************************************

  /// 存储所有卡片.
  List<_Card> _cards = [];
  @override
  BuiltList<Card> get cards {
    return _cards.build();
  }

  //*******************************************************************************************************************

  /// 事件管理.
  final _ActionQueue actionQueue = _ActionQueue(
//    max: 1,
  );

  //*******************************************************************************************************************
  // 用户操作.

  @override
  Function onTap({
    @required
    Card card,
  }) {
    assert(card != null);
    return () {
      if (card is _CoreCard) {
        card._property.color = Colors.grey;
        callback.setState(() {
        });
        actionQueue.add(_Action.run((_Action action) {
          card._property.color = Colors.green;
          callback.setState(() {
          });
        }));
        actionQueue.add(
          _PropertyAnimation.flipOut(
            angleY: _InvisibleAngle.counterClockwise90,
          ).action(card)
        );
        if (card.rightCard != null && card.rightCard is _CoreCard) {
          _CoreCard rightCard = card.rightCard;
          _CoreCard newCard = _CoreCard(
            game: this,
            coreCardGrid: _Grid(rowIndex: rightCard.coreCardGrid.rowIndex, columnIndex: rightCard.coreCardGrid.columnIndex, rowSpan: 1, columnSpan: 1),
            initProperty: _Property(/*opacity: 0.0*/),
          );

          actionQueue.add(
            _PropertyAnimation.moveCoreCard(
              metric: _metric,
              x: -1,
            ).action(rightCard)
          );
          actionQueue.add(_Action.run((_Action action) {
            rightCard.left();
            rightCard._property = _Property();

            _cards[card.index] = newCard;

            callback.setState(() {
            });
          },
          )
          );
          actionQueue.add(
            _PropertyAnimation.flipIn(
              angleY: _InvisibleAngle.counterClockwise90,
            ).action(newCard)
          );
        }
      } else {
        List<_PropertyAnimation> animations = <_PropertyAnimation>[
          _PropertyAnimation.sample(),
//          _PropertyAnimation.rotateXYIn(
//            invisibleRotateY: _InvisibleRotate.clockwise270,
//          ),
//          _PropertyAnimation.rotateXYOut(
//            invisibleRotateX: _InvisibleRotate.counterClockwise90,
//          ),
//          _PropertyAnimation.translate(
//            translateX: -metrics[Metric.cardSize],
//            translateY: metrics[Metric.cardSize],
//          ),
//          _PropertyAnimation.translateIndex(
//            metrics: metrics,
//            indexX: -1,
//          ),
        ];
        animations[Random().nextInt(animations.length)].begin(card);
      }
    };
  }

  @override
  Function onLongPress({
    @required
    Card card,
  }) {
    assert(card != null);
    return null;
  }

  //*******************************************************************************************************************

  @override
  Metric get metric => _metric;
  _Metric _metric;
  _MetricCache metricCache;

  @override
  void build() {
    MediaQueryData mediaQueryData = MediaQuery.of(callback.context);
    _MetricCache metricCache = _MetricCache(mediaQueryData, size);
    if (this.metricCache != metricCache) {
      this.metricCache = metricCache;
      _metric = _buildMetric(mediaQueryData, size);
    }

    if (_cards.isEmpty) {
      initCards();
    }
  }
}

class _MetricCache {
  const _MetricCache(this.mediaQueryData, this.size);

  final MediaQueryData mediaQueryData;
  final int size;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _MetricCache &&
              runtimeType == other.runtimeType &&
              mediaQueryData == other.mediaQueryData &&
              size == other.size;

  @override
  int get hashCode =>
      mediaQueryData.hashCode ^
      size.hashCode;
}

//*********************************************************************************************************************

Metric _buildMetric(MediaQueryData mediaQueryData, int size) {
  /// 安全的屏幕矩形.
  Rect safeScreenRect = Rect.fromLTWH(
    0.0,
    0.0,
    mediaQueryData.size.width - mediaQueryData.padding.left - mediaQueryData.padding.right,
    mediaQueryData.size.height - mediaQueryData.padding.top - mediaQueryData.padding.bottom,
  );
  /// 屏幕矩形.
  Rect screenRect = Rect.fromLTRB(
    safeScreenRect.left - mediaQueryData.padding.left,
    safeScreenRect.top - mediaQueryData.padding.top,
    safeScreenRect.right + mediaQueryData.padding.right,
    safeScreenRect.bottom + mediaQueryData.padding.bottom,
  );
  /// 是否竖屏. [MediaQueryData.orientation].
  bool isVertical = screenRect.width <= screenRect.height;
  /// 水平方向网格总数.
  int horizontalGridCount;
  /// 垂直方向网格总数.
  int verticalGridCount;
  if (isVertical) {
    horizontalGridCount = _Metric.coreBoardGridCount;
    verticalGridCount = _Metric.safeBoardGridCount;
  } else {
    horizontalGridCount = _Metric.safeBoardGridCount;
    verticalGridCount = _Metric.coreBoardGridCount;
  }
  /// 网格尺寸.
  double gridSize = min(safeScreenRect.width / horizontalGridCount, safeScreenRect.height / verticalGridCount);
  
  double safeBoardWidth = horizontalGridCount * gridSize;
  double safeBoardHeight = verticalGridCount * gridSize;
  /// 安全面板矩形.
  Rect safeBoardRect = Rect.fromLTWH(
    (safeScreenRect.width - safeBoardWidth) / 2.0,
    (safeScreenRect.height - safeBoardHeight) / 2.0,
    safeBoardWidth,
    safeBoardHeight,
  );

  /// 边距尺寸.
  double paddingSize = _Metric.paddingGridCount * gridSize;

  double coreBoardSize = _Metric.coreBoardGridCount * gridSize;
  /// 核心面板矩形 (包括 padding).
  Rect coreBoardRect = Rect.fromLTWH(
    (safeScreenRect.width - coreBoardSize) / 2.0,
    (safeScreenRect.height - coreBoardSize) / 2.0,
    coreBoardSize,
    coreBoardSize,
  );
  /// 核心面板矩形 (不包括 padding).
  Rect coreBoardNoPaddingRect = Rect.fromLTRB(
    coreBoardRect.left + paddingSize,
    coreBoardRect.top + paddingSize,
    coreBoardRect.right - paddingSize,
    coreBoardRect.bottom - paddingSize,
  );

  /// Header 面板矩形 (包括 padding).
  Rect headerBoardRect;
  /// Footer 面板矩形 (包括 padding).
  Rect footerBoardRect;
  if (isVertical) {
    headerBoardRect = Rect.fromLTWH(
      safeBoardRect.left,
      safeBoardRect.top,
      safeBoardRect.width,
      coreBoardRect.top,
    );
    footerBoardRect = Rect.fromLTWH(
      headerBoardRect.left,
      coreBoardRect.bottom,
      headerBoardRect.width,
      headerBoardRect.height,
    );
  } else {
    headerBoardRect = Rect.fromLTWH(
      safeBoardRect.left,
      safeBoardRect.top,
      coreBoardRect.left,
      safeBoardRect.height,
    );
    footerBoardRect = Rect.fromLTWH(
      coreBoardRect.right,
      headerBoardRect.top,
      headerBoardRect.width,
      headerBoardRect.height,
    );
  }
  /// Header 面板矩形 (不包括 padding).
  Rect headerBoardNoPadding = Rect.fromLTRB(
    headerBoardRect.left + paddingSize,
    headerBoardRect.top + paddingSize,
    headerBoardRect.right - paddingSize,
    headerBoardRect.bottom - paddingSize,
  );
  /// Footer 面板矩形 (不包括 padding).
  Rect footerBoardNoPadding = Rect.fromLTRB(
    footerBoardRect.left + paddingSize,
    footerBoardRect.top + paddingSize,
    footerBoardRect.right - paddingSize,
    footerBoardRect.bottom - paddingSize,
  );

  Rect Function(_OrientationGrid orientationGrid) gridRect = (orientationGrid) {
    _Grid grid = orientationGrid(isVertical);
    return Rect.fromLTWH(
      safeBoardRect.left + grid.columnIndex * gridSize,
      safeBoardRect.top + grid.rowIndex * gridSize,
      grid.columnSpan * gridSize,
      grid.rowSpan * gridSize,
    );
  };

  /// 每个核心卡片占几个网格.
  int gridPerCoreCard = _Metric.coreBoardNoPaddingGridCount ~/ size;

  /// 核心卡片尺寸.
  double coreCardSize = gridPerCoreCard * gridSize;
  /// Header footer 卡片尺寸.
  double headerFooterCardSize = _Metric.gridPerHeaderFooterCard * gridSize;

  _Grid Function(_OrientationGrid orientationGrid) gridToCoreCardGrid = (orientationGrid) {
    _Grid grid = orientationGrid(isVertical);
    return _Grid(
      rowIndex: (grid.rowIndex - _Metric.paddingGridCount - (isVertical ? _Metric.headerFooterBoardGridCount : 0)) ~/ gridPerCoreCard,
      columnIndex: (grid.columnIndex - _Metric.paddingGridCount - (isVertical ? 0 : _Metric.headerFooterBoardGridCount)) ~/ gridPerCoreCard,
      rowSpan: grid.rowSpan ~/ gridPerCoreCard,
      columnSpan: grid.columnSpan ~/ gridPerCoreCard,
    );
  };

  _OrientationGrid Function(_Grid coreCardGrid) coreCardGridToGrid = (coreCardGrid) {
    return (isVertical) {
      return _Grid(
        rowIndex: gridPerCoreCard * coreCardGrid.rowIndex + _Metric.paddingGridCount + (isVertical ? _Metric.headerFooterBoardGridCount : 0),
        columnIndex: gridPerCoreCard * coreCardGrid.columnIndex + _Metric.paddingGridCount + (isVertical ? 0 : _Metric.headerFooterBoardGridCount),
        rowSpan: gridPerCoreCard * coreCardGrid.rowSpan,
        columnSpan: gridPerCoreCard * coreCardGrid.columnSpan,
      );
    };
  };

  return _Metric(
    size: size,
    safeScreenRect: safeScreenRect,
    screenRect: screenRect,
    isVertical: isVertical,
    horizontalGridCount: horizontalGridCount,
    verticalGridCount: verticalGridCount,
    gridSize: gridSize,
    safeBoardRect: safeBoardRect,
    coreBoardRect: coreBoardRect,
    coreBoardNoPaddingRect: coreBoardNoPaddingRect,
    headerBoardRect: headerBoardRect,
    footerBoardRect: footerBoardRect,
    headerBoardNoPadding: headerBoardNoPadding,
    footerBoardNoPadding: footerBoardNoPadding,
    gridRect: gridRect,
    gridPerCoreCard: gridPerCoreCard,
    coreCardSize: coreCardSize,
    headerFooterCardSize: headerFooterCardSize,
    gridToCoreCardGrid: gridToCoreCardGrid,
    coreCardGridToGrid: coreCardGridToGrid,
  );
}

class _Metric implements Metric {
  /// 边距网格总数.
  static const int paddingGridCount = 2;
  /// 核心面板网格总数 (不包括 padding).
  static const int coreBoardNoPaddingGridCount = 120;
  /// Header footer 面板网格总数 (不包括 padding).
  static const int headerFooterBoardNoPaddingGridCount = 30;
  /// 核心面板网格总数 (包括 padding).
  static const int coreBoardGridCount = coreBoardNoPaddingGridCount + paddingGridCount * 2;
  /// Header footer 面板网格总数 (包括 padding).
  static const int headerFooterBoardGridCount = headerFooterBoardNoPaddingGridCount + paddingGridCount * 2;
  /// 安全面板网格总数.
  static const int safeBoardGridCount = coreBoardGridCount + headerFooterBoardGridCount * 2;
  static const int gridPerHeaderFooterCard = 20;

  _Metric({
    @required
    this.size,
    @required
    this.safeScreenRect,
    @required
    this.screenRect,
    @required
    this.isVertical,
    @required
    this.horizontalGridCount,
    @required
    this.verticalGridCount,
    @required
    this.gridSize,
    @required
    this.safeBoardRect,
    @required
    this.coreBoardRect,
    @required
    this.coreBoardNoPaddingRect,
    @required
    this.headerBoardRect,
    @required
    this.footerBoardRect,
    @required
    this.headerBoardNoPadding,
    @required
    this.footerBoardNoPadding,
    @required
    this.gridRect,
    @required
    this.gridPerCoreCard,
    @required
    this.coreCardSize,
    @required
    this.headerFooterCardSize,
    @required
    this.gridToCoreCardGrid,
    @required
    this.coreCardGridToGrid,
  });

  final int size;
  final Rect safeScreenRect;
  final Rect screenRect;
  final bool isVertical;
  final int horizontalGridCount;
  final int verticalGridCount;
  final double gridSize;
  @override
  final Rect safeBoardRect;
  @override
  final Rect coreBoardRect;
  final Rect coreBoardNoPaddingRect;
  final Rect headerBoardRect;
  final Rect footerBoardRect;
  final Rect headerBoardNoPadding;
  final Rect footerBoardNoPadding;
  final Rect Function(_OrientationGrid orientationGrid) gridRect;
  final int gridPerCoreCard;
  final double coreCardSize;
  final double headerFooterCardSize;
  final _Grid Function(_OrientationGrid orientationGrid) gridToCoreCardGrid;
  final _OrientationGrid Function(_Grid coreCardGrid) coreCardGridToGrid;
}

/// 网格.
class _Grid {
  const _Grid({
    @required
    this.rowIndex,
    @required
    this.columnIndex,
    @required
    this.rowSpan,
    @required
    this.columnSpan,
  }) : assert(rowIndex != null),
        assert(columnIndex != null),
        assert(rowSpan != null),
        assert(columnSpan != null);
  
  /// 行.
  final int rowIndex;
  /// 列.
  final int columnIndex;
  /// 跨行.
  final int rowSpan;
  /// 跨列.
  final int columnSpan;

  _Grid update({
    int rowIndex,
    int columnIndex,
    int rowSpan,
    int columnSpan,
  }) {
    return _Grid(
      rowIndex: rowIndex ?? this.rowIndex,
      columnIndex: columnIndex ?? this.columnIndex,
      rowSpan: rowSpan ?? this.rowSpan,
      columnSpan: columnSpan ?? this.columnSpan,
    );
  }

  _Grid offset({
    int rowIndex,
    int columnIndex,
    int rowSpan,
    int columnSpan,
  }) {
    return _Grid(
      rowIndex: this.rowIndex + (rowIndex ?? 0),
      columnIndex: this.columnIndex + (columnIndex ?? 0),
      rowSpan: this.rowSpan + (rowSpan ?? 0),
      columnSpan: this.columnSpan + (columnSpan ?? 0),
    );
  }
  
  _Grid left() {
    return offset(
      columnIndex: -1,
    );
  }
  
  _Grid right() {
    return offset(
      columnIndex: 1,
    );
  }
  
  _Grid top() {
    return offset(
      rowIndex: -1,
    );
  }
  
  _Grid bottom() {
    return offset(
      rowIndex: 1,
    );
  }

  @override
  String toString() {
    return '$rowIndex,$columnIndex,$rowSpan,$columnSpan';
  }
}

/// 根据屏幕方向返回网格.
typedef _OrientationGrid = _Grid Function(bool isVertical);
