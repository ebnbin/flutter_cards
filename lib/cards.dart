import 'dart:math';

import 'package:flutter/material.dart';

class Cards extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: _cards.map<Widget>((card) {
          return Positioned.fromRect(
            rect: _cardRect(card),
            child: Card(
              child: Center(
                child: Text('$card'),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 卡片数据.
  List<_BaseCard> _cards = [];

  @override
  void initState() {
    super.initState();
    for (int x = 0; x < ROW; x++) {
      for (int y = 0; y < COLUMN; y++) {
        String data;
        switch (x * 10 + y) {
          case 10:
            data = '_C';
            break;
          case 11:
            data = 'ar';
            break;
          case 12:
            data = 'ds';
            break;
          default:
            data = '__';
            break;
        }
        _cards.add(_BaseCard(x, y, data));
      }
    }
  }

  /// 卡片位置.
  Rect _cardRect(_BaseCard card) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // 安全的屏幕宽高.
    Size screenSize = Size(
      mediaQueryData.size.width - mediaQueryData.padding.horizontal,
      mediaQueryData.size.height - mediaQueryData.padding.vertical,
    );
    // 卡片宽高.
    double size = min(screenSize.width / COLUMN, screenSize.height / ROW);
    // 水平边距.
    double horizontal = (screenSize.width - size * COLUMN) / 2.0;
    // 垂直边距.
    double vertical = (screenSize.height - size * ROW) / 2.0;
    return Rect.fromLTWH(
      horizontal + size * card.y,
      vertical + size * card.x,
      size,
      size,
    );
  }
}

/// 卡片行数.
const int ROW = 4;
/// 卡片列数.
const int COLUMN = 4;

/// 卡片数据.
class _BaseCard {
  _BaseCard(this.x, this.y, this.data);

  int x;
  int y;
  String data;

  @override
  String toString() {
    return '$x,$y:$data';
  }
}
