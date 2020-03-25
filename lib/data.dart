import 'dart:collection';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

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

  void build();
}

//*********************************************************************************************************************

abstract class CardData {
  CardData._();

  bool zIndexVisible(int zIndex);

  Rect get rect;

  Color get color;

  Property get property;

  GestureTapCallback get onTap;

  GestureLongPressCallback get onLongPress;
}
