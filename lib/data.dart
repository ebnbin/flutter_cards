import 'dart:collection';
import 'dart:math';

import 'package:cards/metric.dart';
import 'package:flutter/material.dart' hide Card;

part 'data/card.dart';
part 'data/game.dart';
part 'data/public.dart';
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

  Card2 buildCard2() {
    return Card2._(_card);
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

  double get margin => _gridCard.margin;

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

  bool get isSpriteCard {
    return _gridCard is _SpriteCard;
  }

  SpriteCard buildSpriteCard() {
    return SpriteCard._(this, _gridCard as _SpriteCard);
  }
}

/// 精灵卡片.
class SpriteCard {
  SpriteCard._(this.gridCard, this._spriteCard);

  final GridCard gridCard;

  final _SpriteCard _spriteCard;
}
