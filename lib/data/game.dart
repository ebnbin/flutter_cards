part of '../data.dart';

//*********************************************************************************************************************

/// 游戏数据.
class _Game {

  //*******************************************************************************************************************

  _Game(this.callback) {
    gridPainter = _DebugPainter(this);
    gridForegroundPainter = _DebugForegroundPainter(this);
    screen = _GameScreen(this, square: 4);
  }

  final GameCallback callback;

  _DebugPainter gridPainter;
  _DebugForegroundPainter gridForegroundPainter;

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
