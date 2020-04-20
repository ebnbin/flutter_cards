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
    if (face is _PlayerFace) {
      return PlayerFace._(this, face);
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

/// 玩家.
class PlayerFace {
  PlayerFace._(this._card, this._face);

  final Card _card;

  final _PlayerFace _face;

  /// 数字颜色.
  Color get digitColor => Colors.blueGrey.shade100;

  /// 主体.
  Rect get bodyRect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 48.0,
      _card.contentRect.width / 56.0 * 48.0,
    );
  }

  /// 武器.
  Rect get weaponRect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 0.0,
      _card.contentRect.width / 56.0 * 15.0,
      _card.contentRect.width / 56.0 * 24.0,
      _card.contentRect.width / 56.0 * 24.0,
    );
  }

  /// 武器值 0.
  Rect get weaponDigit0Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 1.0,
      _card.contentRect.width / 56.0 * 40.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 武器值 1.
  Rect get weaponDigit1Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 5.0,
      _card.contentRect.width / 56.0 * 40.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 盾牌.
  Rect get shieldRect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 22.0,
      _card.contentRect.width / 56.0 * 17.0,
      _card.contentRect.width / 56.0 * 24.0,
      _card.contentRect.width / 56.0 * 24.0,
    );
  }

  /// 盾牌值 0.
  Rect get shieldDigit0Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 47.0,
      _card.contentRect.width / 56.0 * 29.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 盾牌值 1.
  Rect get shieldDigit1Rect {
    return Rect.fromLTWH(
      _card.contentRect.width / 56.0 * 51.0,
      _card.contentRect.width / 56.0 * 29.0,
      _card.contentRect.width / 56.0 * 4.0,
      _card.contentRect.width / 56.0 * 6.0,
    );
  }

  /// 生命.
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
