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

class Card {
  Card._(this._card);

  final _Card _card;

  bool get absorbPointer {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.absorbPointer;
    }
    return null;
  }

  Color get color => Colors.blueGrey.shade100;

  double get elevation {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.elevation;
    }
    return null;
  }

  bool get ignorePointer {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.ignorePointer;
    }
    return null;
  }

  double get margin {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.margin;
    }
    return null;
  }

  GestureLongPressCallback get onLongPress {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.onLongPress;
    }
    return null;
  }

  GestureTapCallback get onTap {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.onTap;
    }
    return null;
  }

  double get opacity {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.opacity;
    }
    return null;
  }

  double get radius {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.radius;
    }
    return null;
  }

  Rect get rect => _card.rect;

  Matrix4 get transform {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.transform;
    }
    return null;
  }

  bool Function(int zIndex) get zIndexVisible => _card.zIndexVisible;

  @override
  String toString() {
    return _card.toString();
  }
}
