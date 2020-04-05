part of '../data.dart';

//*********************************************************************************************************************

/// 卡片网格.
class _Grid {
  _Grid({
    this.verticalRowIndex = 0,
    this.verticalColumnIndex = 0,
    this.verticalRowSpan = 1,
    this.verticalColumnSpan = 1,
    this.horizontalRowIndex = 0,
    this.horizontalColumnIndex = 0,
    this.horizontalRowSpan = 1,
    this.horizontalColumnSpan = 1,
  });

  /// Body 卡片网格.
  _Grid.body({
    int rowIndex = 0,
    int columnIndex = 0,
    int rowSpan = 1,
    int columnSpan = 1,
  }) {
    bodyRowIndex = rowIndex;
    bodyColumnIndex = columnIndex;
    bodyRowSpan = rowSpan;
    bodyColumnSpan = columnSpan;
  }

  /// 所属卡片.
  _Card card;

  /// 竖屏行.
  int verticalRowIndex;
  /// 竖屏列.
  int verticalColumnIndex;
  /// 竖屏跨行.
  int verticalRowSpan;
  /// 竖屏跨列.
  int verticalColumnSpan;
  /// 横屏行.
  int horizontalRowIndex;
  /// 横屏列.
  int horizontalColumnIndex;
  /// 横屏跨行.
  int horizontalRowSpan;
  /// 横屏跨列.
  int horizontalColumnSpan;

  /// 当前屏幕旋转方向的行.
  int get rowIndex {
    return _Metric.get().isVertical ? verticalRowIndex : horizontalRowIndex;
  }
  set rowIndex(int rowIndex) {
    horizontalRowIndex = rowIndex;
    verticalRowIndex = rowIndex;
  }

  /// 当前屏幕旋转方向的列.
  int get columnIndex {
    return _Metric.get().isVertical ? verticalColumnIndex : horizontalColumnIndex;
  }
  set columnIndex(int columnIndex) {
    horizontalColumnIndex = columnIndex;
    verticalColumnIndex = columnIndex;
  }

  /// 当前屏幕旋转方向的跨行.
  int get rowSpan {
    return _Metric.get().isVertical ? verticalRowSpan : horizontalRowSpan;
  }
  set rowSpan(int rowSpan) {
    horizontalRowSpan = rowSpan;
    verticalRowSpan = rowSpan;
  }

  /// 当前屏幕旋转方向的跨列.
  int get columnSpan {
    return _Metric.get().isVertical ? verticalColumnSpan : horizontalColumnSpan;
  }
  set columnSpan(int columnSpan) {
    horizontalColumnSpan = columnSpan;
    verticalColumnSpan = columnSpan;
  }

  /// 当前屏幕旋转方向的跨行跨列取小值.
  int get minSpan => min(rowSpan, columnSpan);
  /// 当前屏幕旋转方向的跨行跨列取大值.
  int get maxSpan => max(rowSpan, columnSpan);

  /// 网格矩形.
  Rect get rect => Rect.fromLTWH(
    _Metric.get().safeRect.left + columnIndex * _Metric.get().gridSize,
    _Metric.get().safeRect.top + rowIndex * _Metric.get().gridSize,
    columnSpan * _Metric.get().gridSize,
    rowSpan * _Metric.get().gridSize,
  );

  /// Body 卡片行.
  int get bodyRowIndex {
    return (rowIndex - _Metric.paddingGrid - (_Metric.get().isVertical ? _Metric.headerFooterGrid : 0)) ~/
        _Metric.get().bodyCardGrid;
  }
  set bodyRowIndex(int bodyRowIndex) {
    verticalRowIndex = _Metric.get().bodyCardGrid * bodyRowIndex + _Metric.paddingGrid + _Metric.headerFooterGrid;
    horizontalRowIndex = _Metric.get().bodyCardGrid * bodyRowIndex + _Metric.paddingGrid;
  }

  /// Body 卡片列.
  int get bodyColumnIndex {
    return (columnIndex - _Metric.paddingGrid - (_Metric.get().isVertical ? 0 : _Metric.headerFooterGrid)) ~/
        _Metric.get().bodyCardGrid;
  }
  set bodyColumnIndex(int bodyColumnIndex) {
    verticalColumnIndex = _Metric.get().bodyCardGrid * bodyColumnIndex + _Metric.paddingGrid;
    horizontalColumnIndex = _Metric.get().bodyCardGrid * bodyColumnIndex + _Metric.paddingGrid +
        _Metric.headerFooterGrid;
  }

  /// Body 卡片跨行.
  int get bodyRowSpan {
    return rowSpan ~/ _Metric.get().bodyCardGrid;
  }
  set bodyRowSpan(int bodyRowSpan) {
    rowSpan = _Metric.get().bodyCardGrid * bodyRowSpan;
  }

  /// Body 卡片跨列.
  int get bodyColumnSpan {
    return columnSpan ~/ _Metric.get().bodyCardGrid;
  }
  set bodyColumnSpan(int bodyColumnSpan) {
    columnSpan = _Metric.get().bodyCardGrid * bodyColumnSpan;
  }

  @override
  String toString() {
    return '$verticalRowIndex,$verticalColumnIndex,$verticalRowSpan,$verticalColumnSpan\n'
        '$horizontalRowIndex,$horizontalColumnIndex,$horizontalRowSpan,$horizontalColumnSpan';
  }
}
