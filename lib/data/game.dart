part of '../data.dart';

//*********************************************************************************************************************

/// 游戏数据.
class _Game {
  static _Game _game;

  static void init(GameCallback callback) {
    if (_game != null) {
      throw Exception();
    }
    _game = _Game(callback);
  }

  static _Game get() {
    if (_game == null) {
      throw Exception();
    }
    return _game;
  }

  static void dispose() {
    _game = null;
  }

  //*******************************************************************************************************************

  _Game(this.callback);

  final GameCallback callback;

  final _GridPainter gridPainter = _GridPainter();
  final _GridForegroundPainter gridForegroundPainter = _GridForegroundPainter();

  //*******************************************************************************************************************

  _Screen screen = _GameScreen(square: 3);
}
