import 'dart:collection';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

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
    return () {
      _postAction(RotateY360AnimationAction(this, setState, tickerProvider, card));
    };
  }

  Function onLongPress(BuildContext context, SetState setState, TickerProvider tickerProvider, Card card) {
    return card._onLongPress(context, setState, tickerProvider);
  }

  //*******************************************************************************************************************
  // 事件.

  /// 事件队列.
  final Queue<Action> _actions = Queue();

  /// 是否正在处理事件.
  bool _isActing = false;

  /// 加入事件队列.
  void _postAction(Action action) {
    _actions.addLast(action);
    _handleAction();
  }

  /// 处理事件队列.
  void _handleAction() {
    if (_isActing || _actions.isEmpty) {
      return;
    }
    _isActing = true;
    _actions.removeFirst().begin();
  }
}

//*********************************************************************************************************************

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

  Function _onLongPress(BuildContext context, SetState setState, TickerProvider tickerProvider) {
    return _property == defaultProperty ? Feedback.wrapForLongPress(() {
    }, context) : null;
  }

  //*******************************************************************************************************************
  // 属性.

  Property _property = defaultProperty;
  Property get property => _property;

  //*******************************************************************************************************************

  /// 时间戳, 用于 compareTo.
  int _updatedTimestamp = DateTime.now().microsecondsSinceEpoch;

  @override
  int compareTo(Card other) {
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

//*********************************************************************************************************************
// 事件.

/// 事件.
abstract class Action {
  const Action(this.cards) : assert(cards != null);

  final Cards cards;

  /// 开始执行事件.
  void begin();

  /// 结束执行事件.
  void end() {
    cards._isActing = false;
    cards._handleAction();
  }
}

/// 动画事件.
abstract class AnimationAction extends Action {
  const AnimationAction(Cards cards, this.setState, this.tickerProvider, this.duration, {
    this.curve = Curves.linear,
  }) : assert(setState != null),
        assert(tickerProvider != null),
        assert(duration != null && duration >= 0),
        assert(curve != null),
        super(cards);
  
  final SetState setState;
  final TickerProvider tickerProvider;
  final int duration;
  final Curve curve;
  
  @override
  void begin() {
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
            animationController.dispose();
            onCompleted();
            end();
            setState(() {
            });
            break;
        }
      })
      ..addListener(() {
        onRunning(curvedAnimation.value);
        setState(() {
        });
      });
    animationController.forward();
  }
  
  @protected
  void onRunning(double value) {
  }

  @protected
  void onCompleted() {
  }
}

class RotateY360AnimationAction extends AnimationAction {
  const RotateY360AnimationAction(Cards cards, SetState setState, TickerProvider tickerProvider, this.card) :
        assert(card != null),
        super(cards, setState, tickerProvider, 1000, curve: Curves.easeInOut);
  
  final Card card;
  
  @override
  void onRunning(double value) {
    super.onRunning(value);
    card._property = RotateY360Property(
      value: value,
    );
  }
  
  @override
  void onCompleted() {
    card._updatedTimestamp = DateTime.now().microsecondsSinceEpoch;
    card._property = defaultProperty;
    super.onCompleted();
  }
}
