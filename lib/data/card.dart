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
    this.matrix4Entry32 = 0.004,
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.rotateX = 0.0,
    this.rotateY = 0.0,
    this.rotateZ = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.elevation = 1.0,
    this.radius = 4.0,
    this.opacity = 1.0,
    this.visible = true,
    this.margin = 4.0,
    this.color = Colors.white,
  }) : assert(game != null),
        assert(grid != null) {
    data = _CardData(this);
    sprite = _Sprite(card: this);
  }

  //*******************************************************************************************************************

  final _Game game;

  //*******************************************************************************************************************

  int get index => game.cards.indexOf(this);

  //*******************************************************************************************************************

  void reset() {
    translateX = 0.0;
    translateY = 0.0;
    rotateX = 0.0;
    rotateY = 0.0;
    rotateZ = 0.0;
    scaleX = 1.0;
    scaleY = 1.0;
    elevation = 1.0;
    radius = 4.0;
    opacity = 1.0;
  }

  _Grid grid;

  /// Matrix4.setEntry(3, 2, value);
  double matrix4Entry32;

  double translateX;
  double translateY;
  double rotateX;
  double rotateY;
  double rotateZ;
  double scaleX;
  double scaleY;

  Matrix4 get transform => Matrix4.identity()
    ..setEntry(3, 2, matrix4Entry32 ?? 0.0)
    ..translate(translateX ?? 0.0, translateY ?? 0.0)
    ..rotateX(rotateX ?? 0.0)
    ..rotateY(rotateY ?? 0.0)
    ..rotateZ(rotateZ ?? 0.0)
    ..scale(scaleX ?? 1.0, scaleY ?? 1.0);

  double elevation;

  /// 范围 0 ~ 5.
  int get zIndex {
    if (elevation < 1.0) {
      return 0;
    }
    if (elevation == 1.0) {
      return 1;
    }
    if (elevation > 4.0) {
      return 5;
    }
    return elevation.ceil();
  }

  double radius;
  double opacity;

  bool visible;

  bool Function(int zIndex) get zIndexVisible {
    assert(zIndex >= 0 && zIndex <= 5);
    return (zIndex) {
      return visible && this.zIndex == zIndex;
    };
  }

  double margin;

  Color color;

  //*******************************************************************************************************************

  _Card get leftCard {
    return game.cards.firstWhere((element) {
      if (!element.grid.isCoreCard) {
        return false;
      }
      int r = grid.coreCardRowIndex;
      int c = grid.coreCardColumnIndex;
      int r2 = element.grid.coreCardRowIndex;
      int c2 = element.grid.coreCardColumnIndex;
      return r == r2 && c - 1 == c2;
    }, orElse: () => null);
  }

  _Card get rightCard {
    return game.cards.firstWhere((element) {
      if (!element.grid.isCoreCard) {
        return false;
      }
      int r = grid.coreCardRowIndex;
      int c = grid.coreCardColumnIndex;
      int r2 = element.grid.coreCardRowIndex;
      int c2 = element.grid.coreCardColumnIndex;
      return r == r2 && c + 1 == c2;
    }, orElse: () => null);
  }

  _Card get topCard {
    return game.cards.firstWhere((element) {
      if (!element.grid.isCoreCard) {
        return false;
      }
      int r = grid.coreCardRowIndex;
      int c = grid.coreCardColumnIndex;
      int r2 = element.grid.coreCardRowIndex;
      int c2 = element.grid.coreCardColumnIndex;
      return r - 1 == r2 && c == c2;
    }, orElse: () => null);
  }

  _Card get bottomCard {
    return game.cards.firstWhere((element) {
      if (!element.grid.isCoreCard) {
        return false;
      }
      int r = grid.coreCardRowIndex;
      int c = grid.coreCardColumnIndex;
      int r2 = element.grid.coreCardRowIndex;
      int c2 = element.grid.coreCardColumnIndex;
      return r + 1 == r2 && c == c2;
    }, orElse: () => null);
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
  double get elevation => card.elevation;

  @override
  double get margin => card.margin;

  @override
  double get opacity => card.opacity;

  @override
  double get radius => card.radius;

  @override
  Matrix4 get transform => card.transform;

  @override
  bool Function(int zIndex) get zIndexVisible => card.zIndexVisible;

  @override
  Sprite get sprite => card.sprite;
}
