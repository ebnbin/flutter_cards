part of '../data.dart';

//*********************************************************************************************************************

/// 网格标尺. 单例.
class _Metric {
  /// Padding 网格数.
  static const int paddingGrid = 1;
  /// Body 网格数 (不包含 padding).
  static const int bodyNoPaddingGrid = 60;
  /// Header footer 网格数 (不包含 padding).
  static const int headerFooterNoPaddingGrid = 15;
  /// Body 网格数.
  static const int bodyGrid = bodyNoPaddingGrid + paddingGrid * 2;
  /// Header footer 网格数.
  static const int headerFooterGrid = headerFooterNoPaddingGrid + paddingGrid * 2;
  /// 安全网格数.
  static const int safeGrid = bodyGrid + headerFooterGrid * 2;

  static Size sizeCache;
  static EdgeInsets paddingCache;
  static int squareCache;

  static _Metric metricCache;

  /// 在 [_Game.build] 中调用.
  static void build(_Game game) {
    MediaQueryData mediaQueryData = MediaQuery.of(game.callback.context);
    if (sizeCache == mediaQueryData.size && paddingCache == mediaQueryData.padding && squareCache == game.square) {
      return;
    }

    /// 屏幕矩形.
    Rect screenRect = Rect.fromLTWH(
      0.0,
      0.0,
      mediaQueryData.size.width,
      mediaQueryData.size.height,
    );
    /// 安全屏幕矩形.
    Rect safeScreenRect = Rect.fromLTRB(
      screenRect.left + mediaQueryData.padding.left,
      screenRect.top + mediaQueryData.padding.top,
      screenRect.right - mediaQueryData.padding.right,
      screenRect.bottom - mediaQueryData.padding.bottom,
    );
    /// 是否竖屏. [MediaQueryData.orientation].
    bool isVertical = screenRect.width <= screenRect.height;
    /// 水平方向网格数.
    int horizontalGrid = isVertical ? bodyGrid : safeGrid;
    /// 垂直方向网格数.
    int verticalGrid = isVertical ? safeGrid : bodyGrid;
    /// 网格尺寸.
    double gridSize = min(safeScreenRect.width / horizontalGrid, safeScreenRect.height / verticalGrid);
    /// 安全矩形.
    Rect safeRect = Rect.fromCenter(
      center: safeScreenRect.center,
      width: horizontalGrid * gridSize,
      height: verticalGrid * gridSize,
    );
    /// Body 矩形.
    Rect bodyRect = Rect.fromCenter(
      center: safeRect.center,
      width: bodyGrid * gridSize,
      height: bodyGrid * gridSize,
    );
    /// Body 矩形 (不包含 padding).
    Rect bodyNoPaddingRect = Rect.fromLTRB(
      bodyRect.left + paddingGrid * gridSize,
      bodyRect.top + paddingGrid * gridSize,
      bodyRect.right - paddingGrid * gridSize,
      bodyRect.bottom - paddingGrid * gridSize,
    );
    /// Header 矩形.
    Rect headerRect = Rect.fromLTWH(
      safeRect.left,
      safeRect.top,
      isVertical ? safeRect.width : (bodyRect.left - safeRect.left),
      isVertical ? (bodyRect.top - safeRect.top) : safeRect.height,
    );
    /// Footer 矩形.
    Rect footerRect = Rect.fromLTWH(
      isVertical ? headerRect.left : bodyRect.right,
      isVertical ? bodyRect.bottom : headerRect.top,
      headerRect.width,
      headerRect.height,
    );
    /// Header 矩形 (包含屏幕不安全区域).
    Rect headerUnsafeRect = Rect.fromLTWH(
      screenRect.left,
      screenRect.top,
      isVertical ? screenRect.width : (bodyRect.left - screenRect.left),
      isVertical ? (bodyRect.top - screenRect.top) : screenRect.height,
    );
    /// Footer 矩形 (包含屏幕不安全区域).
    Rect footerUnsafeRect = Rect.fromLTWH(
      isVertical ? headerUnsafeRect.left : bodyRect.right,
      isVertical ? bodyRect.bottom : headerUnsafeRect.top,
      isVertical ? headerUnsafeRect.width : (screenRect.right - bodyRect.right),
      isVertical ? (screenRect.bottom - bodyRect.bottom) : headerUnsafeRect.height,
    );
    /// Body 卡片网格数.
    int bodyCardGrid = bodyNoPaddingGrid ~/ game.square;
    /// Body 卡片尺寸.
    double bodyCardSize = bodyCardGrid * gridSize;

    sizeCache = mediaQueryData.size;
    paddingCache = mediaQueryData.padding;
    squareCache = game.square;
    metricCache = _Metric(
      game.square,
      screenRect,
      isVertical,
      horizontalGrid,
      verticalGrid,
      gridSize,
      safeRect,
      bodyRect,
      bodyNoPaddingRect,
      headerUnsafeRect,
      footerUnsafeRect,
      bodyCardGrid,
      bodyCardSize,
    );
  }

  /// 返回单例. 必须在第一次 [build] 后调用.
  static _Metric get() {
    if (metricCache == null) {
      throw Exception();
    }
    return metricCache;
  }

  /// 在 [_Game.dispose] 中调用.
  static void dispose() {
    metricCache = null;
    squareCache = null;
    paddingCache = null;
    sizeCache = null;
  }

  _Metric(
      this.square,
      this.screenRect,
      this.isVertical,
      this.horizontalGrid,
      this.verticalGrid,
      this.gridSize,
      this.safeRect,
      this.bodyRect,
      this.bodyNoPaddingRect,
      this.headerUnsafeRect,
      this.footerUnsafeRect,
      this.bodyCardGrid,
      this.bodyCardSize,
      );

  final int square;
  final Rect screenRect;
  final bool isVertical;
  final int horizontalGrid;
  final int verticalGrid;
  final double gridSize;
  final Rect safeRect;
  final Rect bodyRect;
  final Rect bodyNoPaddingRect;
  final Rect headerUnsafeRect;
  final Rect footerUnsafeRect;
  final int bodyCardGrid;
  final double bodyCardSize;
}
