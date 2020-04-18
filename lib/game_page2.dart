import 'package:cards/data.dart';
import 'package:cards/metric.dart';
import 'package:flutter/material.dart' hide Card;

class GamePage2 extends StatelessWidget {
  GamePage2(this.card);

  final Card2 card;

  @override
  Widget build(BuildContext context) {
    Color c = Colors.blueGrey.shade100;
    return Stack(
      children: <Widget>[
        Container(
          child: Opacity(
            opacity: 1.0,
            child: Image.asset('assets/oak_planks.png',
              scale: Metric.get().imageScale(96, 16.0),
              width: Metric.get().screenRect.width,
              height: Metric.get().screenRect.height,
              repeat: ImageRepeat.repeat,
              color: Colors.black.withAlpha(63),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          color: Colors.black,
        ),
        Positioned.fromRelativeRect(
          rect: RelativeRect.fill,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[

                Positioned.fromRect(
                  rect: card.spriteEntityRect,
                  child: Container(
//                            color: Colors.cyan,
                    child: Image.asset('assets2/steve.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteWeaponRect,
                  child: Container(
//                            color: Colors.red,
                    child: Image.asset('assets2/diamond_sword.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteWeaponValue0Rect,
                  child: Container(
//                            color: Colors.yellow,
                    child: Image.asset('assets2/digit_8.png',
                      fit: BoxFit.contain,
                      color: c,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteWeaponValue1Rect,
                  child: Container(
//                            color: Colors.pink,
                    child: Image.asset('assets2/digit_8.png',
                      fit: BoxFit.contain,
                      color: c,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteShieldRect,
                  child: Container(
//                            color: Colors.green,
                    child: Image.asset('assets2/shield.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteShieldValue0Rect,
                  child: Container(
//                            color: Colors.yellow,
                    child: Image.asset('assets2/digit_1.png',
                      fit: BoxFit.contain,
                      color: c,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteShieldValue1Rect,
                  child: Container(
//                            color: Colors.pink,
                    child: Image.asset('assets2/digit_2.png',
                      fit: BoxFit.contain,
                      color: c,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteHealthRect,
                  child: Container(
//                            color: Colors.orange,
                    child: Image.asset('assets2/icons.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteHealthValue0Rect,
                  child: Container(
//                            color: Colors.yellow,
                    child: Image.asset('assets2/digit_6.png',
                      fit: BoxFit.contain,
                      color: c,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteHealthValue1Rect,
                  child: Container(
//                            color: Colors.pink,
                    child: Image.asset('assets2/digit_7.png',
                      fit: BoxFit.contain,
                      color: c,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteHealthValue2Rect,
                  child: Container(
//                            color: Colors.yellow,
                    child: Image.asset('assets2/digit_slash.png',
                      fit: BoxFit.contain,
                      color: c,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteHealthValue3Rect,
                  child: Container(
//                            color: Colors.pink,
                    child: Image.asset('assets2/digit_8.png',
                      fit: BoxFit.contain,
                      color: c,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteHealthValue4Rect,
                  child: Container(
//                            color: Colors.yellow,
                    child: Image.asset('assets2/digit_9.png',
                      fit: BoxFit.contain,
                      color: c,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteHealthStateRect,
                  child: Container(
//                            color: Colors.orange,
                    child: Image.asset('assets2/icons2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteHealthStateValue0Rect,
                  child: Container(
//                            color: Colors.yellow,
                    child: Image.asset('assets2/digit_4.png',
                      fit: BoxFit.contain,
                      color: c,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteHealthStateValue1Rect,
                  child: Container(
//                            color: Colors.pink,
                    child: Image.asset('assets2/digit_5.png',
                      fit: BoxFit.contain,
                      color: c,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteStateRect,
                  child: Container(
//                            color: Colors.orange,
                    child: Image.asset('assets2/icons2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteStateValue0Rect,
                  child: Container(
//                            color: Colors.yellow,
                    child: Image.asset('assets2/digit_2.png',
                      fit: BoxFit.contain,
                      color: c,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteStateValue1Rect,
                  child: Container(
//                            color: Colors.pink,
                    child: Image.asset('assets2/digit_3.png',
                      fit: BoxFit.contain,
                      color: c,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteAmountValue0Rect,
                  child: Container(
//                            color: Colors.yellow,
                    child: Image.asset('assets2/digit_0.png',
                      fit: BoxFit.contain,
                      color: c,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ),
                Positioned.fromRect(
                  rect: card.spriteAmountValue1Rect,
                  child: Container(
//                            color: Colors.pink,
                    child: Image.asset('assets2/digit_1.png',
                      fit: BoxFit.contain,
                      color: c,
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
      ],
    );
  }
}
