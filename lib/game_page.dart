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
    Game game = _data.buildGame(context);
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
        Positioned.fromRelativeRect(
          rect: RelativeRect.fill,
          child: CustomPaint(
//            painter: Metric.get().debugPainter,
            foregroundPainter: Metric.get().debugForegroundPainter,
            child: _buildCards(context),
          ),
        ),
      ],
    );
  }

  /// 背景
  Widget _buildBackground(BuildContext context) {
    return Positioned.fromRelativeRect(
      rect: RelativeRect.fill,
      child: Image.asset(
        'assets/stone_bricks.png',
        scale: Metric.get().imageScale(48, 8.0),
        /// 不需要设置宽高.
//        width: ,
//        height: ,
        color: Colors.black.withOpacity(0.5),
        colorBlendMode: BlendMode.darken,
        fit: BoxFit.none,
        repeat: ImageRepeat.repeat,
      ),
    );
  }

  /// 全部卡片.
  Widget _buildCards(BuildContext context) {
    List<Card> cards = game.buildCards(context);
    return Stack(
      children: <int>[0, 1, 2, 3,].map<Widget>((zIndex) {
        return Stack(
          children: cards.map<Widget>((card) {
            return _buildCard(context, zIndex, card);
          }).toList(),
        );
      }).toList(),
    );
  }

  /// 卡片.
  Widget _buildCard(BuildContext context, int zIndex, Card card) {
    if (card.zIndexVisible(zIndex)) {
      VisibleCard visibleCard = card.buildVisibleCard();
      Card2 card2 = card.buildCard2();
      return _buildVisibleCard(visibleCard, card2);
    } else {
      return _buildInvisibleCard();
    }
  }

  /// 可见的卡片.
  Widget _buildVisibleCard(VisibleCard visibleCard, Card2 card2) {
    return Positioned.fromRect(
      rect: visibleCard.rect,
      child: Transform(
        transform: visibleCard.transform,
        alignment: Alignment.center,
        child: AbsorbPointer(
          absorbing: visibleCard.absorbPointer,
          child: IgnorePointer(
            ignoring: visibleCard.ignorePointer,
            child: Opacity(
              opacity: visibleCard.opacity,
              child: _buildGridCardOr(visibleCard, card2),
            ),
          ),
        ),
      ),
    );
  }

  /// TODO.
  Widget _buildGridCardOr(VisibleCard visibleCard, Card2 card2) {
    if (visibleCard.isGridCard) {
      GridCard gridCard = visibleCard.buildGridCard();
      return _buildGridCard(gridCard, card2);
    } else {
      return CustomPaint();
    }
  }

  /// 根据网格定位的卡片, 渲染为 Material 卡片.
  Widget _buildGridCard(GridCard gridCard, Card2 card2) {
    return Container(
      margin: EdgeInsets.all(gridCard.margin),
      child: Material(
        elevation: gridCard.elevation,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(gridCard.radius),
        clipBehavior: Clip.hardEdge,
        animationDuration: Duration.zero,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              _buildGridCardBackground(gridCard),
              GamePage2(card2),
            ],
          ),
          onTap: gridCard.onTap,
          onLongPress: gridCard.onLongPress,
        ),
      ),
    );
  }

  /// 网格卡片背景.
  Widget _buildGridCardBackground(GridCard gridCard) {
    return Positioned.fromRelativeRect(
      rect: RelativeRect.fill,
      child: Image.asset(
        'assets/oak_planks.png',
        scale: Metric.get().imageScale(96, 16.0),
        /// 不需要设置宽高.
//        width: ,
//        height: ,
        color: Colors.black.withOpacity(0.25),
        colorBlendMode: BlendMode.darken,
        fit: BoxFit.none,
        repeat: ImageRepeat.repeat,
      ),
    );
  }

  /// 不可见的卡片.
  Widget _buildInvisibleCard() {
    return Positioned.fill(
      child: CustomPaint(),
    );
  }
}
