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
  int get rowCount => 4;
  /// 列数.
  int get columnCount => 4;

  /// 卡片列表.
  List<CardData> _cardDataList = [];
  BuiltList<CardData> get cardDataList {
    // 每次 build 时排序.
    _cardDataList.sort();
    return _cardDataList.build();
  }

  void _initCards() {
    for (int row = 0; row < rowCount; row++) {
      for (int column = 0; column < columnCount; column++) {
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
        assert(row != null && row >= 0 && row < gameData.rowCount),
        assert(column != null && column >= 0 && column < gameData.columnCount) {
    _rowIndex = row;
    _columnIndex = column;
  }

  final GameData gameData;

  /// 所在行.
  int _rowIndex;
  int get rowIndex => _rowIndex;

  /// 所在列.
  int _columnIndex;
  int get columnIndex => _columnIndex;

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
  int _animationTimestamp = DateTime.now().microsecondsSinceEpoch;

  void _updateAnimationTimestamp() {
    _animationTimestamp = DateTime.now().microsecondsSinceEpoch;
  }

  @override
  int compareTo(CardData other) {
    if (_property.elevation == other._property.elevation) {
      return (_animationTimestamp - other._animationTimestamp).sign;
    }
    return (_property.elevation - other._property.elevation).sign.toInt();
  }

  @override
  String toString() {
    return '$_rowIndex,$_columnIndex';
  }
}

//*********************************************************************************************************************

/// State.setState(VoidCallback).
typedef SetState = void Function(VoidCallback);
