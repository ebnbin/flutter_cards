import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:cards/util.dart' as util;
import 'package:flutter/material.dart';

part 'action.dart';
part 'card.dart';
part 'property.dart';

/// 卡片数据. 管理 [CardData2].
class GameData {
  GameData() {
    _initCards();
  }

  /// 行数.
  int get rowCount => 4;
  /// 列数.
  int get columnCount => 4;

  /// 卡片列表.
  List<CardData2> _cardDataList = [];
  BuiltList<CardData2> get cardDataList {
    // 每次 build 时排序.
    _cardDataList.sort();
    return _cardDataList.build();
  }

  void _initCards() {
    for (int row = 0; row < rowCount; row++) {
      for (int column = 0; column < columnCount; column++) {
        _cardDataList.add(CardData2(
          gameData: this,
          defaultProperty: defaultProperty,
          row: row,
          column: column,
        ));
      }
    }
  }

  Function onTap(CardData2 cardData, SetState setState, TickerProvider tickerProvider) {
    return () {
      _actionManager.add(_AnimationAction.sample(
        cardData: cardData,
        setState: setState,
        tickerProvider: tickerProvider,
      ));
    };
  }

  Function onLongPress(CardData2 card, BuildContext context, SetState setState, TickerProvider tickerProvider) {
    return null;
  }

  //*******************************************************************************************************************
  // 事件.

  final util.ActionManager _actionManager = util.ActionManager(
    max: 1,
  );
}

//*********************************************************************************************************************

/// 整个游戏所有元素都由 [CardData2] 组成.
class CardData2 extends CardData {
  CardData2({
    GameData gameData,
    Property defaultProperty,
    int row = 0,
    int column = 0,
  }) : assert(gameData != null),
        assert(row != null && row >= 0 && row < gameData.rowCount),
        assert(column != null && column >= 0 && column < gameData.columnCount),
        super(gameData: gameData, defaultProperty: defaultProperty) {
    _rowIndex = row;
    _columnIndex = column;
  }

  /// 所在行.
  int _rowIndex;
  int get rowIndex => _rowIndex;

  /// 所在列.
  int _columnIndex;
  int get columnIndex => _columnIndex;

  /// 在 Stack 中的位置.
  Rect rect(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // 安全的屏幕宽高.
    Size screenSize = Size(
      mediaQueryData.size.width - mediaQueryData.padding.horizontal,
      mediaQueryData.size.height - mediaQueryData.padding.vertical,
    );
    // 卡片宽高.
    double size = min(screenSize.width / gameData.columnCount, screenSize.height / gameData.rowCount);
    // 水平边距.
    double horizontal = (screenSize.width - size * gameData.columnCount) / 2.0;
    // 垂直边距.
    double vertical = (screenSize.height - size * gameData.rowCount) / 2.0;
    return Rect.fromLTWH(
      horizontal + size * _columnIndex,
      vertical + size * _rowIndex,
      size,
      size,
    );
  }

  @override
  String toString() {
    return '$_rowIndex,$_columnIndex';
  }
}

//*********************************************************************************************************************

/// State.setState(VoidCallback).
typedef SetState = void Function(VoidCallback);
