part of 'game_page.dart';

class Card extends StatelessWidget {
  const Card({
    this.cardData,
    this.child,
  });

  final CardData cardData;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: cardData.rect,
      child: Transform(
        transform: cardData.property.transform,
        alignment: Alignment.center,
        child: Opacity(
          opacity: cardData.property.opacity,
          child: Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(cardData.property.radius),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withAlpha(127),
                  blurRadius: (cardData.property.radius + cardData.property.elevation) / 4.0,
                  spreadRadius: -1.0,
                  offset: Offset.fromDirection(0.25 * pi, 1.0),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(cardData.property.radius),
              child: GestureDetector(
                child: Container(
                  color: Colors.white,
                  child: child,
                ),
                onTap: cardData.onTap,
                onLongPress: cardData.onLongPress,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
