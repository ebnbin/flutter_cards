import 'package:cards/cards_data.dart' as data;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
            return Positioned.fromRect(
              rect: card.position(context),
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.005)
                  ..rotateY(card.rotateY)
                  ..scale(card.scale),
                alignment: Alignment.center,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: GestureDetector(
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
                    behavior: HitTestBehavior.translucent,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  data.Cards _cards = data.Cards();
}
