part of '../data.dart';

//*********************************************************************************************************************

class _Sprite implements Sprite {
  _Sprite({
    @required
    this.card,
  }) {
    data = _SpriteData(this);
  }

  final _Card card;

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
