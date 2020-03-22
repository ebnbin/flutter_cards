import 'package:cards/data/data.dart';
import 'package:flutter/material.dart';

/// 游戏页面.
///
/// 整个游戏只有单个页面. 游戏中所有元素都由卡片组成, 页面控制各种卡片的展示逻辑.
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
          children: <Widget>[
            Positioned.fromRect(
              rect: _gameData.safeRect(context),
              child: Container(
                color: Colors.red,
              ),
            ),
            Positioned.fromRect(
              rect: _gameData.boardRect(context),
              child: Container(
                color: Colors.yellow,
              ),
            ),
            Stack(
              children: _gameData.cardDataList.map<Widget>((CardData cardData) {
                return _buildCard(cardData);
              }).toList(),
            )
          ],
        )
      ),
      backgroundColor: Colors.blue,
    );
  }

  /// 构建一个卡片.
  Widget _buildCard(CardData cardData) {
    return cardData.visible ? _buildVisibleCard(cardData) : _buildInvisibleCard();
  }

  /// 构建一个可见的卡片.
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
            onTap: _gameData.onTap(
              cardData: cardData,
              setState: () {
                this.setState(() {
                });
              },
              tickerProvider: this,
            ),
            onLongPress: _gameData.onLongPress(
              cardData: cardData,
              context: context,
              setState: () {
                this.setState(() {
                });
              },
              tickerProvider: this,
            ),
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ),
    );
  }

  /// 构建一个不可见的卡片.
  Widget _buildInvisibleCard() {
    return Positioned.fill(
      child: SizedBox.shrink(),
    );
  }

  /// 游戏数据.
  GameData _gameData = GameData();
}
