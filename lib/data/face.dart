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

/// 玩家.
class _PlayerFace extends _Face {
  _PlayerFace(_Card card) : super(card);
}
