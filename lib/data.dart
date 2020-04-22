import 'dart:collection';
import 'dart:math';

import 'package:cards/metric.dart';
import 'package:flutter/material.dart' hide Card;

part 'data/game.dart';
part 'data/stuff.dart';
part 'data/card.dart';
part 'data/face.dart';
part 'data/util.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************

abstract class GameCallback implements TickerProvider {
  /// 调用 [State.setState].
  void notifyStateChanged();
}

//*********************************************************************************************************************

/// 全局数据.
class Data {
  Data(GameCallback callback) : _game = _Game(callback);

  final _Game _game;

  /// 返回当前 immutable 的游戏数据.
  Game buildGame(BuildContext context) {
    return Game._(_game);
  }
}

//*********************************************************************************************************************

/// 游戏数据.
class Game {
  Game._(this._game);

  final _Game _game;

  /// 返回当前 immutable 的全部卡片数据.
  List<NullableCard> buildNullableCards(BuildContext context) {
    return List.unmodifiable(_game.screen.cards.map<NullableCard>((card) {
      return NullableCard._(card);
    }));
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 卡片.

/// 可能为空或不可见的卡片.
class NullableCard {
  NullableCard._(this._card);

  /// 可能为 null.
  final _Card _card;

  /// True 为可见卡片, false 为不可见卡片.
  bool Function(int zIndex) get zIndexVisible {
    if (_card == null) {
      return (_) => false;
    }
    return _card.zIndexVisible;
  }

  Card buildCard() {
    return Card._(_card);
  }
}

//*********************************************************************************************************************

/// 卡片.
class Card {
  Card._(this._card);

  /// 不可能为 null.
  final _Card _card;

  Rect get rect => _card.rect;

  Matrix4 get transform => _card.transform;

  bool get absorbPointer => _card.absorbPointer;

  bool get ignorePointer => _card.ignorePointer;

  double get opacity => _card.opacity;

  //*******************************************************************************************************************
  // Material.

  double get marginA => _card.marginA;
  double get marginB => _card.marginB;

  Rect get contentRect => _card.contentRect;

  double get elevation => _card.elevation;

  /// 是否强制启用圆角.
  static const bool _enableRadius = true;

  double get radius {
    if (!_enableRadius) {
      return 0.0;
    }
    return _card.radius;
  }

  GestureTapCallback get onTap {
    return _card.onTap == null ? null : () {
      _card.onTap(_card);
    };
  }

  GestureLongPressCallback get onLongPress {
    return _card.onLongPress == null ? null : () {
      _card.onLongPress(_card);
    };
  }

  Object buildFace() {
    _Face face = _card.face;
    if (face is _SplashFullFace) {
      return SplashFullFace._(this, face);
    }
    if (face is _SplashTitleFace) {
      return SplashTitleFace._(this, face);
    }
    if (face is _SpriteFace) {
      return SpriteFace._(this, face);
    }
    return null;
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 卡片内容.

/// 开屏 Cards 标题.
class SplashTitleFace {
  SplashTitleFace._(this._card, this._face);

  final Card _card;

  final _SplashTitleFace _face;

  /// 中心图片大小.
  Size get size {
    return Size(
      Metric.get().gridSize * 30.0,
      Metric.get().gridSize * 8.0,
    );
  }
}

/// 开屏全屏.
class SplashFullFace {
  SplashFullFace._(this._card, this._face);

  final Card _card;

  final _SplashFullFace _face;

  /// 定位矩形.
  Rect get rect {
    return Rect.fromLTWH(
      Metric.get().gridSize * 8.5,
      Metric.get().coreNoPaddingRect.top,
      Metric.get().gridSize * 45.0,
      Metric.get().gridSize * 12.0,
    );
  }
}

/// 精灵.
class SpriteFace {
  SpriteFace._(this._card, this._face);

  final Card _card;

  final _SpriteFace _face;

  /// 数字图片资源.
  static final List<String> _digits = <String>[
    'assets/digit_0.png',
    'assets/digit_1.png',
    'assets/digit_2.png',
    'assets/digit_3.png',
    'assets/digit_4.png',
    'assets/digit_5.png',
    'assets/digit_6.png',
    'assets/digit_7.png',
    'assets/digit_8.png',
    'assets/digit_9.png',
    'assets/digit_slash.png',
    'assets/digit_space.png',
  ];

  /// 数字颜色.
  Color get digitColor => Colors.blueGrey.shade100;

  /// 主体.
  bool get bodyVisible {
    return body != null && body.isNotEmpty;
  }

  String get body => _face.body;

  Rect get bodyRect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 48.0,
      _card.contentRect.width / 56.0 * 48.0,
    );
  }

  /// 武器.
  bool get weaponVisible {
    return weapon != null && weapon.isNotEmpty;
  }

  String get weapon => _face.weapon;
  
  Rect get weaponRect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 0.0,
      _card.contentRect.width / 56.0 * 15.0,
      _card.contentRect.width / 56.0 * 24.0,
      _card.contentRect.width / 56.0 * 24.0,
    );
  }

  /// 武器值 0.
  SpriteFaceDigit get weaponDigit0 {
    if (!weaponVisible || _face.weaponValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _face.weaponValue));
    return SpriteFaceDigit._visible(_card,
      left: 1.0,
      top: 40.0,
      digit: value < 10 ? value : (value ~/ 10),
    );
  }

  SpriteFaceDigit get weaponDigit1 {
    if (!weaponVisible || _face.weaponValue == null || _face.weaponValue < 10) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _face.weaponValue));
    return SpriteFaceDigit._visible(_card,
      left: 5.0,
      top: 40.0,
      digit: value % 10,
    );
  }

  /// 盾牌.
  bool get shieldVisible {
    return shield != null && shield.isNotEmpty;
  }

  String get shield => _face.shield;

  Rect get shieldRect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 22.0,
      _card.contentRect.width / 56.0 * 17.0,
      _card.contentRect.width / 56.0 * 24.0,
      _card.contentRect.width / 56.0 * 24.0,
    );
  }

  /// 盾牌值 0.
  bool get shieldDigit0Visible {
    return shieldVisible && _face.shieldValue != null && _face.shieldValue >= 10;
  }

  String get shieldDigit0 {
    int value = max(0, min(99, _face.shieldValue));
    return _digits[value ~/ 10];
  }

  Rect get shieldDigit0Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 47.0,
      _card.contentRect.width / 56.0 * 29.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 盾牌值 1.
  bool get shieldDigit1Visible {
    return shieldVisible && _face.shieldValue != null;
  }

  String get shieldDigit1 {
    int value = max(0, min(99, _face.shieldValue));
    return _digits[value % 10];
  }

  Rect get shieldDigit1Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 51.0,
      _card.contentRect.width / 56.0 * 29.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 生命.
  bool get healthVisible {
    return _face.healthValue != null;
  }

  String get health {
    return 'assets/health.png';
  }

  Rect get healthRect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 47.0,
      _card.contentRect.width / 56.0 * 9.0,
      _card.contentRect.width / 56.0 * 9.0,
      _card.contentRect.width / 56.0 * 9.0,
    );
  }

  /// 生命值 0.
  Rect get healthDigit0Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 35.0,
      _card.contentRect.width / 56.0 * 2.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 生命值 1.
  Rect get healthDigit1Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 39.0,
      _card.contentRect.width / 56.0 * 2.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 生命值 2.
  Rect get healthDigit2Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 43.0,
      _card.contentRect.width / 56.0 * 2.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 生命值 3.
  Rect get healthDigit3Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 47.0,
      _card.contentRect.width / 56.0 * 2.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 生命值 4.
  Rect get healthDigit4Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 51.0,
      _card.contentRect.width / 56.0 * 2.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 效果.
  Rect get effectRect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 47.0,
      _card.contentRect.width / 56.0 * 46.0,
      _card.contentRect.width / 56.0 * 9.0,
      _card.contentRect.width / 56.0 * 9.0,
    );
  }

  /// 效果值 0.
  Rect get effectDigit0Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 38.0,
      _card.contentRect.width / 56.0 * 48.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 效果值 1.
  Rect get effectDigit1Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 42.0,
      _card.contentRect.width / 56.0 * 48.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 数量值 0.
  Rect get amountDigit0Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 1.0,
      _card.contentRect.width / 56.0 * 48.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 数量值 1.
  Rect get amountDigit1Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 5.0,
      _card.contentRect.width / 56.0 * 48.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 能力.
  Rect get powerRect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 0.0,
      _card.contentRect.width / 56.0 * 1.0,
      _card.contentRect.width / 56.0 * 9.0,
      _card.contentRect.width / 56.0 * 9.0,
    );
  }

  /// 能力值 0.
  Rect get powerDigit0Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 10.0,
      _card.contentRect.width / 56.0 * 2.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 能力值 1.
  Rect get powerDigit1Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 14.0,
      _card.contentRect.width / 56.0 * 2.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 精灵数字.
class SpriteFaceDigit {
  /// 数字图片资源.
  static final List<String> _digits = <String>[
    'assets/digit_0.png',
    'assets/digit_1.png',
    'assets/digit_2.png',
    'assets/digit_3.png',
    'assets/digit_4.png',
    'assets/digit_5.png',
    'assets/digit_6.png',
    'assets/digit_7.png',
    'assets/digit_8.png',
    'assets/digit_9.png',
    'assets/digit_slash.png',
  ];

  /// 不可见的.
  SpriteFaceDigit._invisible() :
        visible = false,
        rect = null,
        asset = null,
        color = null;

  /// 可见的.
  ///
  /// [left] [top] 用于定位.
  ///
  /// [digit] 在 [digits] 中的 index.
  ///
  /// [color] 传 null 使用默认值.
  SpriteFaceDigit._visible(Card card, {
    @required
    double left,
    @required
    double top,
    @required
    int digit,
    Color color,
  }) : visible = true,
        rect = Rect.fromLTWH(
          card.contentRect.width / 56.0 * left,
          card.contentRect.width / 56.0 * top,
          card.contentRect.width / 56.0 * 4.0,
          card.contentRect.width / 56.0 * 6.0,
        ),
        asset = _digits[digit],
        color = color == null ? Colors.blueGrey.shade100 : color;

  final bool visible;
  final Rect rect;
  final String asset;
  final Color color;
}
