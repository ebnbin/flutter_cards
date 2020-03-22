import 'package:cards/game_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(CardsGame());

/// Cards 游戏.
class CardsGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GamePage(),
    );
  }
}
