part of '../data.dart';

//*********************************************************************************************************************

/// 游戏数据.
class _Game {

  //*******************************************************************************************************************

  _Game(this.callback) {
    gridPainter = _MetricPainter(this);
    gridForegroundPainter = _MetricForegroundPainter(this);
    screen = _GameScreen(this, square: 4);
  }

  final GameCallback callback;

  _MetricPainter gridPainter;
  _MetricForegroundPainter gridForegroundPainter;

  //*******************************************************************************************************************

  Size metricSizeCache;
  EdgeInsets metricPaddingCache;

  _Metric metric;

  void build(BuildContext context) {
    _Metric.build(this, context);
  }

  //*******************************************************************************************************************

  _Screen screen;
}
