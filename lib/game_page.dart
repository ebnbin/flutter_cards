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
    _game.data.build();
    return Scaffold(
      body: SafeArea(
        child: CustomPaint(
          painter: _game.data.painter,
          foregroundPainter: _game.data.foregroundPainter,
          child: Stack(
            children: <Widget>[
              Stack(
                children: _game.data.cards.map<Widget>((Card card) {
                  return _buildCard(card, 0);
                }).toList(),
              ),
              Stack(
                children: _game.data.cards.map<Widget>((Card card) {
                  return _buildCard(card, 1);
                }).toList(),
              ),
              Stack(
                children: _game.data.cards.map<Widget>((Card card) {
                  return _buildCard(card, 2);
                }).toList(),
              ),
              Stack(
                children: _game.data.cards.map<Widget>((Card card) {
                  return _buildCard(card, 3);
                }).toList(),
              ),
              Stack(
                children: _game.data.cards.map<Widget>((Card card) {
                  return _buildCard(card, 4);
                }).toList(),
              ),
              Stack(
                children: _game.data.cards.map<Widget>((Card card) {
                  return _buildCard(card, 5);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建一个卡片.
  Widget _buildCard(Card card, int zIndex) {
    return CardWidget(
      card: card,
      zIndex: zIndex,
      child: Center(
        child: Text('$card'),
      ),
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
