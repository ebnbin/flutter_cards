part of '../data.dart';

//*********************************************************************************************************************

class _GridForegroundPainter extends CustomPainter {
  _GridForegroundPainter({
    @required
    this.metric,
  }) {
    this.metric = metric;
  }

  _Metric metric;

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

class _GridPainter extends CustomPainter {
  _GridPainter({
    @required
    this.metric,
  }) {
    this.metric = metric;
  }

  _Metric metric;

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
