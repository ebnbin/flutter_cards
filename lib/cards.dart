import 'package:cards/cards_data.dart' as data;
import 'package:flutter/material.dart';

/// 卡片页面.
class Cards extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CardsState();
}

class _CardsState extends State<Cards> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: _cards.cards.map<Widget>((data.Card card) {
            return _buildCard(card);
          }).toList(),
        ),
      ),
    );
  }

  /// 每一个卡片.
  Widget _buildCard(data.Card card) {
    return card.visible ? _buildVisibleCard(card) : _buildInvisibleCard();
  }

  /// 一个可见的卡片.
  Widget _buildVisibleCard(data.Card card) {
    return Positioned.fromRect(
      rect: card.rect(context),
      child: Transform(
        transform: card.transform,
        alignment: Alignment.center,
        child: Card(
          elevation: card.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(card.radius),
          ),
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            child: Center(
              child: Text('$card'),
            ),
            onTap: _cards.onTap(setState, this, card),
            onLongPress: _cards.onLongPress(context, setState, this, card),
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

  /// 卡片数据.
  data.Cards _cards = data.Cards();
}
