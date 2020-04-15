part of '../data.dart';

//*********************************************************************************************************************

/// 游戏数据.
class _Game {

  //*******************************************************************************************************************

  _Game(this.callback) {
    gridForegroundPainter = _GridForegroundPainter(this);
    screen = _GameScreen(this, square: 3);
  }

  final GameCallback callback;

  final _GridPainter gridPainter = _GridPainter();
  _GridForegroundPainter gridForegroundPainter;

  //*******************************************************************************************************************

  void build(BuildContext context) {
  }

  //*******************************************************************************************************************

  _Screen screen;
}
