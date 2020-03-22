import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:cards/util.dart' as util;
import 'package:flutter/material.dart';

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

  Function onTap(CardData card, SetState setState, TickerProvider tickerProvider) {
    return () {
      _actionManager.add(_AnimationAction(this, card, setState, tickerProvider, 1000,
        curve: Curves.easeInOut,
        type: _AnimationType.forward,
        createProperty: ((value) {
          return _RotateY360Property(
            value: value,
          );
        }),
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

//*********************************************************************************************************************
// 属性. 描述 Widget 属性在动画时如何变化.

/// 根据 Animation.value 计算属性.
class Property {
  Property({
    double value = 0.0,
    _PropertyData<double> matrix4Entry32Data,
    _PropertyData<double> rotateXData,
    _PropertyData<double> rotateYData,
    _PropertyData<double> scaleXData,
    _PropertyData<double> scaleYData,
    _PropertyData<double> elevationData,
    _PropertyData<double> radiusData,
  }) : assert(value != null),
        assert(matrix4Entry32Data != null),
        assert(rotateXData != null),
        assert(rotateYData != null),
        assert(scaleXData != null),
        assert(scaleYData != null),
        assert(elevationData != null),
        assert(radiusData != null),
        matrix4Entry32 = matrix4Entry32Data.calc(value),
        rotateX = rotateXData.calc(value),
        rotateY = rotateYData.calc(value),
        scaleX = scaleXData.calc(value),
        scaleY = scaleYData.calc(value),
        elevation = elevationData.calc(value),
        radius = radiusData.calc(value);

  /// Matrix4.setEntry(3, 2, value).
  final double matrix4Entry32;

  final double rotateX;

  final double rotateY;

  final double scaleX;

  final double scaleY;

  /// Transform.
  Matrix4 get transform => Matrix4.identity()
    ..setEntry(3, 2, matrix4Entry32)
    ..rotateX(rotateX)
    ..rotateY(rotateY)
    ..scale(scaleX, scaleY);

  final double elevation;

  final double radius;
}

/// 无动画时的默认属性.
class _DefaultProperty extends Property {
  _DefaultProperty() : super(
    matrix4Entry32Data: _PropertyData(
      keys: [0.005],
      propertyCalc: _propertyDataCalc0,
    ),
    rotateXData: _PropertyData(
      keys: [0.0],
      propertyCalc: _propertyDataCalc0,
    ),
    rotateYData: _PropertyData(
      keys: [0.0],
      propertyCalc: _propertyDataCalc0,
    ),
    scaleXData: _PropertyData(
      keys: [1.0],
      propertyCalc: _propertyDataCalc0,
    ),
    scaleYData: _PropertyData(
      keys: [1.0],
      propertyCalc: _propertyDataCalc0,
    ),
    elevationData: _PropertyData(
      keys: [1.0],
      propertyCalc: _propertyDataCalc0,
    ),
    radiusData: _PropertyData(
      keys: [4.0],
      propertyCalc: _propertyDataCalc0,
    ),
  );
}

/// 无动画时的默认属性.
final Property defaultProperty = _DefaultProperty();

/// 属性数据, 用于计算.
class _PropertyData<T> {
  const _PropertyData({
    this.keys,
    this.propertyCalc,
  });
  
  final List<T> keys;
  final _PropertyCalc<T> propertyCalc;
  
  T calc(double value) {
    return propertyCalc(keys, value);
  }
}

/// 属性数据计算.
typedef _PropertyCalc<T> = T Function(List<T> keys, double value);

final _PropertyCalc<double> _propertyDataCalc0 = (List<double> keys, double value) {
  assert(keys.length >= 1);
  return keys[0];
};

final _PropertyCalc<double> _propertyDataCalc01 = (List<double> keys, double value) {
  assert(keys.length >= 2);
  return keys[0] + value * (keys[1] - keys[0]);
};

final _PropertyCalc<double> _propertyDataCalc010 = (List<double> keys, double value) {
  assert(keys.length >= 2);
  return keys[0] + (0.5 - (value - 0.5).abs()) * (keys[1] - keys[0]) * 2.0;
};

class _RotateY360Property extends Property {
  _RotateY360Property({
    double value,
  }) : super(
    value: value,
    matrix4Entry32Data: _PropertyData<double>(
      keys: [0.005],
      propertyCalc: _propertyDataCalc0,
    ),
    rotateXData: _PropertyData<double>(
      keys: [0.0],
      propertyCalc: _propertyDataCalc0,
    ),
    rotateYData: _PropertyData<double>(
      keys: [0.0, 2.0 * pi],
      propertyCalc: _propertyDataCalc01,
    ),
    scaleXData: _PropertyData<double>(
      keys: [1.0, 2.0],
      propertyCalc: _propertyDataCalc010,
    ),
    scaleYData: _PropertyData<double>(
      keys: [1.0, 2.0],
      propertyCalc: _propertyDataCalc010,
    ),
    elevationData: _PropertyData<double>(
      keys: [1.0, 2.0],
      propertyCalc: _propertyDataCalc010,
    ),
    radiusData: _PropertyData<double>(
      keys: [4.0, 8.0],
      propertyCalc: _propertyDataCalc010,
    ),
  );
}

//*********************************************************************************************************************
// 事件. 添加一个动画或一个操作到事件队列.

/// 动画事件.
class _AnimationAction extends util.Action {
  _AnimationAction(this.gameData, this.cardData, this.setState, this.tickerProvider, this.duration, {
    this.curve = Curves.linear,
    this.type = _AnimationType.forward,
    @required
    this.createProperty,
  }) : assert(gameData != null),
        assert(cardData != null),
        assert(setState != null),
        assert(tickerProvider != null),
        assert(duration != null && duration >= 0),
        assert(curve != null),
        assert(type != null),
        assert(createProperty != null),
        super();

  final GameData gameData;
  final CardData cardData;
  final SetState setState;
  final TickerProvider tickerProvider;
  final int duration;
  final Curve curve;
  final _AnimationType type;
  final CreateProperty createProperty;
  
  @override
  void onBegin() {
    super.onBegin();
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
        switch (type) {
          case _AnimationType.forward:
            switch (status) {
              case AnimationStatus.dismissed:
                break;
              case AnimationStatus.forward:
                break;
              case AnimationStatus.reverse:
                break;
              case AnimationStatus.completed:
                _completed(animationController);
                break;
            }
            break;
          case _AnimationType.forwardReverse:
            switch (status) {
              case AnimationStatus.dismissed:
                _completed(animationController);
                break;
              case AnimationStatus.forward:
                break;
              case AnimationStatus.reverse:
                break;
              case AnimationStatus.completed:
                animationController.reverse();
                break;
            }
            break;
        }
      })
      ..addListener(() {
        cardData._property = createProperty(curvedAnimation.value);
        setState(() {
        });
      });
    animationController.forward();
  }
  
  void _completed(AnimationController animationController) {
    animationController.dispose();
    cardData._updatedTimestamp = DateTime.now().microsecondsSinceEpoch;
    cardData._property = defaultProperty;
    end();
    setState(() {
    });
  }
}

/// 动画类型.
enum _AnimationType {
  /// 正序.
  forward,
  /// 正序逆序.
  forwardReverse,
}

/// 根据 Animation.value 创建 Property.
typedef CreateProperty = Property Function(double value);
