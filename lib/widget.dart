part of 'game_page.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    this.card,
    this.zIndex,
    this.child,
  });

  final Card card;

  final int zIndex;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (card.property.zIndexVisible(zIndex)) {
      return _buildVisible();
    } else {
      return _buildInvisible();
    }
  }

  Widget _buildVisible() {
    return Positioned.fromRect(
      rect: card.rect,
      child: Transform(
        transform: card.property.transform,
        alignment: Alignment.center,
        child: Opacity(
          opacity: card.property.opacity,
          child: Container(
            margin: EdgeInsets.all(card.property.margin),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(card.property.radius),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withAlpha(127),
                  blurRadius: (card.property.radius + card.property.elevation) / 4.0,
                  spreadRadius: -1.0,
                  offset: Offset.fromDirection(0.25 * pi, 1.0),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(card.property.radius),
              child: GestureDetector(
                child: Container(
                  color: card.color,
                  child: child,
                ),
                onTap: card.onTap,
                onLongPress: card.onLongPress,
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
