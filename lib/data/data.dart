import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:cards/util.dart' as util;
import 'package:flutter/material.dart';

part 'data_action.dart';
part 'data_card.dart';
part 'data_property.dart';

//*********************************************************************************************************************

/// 游戏数据.
class GameData {
  GameData() {
    _initCardDataList();
  }

  void _initCardDataList() {
    for (int rowIndex = 0; rowIndex < _rowCount; rowIndex++) {
      for (int columnIndex = 0; columnIndex < _columnCount; columnIndex++) {
        _cardDataList.add(IndexedCardData(
          gameData: this,
          defaultProperty: defaultProperty,
          rowIndex: rowIndex,
          columnIndex: columnIndex,
        ));
      }
    }
  }

  //*******************************************************************************************************************

  /// 行数. 不包括 header footer.
  int _rowCount = 4;
  /// 列数. 不包括 header footer.
  int _columnCount = 4;

  //*******************************************************************************************************************

  /// 存储所有卡片.
  List<CardData> _cardDataList = [];
  BuiltList<CardData> get cardDataList {
    // 每次 build 时排序.
    _cardDataList.sort();
    return _cardDataList.build();
  }

  //*******************************************************************************************************************

  /// 事件管理.
  final util.ActionManager _actionManager = util.ActionManager(
    max: 1,
  );

  //*******************************************************************************************************************
  // 用户操作.

  Function onTap({
    @required
    CardData cardData,
    @required
    SetState setState,
    @required
    TickerProvider tickerProvider,
  }) {
    assert(cardData != null);
    assert(setState != null);
    assert(tickerProvider != null);
    return () {
      _actionManager.add(_AnimationAction.sample(
        cardData: cardData,
        setState: setState,
        tickerProvider: tickerProvider,
      ));
    };
  }

  Function onLongPress({
    @required
    CardData cardData,
    @required
    BuildContext context,
    @required
    SetState setState,
    @required
    TickerProvider tickerProvider,
  }) {
    assert(cardData != null);
    assert(context != null);
    assert(setState != null);
    assert(tickerProvider != null);
    return null;
  }
}

//*********************************************************************************************************************

/// () { State.setState(VoidCallback) }.
///
/// 调用 setState() 即可更新状态, 在调用前改变需要更新的数据的值.
typedef SetState = void Function();
