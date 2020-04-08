part of '../data.dart';

//*********************************************************************************************************************

/// 屏幕 (一局游戏).
class _Screen {
  _Screen(this.type, {
    this.square,
  });

  /// 开屏.
  _Screen.splash() : this(_ScreenType.splash,
    square: 4,
  );

  /// 一局游戏.
  _Screen.round({
    int square,
  }) : this(_ScreenType.round,
    square: square,
  );

  void init() {
    devs.add(_Card(this,
      type: _CardType.dev0,
      verticalRowGridIndex: 1,
      verticalColumnGridIndex: 1,
      verticalRowGridSpan: 15,
      verticalColumnGridSpan: 10,
      horizontalRowGridIndex: 1,
      horizontalColumnGridIndex: 1,
      horizontalRowGridSpan: 10,
      horizontalColumnGridSpan: 15,
    ));
  }

  /// 屏幕类型.
  final _ScreenType type;

  /// Core 卡片行列数. 2 ~ 6.
  final int square;

  /// 精灵卡片.
  List<_SpriteCard> sprites = <_SpriteCard>[];
  /// 开发用.
  List<_Card> devs = <_Card>[];

  /// 返回所有卡片.
  BuiltList<_Card> get cards {
    return (<_Card>[]..addAll(sprites)..addAll(devs)).build();
  }

  //*******************************************************************************************************************

  GestureTapCallback onTap(_Card card) {
    if (card.type == _CardType.dev0) {
      return () {
        _Animation.dev(card).begin();
      };
    }
    return null;
  }

  GestureLongPressCallback onLongPress(_Card card) {
    return null;
  }
}

/// 屏幕类型.
enum _ScreenType {
  splash,
  round,
}
