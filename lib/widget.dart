part of 'game_page.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    this.card,
    this.zIndex,
  });

  final Card card;

  final int zIndex;

  @override
  Widget build(BuildContext context) {
    if (card.data.zIndexVisible(zIndex)) {
      return _buildVisible();
    } else {
      return _buildInvisible();
    }
  }

  Widget _buildVisible() {
    return Positioned.fromRect(
      rect: card.data.rect,
      child: Transform(
        transform: card.data.transform,
        alignment: Alignment.center,
        child: Opacity(
          opacity: card.data.opacity,
          child: Container(
            margin: EdgeInsets.all(card.data.margin),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(card.data.radius),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withAlpha(127),
                  blurRadius: (card.data.radius + card.data.elevation) / 4.0,
                  spreadRadius: -1.0,
                  offset: Offset.fromDirection(0.25 * pi, 1.0),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(card.data.radius),
              child: GestureDetector(
                child: Container(
                  color: card.data.color,
                  child: SpriteWidget(
                    sprite: card.data.sprite,
                  ),
                ),
                onTap: card.data.onTap,
                onLongPress: card.data.onLongPress,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvisible() {
    return Positioned.fill(
      child: SizedBox.shrink(),
    );
  }
}

class SpriteWidget extends StatelessWidget {
  SpriteWidget({
    this.sprite,
  });
  
  final Sprite sprite;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '${sprite.data.toString()}',
        style: TextStyle(
          fontSize: 10.0,
        ),
      ),
    );
  }
}
