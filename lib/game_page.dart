import 'package:cards/data.dart';
import 'package:cards/game_page2.dart';
import 'package:cards/metric.dart';
import 'package:flutter/material.dart' hide Card;

/// 游戏页面.
class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin implements GameCallback {
  @override
  Widget build(BuildContext context) {
    Metric.build(context);
    Game game = _data.build(context);
    return Scaffold(
      body: _GameWidget(game),
    );
  }

  Data _data;

  @override
  void initState() {
    super.initState();
    _data = Data(this);
  }

  @override
  void notifyStateChanged() {
    setState(() {
    });
  }
}

/// 根据 [Game] 生成视图.
class _GameWidget extends StatelessWidget {
  _GameWidget(this.game);

  final Game game;

  @override
  Widget build(BuildContext context) {
    return GamePage2(game);
  }
}
