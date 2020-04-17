part of '../data.dart';

//*********************************************************************************************************************

abstract class GameCallback implements TickerProvider {
  void notifyStateChanged();
}

//*********************************************************************************************************************

class Data {
  final _Game _game;

  Data(GameCallback callback) : _game = _Game(callback);

  Game build() {
    return Game._(_game);
  }
}

class Game {
  Game._(this._game);

  final _Game _game;

  List<Card> get cards {
    return List.unmodifiable(_game.screen.cards.map<Card>((card) {
      return Card._(card);
    }));
  }

  double get backgroundImageScale {
    return 256.0 / (min(Metric.get().safeScreenRect.width, Metric.get().safeScreenRect.height) / 62.0 * 16.0 / 2.0);
  }

  double get backgroundImageWidth {
    return Metric.get().screenRect.width;
  }

  double get backgroundImageHeight {
    return Metric.get().screenRect.height;
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
    return (_card).rect;
  }

  Matrix4 get transform {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.transform;
    }
    return null;
  }

  /// 在 [zIndex] 上是否可见.
  ///
  /// [zIndex] 范围 0 ~ 3.
  bool Function(int zIndex) get zIndexVisible {
    return (zIndex) {
      assert(zIndex >= 0 && zIndex <= 3);
      return _card.visible && _card.zIndex == zIndex;
    };
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

  Rect get spriteWeaponValue0Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 1.0,
      rect.width / 60.0 * 40.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteWeaponValue1Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 5.0,
      rect.width / 60.0 * 40.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  double get spriteValueFontSize {
    if (_card == null) {
      return 14.0;
    }
    return rect.width / Metric.get().gridSize / (5.0 / 3.0);
  }

  Rect get spriteShieldRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 22.0,
      rect.width / 60.0 * 17.0,
      rect.width / 60.0 * 24.0,
      rect.width / 60.0 * 24.0,
    );
  }

  Rect get spriteShieldValue0Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 47.0,
      rect.width / 60.0 * 29.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteShieldValue1Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 51.0,
      rect.width / 60.0 * 29.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteHealthRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 47.0,
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 9.0,
    );
  }

  Rect get spriteHealthValue0Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 35.0,
      rect.width / 60.0 * 2.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteHealthValue1Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 39.0,
      rect.width / 60.0 * 2.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteHealthValue2Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 43.0,
      rect.width / 60.0 * 2.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteHealthValue3Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 47.0,
      rect.width / 60.0 * 2.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteHealthValue4Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 51.0,
      rect.width / 60.0 * 2.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
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

  Rect get spriteHealthStateValue0Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 38.0,
      rect.width / 60.0 * 48.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteHealthStateValue1Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 42.0,
      rect.width / 60.0 * 48.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
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

  Rect get spriteStateValue0Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 10.0,
      rect.width / 60.0 * 2.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }
  Rect get spriteStateValue1Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 14.0,
      rect.width / 60.0 * 2.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteAmountValue0Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 1.0,
      rect.width / 60.0 * 48.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteAmountValue1Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 5.0,
      rect.width / 60.0 * 48.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
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
