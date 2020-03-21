import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

/// State.setState(VoidCallback).
typedef SetState = void Function(VoidCallback);

/// 卡片数据. 管理 [Card].
class Cards {
  Cards() {
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        _cards.add(Card(
          this,
          row: row,
          column: column,
        ));
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

  Function onTap(SetState setState, TickerProvider tickerProvider, Card card) {
    return card._onTap(setState, tickerProvider);
  }

  Function onLongPress(BuildContext context, SetState setState, TickerProvider tickerProvider, Card card) {
    return card._onLongPress(context, setState, tickerProvider);
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

  bool visible = true;

  /// 在 Stack 中的位置.
  Rect rect(BuildContext context) {
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

  Property _property = defaultProperty;
  Property get property => _property;

  Matrix4 get transform => Matrix4.identity()
    ..setEntry(3, 2, 0.005)
    ..rotateY(_property.rotateY)
    ..scale(_property.scale);

  int _timestamp = DateTime.now().microsecondsSinceEpoch;

  @override
  int compareTo(Card other) {
    if (_property.elevation == other._property.elevation) {
      return _timestamp - other._timestamp;
    }
    return _property.elevation > other._property.elevation ? 1 : -1;
  }

  @override
  String toString() {
    return '$_row,$_column';
  }

  Function _onTap(SetState setState, TickerProvider tickerProvider) {
    return _property == defaultProperty ? () {
      createAnimation(setState, tickerProvider,
        duration: 1000,
        curve: Curves.easeInOut,
      );
    } : null;
  }

  Function _onLongPress(BuildContext context, SetState setState, TickerProvider tickerProvider) {
    return _property == defaultProperty ? Feedback.wrapForLongPress(() {
    }, context) : null;
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
            _timestamp = DateTime.now().microsecondsSinceEpoch;
            _property = defaultProperty;
            setState(() {
            });
            animationController.dispose();
            break;
        }
      })
      ..addListener(() {
        _property = AnimationProperty(curvedAnimation.value);
        setState(() {
        });
      });
    animationController.forward();
  }
}

abstract class Property {
  const Property(this.value);

  final double value;

  double get rotateY;

  double get scale;

  double get elevation;

  double get radius;
}

class DefaultProperty extends Property {
  const DefaultProperty() : super(0.0);

  @override
  double get rotateY => 0.0;

  @override
  double get scale => 1.0;

  @override
  double get elevation => 1.0;

  @override
  double get radius => 4.0;
}

final Property defaultProperty = DefaultProperty();

class AnimationProperty extends Property {
  const AnimationProperty(double value) : super(value);

  @override
  double get rotateY {
    const double init = 0.0;
    const double increment = 2.0 * pi;
//    if (value == null) {
//      return init;
//    }
    return init + value * increment;
  }

  @override
  double get scale {
    const double init = 1.0;
    const double increment = 1.0;
//    if (value == null) {
//      return init;
//    }
    if (value < 0.5) {
      return init + value * increment * 2.0;
    } else {
      return init + (1.0 - value) * increment * 2.0;
    }
  }

  @override
  double get elevation {
    const double init = 1.0;
    const double increment = 2.0;
//    if (value == null) {
//      return init;
//    }
    if (value < 0.5) {
      return init + value * increment * 2.0;
    } else {
      return init + (1.0 - value) * increment * 2.0;
    }
  }

  @override
  double get radius {
    const double init = 4.0;
    const double increment = 8.0;
//    if (value == null) {
//      return init;
//    }
    if (value < 0.5) {
      return init + value * increment * 2.0;
    } else {
      return init + (1.0 - value) * increment * 2.0;
    }
  }
}
