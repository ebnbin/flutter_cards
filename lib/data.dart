import 'dart:collection';
import 'dart:math';

import 'package:cards/metric.dart';
import 'package:flutter/material.dart' hide Card;

part 'data/game.dart';
part 'data/box.dart';
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
  List<Card> buildCards(BuildContext context) {
    return List.unmodifiable(_game.screen.cards.map<Card>((card) {
      return Card._(card);
    }));
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 卡片.

/// 卡片.
class Card {
  Card._(this._card);

  /// 可能为 null.
  final _Card _card;

  /// True 为可见卡片, false 为不可见卡片.
  bool Function(int zIndex) get zIndexVisible {
    if (_card == null) {
      return (_) => false;
    }
    return _card.zIndexVisible;
  }

  VisibleCard buildVisibleCard() {
    return VisibleCard._(_card);
  }
}

/// 可见的卡片.
class VisibleCard {
  VisibleCard._(this._card);

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

  /// 是否启用圆角.
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

  bool get isSpriteCard {
    return _card is _SpriteCard;
  }

  SpriteCard buildSpriteCard() {
    return SpriteCard._(this, _card as _SpriteCard);
  }

  Object buildFace() {
    _Face face = _card.face;
    if (face is _EmptyFace) {
      return EmptyFace._(this, face);
    }
    if (face is _SplashTitleFace) {
      return SplashTitleFace._(this, face);
    }
    throw Exception();
  }
}

/// 精灵卡片.
class SpriteCard {
  SpriteCard._(this.visibleCard, this._spriteCard);

  final VisibleCard visibleCard;

  final _SpriteCard _spriteCard;

  /// 数字颜色.
  Color get digitColor => Colors.yellow;

  /// 主体.
  Rect get bodyRect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 48.0,
      visibleCard.contentRect.width / 56.0 * 48.0,
    );
  }

  /// 数量数字 0.
  Rect get amountDigit0Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 1.0,
      visibleCard.contentRect.width / 56.0 * 48.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 数量数字 1.
  Rect get amountDigit1Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 5.0,
      visibleCard.contentRect.width / 56.0 * 48.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 生命值.
  Rect get healthRect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 47.0,
      visibleCard.contentRect.width / 56.0 * 9.0,
      visibleCard.contentRect.width / 56.0 * 9.0,
      visibleCard.contentRect.width / 56.0 * 9.0,
    );
  }

  /// 生命值数字 0.
  Rect get healthDigit0Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 35.0,
      visibleCard.contentRect.width / 56.0 * 2.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 生命值数字 1.
  Rect get healthDigit1Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 39.0,
      visibleCard.contentRect.width / 56.0 * 2.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 生命值数字 2.
  Rect get healthDigit2Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 43.0,
      visibleCard.contentRect.width / 56.0 * 2.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 生命值数字 3.
  Rect get healthDigit3Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 47.0,
      visibleCard.contentRect.width / 56.0 * 2.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 生命值数字 4.
  Rect get healthDigit4Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 51.0,
      visibleCard.contentRect.width / 56.0 * 2.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 武器.
  Rect get weaponRect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 0.0,
      visibleCard.contentRect.width / 56.0 * 15.0,
      visibleCard.contentRect.width / 56.0 * 24.0,
      visibleCard.contentRect.width / 56.0 * 24.0,
    );
  }

  /// 武器数字 0.
  Rect get weaponDigit0Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 1.0,
      visibleCard.contentRect.width / 56.0 * 40.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 武器数字 1.
  Rect get weaponDigit1Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 5.0,
      visibleCard.contentRect.width / 56.0 * 40.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 盾牌.
  Rect get shieldRect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 22.0,
      visibleCard.contentRect.width / 56.0 * 17.0,
      visibleCard.contentRect.width / 56.0 * 24.0,
      visibleCard.contentRect.width / 56.0 * 24.0,
    );
  }

  /// 盾牌数字 0.
  Rect get shieldDigit0Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 47.0,
      visibleCard.contentRect.width / 56.0 * 29.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 盾牌数字 1.
  Rect get shieldDigit1Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 51.0,
      visibleCard.contentRect.width / 56.0 * 29.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 效果.
  Rect get effectRect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 47.0,
      visibleCard.contentRect.width / 56.0 * 46.0,
      visibleCard.contentRect.width / 56.0 * 9.0,
      visibleCard.contentRect.width / 56.0 * 9.0,
    );
  }

  /// 效果数字 0.
  Rect get effectDigit0Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 38.0,
      visibleCard.contentRect.width / 56.0 * 48.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 效果数字 1.
  Rect get effectDigit1Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 42.0,
      visibleCard.contentRect.width / 56.0 * 48.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 能力.
  Rect get powerRect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 0.0,
      visibleCard.contentRect.width / 56.0 * 1.0,
      visibleCard.contentRect.width / 56.0 * 9.0,
      visibleCard.contentRect.width / 56.0 * 9.0,
    );
  }

  /// 能力数字 0.
  Rect get powerDigit0Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 10.0,
      visibleCard.contentRect.width / 56.0 * 2.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 能力数字 1.
  Rect get powerDigit1Rect {
    return Rect.fromLTWH(
      visibleCard.contentRect.width / 56.0 * 14.0,
      visibleCard.contentRect.width / 56.0 * 2.0,
      visibleCard.contentRect.width / 56.0 * 4.0,
      visibleCard.contentRect.width / 56.0 * 6.0,
    );
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 卡片内容.

/// 空.
class EmptyFace {
  EmptyFace._(this._visibleCard, this._face);

  final VisibleCard _visibleCard;

  final _EmptyFace _face;
}

/// 开屏 Cards 标题.
class SplashTitleFace {
  SplashTitleFace._(this._visibleCard, this._face);

  final VisibleCard _visibleCard;
  
  final _SplashTitleFace _face;

  /// 中心图片大小.
  Size get size {
    return Size(
      _visibleCard.rect.width / 45.0 * 30.0,
      _visibleCard.rect.width / 45.0 * 8.0,
    );
  }
}
