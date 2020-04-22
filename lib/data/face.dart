part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 卡片内容. 一张卡片可能有多个面, 通过翻转动画切换.
abstract class _Face {
  _Face(this.card);

  final _Card card;
}

/// 绘制一个图标表示当前卡片上什么东西都没有.
class _BlankFace extends _Face {
  _BlankFace(_Card card) : super(card);
}

/// 开屏全屏.
class _SplashFullFace extends _Face {
  _SplashFullFace(_Card card) : super(card);
}

/// 开屏 Cards 标题.
class _SplashTitleFace extends _Face {
  _SplashTitleFace(_Card card) : super(card);
}

/// 精灵.
class _SpriteFace extends _Face {
  _SpriteFace(_Card card) : super(card);

  /// 主体.
  String body = 'assets/steve.png';

  /// 武器.
  String weapon = 'assets/diamond_sword.png';

  /// 武器值.
  int weaponValue = 16;

  /// 盾牌.
  String shield/* = 'assets/shield.png'*/;

  /// 盾牌值.
  int shieldValue;

  /// 生命值.
  int healthValue = 3;

  /// 最大生命值.
  int maxHealthValue = 3;

  /// 效果.
  String effect = 'assets/poison.png';

  /// 效果值.
  int effectValue = 8;

  /// 数量.
  int amount;

  /// 能力.
  String power/* = 'assets/absorption.png'*/;

  /// 能力值.
  int powerValue;
}
