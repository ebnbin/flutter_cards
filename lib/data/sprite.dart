part of '../data.dart';

//*********************************************************************************************************************

class _Sprite {
  _Sprite({
    this.isPlayer = false,
  });

  _Card card;

  final bool isPlayer;

  @override
  String toString() {
    return card.toString();
  }
}
