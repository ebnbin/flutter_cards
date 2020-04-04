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
  int get rowIndex => _Metric.get().gridGetRowIndex(this);
  set rowIndex(int rowIndex) => _Metric.get().gridSetRowIndex(this, rowIndex);

  /// 当前屏幕旋转方向的列.
  int get columnIndex => _Metric.get().gridGetColumnIndex(this);
  set columnIndex(int columnIndex) => _Metric.get().gridSetColumnIndex(this, columnIndex);

  /// 当前屏幕旋转方向的跨行.
  int get rowSpan => _Metric.get().gridGetRowSpan(this);
  set rowSpan(int rowSpan) => _Metric.get().gridSetRowSpan(this, rowSpan);

  /// 当前屏幕旋转方向的跨列.
  int get columnSpan => _Metric.get().gridGetColumnSpan(this);
  set columnSpan(int columnSpan) => _Metric.get().gridSetColumnSpan(this, columnSpan);

  /// 网格矩形.
  Rect get rect => _Metric.get().gridRect(this);

  /// Body 卡片行.
  int get bodyRowIndex => _Metric.get().gridGetBodyRowIndex(this);
  set bodyRowIndex(int bodyRowIndex) => _Metric.get().gridSetBodyRowIndex(this, bodyRowIndex);

  /// Body 卡片列.
  int get bodyColumnIndex => _Metric.get().gridGetBodyColumnIndex(this);
  set bodyColumnIndex(int bodyColumnIndex) => _Metric.get().gridSetBodyColumnIndex(this, bodyColumnIndex);

  /// Body 卡片跨行.
  int get bodyRowSpan => _Metric.get().gridGetBodyRowSpan(this);
  set bodyRowSpan(int bodyRowSpan) => _Metric.get().gridSetBodyRowSpan(this, bodyRowSpan);

  /// Body 卡片跨列.
  int get bodyColumnSpan => _Metric.get().gridGetBodyColumnSpan(this);
  set bodyColumnSpan(int bodyColumnSpan) => _Metric.get().gridSetBodyColumnSpan(this, bodyColumnSpan);

  @override
  String toString() {
    return '$verticalRowIndex,$verticalColumnIndex,$verticalRowSpan,$verticalColumnSpan\n'
        '$horizontalRowIndex,$horizontalColumnIndex,$horizontalRowSpan,$horizontalColumnSpan';
  }
}
