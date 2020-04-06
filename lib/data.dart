import 'dart:collection';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart' hide Card;

part 'data/action.dart';
part 'data/animation.dart';
part 'data/card.dart';
part 'data/card_grid.dart';
part 'data/card_property.dart';
part 'data/card_sprite.dart';
part 'data/game.dart';
part 'data/metric.dart';
part 'data/painter.dart';

//*********************************************************************************************************************

abstract class GameCallback implements TickerProvider {
  BuildContext get context;

  void setState(VoidCallback fn);
}

//*********************************************************************************************************************

abstract class Game {
  static Game create(GameCallback callback) {
    return _Game(callback: callback);
  }

  GameData get data;
}

abstract class GameData {
  BuiltList<Card> get cards;

  void build();

  void dispose();

  CustomPainter get painter;
  CustomPainter get foregroundPainter;

  Rect get headerRect;
  Rect get footerRect;
}

//*********************************************************************************************************************

abstract class Card {
  CardData get data;
}

abstract class CardData {
  Rect get rect;

  GestureTapCallback get onTap;

  GestureLongPressCallback get onLongPress;

  Matrix4 get transform;

  double get elevation;
  double get radius;
  double get opacity;

  bool Function(int zIndex) get zIndexVisible;

  double get margin;

  Color get color;

  bool get absorbPointer;

  bool get ignorePointer;
}
