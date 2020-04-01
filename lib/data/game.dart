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
          initProperty: _Property(
            grid: _Grid.coreCard(metric: _metric, rowIndex: rowIndex, columnIndex: columnIndex, rowSpan: 1, columnSpan: 1),
          ),
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
      initProperty: _Property(
        grid: _Grid(metric: _metric, verticalRowIndex: 6, verticalColumnIndex: 1, verticalRowSpan: 10, verticalColumnSpan: 10,
            horizontalRowIndex: 1, horizontalColumnIndex: 6, horizontalRowSpan: 10, horizontalColumnSpan: 10),
      ),
    ));
//    _cards.add(_Card(
//      game: this,
//      initProperty: _Property(
//        grid: _Grid(metric: _metric, verticalRowIndex: 17, verticalColumnIndex: 2, verticalRowSpan: 15, verticalColumnSpan: 30,
//          horizontalRowIndex: 17, horizontalColumnIndex: 2, horizontalRowSpan: 15, horizontalColumnSpan: 30,),
//      ),
//    ));
//    _cards.add(_Card(
//      game: this,
//      initProperty: _Property(
//        metric: _metric,
//        orientationGrid: (isVertical) => isVertical
//            ? _Grid(verticalRowIndex: 160, verticalColumnIndex: 2, verticalRowSpan: 20, verticalColumnSpan: 20)
//            : _Grid(verticalRowIndex: 2, verticalColumnIndex: 160, verticalRowSpan: 20, verticalColumnSpan: 20),
//      ),
//    ));
//    _cards.add(_Card(
//      game: this,
//      initProperty: _Property(
//        metric: _metric,
//        orientationGrid: (isVertical) => isVertical
//            ? _Grid(verticalRowIndex: 160, verticalColumnIndex: 22, verticalRowSpan: 20, verticalColumnSpan: 20)
//            : _Grid(verticalRowIndex: 22, verticalColumnIndex: 160, verticalRowSpan: 20, verticalColumnSpan: 20),
//      ),
//    ));
//    _cards.add(_Card(
//      game: this,
//      initProperty: _Property(
//        metric: _metric,
//        orientationGrid: (isVertical) => isVertical
//            ? _Grid(verticalRowIndex: 160, verticalColumnIndex: 42, verticalRowSpan: 20, verticalColumnSpan: 20)
//            : _Grid(verticalRowIndex: 42, verticalColumnIndex: 160, verticalRowSpan: 20, verticalColumnSpan: 20),
//      ),
//    ));
//    _cards.add(_Card(
//      game: this,
//      initProperty: _Property(
//        metric: _metric,
//        orientationGrid: (isVertical) => isVertical
//            ? _Grid(verticalRowIndex: 160, verticalColumnIndex: 62, verticalRowSpan: 20, verticalColumnSpan: 20)
//            : _Grid(verticalRowIndex: 62, verticalColumnIndex: 160, verticalRowSpan: 20, verticalColumnSpan: 20),
//      ),
//    ));
//    _cards.add(_Card(
//      game: this,
//      initProperty: _Property(
//        metric: _metric,
//        orientationGrid: (isVertical) => isVertical
//            ? _Grid(verticalRowIndex: 160, verticalColumnIndex: 82, verticalRowSpan: 20, verticalColumnSpan: 20)
//            : _Grid(verticalRowIndex: 82, verticalColumnIndex: 160, verticalRowSpan: 20, verticalColumnSpan: 20),
//      ),
//    ));
//    _cards.add(_Card(
//      game: this,
//      initProperty: _Property(
//        metric: _metric,
//        orientationGrid: (isVertical) => isVertical
//            ? _Grid(verticalRowIndex: 160, verticalColumnIndex: 102, verticalRowSpan: 20, verticalColumnSpan: 20)
//            : _Grid(verticalRowIndex: 102, verticalColumnIndex: 160, verticalRowSpan: 20, verticalColumnSpan: 20),
//      ),
//    ));
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
            initProperty: _Property(/*opacity: 0.0*/
              grid: _Grid.coreCard(metric: _metric, rowIndex: rightCard._property.grid.coreCardRowIndex, columnIndex: rightCard._property.grid.coreCardColumnIndex, rowSpan: 1, columnSpan: 1),
            ),
          );

          actionQueue.add(
            _PropertyAnimation.moveCoreCard(
              metric: _metric,
              x: -1,
            ).action(rightCard)
          );
          actionQueue.add(_Action.run((_Action action) {
            rightCard._property.grid.coreCardColumnIndex = rightCard._property.grid.coreCardColumnIndex - 1;
            rightCard._property.reset();

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
    } else {
      _cards.forEach((element) {
        element._property.grid.metric = _metric;
      });
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

  Rect Function(_Grid grid) gridRect = (grid) {
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
  );
}

class _Metric implements Metric {
  /// 边距网格总数.
  static const int paddingGridCount = 1;
  /// 核心面板网格总数 (不包括 padding).
  static const int coreBoardNoPaddingGridCount = 60;
  /// Header footer 面板网格总数 (不包括 padding).
  static const int headerFooterBoardNoPaddingGridCount = 15;
  /// 核心面板网格总数 (包括 padding).
  static const int coreBoardGridCount = coreBoardNoPaddingGridCount + paddingGridCount * 2;
  /// Header footer 面板网格总数 (包括 padding).
  static const int headerFooterBoardGridCount = headerFooterBoardNoPaddingGridCount + paddingGridCount * 2;
  /// 安全面板网格总数.
  static const int safeBoardGridCount = coreBoardGridCount + headerFooterBoardGridCount * 2;

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
  });

  @override
  final int size;
  final Rect safeScreenRect;
  final Rect screenRect;
  final bool isVertical;
  @override
  final int horizontalGridCount;
  @override
  final int verticalGridCount;
  @override
  final double gridSize;
  @override
  final Rect safeBoardRect;
  @override
  final Rect coreBoardRect;
  @override
  final Rect coreBoardNoPaddingRect;
  final Rect headerBoardRect;
  final Rect footerBoardRect;
  final Rect headerBoardNoPadding;
  final Rect footerBoardNoPadding;
  final Rect Function(_Grid grid) gridRect;
  final int gridPerCoreCard;
  @override
  final double coreCardSize;
}

/// 网格.
class _Grid {
  _Grid({
    @required
    this.metric,
    @required
    this.verticalRowIndex,
    @required
    this.verticalColumnIndex,
    @required
    this.verticalRowSpan,
    @required
    this.verticalColumnSpan,
    @required
    this.horizontalRowIndex,
    @required
    this.horizontalColumnIndex,
    @required
    this.horizontalRowSpan,
    @required
    this.horizontalColumnSpan,
  }) : assert(verticalRowIndex != null),
        assert(verticalColumnIndex != null),
        assert(verticalRowSpan != null),
        assert(verticalColumnSpan != null),
        assert(horizontalRowIndex != null),
        assert(horizontalColumnIndex != null),
        assert(horizontalRowSpan != null),
        assert(horizontalColumnSpan != null);
  
  _Grid.coreCard({
    @required
    _Metric metric,
    @required
    int rowIndex,
    @required
    int columnIndex,
    @required
    int rowSpan,
    @required
    int columnSpan,
  }) : this(
    metric: metric,
    verticalRowIndex: metric.gridPerCoreCard * rowIndex + _Metric.paddingGridCount + (true ? _Metric.headerFooterBoardGridCount : 0),
    verticalColumnIndex: metric.gridPerCoreCard * columnIndex + _Metric.paddingGridCount + (true ? 0 : _Metric.headerFooterBoardGridCount),
    verticalRowSpan: metric.gridPerCoreCard * rowSpan,
    verticalColumnSpan: metric.gridPerCoreCard * columnSpan,
    horizontalRowIndex: metric.gridPerCoreCard * rowIndex + _Metric.paddingGridCount + (false ? _Metric.headerFooterBoardGridCount : 0),
    horizontalColumnIndex: metric.gridPerCoreCard * columnIndex + _Metric.paddingGridCount + (false ? 0 : _Metric.headerFooterBoardGridCount),
    horizontalRowSpan: metric.gridPerCoreCard * rowSpan,
    horizontalColumnSpan: metric.gridPerCoreCard * columnSpan,
  );
  
  _Metric metric;
  
  /// 行.
  int verticalRowIndex;
  /// 列.
  int verticalColumnIndex;
  /// 跨行.
  int verticalRowSpan;
  /// 跨列.
  int verticalColumnSpan;
  
  int horizontalRowIndex;
  int horizontalColumnIndex;
  int horizontalRowSpan;
  int horizontalColumnSpan;
  
  int get rowIndex => metric.isVertical ? verticalRowIndex : horizontalRowIndex;
  int get columnIndex => metric.isVertical ? verticalColumnIndex : horizontalColumnIndex;
  int get rowSpan => metric.isVertical ? verticalRowSpan : horizontalRowSpan;
  int get columnSpan => metric.isVertical ? verticalColumnSpan : horizontalColumnSpan;

  set rowIndex(int rowIndex) {
    verticalRowIndex = rowIndex;
    horizontalRowIndex = rowIndex;
  }

  set columnIndex(int columnIndex) {
    verticalColumnIndex = columnIndex;
    horizontalColumnIndex = columnIndex;
  }

  set rowSpan(int rowSpan) {
    verticalRowSpan = rowSpan;
    horizontalRowSpan = rowSpan;
  }

  set columnSpan(int columnSpan) {
    verticalColumnSpan = columnSpan;
    horizontalColumnSpan = columnSpan;
  }

  Rect get rect => Rect.fromLTWH(
    metric.safeBoardRect.left + columnIndex * metric.gridSize,
    metric.safeBoardRect.top + rowIndex * metric.gridSize,
    columnSpan * metric.gridSize,
    rowSpan * metric.gridSize,
  );

  int get coreCardRowIndex => (rowIndex - _Metric.paddingGridCount - (metric.isVertical ? _Metric.headerFooterBoardGridCount : 0)) ~/ metric.gridPerCoreCard;
  int get coreCardColumnIndex => (columnIndex - _Metric.paddingGridCount - (metric.isVertical ? 0 : _Metric.headerFooterBoardGridCount)) ~/ metric.gridPerCoreCard;
  int get coreCardRowSpan => rowSpan ~/ metric.gridPerCoreCard;
  int get coreCardColumnSpan => columnSpan ~/ metric.gridPerCoreCard;

  set coreCardRowIndex(int coreCardRowIndex) {
    verticalRowIndex = metric.gridPerCoreCard * coreCardRowIndex + _Metric.paddingGridCount + (true ? _Metric.headerFooterBoardGridCount : 0);
    horizontalRowIndex = metric.gridPerCoreCard * coreCardRowIndex + _Metric.paddingGridCount + (false ? _Metric.headerFooterBoardGridCount : 0);
  }

  set coreCardColumnIndex(int coreCardColumnIndex) {
    verticalColumnIndex = metric.gridPerCoreCard * coreCardColumnIndex + _Metric.paddingGridCount + (true ? 0 : _Metric.headerFooterBoardGridCount);
    horizontalColumnIndex = metric.gridPerCoreCard * coreCardColumnIndex + _Metric.paddingGridCount + (false ? 0 : _Metric.headerFooterBoardGridCount);
  }

  set coreCardRowSpan(int coreCardRowSpan) {
    rowSpan = metric.gridPerCoreCard * coreCardRowSpan;
  }

  set coreCardColumnSpan(int coreCardColumnSpan) {
    columnSpan = metric.gridPerCoreCard * coreCardColumnSpan;
  }

  @override
  String toString() {
    return
      '$verticalRowIndex,$verticalColumnIndex,$verticalRowSpan,$verticalColumnSpan\n'
        '$horizontalRowIndex,$horizontalColumnIndex,$horizontalRowSpan,$horizontalColumnSpan\n'
//        '$rowIndex,$columnIndex,$rowSpan,$columnSpan\n'
        '$coreCardRowIndex,$coreCardColumnIndex,$coreCardRowSpan,$coreCardColumnSpan';
  }
}
