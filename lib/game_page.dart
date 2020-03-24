import 'dart:math';

import 'package:cards/data.dart';
import 'package:flutter/material.dart';

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
    _gameData.build();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned.fromRect(
              rect: _gameData.safeRect,
              child: Container(
                color: Colors.red,
              ),
            ),
            Positioned.fromRect(
              rect: _gameData.boardRect,
              child: Container(
                color: Colors.yellow,
              ),
            ),
            Stack(
              children: _gameData.cardDataList.map<Widget>((CardData cardData) {
                return _buildCard(cardData, 0);
              }).toList(),
            ),
            Stack(
              children: _gameData.cardDataList.map<Widget>((CardData cardData) {
                return _buildCard(cardData, 1);
              }).toList(),
            ),
            Stack(
              children: _gameData.cardDataList.map<Widget>((CardData cardData) {
                return _buildCard(cardData, 2);
              }).toList(),
            ),
            Stack(
              children: _gameData.cardDataList.map<Widget>((CardData cardData) {
                return _buildCard(cardData, 3);
              }).toList(),
            ),
            Stack(
              children: _gameData.cardDataList.map<Widget>((CardData cardData) {
                return _buildCard(cardData, 4);
              }).toList(),
            ),
            Stack(
              children: _gameData.cardDataList.map<Widget>((CardData cardData) {
                return _buildCard(cardData, 5);
              }).toList(),
            ),
          ],
        )
      ),
      backgroundColor: Colors.blue,
    );
  }

  /// 构建一个卡片.
  Widget _buildCard(CardData cardData, int zIndex) {
    return Card(
      cardData: cardData,
      zIndex: zIndex,
      child: Center(
        child: Text('$cardData'),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _gameData = GameData.create(this);
  }

  /// 游戏数据.
  GameData _gameData;
}
