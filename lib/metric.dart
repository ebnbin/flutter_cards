import 'dart:math';

import 'package:flutter/material.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************
// 网格标尺.

/// 网格标尺单例.
class Metric {
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
  static final Map<int, int> squareGridMap = Map<int, int>.unmodifiable({
    3: coreNoPaddingGrid ~/ 3,
    4: coreNoPaddingGrid ~/ 4,
    5: coreNoPaddingGrid ~/ 5,
  });

  static Size _sizeCache;
  static EdgeInsets _paddingCache;
  static Metric _metricCache;

  /// 必需在第一次 [build] 之后调用.
  static Metric get() {
    assert(_metricCache != null);
    return _metricCache;
  }

  const Metric._(
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
      this.debugPainter,
      this.debugForegroundPainter,
      this.imageScale,
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
  final CustomPainter debugPainter;
  final CustomPainter debugForegroundPainter;
  final double Function(int imageSize, double grid) imageScale;

  /// 在 [State.build] 中调用.
  static void build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    if (_sizeCache == mediaQueryData.size && _paddingCache == mediaQueryData.padding) {
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
    Map<int, double> squareSizeMap = Map<int, double>.unmodifiable({
      3: squareGridMap[3] * gridSize,
      4: squareGridMap[4] * gridSize,
      5: squareGridMap[5] * gridSize,
    });
    /// 绘制 debug 背景.
    CustomPainter debugPainter = _DebugPainter((canvas, size, paint) {
      paint.style = PaintingStyle.fill;
      paint.color = Colors.blue;
      canvas.drawRect(screenRect, paint);
      paint.color = Colors.green;
      canvas.drawRect(safeRect, paint);
      paint.color = Colors.red;
      canvas.drawRect(coreRect, paint);
    });
    /// 绘制 debug 前景.
    CustomPainter debugForegroundPainter = _DebugPainter((canvas, size, paint) {
      paint.style = PaintingStyle.stroke;
      paint.color = Colors.cyan;
      // 行.
      for (int rowIndex = 0; rowIndex <= verticalSafeGrid; rowIndex++) {
        canvas.drawLine(
          Offset(safeRect.left, safeRect.top + rowIndex * gridSize),
          Offset(safeRect.right, safeRect.top + rowIndex * gridSize),
          paint,
        );
      }
      // 列.
      for (int columnIndex = 0; columnIndex <= horizontalSafeGrid; columnIndex++) {
        canvas.drawLine(
          Offset(safeRect.left + columnIndex * gridSize, safeRect.top),
          Offset(safeRect.left + columnIndex * gridSize, safeRect.bottom),
          paint,
        );
      }
      Map<int, Color> colorMap = {
        3: Colors.yellow,
        4: Colors.purple,
        5: Colors.white,
      };
      for (int square = 3; square <= 5; square++) {
        paint.color = colorMap[square];
        // 行.
        for (int rowIndex = 0; rowIndex <= square; rowIndex++) {
          canvas.drawLine(
            Offset(coreNoPaddingRect.left, coreNoPaddingRect.top + rowIndex * squareSizeMap[square]),
            Offset(coreNoPaddingRect.right, coreNoPaddingRect.top + rowIndex * squareSizeMap[square]),
            paint,
          );
        }
        // 列.
        for (int columnIndex = 0; columnIndex <= square; columnIndex++) {
          canvas.drawLine(
            Offset(coreNoPaddingRect.left + columnIndex * squareSizeMap[square], coreNoPaddingRect.top),
            Offset(coreNoPaddingRect.left + columnIndex * squareSizeMap[square], coreNoPaddingRect.bottom),
            paint,
          );
        }
      }
    });
    /// 计算图片缩放.
    ///
    /// [imageSize] 图片大小 (像素).
    ///
    /// [grid] 网格数.
    double Function(int imageSize, double grid) imageScale = (imageSize, grid) {
      return imageSize / gridSize / grid * 2.0;
    };

    _sizeCache = mediaQueryData.size;
    _paddingCache = mediaQueryData.padding;
    _metricCache = Metric._(
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
      debugPainter,
      debugForegroundPainter,
      imageScale,
    );
  }
}

//*********************************************************************************************************************

/// 绘制 debug 图层.
class _DebugPainter extends CustomPainter {
  _DebugPainter(this._onPaint);

  final void Function(Canvas canvas, Size size, Paint paint) _onPaint;

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    _onPaint(canvas, size, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
