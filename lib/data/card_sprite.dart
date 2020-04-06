part of '../data.dart';

//*********************************************************************************************************************

/// 卡片精灵.
class _CardSprite {
  _CardSprite({
    this.isPlayer = false,
  });

  /// 所属卡片.
  _Card card;

  /// 是否为玩家卡片.
  final bool isPlayer;
}
