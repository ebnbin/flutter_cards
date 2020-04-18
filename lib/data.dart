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
