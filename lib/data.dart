import 'dart:collection';
import 'dart:math';

import 'package:cards/metric.dart';
import 'package:flutter/material.dart' hide Card;

part 'data/game.dart';
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

  String get background {
    if (_game.screen is _SpriteScreen) {
      return 'assets/purpur_block.png';
    }
    return 'assets/stone_bricks.png';
  }

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

  /// 在 [Stack] 的 [zIndex] 上是否可见. True 为可见卡片, false 为不可见卡片.
  ///
  /// [zIndex] 范围 0 ~ 3.
  bool Function(int zIndex) get zIndexVisible {
    if (_card == null) {
      return (_) => false;
    }
    return (zIndex) {
      assert(zIndex >= 0 && zIndex <= 3);
      return max(0, min(3, _card.zIndex)) == zIndex && _card.visible;
    };
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

  /// 变换矩阵.
  Matrix4 get transform {
    // 数值越大, 3d 旋转镜头越近, 效果越明显, 但越容易绘制异常.
    double matrix4Entry32 = 0.2 / _card.rect.longSize();
    return Matrix4.identity()..setEntry(3, 2, matrix4Entry32)
      ..rotateX(_card.rotateX)
      ..rotateY(_card.rotateY)
      ..rotateZ(_card.rotateZ)
      ..leftTranslate(_card.translateX, _card.translateY)
      ..scale(_card.scaleX, _card.scaleY);
  }

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

  /// 主体.
  SpriteFaceImage get body {
    if (_face.body == null || _face.body.isEmpty) {
      return SpriteFaceImage._invisible();
    }
    return SpriteFaceImage._visible(_card,
      left: 4.0,
      top: 4.0,
      width: 48.0,
      height: 48.0,
      image: _face.body,
    );
  }

  /// 武器.
  SpriteFaceImage get weapon {
    if (_face.weapon == null || _face.weapon.isEmpty) {
      return SpriteFaceImage._invisible();
    }
    return SpriteFaceImage._visible(_card,
      left: 0.0,
      top: 15.0,
      width: 24.0,
      height: 24.0,
      image: _face.weapon,
    );
  }

  /// 武器值 0.
  SpriteFaceDigit get weaponDigit0 {
    if (_face.weapon == null || _face.weapon.isEmpty || _face.weaponValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _face.weaponValue));
    return SpriteFaceDigit._visible(_card,
      left: 1.0,
      top: 40.0,
      digit: value < 10 ? value : (value ~/ 10),
    );
  }

  /// 武器值 1.
  SpriteFaceDigit get weaponDigit1 {
    if (_face.weapon == null || _face.weapon.isEmpty || _face.weaponValue == null || _face.weaponValue < 10) {
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
  SpriteFaceImage get shield {
    if (_face.shield == null || _face.shield.isEmpty) {
      return SpriteFaceImage._invisible();
    }
    return SpriteFaceImage._visible(_card,
      left: 22.0,
      top: 17.0,
      width: 24.0,
      height: 24.0,
      image: _face.shield,
    );
  }

  /// 盾牌值 0.
  SpriteFaceDigit get shieldDigit0 {
    if (_face.shield == null || _face.shield.isEmpty || _face.shieldValue == null || _face.shieldValue < 10) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _face.shieldValue));
    return SpriteFaceDigit._visible(_card,
      left: 47.0,
      top: 29.0,
      digit: value ~/ 10,
    );
  }

  /// 盾牌值 1.
  SpriteFaceDigit get shieldDigit1 {
    if (_face.shield == null || _face.shield.isEmpty || _face.shieldValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _face.shieldValue));
    return SpriteFaceDigit._visible(_card,
      left: 51.0,
      top: 29.0,
      digit: value % 10,
    );
  }

  /// 生命.
  SpriteFaceImage get health {
    if (_face.healthValue == null) {
      return SpriteFaceImage._invisible();
    }
    return SpriteFaceImage._visible(_card,
      left: 47.0,
      top: 9.0,
      width: 9.0,
      height: 9.0,
      image: 'assets/health.png',
    );
  }

  /// 生命值 0.
  SpriteFaceDigit get healthDigit0 {
    if (_face.healthValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int digitCount = 0;
    int healthValue = max(0, min(99, _face.healthValue));
    int maxHealthValue;
    if (_face.maxHealthValue != null) {
      maxHealthValue = max(0, min(99, _face.maxHealthValue));
      healthValue = min(maxHealthValue, healthValue);
      digitCount += (maxHealthValue < 10 ? 2 : 3);
    }
    digitCount += (healthValue < 10 ? 1 : 2);
    if (digitCount < 5) {
      return SpriteFaceDigit._invisible();
    }
    return SpriteFaceDigit._visible(_card,
      left: 35.0,
      top: 2.0,
      digit: healthValue ~/ 10,
    );
  }

  /// 生命值 1.
  SpriteFaceDigit get healthDigit1 {
    if (_face.healthValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int digitCount = 0;
    int healthValue = max(0, min(99, _face.healthValue));
    int maxHealthValue;
    if (_face.maxHealthValue != null) {
      maxHealthValue = max(0, min(99, _face.maxHealthValue));
      healthValue = min(maxHealthValue, healthValue);
      digitCount += (maxHealthValue < 10 ? 2 : 3);
    }
    digitCount += (healthValue < 10 ? 1 : 2);
    if (digitCount < 4) {
      return SpriteFaceDigit._invisible();
    }
    return SpriteFaceDigit._visible(_card,
      left: 39.0,
      top: 2.0,
      digit: healthValue % 10,
    );
  }

  /// 生命值 2.
  SpriteFaceDigit get healthDigit2 {
    if (_face.healthValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int digitCount = 0;
    int healthValue = max(0, min(99, _face.healthValue));
    int maxHealthValue;
    if (_face.maxHealthValue != null) {
      maxHealthValue = max(0, min(99, _face.maxHealthValue));
      healthValue = min(maxHealthValue, healthValue);
      digitCount += (maxHealthValue < 10 ? 2 : 3);
    }
    digitCount += (healthValue < 10 ? 1 : 2);
    if (digitCount < 3) {
      return SpriteFaceDigit._invisible();
    }
    return SpriteFaceDigit._visible(_card,
      left: 43.0,
      top: 2.0,
      digit: maxHealthValue < 10 ? healthValue : 10,
    );
  }

  /// 生命值 3.
  SpriteFaceDigit get healthDigit3 {
    if (_face.healthValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int digitCount = 0;
    int healthValue = max(0, min(99, _face.healthValue));
    int maxHealthValue;
    if (_face.maxHealthValue != null) {
      maxHealthValue = max(0, min(99, _face.maxHealthValue));
      healthValue = min(maxHealthValue, healthValue);
      digitCount += (maxHealthValue < 10 ? 2 : 3);
    }
    digitCount += (healthValue < 10 ? 1 : 2);
    if (digitCount < 2) {
      return SpriteFaceDigit._invisible();
    }
    return SpriteFaceDigit._visible(_card,
      left: 47.0,
      top: 2.0,
      digit: maxHealthValue == null ? healthValue ~/ 10 : maxHealthValue < 10 ? 10 : maxHealthValue ~/ 10,
    );
  }

  /// 生命值 4.
  SpriteFaceDigit get healthDigit4 {
    if (_face.healthValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int digitCount = 0;
    int healthValue = max(0, min(99, _face.healthValue));
    int maxHealthValue;
    if (_face.maxHealthValue != null) {
      maxHealthValue = max(0, min(99, _face.maxHealthValue));
      healthValue = min(maxHealthValue, healthValue);
      digitCount += (maxHealthValue < 10 ? 2 : 3);
    }
    digitCount += (healthValue < 10 ? 1 : 2);
    return SpriteFaceDigit._visible(_card,
      left: 51.0,
      top: 2.0,
      digit: maxHealthValue == null ? healthValue % 10 : maxHealthValue < 10 ? maxHealthValue : maxHealthValue % 10,
    );
  }

  /// 效果.
  SpriteFaceImage get effect {
    if (_face.effect == null || _face.effect.isEmpty) {
      return SpriteFaceImage._invisible();
    }
    return SpriteFaceImage._visible(_card,
      left: 47.0,
      top: 46.0,
      width: 9.0,
      height: 9.0,
      image: _face.effect,
    );
  }

  /// 效果值 0.
  SpriteFaceDigit get effectDigit0 {
    if (_face.effect == null || _face.effect.isEmpty || _face.effectValue == null || _face.effectValue < 10) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _face.effectValue));
    return SpriteFaceDigit._visible(_card,
      left: 38.0,
      top: 48.0,
      digit: value ~/ 10,
    );
  }

  /// 效果值 1.
  SpriteFaceDigit get effectDigit1 {
    if (_face.effect == null || _face.effect.isEmpty || _face.effectValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _face.effectValue));
    return SpriteFaceDigit._visible(_card,
      left: 42.0,
      top: 48.0,
      digit: value % 10,
    );
  }

  /// 数量值 0.
  SpriteFaceDigit get amountDigit0 {
    if (_face.amount == null) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _face.amount));
    return SpriteFaceDigit._visible(_card,
      left: 1.0,
      top: 48.0,
      digit: value < 10 ? value : (value ~/ 10),
    );
  }

  /// 数量值 1.
  SpriteFaceDigit get amountDigit1 {
    if (_face.amount == null || _face.amount < 10) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _face.amount));
    return SpriteFaceDigit._visible(_card,
      left: 5.0,
      top: 48.0,
      digit: value % 10,
    );
  }

  /// 能力.
  SpriteFaceImage get power {
    if (_face.power == null || _face.power.isEmpty) {
      return SpriteFaceImage._invisible();
    }
    return SpriteFaceImage._visible(_card,
      left: 0.0,
      top: 1.0,
      width: 9.0,
      height: 9.0,
      image: _face.power,
    );
  }

  /// 能力值 0.
  SpriteFaceDigit get powerDigit0 {
    if (_face.power == null || _face.power.isEmpty || _face.powerValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _face.powerValue));
    return SpriteFaceDigit._visible(_card,
      left: 10.0,
      top: 2.0,
      digit: value < 10 ? value : (value ~/ 10),
    );
  }

  /// 能力值 1.
  SpriteFaceDigit get powerDigit1 {
    if (_face.power == null || _face.power.isEmpty || _face.powerValue == null || _face.powerValue < 10) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _face.powerValue));
    return SpriteFaceDigit._visible(_card,
      left: 14.0,
      top: 2.0,
      digit: value % 10,
    );
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 精灵图片.
class SpriteFaceImage {
  SpriteFaceImage._invisible() :
        visible = false,
        rect = null,
        image = null;

  SpriteFaceImage._visible(Card card, {
    @required
    double left,
    @required
    double top,
    @required
    double width,
    @required
    double height,
    @required
    this.image,
  }) : visible = true,
        rect = Rect.fromLTWH(
          card.contentRect.width / 56.0 * left,
          card.contentRect.width / 56.0 * top,
          card.contentRect.width / 56.0 * width,
          card.contentRect.width / 56.0 * height,
        );
  
  final bool visible;
  final Rect rect;
  final String image;
}

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
        image = null,
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
        image = _digits[digit],
        color = color == null ? Colors.blueGrey.shade100 : color;

  final bool visible;
  final Rect rect;
  final String image;
  final Color color;
}
