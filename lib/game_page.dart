import 'package:cards/data.dart';
import 'package:flutter/material.dart';

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
      rect: cardData.rect,
      child: Transform(
        transform: cardData.property.transform,
        alignment: Alignment.center,
        child: Opacity(
          opacity: cardData.property.opacity,
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
              ),
              onLongPress: _gameData.onLongPress(
                cardData: cardData,
              ),
              behavior: HitTestBehavior.translucent,
            ),
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


  @override
  void initState() {
    super.initState();
    _gameData = GameData.create(this);
  }

  /// 游戏数据.
  GameData _gameData;
}
