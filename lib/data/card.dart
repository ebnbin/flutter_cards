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
    this.isCoreCard,
//    this.margin = 4.0,
    this.state = _CardState.idle,
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

  final bool isCoreCard;

  //*******************************************************************************************************************

  int get index => game.coreCards.indexOf(this);

  //*******************************************************************************************************************

  _CardGrid grid;

  _CardProperty property;

  Color get color {
    if (sprite.isPlayer) {
      return Colors.blueGrey;
    }
    switch (state) {
      case _CardState.idle:
        return Colors.white;
      case _CardState.pending:
        return Colors.grey;
      case _CardState.acting:
        return Colors.yellow;
      default:
        return Colors.white;
    }
  }

  //*******************************************************************************************************************

  GestureTapCallback get onTap => game.onTap(card: this);

  GestureLongPressCallback get onLongPress => game.onLongPress(card: this);

  //*******************************************************************************************************************

  @override
  String toString() {
    return '$grid\n$index';
  }

  //*******************************************************************************************************************

  CardData data;

  _Sprite sprite;

  _CardState state;
}

enum _CardState {
  idle,
  pending,
  acting,
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
  Color get color => card.color;

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
