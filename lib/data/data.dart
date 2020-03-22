import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:cards/util.dart' as util;
import 'package:flutter/material.dart';

part 'action.dart';
part 'card.dart';
part 'property.dart';

/// 整个游戏所有元素都由 [CardData2] 组成.
class CardData2 extends CardData {
  CardData2({
    GameData gameData,
    Property defaultProperty,
    int rowIndex = 0,
    int columnIndex = 0,
  }) : assert(gameData != null),
        assert(rowIndex != null && rowIndex >= 0 && rowIndex < gameData._rowCount),
        assert(columnIndex != null && columnIndex >= 0 && columnIndex < gameData._columnCount),
        super(gameData: gameData, defaultProperty: defaultProperty) {
    _rowIndex = rowIndex;
    _columnIndex = columnIndex;
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
    double size = min(screenSize.width / gameData._columnCount, screenSize.height / gameData._rowCount);
    // 水平边距.
    double horizontal = (screenSize.width - size * gameData._columnCount) / 2.0;
    // 垂直边距.
    double vertical = (screenSize.height - size * gameData._rowCount) / 2.0;
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

/// () { State.setState(VoidCallback) }.
///
/// 调用 setState() 即可更新状态, 在调用前改变需要更新的数据的值.
typedef SetState = void Function();

//*********************************************************************************************************************

/// 游戏数据.
class GameData {
  GameData() {
    _initCardDataList();
  }

  void _initCardDataList() {
    for (int rowIndex = 0; rowIndex < _rowCount; rowIndex++) {
      for (int columnIndex = 0; columnIndex < _columnCount; columnIndex++) {
        _cardDataList.add(CardData2(
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
