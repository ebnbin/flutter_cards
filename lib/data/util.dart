part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************
// 方向.

extension _AxisDirectionExtension on AxisDirection {
  /// 水平方向值.
  int get x {
    switch (this) {
      case AxisDirection.up:
        return 0;
      case AxisDirection.right:
        return 1;
      case AxisDirection.down:
        return 0;
      case AxisDirection.left:
        return -1;
      default:
        throw Exception();
    }
  }

  /// 垂直方向值.
  int get y {
    switch (this) {
      case AxisDirection.up:
        return -1;
      case AxisDirection.right:
        return 0;
      case AxisDirection.down:
        return 1;
      case AxisDirection.left:
        return 0;
      default:
        throw Exception();
    }
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 旋转角度.

/// 可见的旋转角度. -360, -180, 180, 360.
enum _VisibleAngle {
  counterClockwise360,
  counterClockwise180,
  clockwise180,
  clockwise360,
}

extension _VisibleAngleExtension on _VisibleAngle {
  /// 值.
  double get value {
    switch (this) {
      case _VisibleAngle.counterClockwise360:
        return -2.0 * pi;
      case _VisibleAngle.counterClockwise180:
        return -pi;
      case _VisibleAngle.clockwise180:
        return pi;
      case _VisibleAngle.clockwise360:
        return 2.0 * pi;
      default:
        throw Exception();
    }
  }
}

/// 不可见的旋转角度. -270, -90, 90, 270.
enum _InvisibleAngle {
  counterClockwise270,
  counterClockwise90,
  clockwise90,
  clockwise270,
}

extension _InvisibleAngleExtension on _InvisibleAngle {
  /// 值.
  double get value {
    switch (this) {
      case _InvisibleAngle.counterClockwise270:
        return -1.5 * pi;
      case _InvisibleAngle.counterClockwise90:
        return -0.5 * pi;
      case _InvisibleAngle.clockwise90:
        return 0.5 * pi;
      case _InvisibleAngle.clockwise270:
        return 1.5 * pi;
      default:
        throw Exception();
    }
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 网格标尺.

/// 网格标尺.
class _Metric {
  /// Padding 网格数.
  static const int paddingGrid = 1;
  /// Core 网格数 (不包含 padding).
  static const int coreNoPaddingGrid = 60;
  /// Header footer 网格数 (不包含 padding).
  static const int headerFooterNoPaddingGrid = 15;
  /// Core 网格数.
  static const int coreGrid = coreNoPaddingGrid + paddingGrid * 2;
  /// Header footer 网格数.
  static const int headerFooterGrid = headerFooterNoPaddingGrid + paddingGrid * 2;
  /// 安全网格数.
  static const int safeGrid = coreGrid + headerFooterGrid * 2;
  /// 方格数 to 方格网格数.
  ///
  /// Key 范围 3, 4, 5.
  static final Map<int, int> squareGridMap = Map.unmodifiable({
    3: coreNoPaddingGrid ~/ 3,
    4: coreNoPaddingGrid ~/ 4,
    5: coreNoPaddingGrid ~/ 5,
  });

  const _Metric(
      this.screenRect,
      this.safeScreenRect,
      this.isVertical,
      this.horizontalSafeGrid,
      this.verticalSafeGrid,
      this.gridSize,
      this.safeRect,
      this.coreRect,
      this.coreNoPaddingRect,
      this.headerRect,
      this.footerRect,
      this.headerUnsafeRect,
      this.footerUnsafeRect,
      this.squareSizeMap,
      );

  final Rect screenRect;
  final Rect safeScreenRect;
  final bool isVertical;
  final int horizontalSafeGrid;
  final int verticalSafeGrid;
  final double gridSize;
  final Rect safeRect;
  final Rect coreRect;
  final Rect coreNoPaddingRect;
  final Rect headerRect;
  final Rect footerRect;
  final Rect headerUnsafeRect;
  final Rect footerUnsafeRect;
  final Map<int, double> squareSizeMap;

  /// 在 [_Game.build] 中调用.
  static void build(_Game game, BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    if (game.metricSizeCache == mediaQueryData.size && game.metricPaddingCache == mediaQueryData.padding) {
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
    /// 是否竖屏.
    ///
    /// [MediaQueryData.orientation].
    bool isVertical = screenRect.width <= screenRect.height;
    /// 水平方向安全网格数.
    int horizontalSafeGrid = isVertical ? coreGrid : safeGrid;
    /// 垂直方向安全网格数.
    int verticalSafeGrid = isVertical ? safeGrid : coreGrid;
    /// 网格尺寸.
    double gridSize = min(safeScreenRect.width / horizontalSafeGrid, safeScreenRect.height / verticalSafeGrid);
    /// 安全矩形.
    Rect safeRect = Rect.fromCenter(
      center: safeScreenRect.center,
      width: horizontalSafeGrid * gridSize,
      height: verticalSafeGrid * gridSize,
    );
    /// Core 矩形.
    Rect coreRect = Rect.fromCenter(
      center: safeRect.center,
      width: coreGrid * gridSize,
      height: coreGrid * gridSize,
    );
    /// Core 矩形 (不包含 padding).
    Rect coreNoPaddingRect = Rect.fromLTRB(
      coreRect.left + paddingGrid * gridSize,
      coreRect.top + paddingGrid * gridSize,
      coreRect.right - paddingGrid * gridSize,
      coreRect.bottom - paddingGrid * gridSize,
    );
    /// Header 矩形.
    Rect headerRect = Rect.fromLTWH(
      safeRect.left,
      safeRect.top,
      isVertical ? safeRect.width : (coreRect.left - safeRect.left),
      isVertical ? (coreRect.top - safeRect.top) : safeRect.height,
    );
    /// Footer 矩形.
    Rect footerRect = Rect.fromLTWH(
      isVertical ? headerRect.left : coreRect.right,
      isVertical ? coreRect.bottom : headerRect.top,
      headerRect.width,
      headerRect.height,
    );
    /// Header 矩形 (包含屏幕不安全区域).
    Rect headerUnsafeRect = Rect.fromLTWH(
      screenRect.left,
      screenRect.top,
      isVertical ? screenRect.width : (coreRect.left - screenRect.left),
      isVertical ? (coreRect.top - screenRect.top) : screenRect.height,
    );
    /// Footer 矩形 (包含屏幕不安全区域).
    Rect footerUnsafeRect = Rect.fromLTWH(
      isVertical ? headerUnsafeRect.left : coreRect.right,
      isVertical ? coreRect.bottom : headerUnsafeRect.top,
      isVertical ? headerUnsafeRect.width : (screenRect.right - coreRect.right),
      isVertical ? (screenRect.bottom - coreRect.bottom) : headerUnsafeRect.height,
    );
    /// 方格数 to 方格尺寸.
    ///
    /// Key 范围 3, 4, 5.
    Map<int, double> squareSizeMap = Map.unmodifiable({
      3: squareGridMap[3] * gridSize,
      4: squareGridMap[4] * gridSize,
      5: squareGridMap[5] * gridSize,
    });

    game.metricSizeCache = mediaQueryData.size;
    game.metricPaddingCache = mediaQueryData.padding;
    game.metric = _Metric(
      screenRect,
      safeScreenRect,
      isVertical,
      horizontalSafeGrid,
      verticalSafeGrid,
      gridSize,
      safeRect,
      coreRect,
      coreNoPaddingRect,
      headerRect,
      footerRect,
      headerUnsafeRect,
      footerUnsafeRect,
      squareSizeMap,
    );
  }
}

//*********************************************************************************************************************

/// Debug 用网格标尺背景.
class _MetricPainter extends CustomPainter {
  _MetricPainter(this.game);

  final _Game game;

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    _paint.style = PaintingStyle.fill;
    _paint.color = Colors.blue;
    canvas.drawRect(game.metric.screenRect, _paint);
    _paint.color = Colors.green;
    canvas.drawRect(game.metric.safeRect, _paint);
    _paint.color = Colors.red;
    canvas.drawRect(game.metric.coreRect, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

/// Debug 用网格标尺前景.
class _MetricForegroundPainter extends CustomPainter {
  static final Map<int, Color> _colorMap = Map.unmodifiable({
    3: Colors.yellow,
    4: Colors.purple,
    5: Colors.white,
  });

  _MetricForegroundPainter(this.game);

  final _Game game;

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    _paint.style = PaintingStyle.stroke;
    _paint.color = Colors.cyan;
    // 行.
    for (int rowIndex = 0; rowIndex <= game.metric.verticalSafeGrid; rowIndex++) {
      canvas.drawLine(
        Offset(
          game.metric.safeRect.left,
          game.metric.safeRect.top + rowIndex * game.metric.gridSize,
        ),
        Offset(
          game.metric.safeRect.right,
          game.metric.safeRect.top + rowIndex * game.metric.gridSize,
        ),
        _paint,
      );
    }
    // 列.
    for (int columnIndex = 0; columnIndex <= game.metric.horizontalSafeGrid; columnIndex++) {
      canvas.drawLine(
        Offset(
          game.metric.safeRect.left + columnIndex * game.metric.gridSize,
          game.metric.safeRect.top,
        ),
        Offset(
          game.metric.safeRect.left + columnIndex * game.metric.gridSize,
          game.metric.safeRect.bottom,
        ),
        _paint,
      );
    }
    for (int square = 3; square <= 5; square++) {
      _paint.color = _colorMap[square];
      // 行.
      for (int rowIndex = 0; rowIndex <= square; rowIndex++) {
        canvas.drawLine(
          Offset(
            game.metric.coreNoPaddingRect.left,
            game.metric.coreNoPaddingRect.top + rowIndex * game.metric.squareSizeMap[square],
          ),
          Offset(
            game.metric.coreNoPaddingRect.right,
            game.metric.coreNoPaddingRect.top + rowIndex * game.metric.squareSizeMap[square],
          ),
          _paint,
        );
      }
      // 列.
      for (int columnIndex = 0; columnIndex <= square; columnIndex++) {
        canvas.drawLine(
          Offset(
            game.metric.coreNoPaddingRect.left + columnIndex * game.metric.squareSizeMap[square],
            game.metric.coreNoPaddingRect.top,
          ),
          Offset(
            game.metric.coreNoPaddingRect.left + columnIndex * game.metric.squareSizeMap[square],
            game.metric.coreNoPaddingRect.bottom,
          ),
          _paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 随机数.

/// 随机数.
final Random _random = Random();

extension _RandomExtension on Random {
  /// 包含 [from] 和 [to].
  int nextIntFromTo(int from, int to) {
    return this.nextInt(to - from + 1) + from;
  }

  /// 返回列表中随机的一个 item. 如果列表为空则返回 null.
  T nextListItem<T>(List<T> list) {
    if (list == null || list.isEmpty) {
      return null;
    }
    return list[this.nextInt(list.length)];
  }
}
