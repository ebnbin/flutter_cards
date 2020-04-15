part of '../data.dart';

//*********************************************************************************************************************

class _GridForegroundPainter extends CustomPainter {
  _GridForegroundPainter(this._game);

  final Paint _paint = Paint();

  final _Game _game;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.style = PaintingStyle.stroke;
    _paint.color = Colors.cyan;
    for (int rowIndex = 0; rowIndex <= Metric.get().verticalGrid; rowIndex += 1) {
      Offset p1 = new Offset(Metric.get().safeRect.left, Metric.get().safeRect.top + rowIndex * Metric.get().gridSize);
      Offset p2 = new Offset(Metric.get().safeRect.right, Metric.get().safeRect.top + rowIndex * Metric.get().gridSize);
      canvas.drawLine(p1, p2, _paint);
    }
    for (int columnIndex = 0; columnIndex <= Metric.get().horizontalGrid; columnIndex += 1) {
      Offset p1 = new Offset(Metric.get().safeRect.left + columnIndex * Metric.get().gridSize, Metric.get().safeRect.top);
      Offset p2 = new Offset(Metric.get().safeRect.left + columnIndex * Metric.get().gridSize, Metric.get().safeRect.bottom);
      canvas.drawLine(p1, p2, _paint);
    }
    _paint.color = Colors.yellow;
    for (int rowIndex = 0; rowIndex <= _game.screen.square; rowIndex += 1) {
      Offset p1 = new Offset(Metric.get().coreNoPaddingRect.left, Metric.get().coreNoPaddingRect.top + rowIndex * Metric.get().coreCardSize(_game.screen.square));
      Offset p2 = new Offset(Metric.get().coreNoPaddingRect.right, Metric.get().coreNoPaddingRect.top + rowIndex * Metric.get().coreCardSize(_game.screen.square));
      canvas.drawLine(p1, p2, _paint);
    }
    for (int columnIndex = 0; columnIndex <= _game.screen.square; columnIndex += 1) {
      Offset p1 = new Offset(Metric.get().coreNoPaddingRect.left + columnIndex * Metric.get().coreCardSize(_game.screen.square), Metric.get().coreNoPaddingRect.top);
      Offset p2 = new Offset(Metric.get().coreNoPaddingRect.left + columnIndex * Metric.get().coreCardSize(_game.screen.square), Metric.get().coreNoPaddingRect.bottom);
      canvas.drawLine(p1, p2, _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter();

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    _paint.style = PaintingStyle.fill;
    _paint.color = Colors.blue;
    canvas.drawRect(Metric.get().screenRect, _paint);
    _paint.color = Colors.green;
    canvas.drawRect(Metric.get().safeRect, _paint);
    _paint.color = Colors.red;
    canvas.drawRect(Metric.get().coreRect, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
