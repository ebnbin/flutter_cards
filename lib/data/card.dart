part of '../data.dart';

//*********************************************************************************************************************
// 游戏中所有元素都由卡片组成.

/// 按照网格定位的卡片, 可以根据横竖屏控制不同的行列.
class _Card implements Card {
  _Card({
    this.game,
    @required
    _Property initProperty,
  }) : assert(game != null),
        assert(initProperty != null) {
    property = initProperty;
    data = _CardData(this);
  }

  //*******************************************************************************************************************

  final _Game game;

  //*******************************************************************************************************************

  int get index => game.cards.indexOf(this);

  //*******************************************************************************************************************
  // 属性.

  /// 属性.
  _Property property;

  //*******************************************************************************************************************

  _Card get leftCard {
    return game.cards.firstWhere((element) {
      if (!element.property.grid.isCoreCard) {
        return false;
      }
      int r = property.grid.coreCardRowIndex;
      int c = property.grid.coreCardColumnIndex;
      int r2 = element.property.grid.coreCardRowIndex;
      int c2 = element.property.grid.coreCardColumnIndex;
      return r == r2 && c - 1 == c2;
    }, orElse: () => null);
  }

  _Card get rightCard {
    return game.cards.firstWhere((element) {
      if (!element.property.grid.isCoreCard) {
        return false;
      }
      int r = property.grid.coreCardRowIndex;
      int c = property.grid.coreCardColumnIndex;
      int r2 = element.property.grid.coreCardRowIndex;
      int c2 = element.property.grid.coreCardColumnIndex;
      return r == r2 && c + 1 == c2;
    }, orElse: () => null);
  }

  _Card get topCard {
    return game.cards.firstWhere((element) {
      if (!element.property.grid.isCoreCard) {
        return false;
      }
      int r = property.grid.coreCardRowIndex;
      int c = property.grid.coreCardColumnIndex;
      int r2 = element.property.grid.coreCardRowIndex;
      int c2 = element.property.grid.coreCardColumnIndex;
      return r - 1 == r2 && c == c2;
    }, orElse: () => null);
  }

  _Card get bottomCard {
    return game.cards.firstWhere((element) {
      if (!element.property.grid.isCoreCard) {
        return false;
      }
      int r = property.grid.coreCardRowIndex;
      int c = property.grid.coreCardColumnIndex;
      int r2 = element.property.grid.coreCardRowIndex;
      int c2 = element.property.grid.coreCardColumnIndex;
      return r + 1 == r2 && c == c2;
    }, orElse: () => null);
  }

  //*******************************************************************************************************************

  @override
  GestureTapCallback get onTap => game.onTap(card: this);

  @override
  GestureLongPressCallback get onLongPress => game.onLongPress(card: this);

  //*******************************************************************************************************************

  @override
  String toString() {
    return '${property.grid}\n$index';
  }

  //*******************************************************************************************************************

  CardData data;
}

class _CardData implements CardData {
  _CardData(this.card);

  final _Card card;

  @override
  get onLongPress => card.onLongPress;

  @override
  get onTap => card.onTap;

  @override
  Rect get rect => card.property.grid.rect;

  @override
  Color get color => card.property.color;

  @override
  double get elevation => card.property.elevation;

  @override
  double get margin => card.property.margin;

  @override
  double get opacity => card.property.opacity;

  @override
  double get radius => card.property.radius;

  @override
  Matrix4 get transform => card.property.transform;

  @override
  bool Function(int zIndex) get zIndexVisible => card.property.zIndexVisible;
}
