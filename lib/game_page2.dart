import 'package:cards/data.dart';
import 'package:cards/metric.dart';
import 'package:flutter/material.dart' hide Card;

class GamePage2 extends StatelessWidget {
  GamePage2(this.game);

  final Game game;

  @override
  Widget build(BuildContext context) {
    return _buildGame(game);
  }

  Widget _buildGame(Game game) {
    return Stack(
      children: <Widget>[
        Image.asset('assets/stone_bricks.png',
          scale: game.backgroundImageScale,
          width: game.backgroundImageWidth,
          height: game.backgroundImageHeight,
          repeat: ImageRepeat.repeat,
          color: Colors.black.withAlpha(127),
          colorBlendMode: BlendMode.darken,
        ),
        CustomPaint(
          painter: Metric.get().debugPainter,
          foregroundPainter: Metric.get().debugForegroundPainter,
          child: Stack(
            children: [0, 1, 2, 3,].map<Widget>((zIndex) {
              return Stack(
                children: game.cards.map<Widget>((card) {
                  return _buildCard(card, zIndex);
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ],
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
                  animationDuration: Duration(
                    milliseconds: 0,
                  ),
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
                        Container(
                          child: Image.asset('assets/white_wool.png',
                            scale: game.backgroundImageScale / 2.0,
                            width: game.backgroundImageWidth,
                            height: game.backgroundImageHeight,
                            repeat: ImageRepeat.repeat,
                            color: Colors.black.withAlpha(127),
                            colorBlendMode: BlendMode.darken,
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteEntityRect,
                          child: Container(
//                            color: Colors.cyan,
                            child: Image.asset('assets/steve.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteWeaponRect,
                          child: Container(
//                            color: Colors.red,
                            child: Image.asset('assets/diamond_sword.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteWeaponValue0Rect,
                          child: Container(
//                            color: Colors.yellow,
                            child: Image.asset('assets/digit_8.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteWeaponValue1Rect,
                          child: Container(
//                            color: Colors.pink,
                            child: Image.asset('assets/digit_8.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteShieldRect,
                          child: Container(
//                            color: Colors.green,
                            child: Image.asset('assets/shield.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteShieldValue0Rect,
                          child: Container(
//                            color: Colors.yellow,
                            child: Image.asset('assets/digit_1.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteShieldValue1Rect,
                          child: Container(
//                            color: Colors.pink,
                            child: Image.asset('assets/digit_2.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteHealthRect,
                          child: Container(
//                            color: Colors.orange,
                            child: Image.asset('assets/icons.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteHealthValue0Rect,
                          child: Container(
//                            color: Colors.yellow,
                            child: Image.asset('assets/digit_6.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteHealthValue1Rect,
                          child: Container(
//                            color: Colors.pink,
                            child: Image.asset('assets/digit_7.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteHealthValue2Rect,
                          child: Container(
//                            color: Colors.yellow,
                            child: Image.asset('assets/digit_slash.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteHealthValue3Rect,
                          child: Container(
//                            color: Colors.pink,
                            child: Image.asset('assets/digit_8.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteHealthValue4Rect,
                          child: Container(
//                            color: Colors.yellow,
                            child: Image.asset('assets/digit_9.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteHealthStateRect,
                          child: Container(
//                            color: Colors.orange,
                            child: Image.asset('assets/icons2.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteHealthStateValue0Rect,
                          child: Container(
//                            color: Colors.yellow,
                            child: Image.asset('assets/digit_4.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteHealthStateValue1Rect,
                          child: Container(
//                            color: Colors.pink,
                            child: Image.asset('assets/digit_5.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteStateRect,
                          child: Container(
//                            color: Colors.orange,
                            child: Image.asset('assets/icons2.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteStateValue0Rect,
                          child: Container(
//                            color: Colors.yellow,
                            child: Image.asset('assets/digit_2.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteStateValue1Rect,
                          child: Container(
//                            color: Colors.pink,
                            child: Image.asset('assets/digit_3.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteAmountValue0Rect,
                          child: Container(
//                            color: Colors.yellow,
                            child: Image.asset('assets/digit_0.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Positioned.fromRect(
                          rect: card.spriteAmountValue1Rect,
                          child: Container(
//                            color: Colors.pink,
                            child: Image.asset('assets/digit_1.png',
                              fit: BoxFit.contain,
                              color: Colors.black,
                              colorBlendMode: BlendMode.srcATop,
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
