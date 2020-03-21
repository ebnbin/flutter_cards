import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';

/// 卡片数据. 管理 [BaseCard].
class CardsData {
  CardsData() {
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
        BaseCard baseCard = BaseCard(
          this,
          row: row,
          column: column,
        );
        baseCard.data = data;
        _cards.add(baseCard);
      }
    }
  }

  /// 行数.
  int get rows => 4;
  /// 列数.
  int get columns => 4;

  List<BaseCard> _cards = [];
  BuiltList<BaseCard> get cards => _cards.build();
}

/// 整个游戏所有元素都由 [BaseCard] 组成.
class BaseCard {
  BaseCard(this.cardsData, {
    int row = 0,
    int column = 0,
  }) : assert(cardsData != null),
        assert(row != null && row >= 0 && row < cardsData.rows),
        assert(column != null && column >= 0 && column < cardsData.columns) {
    _row = row;
    _column = column;
  }

  final CardsData cardsData;

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
    double size = min(screenSize.width / cardsData.columns, screenSize.height / cardsData.rows);
    // 水平边距.
    double horizontal = (screenSize.width - size * cardsData.columns) / 2.0;
    // 垂直边距.
    double vertical = (screenSize.height - size * cardsData.rows) / 2.0;
    return Rect.fromLTWH(
      horizontal + size * _column,
      vertical + size * _row,
      size,
      size,
    );
  }

  // 临时数据.
  String data;

  /// 如果不为 null 表示正在动画.
  double animationValue;

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
    const double increment = -0.2;
    if (animationValue == null) {
      return init;
    }
    if (animationValue < 0.5) {
      return init + animationValue * increment * 2.0;
    } else {
      return init + (1.0 - animationValue) * increment * 2.0;
    }
  }

  @override
  String toString() {
    return '$_row,$_column:$data';
  }
}
