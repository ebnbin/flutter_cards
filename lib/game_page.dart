import 'package:cards/game_data.dart';
import 'package:flutter/material.dart';

/// 游戏页面.
class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: _gameData.cardDataList.map<Widget>((CardData cardData) {
            return _buildCard(cardData);
          }).toList(),
        ),
      ),
    );
  }

  /// 每一个卡片.
  Widget _buildCard(CardData cardData) {
    return cardData.visible ? _buildVisibleCard(cardData) : _buildInvisibleCard();
  }

  /// 一个可见的卡片.
  Widget _buildVisibleCard(CardData cardData) {
    return Positioned.fromRect(
      rect: cardData.rect(context),
      child: Transform(
        transform: cardData.property.transform,
        alignment: Alignment.center,
        child: Card(
          elevation: cardData.property.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardData.property.radius),
          ),
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            child: Center(
              child: Text('$cardData'),
            ),
            onTap: _gameData.onTap(cardData, setState, this),
            onLongPress: _gameData.onLongPress(cardData, context, setState, this),
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ),
    );
  }

  /// 一个不可见的卡片.
  Widget _buildInvisibleCard() {
    return Positioned.fill(
      child: SizedBox.shrink(),
    );
  }

  /// 游戏数据.
  GameData _gameData = GameData();
}
