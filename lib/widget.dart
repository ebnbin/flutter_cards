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
                  color: card.property.color,
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

class GridForegroundPainter extends CustomPainter {
  GridForegroundPainter({
    @required
    this.metric,
  }) {
    this.metric = metric;
  }

  Metric metric;

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    _paint.style = PaintingStyle.stroke;
    _paint.color = Colors.cyan;
    for (int rowIndex = 0; rowIndex <= metric.verticalGridCount; rowIndex += 1) {
      Offset p1 = new Offset(metric.safeBoardRect.left, metric.safeBoardRect.top + rowIndex * metric.gridSize);
      Offset p2 = new Offset(metric.safeBoardRect.right, metric.safeBoardRect.top + rowIndex * metric.gridSize);
      canvas.drawLine(p1, p2, _paint);
    }
    for (int columnIndex = 0; columnIndex <= metric.horizontalGridCount; columnIndex += 1) {
      Offset p1 = new Offset(metric.safeBoardRect.left + columnIndex * metric.gridSize, metric.safeBoardRect.top);
      Offset p2 = new Offset(metric.safeBoardRect.left + columnIndex * metric.gridSize, metric.safeBoardRect.bottom);
      canvas.drawLine(p1, p2, _paint);
    }
    _paint.color = Colors.pink;
    for (int rowIndex = 0; rowIndex <= metric.size; rowIndex += 1) {
      Offset p1 = new Offset(metric.coreBoardNoPaddingRect.left, metric.coreBoardNoPaddingRect.top + rowIndex * metric.coreCardSize);
      Offset p2 = new Offset(metric.coreBoardNoPaddingRect.right, metric.coreBoardNoPaddingRect.top + rowIndex * metric.coreCardSize);
      canvas.drawLine(p1, p2, _paint);
    }
    for (int columnIndex = 0; columnIndex <= metric.size; columnIndex += 1) {
      Offset p1 = new Offset(metric.coreBoardNoPaddingRect.left + columnIndex * metric.coreCardSize, metric.coreBoardNoPaddingRect.top);
      Offset p2 = new Offset(metric.coreBoardNoPaddingRect.left + columnIndex * metric.coreCardSize, metric.coreBoardNoPaddingRect.bottom);
      canvas.drawLine(p1, p2, _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class GridPainter extends CustomPainter {
  GridPainter({
    @required
    this.metric,
  }) {
    this.metric = metric;
  }

  Metric metric;

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    _paint.style = PaintingStyle.fill;
    _paint.color = Colors.blue;
    canvas.drawRect(metric.screenRect, _paint);
    _paint.color = Colors.red;
    canvas.drawRect(metric.safeBoardRect, _paint);
    _paint.color = Colors.yellow;
    canvas.drawRect(metric.coreBoardRect, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
