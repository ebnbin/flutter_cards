import 'dart:math';

import 'package:cards/data.dart';
import 'package:cards/material_card.dart';
import 'package:flutter/material.dart' hide Card;

part 'widget.dart';

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
    _game.data.build();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fromRect(
            rect: _game.data.headerRect,
            child: MaterialCard(
              color: Colors.blueGrey.shade300,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              margin: EdgeInsets.zero,
            ),
          ),
          Positioned.fromRect(
            rect: _game.data.footerRect,
            child: MaterialCard(
              color: Colors.blueGrey.shade300,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              margin: EdgeInsets.zero,
            ),
          ),
          CustomPaint(
//            painter: _game.data.painter,
//            foregroundPainter: _game.data.foregroundPainter,
            child: Stack(
              children: [0, 1, 2, 3, 4, 5].map<Widget>((zIndex) {
                return Stack(
                  children: _game.data.cards.map<Widget>((card) {
                    return _buildCard(card, zIndex);
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey.shade100,
    );
  }

  /// 构建一个卡片.
  Widget _buildCard(Card card, int zIndex) {
    return CardWidget(
      card: card,
      zIndex: zIndex,
    );
  }


  @override
  void initState() {
    super.initState();
    _game = Game.create(this);
  }

  /// 游戏数据.
  Game _game;
}
