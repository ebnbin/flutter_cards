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
    return GamePage2(Game.get());
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
          Image.asset('assets/options_background.png',
            scale: 256.0 / (min(Metric.get().screenRect.width, Metric.get().screenRect.height) / 62.0 * 16.0),
            width: Metric.get().screenRect.width,
            height: Metric.get().screenRect.height,
            repeat: ImageRepeat.repeat,
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
                        Container(
                          width: card.rect.width / 60.0 * 48.0,
                          height: card.rect.width / 60.0 * 48.0,
//                          color: Colors.red,
                          alignment: AlignmentDirectional.center,
                          margin: EdgeInsets.only(
                            left: card.rect.width / 60.0 * 4.0,
                            top: card.rect.width / 60.0 * 4.0,
                          ),
                          child: Image.asset('assets/steve.png',
                            width: card.rect.width / 60.0 * 48.0,
                            height: card.rect.height / 60.0 * 48.0,
                            fit: BoxFit.contain,
                          ),
                        ),
//                        Container(
//                          width: card.rect.width / 60.0 * 48.0,
//                          height: card.rect.width / 60.0 * 48.0,
////                          color: Colors.red,
//                          alignment: AlignmentDirectional.center,
//                          margin: EdgeInsets.only(
//                            left: card.rect.width / 60.0 * 4.0,
//                            top: card.rect.width / 60.0 * 4.0,
//                          ),
//                          child: Image.asset('assets/diamond_layer.png',
//                            width: card.rect.width / 60.0 * 48.0,
//                            height: card.rect.height / 60.0 * 48.0,
//                            fit: BoxFit.contain,
//                          ),
//                        ),
                        Container(
                          width: card.rect.width / 60.0 * 24.0,
                          height: card.rect.width / 60.0 * 24.0,
//                          color: Colors.green,
                          alignment: AlignmentDirectional.center,
                          margin: EdgeInsets.only(
                            left: card.rect.width / 60.0 * 0.0,
                            top: card.rect.width / 60.0 * 15.0,
                          ),
                          child: Image.asset('assets/diamond_sword.png',
                            width: card.rect.width / 60.0 * 24.0,
                            height: card.rect.height / 60.0 * 24.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          width: card.rect.width / 60.0 * 9.0,
                          height: card.rect.width / 60.0 * 7.0,
                          margin: EdgeInsets.only(
                            left: card.rect.width / 60.0 * 0.0,
                            top: card.rect.width / 60.0 * 39.0,
                          ),
//                          color: Colors.blue,
                          alignment: AlignmentDirectional.center,
                          child: Text('88',
                            style: TextStyle(
                              fontSize: card.rect.width / Metric.get().gridSize / (5.0 / 3.0),
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: card.rect.width / 60.0 * 24.0,
                          height: card.rect.width / 60.0 * 24.0,
//                          color: Colors.cyan,
                          alignment: AlignmentDirectional.center,
                          margin: EdgeInsets.only(
                            left: card.rect.width / 60.0 * 23.0,
                            top: card.rect.width / 60.0 * 17.0,
                          ),
                          child: Image.asset('assets/shield.png',
                            width: card.rect.width / 60.0 * 24.0,
                            height: card.rect.height / 60.0 * 24.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          width: card.rect.width / 60.0 * 9.0,
                          height: card.rect.width / 60.0 * 9.0,
                          margin: EdgeInsets.only(
                            left: card.rect.width / 60.0 * 47.0,
                            top: card.rect.width / 60.0 * 8.0,
                          ),
//                          color: Colors.cyan,
                          alignment: AlignmentDirectional.center,
                          child: Image.asset('assets/icons.png',
                            width: card.rect.width / 60.0 * 9.0,
                            height: card.rect.height / 60.0 * 9.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          width: card.rect.width / 60.0 * 21.0,
                          height: card.rect.width / 60.0 * 7.0,
                          margin: EdgeInsets.only(
                            left: card.rect.width / 60.0 * 35.0,
                            top: card.rect.width / 60.0 * 1.0,
                          ),
//                          color: Colors.pink,
                          alignment: AlignmentDirectional.center,
                          child: Text('88/88',
                            style: TextStyle(
                              fontSize: card.rect.width / Metric.get().gridSize / (5.0 / 3.0),
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: card.rect.width / 60.0 * 9.0,
                          height: card.rect.width / 60.0 * 7.0,
                          margin: EdgeInsets.only(
                            left: card.rect.width / 60.0 * 47.0,
                            top: card.rect.width / 60.0 * 28.0,
                          ),
//                          color: Colors.yellow,
                          alignment: AlignmentDirectional.center,
                          child: Text('88',
                            style: TextStyle(
                              fontSize: card.rect.width / Metric.get().gridSize / (5.0 / 3.0),
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: card.rect.width / 60.0 * 9.0,
                          height: card.rect.width / 60.0 * 9.0,
                          margin: EdgeInsets.only(
                            left: card.rect.width / 60.0 * 0.0,
                            top: card.rect.width / 60.0 * 1.0,
                          ),
//                          color: Colors.green,
                          alignment: AlignmentDirectional.center,
                          child: Image.asset('assets/icons2.png',
                            width: card.rect.width / 60.0 * 9.0,
                            height: card.rect.height / 60.0 * 9.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          width: card.rect.width / 60.0 * 9.0,
                          height: card.rect.width / 60.0 * 7.0,
                          margin: EdgeInsets.only(
                            left: card.rect.width / 60.0 * 9.0,
                            top: card.rect.width / 60.0 * 1.0,
                          ),
//                          color: Colors.blue,
                          alignment: AlignmentDirectional.center,
                          child: Text('88',
                            style: TextStyle(
                              fontSize: card.rect.width / Metric.get().gridSize / (5.0 / 3.0),
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: card.rect.width / 60.0 * 9.0,
                          height: card.rect.width / 60.0 * 9.0,
                          margin: EdgeInsets.only(
                            left: card.rect.width / 60.0 * 47.0,
                            top: card.rect.width / 60.0 * 46.0,
                          ),
//                          color: Colors.green,
                          alignment: AlignmentDirectional.center,
                          child: Image.asset('assets/icons2.png',
                            width: card.rect.width / 60.0 * 9.0,
                            height: card.rect.height / 60.0 * 9.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          width: card.rect.width / 60.0 * 9.0,
                          height: card.rect.width / 60.0 * 7.0,
                          margin: EdgeInsets.only(
                            left: card.rect.width / 60.0 * 38.0,
                            top: card.rect.width / 60.0 * 48.0,
                          ),
//                          color: Colors.blue,
                          alignment: AlignmentDirectional.center,
                          child: Text('88',
                            style: TextStyle(
                              fontSize: card.rect.width / Metric.get().gridSize / (5.0 / 3.0),
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: card.rect.width / 60.0 * 9.0,
                          height: card.rect.width / 60.0 * 7.0,
                          margin: EdgeInsets.only(
                            left: card.rect.width / 60.0 * 0.0,
                            top: card.rect.width / 60.0 * 48.0,
                          ),
//                          color: Colors.yellow,
                          alignment: AlignmentDirectional.center,
                          child: Text('88',
                            style: TextStyle(
                              fontSize: card.rect.width / Metric.get().gridSize / (5.0 / 3.0),
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
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
