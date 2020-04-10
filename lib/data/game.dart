part of '../data.dart';

//*********************************************************************************************************************

abstract class GameCallback implements TickerProvider {
  void notifyStateChanged();
}

//*********************************************************************************************************************

class Game {
  static void init(GameCallback callback) {
    _Game.init(callback);
  }

  static Game get() {
    return Game._(_Game.get());
  }

  static void dispose() {
    _Game.dispose();
  }

  //*******************************************************************************************************************

  Game._(this._game);

  final _Game _game;

  BuiltList<Card> get cards => _game.screen.cards.map<Card>((card) {
    return Card._(card);
  }).toBuiltList();

  CustomPainter get foregroundPainter => _game.gridForegroundPainter;

  CustomPainter get painter => _game.gridPainter;
}

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

  _Screen screen = _GameScreen(square: 5);
}
