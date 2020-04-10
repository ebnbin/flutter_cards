import 'package:cards/data.dart';
import 'package:cards/metric.dart';
import 'package:flutter/material.dart' hide Card;

/// 游戏页面.
///
/// 整个游戏只有单个页面. 游戏中所有元素都由卡片组成, 页面控制各种卡片的展示逻辑.
class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin implements GameCallback {
  @override
  Widget build(BuildContext context) {
    Metric.build(context);
    return _buildGame(Game.get());
  }
  
  Widget _buildGame(Game game) {
    return Scaffold(
      body: CustomPaint(
        painter: game.painter,
        foregroundPainter: game.foregroundPainter,
        child: Stack(
          children: [0, 1, 2, 3, 4, 5].map<Widget>((zIndex) {
            return Stack(
              children: game.cards.map<Widget>((card) {
                return _buildCard(card, zIndex);
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCard(Card card, int zIndex) {
    if (card.zIndexVisible(zIndex)) {
      return _buildVisibleCard(card);
    } else {
      return _buildInvisibleCard();
    }
  }

  Widget _buildVisibleCard(Card card) {
    return Positioned.fromRect(
      rect: card.rect,
      child: Transform(
        transform: card.transform,
        alignment: Alignment.center,
        child: AbsorbPointer(
          absorbing: card.absorbPointer,
          child: IgnorePointer(
            ignoring: card.ignorePointer,
            child: Opacity(
              opacity: card.opacity,
              child: Container(
                margin: EdgeInsets.all(card.margin),
                child: Material(
                  type: MaterialType.card,
                  color: card.color,
                  elevation: card.elevation,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(card.radius),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    child: Center(
                      child: Text('$card',
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                    onTap: card.onTap,
                    onLongPress: card.onLongPress,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvisibleCard() {
    return Positioned.fill(
      child: SizedBox.shrink(),
    );
  }

  @override
  void initState() {
    super.initState();
    Game.init(this);
  }


  @override
  void dispose() {
    Game.dispose();
    Metric.dispose();
    super.dispose();
  }

  @override
  void notifyStateChanged() {
    setState(() {
    });
  }
}
