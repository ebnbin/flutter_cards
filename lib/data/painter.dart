part of '../data.dart';

//*********************************************************************************************************************

class _GridForegroundPainter extends CustomPainter {
  _GridForegroundPainter(this.game);

  final Paint _paint = Paint();

  final _Game game;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.style = PaintingStyle.stroke;
    _paint.color = Colors.cyan;
    for (int rowIndex = 0; rowIndex <= game.metric.verticalSafeGrid; rowIndex += 1) {
      Offset p1 = new Offset(game.metric.safeRect.left, game.metric.safeRect.top + rowIndex * game.metric.gridSize);
      Offset p2 = new Offset(game.metric.safeRect.right, game.metric.safeRect.top + rowIndex * game.metric.gridSize);
      canvas.drawLine(p1, p2, _paint);
    }
    for (int columnIndex = 0; columnIndex <= game.metric.horizontalSafeGrid; columnIndex += 1) {
      Offset p1 = new Offset(game.metric.safeRect.left + columnIndex * game.metric.gridSize, game.metric.safeRect.top);
      Offset p2 = new Offset(game.metric.safeRect.left + columnIndex * game.metric.gridSize, game.metric.safeRect.bottom);
      canvas.drawLine(p1, p2, _paint);
    }
    _paint.color = Colors.yellow;
    for (int rowIndex = 0; rowIndex <= game.screen.square; rowIndex += 1) {
      Offset p1 = new Offset(game.metric.coreNoPaddingRect.left, game.metric.coreNoPaddingRect.top + rowIndex * game.metric.squareSizeMap[game.screen.square]);
      Offset p2 = new Offset(game.metric.coreNoPaddingRect.right, game.metric.coreNoPaddingRect.top + rowIndex * game.metric.squareSizeMap[game.screen.square]);
      canvas.drawLine(p1, p2, _paint);
    }
    for (int columnIndex = 0; columnIndex <= game.screen.square; columnIndex += 1) {
      Offset p1 = new Offset(game.metric.coreNoPaddingRect.left + columnIndex * game.metric.squareSizeMap[game.screen.square], game.metric.coreNoPaddingRect.top);
      Offset p2 = new Offset(game.metric.coreNoPaddingRect.left + columnIndex * game.metric.squareSizeMap[game.screen.square], game.metric.coreNoPaddingRect.bottom);
      canvas.drawLine(p1, p2, _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter(this.game);

  final _Game game;

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    _paint.style = PaintingStyle.fill;
    _paint.color = Colors.blue;
    canvas.drawRect(game.metric.screenRect, _paint);
    _paint.color = Colors.green;
    canvas.drawRect(game.metric.safeRect, _paint);
    _paint.color = Colors.red;
    canvas.drawRect(game.metric.coreRect, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
