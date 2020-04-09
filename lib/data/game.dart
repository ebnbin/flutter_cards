part of '../data.dart';

//*********************************************************************************************************************

/// 游戏数据.
class _Game implements Game {
  static _Game _game;

  static void init(GameCallback callback) {
    if (_game != null) {
      throw Exception();
    }
    _game = _Game(callback);
  }

  static _Game get() {
    if (_game == null) {
      throw Exception();
    }
    return _game;
  }

  static void dispose() {
    _game?.onDispose();
    _game = null;
    _Metric.dispose();
  }

  //*******************************************************************************************************************

  _Game(this.callback) {
    data = GameData._(this);
    setScreen(_GameScreen(square: 6));
  }

  final GameCallback callback;

  final _GridPainter gridPainter = _GridPainter();
  final _GridForegroundPainter gridForegroundPainter = _GridForegroundPainter();

  //*******************************************************************************************************************

  /// 是否是第一次调用 [build].
  bool _firstBuild = true;

  void build() {
    _Metric.build();
    if (_firstBuild) {
      _firstBuild = false;
      screen.init();
    }
  }

  void onDispose() {
  }

  //*******************************************************************************************************************

  _Screen screen;

  /// 改变屏幕时必须重新调用 [_Metric.build].
  void setScreen(_Screen screen) {
    this.screen = screen;
    if (_firstBuild) {
      return;
    }
    _Metric.build();
    screen.init();
  }

  //*******************************************************************************************************************

  @override
  GameData data;
}

/// 卡片类型.
enum _CardType {
  placeholder,
  core,

  sample,
  dev0,
  dev1,
  dev2,
  dev3,
  dev4,
  dev5,
}
