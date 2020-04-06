part of '../data.dart';

//*********************************************************************************************************************
// 游戏中所有元素都由卡片组成.

/// 按照网格定位的卡片, 可以根据横竖屏控制不同的行列.
class _Card implements Card {
  _Card({
    @required
    this.game,
    @required
    this.grid,
    @required
    this.property,
    @required
    this.sprite,
  }) : assert(game != null),
        assert(grid != null) {
    data = _CardData(this);
    sprite.card = this;

    grid.card = this;
    property.card = this;
  }

  //*******************************************************************************************************************

  final _Game game;

  _CardGrid grid;

  _CardProperty property;

  //*******************************************************************************************************************

  GestureTapCallback get onTap => game.onTap(card: this);

  GestureLongPressCallback get onLongPress => game.onLongPress(card: this);

  //*******************************************************************************************************************

  @override
  String toString() {
    return '$grid';
  }

  //*******************************************************************************************************************

  CardData data;

  _Sprite sprite;
}

class _CardData implements CardData {
  _CardData(this.card);

  final _Card card;

  @override
  get onLongPress => card.onLongPress;

  @override
  get onTap => card.onTap;

  @override
  Rect get rect => card.grid.rect;

  @override
  Color get color => Colors.white;

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

  @override
  Sprite get sprite => card.sprite;

  @override
  bool get absorbPointer => card.property.absorbPointer;

  @override
  bool get ignorePointer => card.property.ignorePointer;
}
