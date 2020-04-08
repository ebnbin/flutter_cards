import 'dart:collection';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart' hide Card;

part 'data/action.dart';
part 'data/animation.dart';
part 'data/card.dart';
part 'data/game.dart';
part 'data/metric.dart';
part 'data/painter.dart';
part 'data/random.dart';
part 'data/screen.dart';

//*********************************************************************************************************************

abstract class GameCallback implements TickerProvider {
  BuildContext get context;

  void setState(VoidCallback fn);
}

//*********************************************************************************************************************

abstract class Game {
  static void init(GameCallback callback) {
    _Game.init(callback);
  }

  static Game get() {
    return _Game.get();
  }

  static void dispose() {
    _Game.dispose();
  }

  GameData data;
}

class GameData {
  GameData._(this._game);
  
  final _Game _game;

  void build() {
    _game.build();
  }

  BuiltList<Card> get cards => _game.screen.cards;

  CustomPainter get foregroundPainter => _game.gridForegroundPainter;

  CustomPainter get painter => _game.gridPainter;
}

//*********************************************************************************************************************

abstract class Card {
  CardData data;
}

class CardData {
  CardData._(this._card);

  final _Card _card;

  bool get absorbPointer => _card.absorbPointer;

  Color get color => Colors.white;

  double get elevation => _card.elevation;

  bool get ignorePointer => _card.ignorePointer;

  double get margin => _card.margin;

  GestureLongPressCallback get onLongPress => _card.screen.onLongPress(_card);

  GestureTapCallback get onTap => _card.screen.onTap(_card);

  double get opacity => _card.opacity;

  double get radius => _card.radius;

  Rect get rect => _card.rect;

  Matrix4 get transform => _card.transform;

  bool Function(int zIndex) get zIndexVisible => _card.zIndexVisible;

  @override
  String toString() {
    return _card.toString();
  }
}
