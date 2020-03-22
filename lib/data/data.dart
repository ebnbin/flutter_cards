import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:cards/util.dart' as util;
import 'package:flutter/material.dart';

part 'action.dart';
part 'property.dart';

/// 卡片数据. 管理 [CardData].
class GameData {
  GameData() {
    _initCards();
  }

  /// 行数.
  int get rows => 4;
  /// 列数.
  int get columns => 4;

  /// 卡片列表.
  List<CardData> _cardDataList = [];
  BuiltList<CardData> get cardDataList {
    // 每次 build 时排序.
    _cardDataList.sort();
    return _cardDataList.build();
  }

  void _initCards() {
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        _cardDataList.add(CardData(
          this,
          row: row,
          column: column,
        ));
      }
    }
  }

  Function onTap(CardData cardData, SetState setState, TickerProvider tickerProvider) {
    return () {
      _actionManager.add(_AnimationAction.sample(
        cardData: cardData,
        setState: setState,
        tickerProvider: tickerProvider,
      ));
    };
  }

  Function onLongPress(CardData card, BuildContext context, SetState setState, TickerProvider tickerProvider) {
    return card._onLongPress(context, setState, tickerProvider);
  }

  //*******************************************************************************************************************
  // 事件.

  final util.ActionManager _actionManager = util.ActionManager(
    max: 1,
  );
}

//*********************************************************************************************************************

/// 整个游戏所有元素都由 [CardData] 组成.
class CardData implements Comparable<CardData> {
  CardData(this.gameData, {
    int row = 0,
    int column = 0,
  }) : assert(gameData != null),
        assert(row != null && row >= 0 && row < gameData.rows),
        assert(column != null && column >= 0 && column < gameData.columns) {
    _row = row;
    _column = column;
  }

  final GameData gameData;

  /// 所在行.
  int _row;
  int get row => _row;

  /// 所在列.
  int _column;
  int get column => _column;

  /// 是否可见.
  bool _visible = true;
  bool get visible => _visible;

  /// 在 Stack 中的位置.
  Rect rect(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // 安全的屏幕宽高.
    Size screenSize = Size(
      mediaQueryData.size.width - mediaQueryData.padding.horizontal,
      mediaQueryData.size.height - mediaQueryData.padding.vertical,
    );
    // 卡片宽高.
    double size = min(screenSize.width / gameData.columns, screenSize.height / gameData.rows);
    // 水平边距.
    double horizontal = (screenSize.width - size * gameData.columns) / 2.0;
    // 垂直边距.
    double vertical = (screenSize.height - size * gameData.rows) / 2.0;
    return Rect.fromLTWH(
      horizontal + size * _column,
      vertical + size * _row,
      size,
      size,
    );
  }

  Function _onLongPress(BuildContext context, SetState setState, TickerProvider tickerProvider) {
    return _property == _defaultProperty ? Feedback.wrapForLongPress(() {
    }, context) : null;
  }

  //*******************************************************************************************************************
  // 属性.

  Property _defaultProperty = defaultProperty;

  Property _property = defaultProperty;
  Property get property => _property;

  void _resetProperty() {
    _property = _defaultProperty;
  }

  //*******************************************************************************************************************

  /// 时间戳, 用于 compareTo.
  int _updatedTimestamp = DateTime.now().microsecondsSinceEpoch;

  void _updateTimestamp() {
    _updatedTimestamp = DateTime.now().microsecondsSinceEpoch;
  }

  @override
  int compareTo(CardData other) {
    if (_property.elevation == other._property.elevation) {
      return (_updatedTimestamp - other._updatedTimestamp).sign;
    }
    return (_property.elevation - other._property.elevation).sign.toInt();
  }

  @override
  String toString() {
    return '$_row,$_column';
  }
}

//*********************************************************************************************************************

/// State.setState(VoidCallback).
typedef SetState = void Function(VoidCallback);
