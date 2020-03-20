import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Cards extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CardsState();
}

class _CardsState extends State<Cards> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: _cards.map<Widget>((card) {
          return _buildCard(card);
        }).toList(),
      ),
    );
  }

  /// 构建卡片控件.
  Widget _buildCard(_BaseCard card) {
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

    return Positioned.fromRect(
      rect: Rect.fromLTWH(
        horizontal + size * card.y,
        vertical + size * card.x,
        size,
        size,
      ),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.005)
          ..rotateY(card.animationRotateY())
          ..scale(card.animationScale()),
        alignment: Alignment.center,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: InkWell(
            child: Center(
              child: Text('$card'),
            ),
            onTap: card.animationValue == null ? () {
              AnimationController animationController = AnimationController(
                duration: Duration(
                  milliseconds: 1000,
                ),
                vsync: this,
              );
              CurvedAnimation curvedAnimation = CurvedAnimation(
                parent: animationController,
                curve: Curves.easeInOut,
              );
              curvedAnimation
                ..addStatusListener((AnimationStatus status) {
                  switch (status) {
                    case AnimationStatus.dismissed:
                      break;
                    case AnimationStatus.forward:
                      break;
                    case AnimationStatus.reverse:
                      break;
                    case AnimationStatus.completed:
                      setState(() {
                        card.animationValue = null;
                      });
                      animationController.dispose();
                      break;
                  }
                })
                ..addListener(() {
                  setState(() {
                    card.animationValue = curvedAnimation.value;
                  });
                });
              animationController.forward();
            } : null,
          ),
        ),
      )
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
  /// 如果不为 null 表示正在动画.
  double animationValue;

  double animationRotateY({double init = 0.0, double increment = 2.0 * pi}) {
    if (animationValue == null) {
      return init;
    }
    return init + animationValue * increment;
  }

  double animationScale({double init = 1.0, double increment = -0.2}) {
    if (animationValue == null) {
      return init;
    }
    if (animationValue < 0.5) {
      return init + animationValue * increment * 2.0;
    } else {
      return init + (1.0 - animationValue) * increment * 2.0;
    }
  }

  @override
  String toString() {
    return '$x,$y:$data';
  }
}
