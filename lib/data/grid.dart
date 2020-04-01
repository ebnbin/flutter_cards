part of '../data.dart';

//*********************************************************************************************************************

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

  static Metric build(MediaQueryData mediaQueryData, int size) {
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
  @override
  final Rect safeScreenRect;
  @override
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
    this.isCoreCard = false,
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
    isCoreCard: true,
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

  final bool isCoreCard;

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
