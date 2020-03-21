import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

/// 卡片数据. 管理 [Card].
class Cards {
  Cards() {
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        String data;
        switch (row * 10 + column) {
          case 10:
            data = '_C';
            break;
          case 11:
            data = 'ar';
            break;
          case 12:
            data = 'ds';
            break;
          default:
            data = '__';
            break;
        }
        Card card = Card(
          this,
          row: row,
          column: column,
        );
        card.data = data;
        _cards.add(card);
      }
    }
  }

  /// 行数.
  int get rows => 4;
  /// 列数.
  int get columns => 4;

  List<Card> _cards = [];
  BuiltList<Card> get cards {
    _cards.sort();
    return _cards.build();
  }
}

/// 整个游戏所有元素都由 [Card] 组成.
class Card implements Comparable<Card> {
  Card(this.cards, {
    int row = 0,
    int column = 0,
  }) : assert(cards != null),
        assert(row != null && row >= 0 && row < cards.rows),
        assert(column != null && column >= 0 && column < cards.columns) {
    _row = row;
    _column = column;
  }

  final Cards cards;

  /// 所在行.
  int _row;
  int get row => _row;

  /// 所在列.
  int _column;
  int get column => _column;

  /// 在 Stack 中的位置.
  Rect position(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // 安全的屏幕宽高.
    Size screenSize = Size(
      mediaQueryData.size.width - mediaQueryData.padding.horizontal,
      mediaQueryData.size.height - mediaQueryData.padding.vertical,
    );
    // 卡片宽高.
    double size = min(screenSize.width / cards.columns, screenSize.height / cards.rows);
    // 水平边距.
    double horizontal = (screenSize.width - size * cards.columns) / 2.0;
    // 垂直边距.
    double vertical = (screenSize.height - size * cards.rows) / 2.0;
    return Rect.fromLTWH(
      horizontal + size * _column,
      vertical + size * _row,
      size,
      size,
    );
  }

  Matrix4 get transform => Matrix4.identity()
    ..setEntry(3, 2, 0.005)
    ..rotateY(rotateY)
    ..scale(scale);

  // 临时数据.
  String data;

  /// 如果不为 null 表示正在动画.
  double animationValue;

  int get _zIndex => animationValue == null ? 0 : 1;

  double get rotateY {
    const double init = 0.0;
    const double increment = 2.0 * pi;
    if (animationValue == null) {
      return init;
    }
    return init + animationValue * increment;
  }

  double get scale {
    const double init = 1.0;
    const double increment = 1.0;
    if (animationValue == null) {
      return init;
    }
    if (animationValue < 0.5) {
      return init + animationValue * increment * 2.0;
    } else {
      return init + (1.0 - animationValue) * increment * 2.0;
    }
  }

  final int _timestamp = DateTime.now().microsecondsSinceEpoch;

  @override
  int compareTo(Card other) {
    if (_zIndex == other._zIndex) {
      return _timestamp - other._timestamp;
    }
    return _zIndex - other._zIndex;
  }

  @override
  String toString() {
    return '$_row,$_column:$data';
  }

  void createAnimation(SetState setState, TickerProvider tickerProvider, {
    int duration = 1000,
    Curve curve = Curves.linear,
  }) {
    assert(setState != null);
    assert(tickerProvider != null);
    assert(duration != null && duration >= 0);
    assert(curve != null);
    AnimationController animationController = AnimationController(
      duration: Duration(
        milliseconds: duration,
      ),
      vsync: tickerProvider,
    );
    CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: curve,
    );
    curvedAnimation
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.dismissed:
            break;
          case AnimationStatus.forward:
            break;
          case AnimationStatus.reverse:
            break;
          case AnimationStatus.completed:
            animationValue = null;
            setState();
            animationController.dispose();
            break;
        }
      })
      ..addListener(() {
        animationValue = curvedAnimation.value;
        setState();
      });
    animationController.forward();
  }
}

typedef SetState = void Function();
