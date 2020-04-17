part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************
// 卡片.

/// 卡片.
abstract class _Card {
  _Card(this.screen, {
    this.zIndex = 1,
    this.visible = true,
  });

  final _Screen screen;

  /// 当前卡片在 [screen.cards] 中的索引.
  int get index {
    return screen.cards.indexOf(this);
  }

  /// [Stack] 中的索引. 数字越大在越上层. 范围 0 ~ 3.
  ///
  /// 0: 在做下沉动画.
  ///
  /// 1: 默认.
  ///
  /// 2: 在做上升动画.
  ///
  /// 3: 在顶层做动画.
  int zIndex;

  /// 是否可见.
  bool visible;

  /// 定位矩形.
  Rect get rect;

  @override
  String toString() {
    return '$index';
  }
}
