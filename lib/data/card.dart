part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************
// 卡片.

/// 卡片.
abstract class _Card {
  _Card(this.screen);

  final _Screen screen;

  /// 当前卡片在 [screen.cards] 中的索引.
  int get index {
    return screen.cards.indexOf(this);
  }

  @override
  String toString() {
    return '$index';
  }
}
