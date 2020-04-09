import 'package:cards/data.dart';
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
    Game.get().data.build();
    return Scaffold(
      body: CustomPaint(
        painter: Game.get().data.painter,
        foregroundPainter: Game.get().data.foregroundPainter,
        child: Stack(
          children: [0, 1, 2, 3, 4, 5].map<Widget>((zIndex) {
            return Stack(
              children: Game.get().data.cards.map<Widget>((card) {
                return _buildCard(card, zIndex);
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCard(Card card, int zIndex) {
    if (card.data.zIndexVisible(zIndex)) {
      return _buildVisibleCard(card);
    } else {
      return _buildInvisibleCard();
    }
  }

  Widget _buildVisibleCard(Card card) {
    return Positioned.fromRect(
      rect: card.data.rect,
      child: Transform(
        transform: card.data.transform,
        alignment: Alignment.center,
        child: AbsorbPointer(
          absorbing: card.data.absorbPointer,
          child: IgnorePointer(
            ignoring: card.data.ignorePointer,
            child: Opacity(
              opacity: card.data.opacity,
              child: Container(
                margin: EdgeInsets.all(card.data.margin),
                child: Material(
                  type: MaterialType.card,
                  color: card.data.color,
                  elevation: card.data.elevation,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(card.data.radius),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    child: Center(
                      child: Text('${card.data}',
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                    onTap: card.data.onTap,
                    onLongPress: card.data.onLongPress,
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
    super.dispose();
  }
}
