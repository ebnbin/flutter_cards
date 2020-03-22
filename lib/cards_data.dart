import 'dart:collection';
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

  Queue<Action> _actions = Queue();
  bool _isActing = false;

  void postAction(Action action) {
    _actions.addLast(action);
    _handleAction();
  }

  void _handleAction() {
    if (_isActing || _actions.isEmpty) {
      return;
    }
    Action action = _actions.removeFirst();
    _isActing = true;
    action.start();
  }

  Function _onTap(SetState setState, TickerProvider tickerProvider) {
    return () {
      postAction(AnimationAction(this, null, setState, tickerProvider, 1000, Curves.easeInOut));
    };
  }

  Function _onLongPress(BuildContext context, SetState setState, TickerProvider tickerProvider) {
    return _property == defaultProperty ? Feedback.wrapForLongPress(() {
    }, context) : null;
  }

  //*******************************************************************************************************************
  // 属性.

  Property _property = defaultProperty;
  Property get property => _property;
}

//*********************************************************************************************************************

abstract class Action {
  const Action(this.card, this.actionCompletedCallback);

  final Card card;
  final ActionCompletedCallback actionCompletedCallback;

  void start();
  
  void end() {
    actionCompletedCallback?.call();
    card._isActing = false;
    card._handleAction();
  }
}

typedef ActionCompletedCallback = void Function();

class AnimationAction extends Action {
  AnimationAction(Card card, ActionCompletedCallback actionCompletedCallback,
      this.setState, this.tickerProvider, this.duration, this.curve,) : super(card, actionCompletedCallback);

  final SetState setState;
  final TickerProvider tickerProvider;
  final int duration;
  final Curve curve;

  @override
  void start() {
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
            card._timestamp = DateTime.now().microsecondsSinceEpoch;
            card._property = defaultProperty;
            end();
            setState(() {
            });
            animationController.dispose();
            break;
        }
      })
      ..addListener(() {
        card._property = RotateY360Property(
          value: curvedAnimation.value,
        );
        setState(() {
        });
      });
    animationController.forward();
  }
}

//*********************************************************************************************************************
// 属性.

/// 根据 Animation.value 计算属性.
abstract class Property {
  const Property({
    this.value = 0.0,
  }) : assert(value != null);

  /// Animation.value.
  final double value;

  /// Matrix4.setEntry(3, 2, value).
  double get matrix4Entry32;

  double get rotateX;

  double get rotateY;

  double get scaleX;

  double get scaleY;

  /// Transform.
  Matrix4 get transform => Matrix4.identity()
      ..setEntry(3, 2, matrix4Entry32)
      ..rotateX(rotateX)
      ..rotateY(rotateY)
      ..scale(scaleX, scaleY);

  double get elevation;

  double get radius;
}

/// 无动画时的默认属性.
class DefaultProperty extends Property {
  const DefaultProperty() : super();

  @override
  double get matrix4Entry32 => 0.005;

  @override
  double get rotateX => 0.0;

  @override
  double get rotateY => 0.0;

  @override
  double get scaleX => 1.0;

  @override
  double get scaleY => 1.0;

  @override
  double get elevation => 1.0;

  @override
  double get radius => 4.0;
}

/// 无动画时的默认属性.
final Property defaultProperty = DefaultProperty();

class RotateY360Property extends Property {
  const RotateY360Property({
    double value,
  }) : super(value: value);

  @override
  double get matrix4Entry32 => 0.005;

  @override
  double get rotateX => 0.0;

  @override
  double get rotateY {
    const double init = 0.0;
    const double increment = 2.0 * pi;
    return init + value * increment;
  }

  @override
  double get scaleX {
    const double init = 1.0;
    const double increment = 1.0;
    return init + (0.5 - (value - 0.5).abs()) * increment * 2.0;
  }

  @override
  double get scaleY {
    const double init = 1.0;
    const double increment = 1.0;
    return init + (0.5 - (value - 0.5).abs()) * increment * 2.0;
  }

  @override
  double get elevation {
    const double init = 1.0;
    const double increment = 1.0;
    return init + (0.5 - (value - 0.5).abs()) * increment * 2.0;
  }

  @override
  double get radius {
    const double init = 4.0;
    const double increment = 4.0;
    return init + (0.5 - (value - 0.5).abs()) * increment * 2.0;
  }
}
