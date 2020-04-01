import 'dart:collection';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart' hide Card;

part 'data/action.dart';
part 'data/animation.dart';
part 'data/card.dart';
part 'data/custom_painter.dart';
part 'data/game.dart';
part 'data/grid.dart';
part 'data/property.dart';

//*********************************************************************************************************************

abstract class Property {
  Matrix4 get transform;

  double get elevation;
  double get radius;
  double get opacity;

  /// 根据 [zIndex] 计算是否可见.
  ///
  /// [zIndex] 范围 0 ~ 5.
  bool Function(int zIndex) get zIndexVisible;

  double get margin;

  Color get color;
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
  static Game create(GameCallback callback) {
    return _Game(callback: callback);
  }

  BuiltList<Card> get cards;

  void build();

  CustomPainter get painter;
  CustomPainter get foregroundPainter;
}

//*********************************************************************************************************************

abstract class Card {
  Rect get rect;

  Property get property;

  GestureTapCallback get onTap;

  GestureLongPressCallback get onLongPress;
}
