part of '../data.dart';

//*********************************************************************************************************************

/// 卡片.
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
  }) : data = _CardData() {
    grid.card = this;
    property.card = this;
    sprite.card = this;
    data.card = this;
  }

  final _Game game;

  final _CardGrid grid;

  final _CardProperty property;

  final _Sprite sprite;

  @override
  final _CardData data;
}

class _CardData implements CardData {
  _Card card;

  @override
  bool get absorbPointer => card.property.absorbPointer;

  @override
  Color get color => Colors.white;

  @override
  double get elevation => card.property.elevation;

  @override
  bool get ignorePointer => card.property.ignorePointer;

  @override
  double get margin => card.property.margin;

  @override
  get onLongPress => card.game.onLongPress(card);

  @override
  get onTap => card.game.onTap(card);

  @override
  double get opacity => card.property.opacity;

  @override
  double get radius => card.property.radius;

  @override
  Rect get rect => card.grid.rect;

  @override
  Matrix4 get transform => card.property.transform;

  @override
  bool Function(int zIndex) get zIndexVisible => card.property.zIndexVisible;

  @override
  String toString() {
    return card.toString();
  }
}
