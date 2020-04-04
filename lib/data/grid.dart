part of '../data.dart';

//*********************************************************************************************************************

/// 网格.
class _Grid {
  _Grid({
    this.isCoreCard = false,
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
    int rowIndex,
    @required
    int columnIndex,
    @required
    int rowSpan,
    @required
    int columnSpan,
  }) : this(
    isCoreCard: true,
    verticalRowIndex: _Metric.get().bodyCardGrid * rowIndex + _Metric.paddingGrid + (true ? _Metric.headerFooterGrid : 0),
    verticalColumnIndex: _Metric.get().bodyCardGrid * columnIndex + _Metric.paddingGrid + (true ? 0 : _Metric.headerFooterGrid),
    verticalRowSpan: _Metric.get().bodyCardGrid * rowSpan,
    verticalColumnSpan: _Metric.get().bodyCardGrid * columnSpan,
    horizontalRowIndex: _Metric.get().bodyCardGrid * rowIndex + _Metric.paddingGrid + (false ? _Metric.headerFooterGrid : 0),
    horizontalColumnIndex: _Metric.get().bodyCardGrid * columnIndex + _Metric.paddingGrid + (false ? 0 : _Metric.headerFooterGrid),
    horizontalRowSpan: _Metric.get().bodyCardGrid * rowSpan,
    horizontalColumnSpan: _Metric.get().bodyCardGrid * columnSpan,
  );

  final bool isCoreCard;

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

  int get rowIndex => _Metric.get().isVertical ? verticalRowIndex : horizontalRowIndex;
  int get columnIndex => _Metric.get().isVertical ? verticalColumnIndex : horizontalColumnIndex;
  int get rowSpan => _Metric.get().isVertical ? verticalRowSpan : horizontalRowSpan;
  int get columnSpan => _Metric.get().isVertical ? verticalColumnSpan : horizontalColumnSpan;

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
    _Metric.get().safeRect.left + columnIndex * _Metric.get().gridSize,
    _Metric.get().safeRect.top + rowIndex * _Metric.get().gridSize,
    columnSpan * _Metric.get().gridSize,
    rowSpan * _Metric.get().gridSize,
  );

  int get coreCardRowIndex => (rowIndex - _Metric.paddingGrid - (_Metric.get().isVertical ? _Metric.headerFooterGrid : 0)) ~/ _Metric.get().bodyCardGrid;
  int get coreCardColumnIndex => (columnIndex - _Metric.paddingGrid - (_Metric.get().isVertical ? 0 : _Metric.headerFooterGrid)) ~/ _Metric.get().bodyCardGrid;
  int get coreCardRowSpan => rowSpan ~/ _Metric.get().bodyCardGrid;
  int get coreCardColumnSpan => columnSpan ~/ _Metric.get().bodyCardGrid;

  set coreCardRowIndex(int coreCardRowIndex) {
    verticalRowIndex = _Metric.get().bodyCardGrid * coreCardRowIndex + _Metric.paddingGrid + (true ? _Metric.headerFooterGrid : 0);
    horizontalRowIndex = _Metric.get().bodyCardGrid * coreCardRowIndex + _Metric.paddingGrid + (false ? _Metric.headerFooterGrid : 0);
  }

  set coreCardColumnIndex(int coreCardColumnIndex) {
    verticalColumnIndex = _Metric.get().bodyCardGrid * coreCardColumnIndex + _Metric.paddingGrid + (true ? 0 : _Metric.headerFooterGrid);
    horizontalColumnIndex = _Metric.get().bodyCardGrid * coreCardColumnIndex + _Metric.paddingGrid + (false ? 0 : _Metric.headerFooterGrid);
  }

  set coreCardRowSpan(int coreCardRowSpan) {
    rowSpan = _Metric.get().bodyCardGrid * coreCardRowSpan;
  }

  set coreCardColumnSpan(int coreCardColumnSpan) {
    columnSpan = _Metric.get().bodyCardGrid * coreCardColumnSpan;
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
