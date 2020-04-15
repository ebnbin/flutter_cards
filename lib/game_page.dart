import 'dart:math';

import 'package:cards/data.dart';
import 'package:cards/metric.dart';
import 'package:flutter/material.dart' hide Card;

class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin implements GameCallback {
  @override
  Widget build(BuildContext context) {
    Metric.build(context);
    Game game = Game.build(context);
    return GamePage2(game);
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

  @override
  void notifyStateChanged() {
    setState(() {
    });
  }
}

/// 游戏页面.
///
/// 整个游戏只有单个页面. 游戏中所有元素都由卡片组成, 页面控制各种卡片的展示逻辑.
class GamePage2 extends StatelessWidget {
  GamePage2(this.game);

  final Game game;

  @override
  Widget build(BuildContext context) {
    return _buildGame(game);
  }

  Widget _buildGame(Game game) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset('assets/stone_bricks.png',
            scale: 256.0 / (min(Metric.get().safeScreenRect.width, Metric.get().safeScreenRect.height) / 62.0 * 16.0 / 2.0),
            width: Metric.get().screenRect.width,
            height: Metric.get().screenRect.height,
            repeat: ImageRepeat.repeat,
            color: Colors.black.withAlpha(127),
            colorBlendMode: BlendMode.darken,
          ),
          CustomPaint(
//            painter: game.painter,
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
        ],
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
                    child: Stack(
                      children: <Widget>[
                        Positioned.fromRect(
                          rect: card.spriteEntityRect,
                          child: Container(
                            color: Colors.red,
                            child: Image.asset('assets/steve.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteWeaponRect,
                          child: Container(
                            color: Colors.green,
                            child: Image.asset('assets/diamond_sword.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteWeaponValueRect,
                          child: Container(
                            color: Colors.blue,
                            alignment: AlignmentDirectional.center,
                            child: Text('88',
                              style: TextStyle(
                                fontSize: card.spriteValueFontSize,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteShieldRect,
                          child: Container(
                            color: Colors.cyan,
                            child: Image.asset('assets/shield.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteShieldValueRect,
                          child: Container(
                            color: Colors.yellow,
                            alignment: AlignmentDirectional.center,
                            child: Text('88',
                              style: TextStyle(
                                fontSize: card.spriteValueFontSize,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteHealthRect,
                          child: Container(
                            color: Colors.cyan,
                            child: Image.asset('assets/icons.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteHealthValueRect,
                          child: Container(
                            color: Colors.pink,
                            alignment: AlignmentDirectional.center,
                            child: Text('88/88',
                              style: TextStyle(
                                fontSize: card.spriteValueFontSize,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteHealthStateRect,
                          child: Container(
                            color: Colors.green,
                            child: Image.asset('assets/icons2.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteHealthStateValueRect,
                          child: Container(
                            color: Colors.blue,
                            alignment: AlignmentDirectional.center,
                            child: Text('88',
                              style: TextStyle(
                                fontSize: card.spriteValueFontSize,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteStateRect,
                          child: Container(
                            color: Colors.green,
                            child: Image.asset('assets/icons2.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteStateValueRect,
                          child: Container(
                            color: Colors.blue,
                            alignment: AlignmentDirectional.center,
                            child: Text('88',
                              style: TextStyle(
                                fontSize: card.spriteValueFontSize,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteAmountValueRect,
                          child: Container(
                            color: Colors.yellow,
                            alignment: AlignmentDirectional.center,
                            child: Text('88',
                              style: TextStyle(
                                fontSize: card.spriteValueFontSize,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Text('$card',
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                      ],
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
}
