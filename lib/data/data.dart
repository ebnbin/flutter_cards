part of '../data.dart';

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
    // 更新网格标尺.
    _Metric.build(context);
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
      return 'images/purpur_block.png';
    }
    return 'images/stone_bricks.png';
  }

  double get backgroundScale {
    return _Metric.get().imageScale(144, 8.0);
  }

  /// 返回当前 immutable 的全部卡片数据.
  List<NullableCard> buildNullableCards(BuildContext context) {
    return List.unmodifiable(_game.screen.cards.map<NullableCard>((card) {
      return NullableCard._(card);
    }));
  }

  CustomPainter get debugPainter {
    return _Metric.get().debugPainter;
  }

  CustomPainter get debugForegroundPainter {
    return _Metric.get().debugForegroundPainter;
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

  String get background {
    return 'images/white_wool.png';
  }

  double get backgroundScale {
    return _Metric.get().imageScale(288, 16.0);
  }

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

  double get borderWidth => _card.borderWidth;

  Color get borderColor {
    if (_card is _SpriteCard) {
      _SpriteCard spriteCard = _card;
      if (spriteCard.sprite is _PlayerSprite) {
        return Colors.cyanAccent.withOpacity(0.5);
      }
    }
    return Colors.transparent;
  }

  Color get shadowColor {
    if (_card is _SpriteCard) {
      _SpriteCard spriteCard = _card;
      if (spriteCard.sprite is _PlayerSprite) {
        return Colors.cyanAccent;
      }
      if (spriteCard.spriteScreen.playerCard.adjacentDirection(spriteCard) != null) {
        return Colors.cyanAccent;
      }
    }
    return Colors.black;
  }

  Rect get contentRect => _card.contentRect;

  double get elevation => _card.elevation;

  /// 是否强制禁用圆角.
  static const bool _disableRadius = false;

  double get radius {
    if (_disableRadius) {
      return 0.0;
    }
    return _card.radius;
  }

  GestureTapCallback get onTap {
    switch (_card.dimension) {
      case _CardDimension.main:
        return _card.mainOnTap == null ? null : () {
          _card.mainOnTap(_card);
        };
      case _CardDimension.detail:
        return _card.detailOnTap == null ? null : () {
          _card.detailOnTap(_card);
        };
      case _CardDimension.full:
        return null;
      default:
        throw Exception();
    }
  }

  GestureLongPressCallback get onLongPress {
    switch (_card.dimension) {
      case _CardDimension.main:
        return _card.mainOnLongPress == null ? null : () {
          _card.mainOnLongPress(_card);
        };
      case _CardDimension.detail:
        return _card.detailOnLongPress == null ? null : () {
          _card.detailOnLongPress(_card);
        };
      case _CardDimension.full:
        return null;
      default:
        throw Exception();
    }
  }

  Object buildFace() {
    /// 卡片翻转到背面时不显示内容.
    if (_card.backFace()) {
      return null;
    }
    /// TODO 全屏尺寸时内容属于全局.
    if (_card.dimension == _CardDimension.full) {
      if (_card.game.full == null) {
        return null;
      } else {
        return TextFace._(this,
          text: _card.game.full,
        );
      }
    }
    if (_card is _SpriteCard) {
      _SpriteCard spriteCard = _card;
      return SpriteFace._(this, spriteCard.sprite);
    }
    if (_card.name != null) {
      return TextFace._(this,
        text: _card.name,
      );
    }
    return null;
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 卡片内容.

/// 文字.
class TextFace {
  TextFace._(this._card, {
    this.text,
  });

  final Card _card;

  final String text;
}

/// 精灵.
class SpriteFace {
  SpriteFace._(this._card, this._sprite);

  final Card _card;

  final _Sprite _sprite;

  /// 主体.
  SpriteFaceImage get body {
    if (_sprite.body == null || _sprite.body.isEmpty) {
      return SpriteFaceImage._invisible();
    }
    return SpriteFaceImage._visible(_card,
      left: 4.0,
      top: 4.0,
      width: 48.0,
      height: 48.0,
      image: _sprite.body,
    );
  }

  /// 武器.
  SpriteFaceImage get weapon {
    if (_sprite.weapon == null || _sprite.weapon.isEmpty) {
      return SpriteFaceImage._invisible();
    }
    return SpriteFaceImage._visible(_card,
      left: 3.0,
      top: 18.0,
      width: 20.0,
      height: 20.0,
      image: _sprite.weapon,
    );
  }

  /// 武器值 0.
  SpriteFaceDigit get weaponDigit0 {
    if (_sprite.weapon == null || _sprite.weapon.isEmpty || _sprite.weaponValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _sprite.weaponValue));
    return SpriteFaceDigit._visible(_card,
      left: 3.0,
      top: 38.0,
      digit: value < 10 ? value : (value ~/ 10),
    );
  }

  /// 武器值 1.
  SpriteFaceDigit get weaponDigit1 {
    if (_sprite.weapon == null || _sprite.weapon.isEmpty || _sprite.weaponValue == null || _sprite.weaponValue < 10) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _sprite.weaponValue));
    return SpriteFaceDigit._visible(_card,
      left: 8.0,
      top: 38.0,
      digit: value % 10,
    );
  }

  /// 盾牌.
  SpriteFaceImage get shield {
    if (_sprite.shield == null || _sprite.shield.isEmpty) {
      return SpriteFaceImage._invisible();
    }
    return SpriteFaceImage._visible(_card,
      left: 25.0,
      top: 22.0,
      width: 20.0,
      height: 20.0,
      image: _sprite.shield,
    );
  }

  /// 盾牌值 0.
  SpriteFaceDigit get shieldDigit0 {
    if (_sprite.shield == null || _sprite.shield.isEmpty || _sprite.shieldValue == null || _sprite.shieldValue < 10) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _sprite.shieldValue));
    return SpriteFaceDigit._visible(_card,
      left: 45.0,
      top: 28.0,
      digit: value ~/ 10,
    );
  }

  /// 盾牌值 1.
  SpriteFaceDigit get shieldDigit1 {
    if (_sprite.shield == null || _sprite.shield.isEmpty || _sprite.shieldValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _sprite.shieldValue));
    return SpriteFaceDigit._visible(_card,
      left: 50.0,
      top: 28.0,
      digit: value % 10,
    );
  }

  /// 生命.
  SpriteFaceImage get health {
    if (_sprite.healthValue == null) {
      return SpriteFaceImage._invisible();
    }
    return SpriteFaceImage._visible(_card,
      left: 46.0,
      top: 8.0,
      width: 9.0,
      height: 9.0,
      image: 'images/health.png',
    );
  }

  /// 生命值 0.
  SpriteFaceDigit get healthDigit0 {
    if (_sprite.healthValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int digitCount = 0;
    int healthValue = max(0, min(99, _sprite.healthValue));
    int maxHealthValue;
    if (_sprite.maxHealthValue != null) {
      maxHealthValue = max(0, min(99, _sprite.maxHealthValue));
      healthValue = min(maxHealthValue, healthValue);
      digitCount += (maxHealthValue < 10 ? 2 : 3);
    }
    digitCount += (healthValue < 10 ? 1 : 2);
    if (digitCount < 5) {
      return SpriteFaceDigit._invisible();
    }
    return SpriteFaceDigit._visible(_card,
      left: 30.0,
      top: 1.0,
      digit: healthValue ~/ 10,
    );
  }

  /// 生命值 1.
  SpriteFaceDigit get healthDigit1 {
    if (_sprite.healthValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int digitCount = 0;
    int healthValue = max(0, min(99, _sprite.healthValue));
    int maxHealthValue;
    if (_sprite.maxHealthValue != null) {
      maxHealthValue = max(0, min(99, _sprite.maxHealthValue));
      healthValue = min(maxHealthValue, healthValue);
      digitCount += (maxHealthValue < 10 ? 2 : 3);
    }
    digitCount += (healthValue < 10 ? 1 : 2);
    if (digitCount < 4) {
      return SpriteFaceDigit._invisible();
    }
    return SpriteFaceDigit._visible(_card,
      left: 35.0,
      top: 1.0,
      digit: healthValue % 10,
    );
  }

  /// 生命值 2.
  SpriteFaceDigit get healthDigit2 {
    if (_sprite.healthValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int digitCount = 0;
    int healthValue = max(0, min(99, _sprite.healthValue));
    int maxHealthValue;
    if (_sprite.maxHealthValue != null) {
      maxHealthValue = max(0, min(99, _sprite.maxHealthValue));
      healthValue = min(maxHealthValue, healthValue);
      digitCount += (maxHealthValue < 10 ? 2 : 3);
    }
    digitCount += (healthValue < 10 ? 1 : 2);
    if (digitCount < 3) {
      return SpriteFaceDigit._invisible();
    }
    return SpriteFaceDigit._visible(_card,
      left: 40.0,
      top: 1.0,
      digit: maxHealthValue < 10 ? healthValue : 10,
    );
  }

  /// 生命值 3.
  SpriteFaceDigit get healthDigit3 {
    if (_sprite.healthValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int digitCount = 0;
    int healthValue = max(0, min(99, _sprite.healthValue));
    int maxHealthValue;
    if (_sprite.maxHealthValue != null) {
      maxHealthValue = max(0, min(99, _sprite.maxHealthValue));
      healthValue = min(maxHealthValue, healthValue);
      digitCount += (maxHealthValue < 10 ? 2 : 3);
    }
    digitCount += (healthValue < 10 ? 1 : 2);
    if (digitCount < 2) {
      return SpriteFaceDigit._invisible();
    }
    return SpriteFaceDigit._visible(_card,
      left: 45.0,
      top: 1.0,
      digit: maxHealthValue == null ? healthValue ~/ 10 : maxHealthValue < 10 ? 10 : maxHealthValue ~/ 10,
    );
  }

  /// 生命值 4.
  SpriteFaceDigit get healthDigit4 {
    if (_sprite.healthValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int digitCount = 0;
    int healthValue = max(0, min(99, _sprite.healthValue));
    int maxHealthValue;
    if (_sprite.maxHealthValue != null) {
      maxHealthValue = max(0, min(99, _sprite.maxHealthValue));
      healthValue = min(maxHealthValue, healthValue);
      digitCount += (maxHealthValue < 10 ? 2 : 3);
    }
    digitCount += (healthValue < 10 ? 1 : 2);
    return SpriteFaceDigit._visible(_card,
      left: 50.0,
      top: 1.0,
      digit: maxHealthValue == null ? healthValue % 10 : maxHealthValue < 10 ? maxHealthValue : maxHealthValue % 10,
    );
  }

  /// 效果.
  SpriteFaceImage get effect {
    if (_sprite.effect == null || _sprite.effect.isEmpty) {
      return SpriteFaceImage._invisible();
    }
    return SpriteFaceImage._visible(_card,
      left: 46.0,
      top: 46.0,
      width: 9.0,
      height: 9.0,
      image: _sprite.effect,
    );
  }

  /// 效果值 0.
  SpriteFaceDigit get effectDigit0 {
    if (_sprite.effect == null || _sprite.effect.isEmpty || _sprite.effectValue == null || _sprite.effectValue < 10) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _sprite.effectValue));
    return SpriteFaceDigit._visible(_card,
      left: 36.0,
      top: 48.0,
      digit: value ~/ 10,
    );
  }

  /// 效果值 1.
  SpriteFaceDigit get effectDigit1 {
    if (_sprite.effect == null || _sprite.effect.isEmpty || _sprite.effectValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _sprite.effectValue));
    return SpriteFaceDigit._visible(_card,
      left: 41.0,
      top: 48.0,
      digit: value % 10,
    );
  }

  /// 数量值 0.
  SpriteFaceDigit get amountDigit0 {
    if (_sprite.amount == null) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _sprite.amount));
    return SpriteFaceDigit._visible(_card,
      left: 1.0,
      top: 48.0,
      digit: value < 10 ? value : (value ~/ 10),
    );
  }

  /// 数量值 1.
  SpriteFaceDigit get amountDigit1 {
    if (_sprite.amount == null || _sprite.amount < 10) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _sprite.amount));
    return SpriteFaceDigit._visible(_card,
      left: 6.0,
      top: 48.0,
      digit: value % 10,
    );
  }

  /// 能力.
  SpriteFaceImage get power {
    if (_sprite.power == null || _sprite.power.isEmpty) {
      return SpriteFaceImage._invisible();
    }
    return SpriteFaceImage._visible(_card,
      left: 1.0,
      top: 1.0,
      width: 9.0,
      height: 9.0,
      image: _sprite.power,
    );
  }

  /// 能力值 0.
  SpriteFaceDigit get powerDigit0 {
    if (_sprite.power == null || _sprite.power.isEmpty || _sprite.powerValue == null) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _sprite.powerValue));
    return SpriteFaceDigit._visible(_card,
      left: 10.0,
      top: 1.0,
      digit: value < 10 ? value : (value ~/ 10),
    );
  }

  /// 能力值 1.
  SpriteFaceDigit get powerDigit1 {
    if (_sprite.power == null || _sprite.power.isEmpty || _sprite.powerValue == null || _sprite.powerValue < 10) {
      return SpriteFaceDigit._invisible();
    }
    int value = max(0, min(99, _sprite.powerValue));
    return SpriteFaceDigit._visible(_card,
      left: 15.0,
      top: 1.0,
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
    'images/digit_0.png',
    'images/digit_1.png',
    'images/digit_2.png',
    'images/digit_3.png',
    'images/digit_4.png',
    'images/digit_5.png',
    'images/digit_6.png',
    'images/digit_7.png',
    'images/digit_8.png',
    'images/digit_9.png',
    'images/digit_slash.png',
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
          card.contentRect.width / 56.0 * 5.0,
          card.contentRect.width / 56.0 * 7.0,
        ),
        image = _digits[digit],
        color = color == null ? Colors.blueGrey.shade100 : color;

  final bool visible;
  final Rect rect;
  final String image;
  final Color color;
}
