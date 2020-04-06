part of '../data.dart';

//*********************************************************************************************************************

class _Sprite implements Sprite {
  _Sprite({
    this.isPlayer = false,
  }) {
    data = _SpriteData(this);
  }

  _Card card;

  final bool isPlayer;

  @override
  SpriteData data;

  @override
  String toString() {
    return card.toString();
  }
}

class _SpriteData implements SpriteData {
  _SpriteData(this.sprite);

  final _Sprite sprite;

  @override
  String toString() {
    return sprite.toString();
  }
}
