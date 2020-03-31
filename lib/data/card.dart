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
    _property = initProperty;
  }

  //*******************************************************************************************************************

  final _Game game;

  //*******************************************************************************************************************

  int get index => game._cards.indexOf(this);

  //*******************************************************************************************************************
  // 位置.

  /// 在 Stack 中的位置. Positioned.fromRect().
  @override
  Rect get rect {
    return _property.grid.rect;
  }

  //*******************************************************************************************************************
  // 属性.

  /// 属性.
  @override
  Property get property => _property;
  _Property _property;

  //*******************************************************************************************************************

  _Card get leftCard {
    return game._cards.firstWhere((element) {
      if (element is! _CoreCard) {
        return false;
      }
      int r = _property.grid.coreCardRowIndex;
      int c = _property.grid.coreCardColumnIndex;
      int r2 = element._property.grid.coreCardRowIndex;
      int c2 = element._property.grid.coreCardColumnIndex;
      return r == r2 && c - 1 == c2;
    }, orElse: () => null);
  }

  _Card get rightCard {
    return game._cards.firstWhere((element) {
      if (element is! _CoreCard) {
        return false;
      }
      int r = _property.grid.coreCardRowIndex;
      int c = _property.grid.coreCardColumnIndex;
      int r2 = element._property.grid.coreCardRowIndex;
      int c2 = element._property.grid.coreCardColumnIndex;
      return r == r2 && c + 1 == c2;
    }, orElse: () => null);
  }

  _Card get topCard {
    return game._cards.firstWhere((element) {
      if (element is! _CoreCard) {
        return false;
      }
      int r = _property.grid.coreCardRowIndex;
      int c = _property.grid.coreCardColumnIndex;
      int r2 = element._property.grid.coreCardRowIndex;
      int c2 = element._property.grid.coreCardColumnIndex;
      return r - 1 == r2 && c == c2;
    }, orElse: () => null);
  }

  _Card get bottomCard {
    return game._cards.firstWhere((element) {
      if (element is! _CoreCard) {
        return false;
      }
      int r = _property.grid.coreCardRowIndex;
      int c = _property.grid.coreCardColumnIndex;
      int r2 = element._property.grid.coreCardRowIndex;
      int c2 = element._property.grid.coreCardColumnIndex;
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
    return '${_property.grid}\n$index';
  }
}

//*********************************************************************************************************************

/// 按照索引定位的卡片, 不能根据横竖屏控制不同的行列.
class _CoreCard extends _Card {
  _CoreCard({
    _Game game,
    @required
    _Property initProperty,
  }) : super(
        game: game,
        initProperty: initProperty,
      );
}
