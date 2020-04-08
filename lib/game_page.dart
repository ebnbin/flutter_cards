import 'dart:math';

import 'package:cards/data.dart';
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
    Game.init(this);
  }


  @override
  void dispose() {
    Game.dispose();
    super.dispose();
  }
}
