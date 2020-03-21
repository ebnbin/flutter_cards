import 'package:cards/cards_data.dart' as data;
import 'package:flutter/material.dart';

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
          children: _cards.cards.map<Widget>((card) {
            return _buildCard(card);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCard(data.Card card) {
    return Positioned.fromRect(
      rect: card.position(context),
      child: Transform(
        transform: card.transform,
        alignment: Alignment.center,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: GestureDetector(
            child: Center(
              child: Text('$card'),
            ),
            onTap: card.animationValue == null ? () {
              card.createAnimation(() {
                setState(() {
                });
              }, this,
                duration: 1000,
                curve: Curves.easeInOut,
              );
            } : null,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ),
    );
  }

  data.Cards _cards = data.Cards();
}
