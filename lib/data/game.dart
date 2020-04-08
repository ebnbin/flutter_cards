part of '../data.dart';

//*********************************************************************************************************************

/// 游戏数据.
class _Game implements Game {
  _Game(this.callback) : data = _GameData() {
    data.game = this;
    setScreen(_Screen.round(this, square: 6));
  }

  final GameCallback callback;

  final _GridPainter gridPainter = _GridPainter();
  final _GridForegroundPainter gridForegroundPainter = _GridForegroundPainter();

  //*******************************************************************************************************************

  /// 是否是第一次调用 [build].
  bool _firstBuild = true;

  void build() {
    if (_firstBuild) {
      _firstBuild = false;
      screen.init();
    }
  }

  void dispose() {
  }

  //*******************************************************************************************************************

  _Screen screen;

  /// 改变屏幕时必须重新调用 [_Metric.build].
  void setScreen(_Screen screen) {
    this.screen = screen;
    if (_firstBuild) {
      return;
    }
    _Metric.build(this);
    screen.init();
  }

  //*******************************************************************************************************************

  final _GameData data;
}

class _GameData implements GameData {
  _Game game;

  @override
  void build() {
    _Metric.build(game);
    game.build();
  }

  @override
  BuiltList<Card> get cards => game.screen.cards;

  @override
  void dispose() {
    game.dispose();
    _Metric.dispose();
  }

  @override
  CustomPainter get foregroundPainter => game.gridForegroundPainter;

  @override
  CustomPainter get painter => game.gridPainter;
}

/// 卡片类型.
enum _CardType {
  placeholder,
  core,

  dev0,
  dev1,
  dev2,
  dev3,
  dev4,
  dev5,
}
