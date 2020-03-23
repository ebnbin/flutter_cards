import 'dart:collection';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

part 'data/action.dart';
part 'data/animation.dart';
part 'data/card.dart';
part 'data/game.dart';
part 'data/property.dart';

//*********************************************************************************************************************

abstract class GameCallback implements TickerProvider {
  BuildContext get context;

  void setState(VoidCallback fn);
}

//*********************************************************************************************************************

abstract class GameData {
  GameData._();

  static GameData create(GameCallback callback) {
    return _GameData(callback: callback);
  }

  Rect get safeRect;

  Rect get boardRect;

  BuiltList<CardData> get cardDataList;

  Function onTap({
    @required
    CardData cardData,
  });

  Function onLongPress({
    @required
    CardData cardData,
  });
}

//*********************************************************************************************************************

abstract class CardData {
  CardData._();

  bool get visible;

  Rect get rect;

  Property get property;
}

//*********************************************************************************************************************

abstract class Property {
  Property._();

  double get rotateX;
  double get rotateY;
  double get rotateZ;
  double get scaleX;
  double get scaleY;
  double get opacity;
  double get elevation;
  double get radius;

  Matrix4 get transform;
}
