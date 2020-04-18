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
    return Stack(
      children: <Widget>[
        _buildBackground(context),
        CustomPaint(
//          painter: Metric.get().debugPainter,
          foregroundPainter: Metric.get().debugForegroundPainter,
          child: _buildCards(context),
        ),
      ],
    );
  }

  /// 背景
  Widget _buildBackground(BuildContext context) {
    return Image.asset(
      'assets/stone_bricks.png',
      scale: Metric.get().imageScale(48, 8.0),
      width: Metric.get().screenRect.width,
      height: Metric.get().screenRect.height,
      color: Colors.black.withOpacity(0.5),
      colorBlendMode: BlendMode.darken,
      repeat: ImageRepeat.repeat,
    );
  }

  /// 全部卡片.
  Widget _buildCards(BuildContext context) {
    return Stack(
      children: <int>[0, 1, 2, 3,].map<Widget>((zIndex) {
        return Stack(
          children: game.cards.map<Widget>((card) {
            return _buildCard(context, zIndex, card);
          }).toList(),
        );
      }).toList(),
    );
  }

  /// 卡片.
  Widget _buildCard(BuildContext context, int zIndex, Card card) {
    if (card.zIndexVisible(zIndex)) {
      return GamePage2(card);
    } else {
      return _buildInvisibleCard();
    }
  }

  /// 不可见的卡片.
  Widget _buildInvisibleCard() {
    return Positioned.fill(
      child: CustomPaint(),
    );
  }
}
