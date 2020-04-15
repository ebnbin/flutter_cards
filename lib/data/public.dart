part of '../data.dart';

//*********************************************************************************************************************

abstract class GameCallback implements TickerProvider {
  void notifyStateChanged();
}

//*********************************************************************************************************************

class Game {
  static _Game _instance;

  static void init(GameCallback callback) {
    if (_instance != null) {
      throw Exception();
    }
    _instance = _Game(callback);
  }

  static Game build(BuildContext context) {
    if (_instance == null) {
      throw Exception();
    }
    _instance.build(context);
    return Game._(_instance);
  }

  static void dispose() {
    _instance = null;
  }

  //*******************************************************************************************************************

  Game._(this._game);

  final _Game _game;

  BuiltList<Card> get cards => _game.screen.cards.map<Card>((card) {
    return Card._(card);
  }).toBuiltList();

  CustomPainter get foregroundPainter => _game.gridForegroundPainter;

  CustomPainter get painter => _game.gridPainter;

  double get backgroundImageScale {
    return 256.0 / (min(_game.metric.safeScreenRect.width, _game.metric.safeScreenRect.height) / 62.0 * 16.0 / 2.0);
  }

  double get backgroundImageWidth {
    return _game.metric.screenRect.width;
  }

  double get backgroundImageHeight {
    return _game.metric.screenRect.height;
  }
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
//      _GridCard gridCard = _card as _GridCard;
//      return gridCard.radius;
      return 0.0;
    }
    return null;
  }

  Rect get rect {
    if (_card == null) {
      return Rect.zero;
    }
    return _card.rect;
  }

  Matrix4 get transform {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.transform;
    }
    return null;
  }

  bool Function(int zIndex) get zIndexVisible {
    if (_card == null) {
      return (_) => false;
    }
    return _card.zIndexVisible;
  }

  Rect get spriteEntityRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 48.0,
      rect.width / 60.0 * 48.0,
    );
  }

  Rect get spriteWeaponRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 0.0,
      rect.width / 60.0 * 15.0,
      rect.width / 60.0 * 24.0,
      rect.width / 60.0 * 24.0,
    );
  }

  Rect get spriteWeaponValueRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 0.0,
      rect.width / 60.0 * 39.0,
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 7.0,
    );
  }

  double get spriteValueFontSize {
    if (_card == null) {
      return 14.0;
    }
    return rect.width / _card.screen.game.metric.gridSize / (5.0 / 3.0);
  }

  Rect get spriteShieldRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 23.0,
      rect.width / 60.0 * 17.0,
      rect.width / 60.0 * 24.0,
      rect.width / 60.0 * 24.0,
    );
  }

  Rect get spriteShieldValueRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 47.0,
      rect.width / 60.0 * 28.0,
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 7.0,
    );
  }

  Rect get spriteHealthRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 47.0,
      rect.width / 60.0 * 8.0,
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 9.0,
    );
  }

  Rect get spriteHealthValueRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 35.0,
      rect.width / 60.0 * 1.0,
      rect.width / 60.0 * 21.0,
      rect.width / 60.0 * 7.0,
    );
  }

  Rect get spriteHealthStateRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 47.0,
      rect.width / 60.0 * 46.0,
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 9.0,
    );
  }

  Rect get spriteHealthStateValueRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 38.0,
      rect.width / 60.0 * 48.0,
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 7.0,
    );
  }

  Rect get spriteStateRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 0.0,
      rect.width / 60.0 * 1.0,
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 9.0,
    );
  }

  Rect get spriteStateValueRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 1.0,
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 7.0,
    );
  }

  Rect get spriteAmountValueRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 0.0,
      rect.width / 60.0 * 48.0,
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 7.0,
    );
  }

  @override
  String toString() {
    if (_card == null) {
      return "";
    }
    return _card.toString();
  }
}
