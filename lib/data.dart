import 'dart:collection';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart' hide Card;

part 'data/action.dart';
part 'data/animation.dart';
part 'data/card.dart';
part 'data/game.dart';

//*********************************************************************************************************************

abstract class Property {
  Property._();

  Matrix4 get transform;

  double get elevation;
  double get radius;
  double get opacity;
}

//*********************************************************************************************************************
//*********************************************************************************************************************
//*********************************************************************************************************************

abstract class GameCallback implements TickerProvider {
  BuildContext get context;

  void setState(VoidCallback fn);
}

//*********************************************************************************************************************

abstract class Game {
  Game._();

  static Game create(GameCallback callback) {
    return _Game(callback: callback);
  }

  Rect get safeRect;

  Rect get boardRect;

  BuiltList<Card> get cards;

  Function onTap({
    @required
    Card card,
  });

  Function onLongPress({
    @required
    Card card,
  });

  void build();
}

//*********************************************************************************************************************

abstract class Card {
  Card._();

  bool zIndexVisible(int zIndex);

  Rect get rect;

  Color get color;

  Property get property;

  GestureTapCallback get onTap;

  GestureLongPressCallback get onLongPress;
}
