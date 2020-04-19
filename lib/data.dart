import 'dart:collection';
import 'dart:math';

import 'package:cards/metric.dart';
import 'package:flutter/material.dart' hide Card;

part 'data/game.dart';
part 'data/card.dart';
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

  bool get isGridCard {
    return _card is _GridCard;
  }

  GridCard buildGridCard() {
    return GridCard._(this, _card as _GridCard);
  }
}

/// 根据网格定位的卡片, 渲染为 Material 卡片.
class GridCard {
  GridCard._(this.visibleCard, this._gridCard);

  final VisibleCard visibleCard;

  final _GridCard _gridCard;

  double get marginA => _gridCard.marginA;
  double get marginB => _gridCard.marginB;

  double get elevation => _gridCard.elevation;

  /// 是否启用圆角.
  static const bool _enableRadius = true;

  double get radius {
    if (!_enableRadius) {
      return 0.0;
    }
    return _gridCard.radius;
  }

  GestureTapCallback get onTap {
    return _gridCard.onTap == null ? null : () {
      _gridCard.onTap(_gridCard);
    };
  }

  GestureLongPressCallback get onLongPress {
    return _gridCard.onLongPress == null ? null : () {
      _gridCard.onLongPress(_gridCard);
    };
  }

  bool get isSplashTitleCard {
    return _gridCard is _SplashTitleCard;
  }

  SplashTitleCard buildSplashTitleCard() {
    return SplashTitleCard._(this);
  }

  bool get isSpriteCard {
    return _gridCard is _SpriteCard;
  }

  SpriteCard buildSpriteCard() {
    return SpriteCard._(this, _gridCard as _SpriteCard);
  }
}

/// 开屏 Cards 标题.
class SplashTitleCard {
  SplashTitleCard._(this.gridCard);

  final GridCard gridCard;

  /// 定位矩形.
  Rect get rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 45.0 * 7,
      gridCard.visibleCard.rect.width / 45.0 * 3,
      gridCard.visibleCard.rect.width / 45.0 * 30.0,
      gridCard.visibleCard.rect.width / 45.0 * 8.0,
    );
  }
}

/// 精灵卡片.
class SpriteCard {
  SpriteCard._(this.gridCard, this._spriteCard);

  final GridCard gridCard;

  final _SpriteCard _spriteCard;

  /// 数字颜色.
  Color get digitColor => Colors.yellow;

  /// 主体.
  Rect get bodyRect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 48.0,
      gridCard.visibleCard.rect.width / 60.0 * 48.0,
    );
  }

  /// 数量数字 0.
  Rect get amountDigit0Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 1.0,
      gridCard.visibleCard.rect.width / 60.0 * 48.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }

  /// 数量数字 1.
  Rect get amountDigit1Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 5.0,
      gridCard.visibleCard.rect.width / 60.0 * 48.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }

  /// 生命值.
  Rect get healthRect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 47.0,
      gridCard.visibleCard.rect.width / 60.0 * 9.0,
      gridCard.visibleCard.rect.width / 60.0 * 9.0,
      gridCard.visibleCard.rect.width / 60.0 * 9.0,
    );
  }

  /// 生命值数字 0.
  Rect get healthDigit0Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 35.0,
      gridCard.visibleCard.rect.width / 60.0 * 2.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }

  /// 生命值数字 1.
  Rect get healthDigit1Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 39.0,
      gridCard.visibleCard.rect.width / 60.0 * 2.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }

  /// 生命值数字 2.
  Rect get healthDigit2Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 43.0,
      gridCard.visibleCard.rect.width / 60.0 * 2.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }

  /// 生命值数字 3.
  Rect get healthDigit3Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 47.0,
      gridCard.visibleCard.rect.width / 60.0 * 2.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }

  /// 生命值数字 4.
  Rect get healthDigit4Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 51.0,
      gridCard.visibleCard.rect.width / 60.0 * 2.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }

  /// 武器.
  Rect get weaponRect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 0.0,
      gridCard.visibleCard.rect.width / 60.0 * 15.0,
      gridCard.visibleCard.rect.width / 60.0 * 24.0,
      gridCard.visibleCard.rect.width / 60.0 * 24.0,
    );
  }

  /// 武器数字 0.
  Rect get weaponDigit0Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 1.0,
      gridCard.visibleCard.rect.width / 60.0 * 40.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }

  /// 武器数字 1.
  Rect get weaponDigit1Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 5.0,
      gridCard.visibleCard.rect.width / 60.0 * 40.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }

  /// 盾牌.
  Rect get shieldRect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 22.0,
      gridCard.visibleCard.rect.width / 60.0 * 17.0,
      gridCard.visibleCard.rect.width / 60.0 * 24.0,
      gridCard.visibleCard.rect.width / 60.0 * 24.0,
    );
  }

  /// 盾牌数字 0.
  Rect get shieldDigit0Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 47.0,
      gridCard.visibleCard.rect.width / 60.0 * 29.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }

  /// 盾牌数字 1.
  Rect get shieldDigit1Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 51.0,
      gridCard.visibleCard.rect.width / 60.0 * 29.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }

  /// 效果.
  Rect get effectRect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 47.0,
      gridCard.visibleCard.rect.width / 60.0 * 46.0,
      gridCard.visibleCard.rect.width / 60.0 * 9.0,
      gridCard.visibleCard.rect.width / 60.0 * 9.0,
    );
  }

  /// 效果数字 0.
  Rect get effectDigit0Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 38.0,
      gridCard.visibleCard.rect.width / 60.0 * 48.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }

  /// 效果数字 1.
  Rect get effectDigit1Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 42.0,
      gridCard.visibleCard.rect.width / 60.0 * 48.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }

  /// 能力.
  Rect get powerRect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 0.0,
      gridCard.visibleCard.rect.width / 60.0 * 1.0,
      gridCard.visibleCard.rect.width / 60.0 * 9.0,
      gridCard.visibleCard.rect.width / 60.0 * 9.0,
    );
  }

  /// 能力数字 0.
  Rect get powerDigit0Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 10.0,
      gridCard.visibleCard.rect.width / 60.0 * 2.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }

  /// 能力数字 1.
  Rect get powerDigit1Rect {
    return Rect.fromLTWH(
      gridCard.visibleCard.rect.width / 60.0 * 14.0,
      gridCard.visibleCard.rect.width / 60.0 * 2.0,
      gridCard.visibleCard.rect.width / 60.0 * 4.0,
      gridCard.visibleCard.rect.width / 60.0 * 6.0,
    );
  }
}
