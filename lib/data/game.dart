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
        _IndexCard card = _IndexCard(
          game: this,
          rowIndex: rowIndex,
          columnIndex: columnIndex,
          rowSpan: 1,
          columnSpan: 1,
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
    _cards.add(_GridCard(
      game: this,
      gridColumnIndex: (isVertical) => isVertical ? 2 : 2,
      gridRowIndex: (isVertical) => isVertical ? 2 : 2,
      gridColumnSpan: (isVertical) => isVertical ? 10 : 10,
      gridRowSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cards.add(_GridCard(
      game: this,
      gridColumnIndex: (isVertical) => isVertical ? 2 : 2,
      gridRowIndex: (isVertical) => isVertical ? 12 : 12,
      gridColumnSpan: (isVertical) => isVertical ? 20 : 20,
      gridRowSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cards.add(_GridCard(
      game: this,
      gridColumnIndex: (isVertical) => isVertical ? 2 : 90,
      gridRowIndex: (isVertical) => isVertical ? 90 : 2,
      gridColumnSpan: (isVertical) => isVertical ? 10 : 10,
      gridRowSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cards.add(_GridCard(
      game: this,
      gridColumnIndex: (isVertical) => isVertical ? 12 : 90,
      gridRowIndex: (isVertical) => isVertical ? 90 : 12,
      gridColumnSpan: (isVertical) => isVertical ? 10 : 10,
      gridRowSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cards.add(_GridCard(
      game: this,
      gridColumnIndex: (isVertical) => isVertical ? 22 : 90,
      gridRowIndex: (isVertical) => isVertical ? 90 : 22,
      gridColumnSpan: (isVertical) => isVertical ? 10 : 10,
      gridRowSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cards.add(_GridCard(
      game: this,
      gridColumnIndex: (isVertical) => isVertical ? 32 : 90,
      gridRowIndex: (isVertical) => isVertical ? 90 : 32,
      gridColumnSpan: (isVertical) => isVertical ? 10 : 10,
      gridRowSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cards.add(_GridCard(
      game: this,
      gridColumnIndex: (isVertical) => isVertical ? 42 : 90,
      gridRowIndex: (isVertical) => isVertical ? 90 : 42,
      gridColumnSpan: (isVertical) => isVertical ? 10 : 10,
      gridRowSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cards.add(_GridCard(
      game: this,
      gridColumnIndex: (isVertical) => isVertical ? 52 : 90,
      gridRowIndex: (isVertical) => isVertical ? 90 : 52,
      gridColumnSpan: (isVertical) => isVertical ? 10 : 10,
      gridRowSpan: (isVertical) => isVertical ? 10 : 10,
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
      if (card is _IndexCard) {
        card._color = Colors.grey;
        callback.setState(() {
        });
        actionQueue.add(_Action.run((_Action action) {
          card._color = Colors.green;
          callback.setState(() {
          });
        }));
        actionQueue.add(
          _PropertyAnimation.flipOut(
            angleY: _InvisibleAngle.counterClockwise90,
          ).action(card)
        );
        if (card.rightCard != null && card.rightCard is _IndexCard) {
          _IndexCard rightCard = card.rightCard;
          _IndexCard newCard = _IndexCard(
            game: this,
            rowIndex: rightCard.rowIndex,
            columnIndex: rightCard.columnIndex,
            rowSpan: 1,
            columnSpan: 1,
            initProperty: _Property.def(/*opacity: 0.0*/),
          );

          actionQueue.add(
            _PropertyAnimation.moveCoreCard(
              metric: _metric,
              x: -1,
            ).action(rightCard)
          );
          actionQueue.add(_Action.run((_Action action) {
            rightCard.left();
            rightCard._property = _Property.def();

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

  Rect Function(
      _OrientationGrid gridColumnIndex,
      _OrientationGrid gridRowIndex,
      _OrientationGrid gridColumnSpan,
      _OrientationGrid gridRowSpan) gridRect = (gridColumnIndex, gridRowIndex, gridColumnSpan, gridRowSpan) {
    return Rect.fromLTWH(
      safeBoardRect.left + gridColumnIndex(isVertical) * gridSize,
      safeBoardRect.top + gridRowIndex(isVertical) * gridSize,
      gridColumnSpan(isVertical) * gridSize,
      gridRowSpan(isVertical) * gridSize,
    );
  };

  /// 每个核心卡片占几个网格.
  int gridPerCoreCard = _Metric.coreBoardNoPaddingGridCount ~/ size;

  /// 核心卡片尺寸.
  double coreCardSize = gridPerCoreCard * gridSize;
  /// Header footer 卡片尺寸.
  double headerFooterCardSize = _Metric.gridPerHeaderFooterCard * gridSize;

  int Function(_OrientationGrid gridColumnIndex) gridColumnIndexToColumnIndex = (gridColumnIndex) {
    return (gridColumnIndex(isVertical) - _Metric.paddingGridCount - (isVertical ? 0 : _Metric.headerFooterBoardGridCount)) ~/ gridPerCoreCard;
  };

  int Function(_OrientationGrid gridRowIndex) gridRowIndexToRowIndex = (gridRowIndex) {
    return (gridRowIndex(isVertical) - _Metric.paddingGridCount - (isVertical ? _Metric.headerFooterBoardGridCount : 0)) ~/ gridPerCoreCard;
  };

  int Function(_OrientationGrid gridColumnSpan) gridColumnSpanToColumnSpan = (gridColumnSpan) {
    return gridColumnSpan(isVertical) ~/ gridPerCoreCard;
  };

  int Function(_OrientationGrid gridRowSpan) gridRowSpanToRowSpan = (gridRowSpan) {
    return gridRowSpan(isVertical) ~/ gridPerCoreCard;
  };

  _OrientationGrid Function(int columnIndex) columnIndexToGridColumnIndex = (columnIndex) {
    return (isVertical) {
      return gridPerCoreCard * columnIndex + _Metric.paddingGridCount + (isVertical ? 0 : _Metric.headerFooterBoardGridCount);
    };
  };

  _OrientationGrid Function(int rowIndex) rowIndexToGridRowIndex = (rowIndex) {
    return (isVertical) {
      return gridPerCoreCard * rowIndex + _Metric.paddingGridCount + (isVertical ? _Metric.headerFooterBoardGridCount : 0);
    };
  };

  _OrientationGrid Function(int columnSpan) columnSpanToGridColumnSpan = (columnSpan) {
    return (isVertical) {
      return gridPerCoreCard * columnSpan;
    };
  };

  _OrientationGrid Function(int rowSpan) rowSpanToGridRowSpan = (rowSpan) {
    return (isVertical) {
      return gridPerCoreCard * rowSpan;
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
    gridColumnIndexToColumnIndex: gridColumnIndexToColumnIndex,
    gridRowIndexToRowIndex: gridRowIndexToRowIndex,
    gridColumnSpanToColumnSpan: gridColumnSpanToColumnSpan,
    gridRowSpanToRowSpan: gridRowSpanToRowSpan,
    columnIndexToGridColumnIndex: columnIndexToGridColumnIndex,
    rowIndexToGridRowIndex: rowIndexToGridRowIndex,
    columnSpanToGridColumnSpan: columnSpanToGridColumnSpan,
    rowSpanToGridRowSpan: rowSpanToGridRowSpan,
  );
}

class _Metric implements Metric {
  /// 边距网格总数.
  static const int paddingGridCount = 2;
  /// 核心面板网格总数 (不包括 padding).
  static const int coreBoardNoPaddingGridCount = 60;
  /// Header footer 面板网格总数 (不包括 padding).
  static const int headerFooterBoardNoPaddingGridCount = 20;
  /// 核心面板网格总数 (包括 padding).
  static const int coreBoardGridCount = coreBoardNoPaddingGridCount + paddingGridCount * 2;
  /// Header footer 面板网格总数 (包括 padding).
  static const int headerFooterBoardGridCount = headerFooterBoardNoPaddingGridCount + paddingGridCount * 2;
  /// 安全面板网格总数.
  static const int safeBoardGridCount = coreBoardGridCount + headerFooterBoardGridCount * 2;
  static const int gridPerHeaderFooterCard = 10;

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
    this.gridColumnIndexToColumnIndex,
    @required
    this.gridRowIndexToRowIndex,
    @required
    this.gridColumnSpanToColumnSpan,
    @required
    this.gridRowSpanToRowSpan,
    @required
    this.columnIndexToGridColumnIndex,
    @required
    this.rowIndexToGridRowIndex,
    @required
    this.columnSpanToGridColumnSpan,
    @required
    this.rowSpanToGridRowSpan,
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
  final Rect Function(
      _OrientationGrid gridColumnIndex,
      _OrientationGrid gridRowIndex,
      _OrientationGrid gridColumnSpan,
      _OrientationGrid gridRowSpan) gridRect;
  final int gridPerCoreCard;
  final double coreCardSize;
  final double headerFooterCardSize;
  final int Function(_OrientationGrid gridColumnIndex) gridColumnIndexToColumnIndex;
  final int Function(_OrientationGrid gridRowIndex) gridRowIndexToRowIndex;
  final int Function(_OrientationGrid gridColumnSpan) gridColumnSpanToColumnSpan;
  final int Function(_OrientationGrid gridRowSpan) gridRowSpanToRowSpan;
  final _OrientationGrid Function(int columnIndex) columnIndexToGridColumnIndex;
  final _OrientationGrid Function(int rowIndex) rowIndexToGridRowIndex;
  final _OrientationGrid Function(int columnSpan) columnSpanToGridColumnSpan;
  final _OrientationGrid Function(int rowSpan) rowSpanToGridRowSpan;
}

/// 根据屏幕方向返回网格值.
typedef _OrientationGrid = int Function(bool isVertical);
