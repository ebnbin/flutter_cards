part of '../data.dart';

//*********************************************************************************************************************

class _GridForegroundPainter extends CustomPainter {
  _GridForegroundPainter();

  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    _paint.style = PaintingStyle.stroke;
    _paint.color = Colors.cyan;
    for (int rowIndex = 0; rowIndex <= _Metric.get().verticalGrid; rowIndex += 1) {
      Offset p1 = new Offset(_Metric.get().safeRect.left, _Metric.get().safeRect.top + rowIndex * _Metric.get().gridSize);
      Offset p2 = new Offset(_Metric.get().safeRect.right, _Metric.get().safeRect.top + rowIndex * _Metric.get().gridSize);
      canvas.drawLine(p1, p2, _paint);
    }
    for (int columnIndex = 0; columnIndex <= _Metric.get().horizontalGrid; columnIndex += 1) {
      Offset p1 = new Offset(_Metric.get().safeRect.left + columnIndex * _Metric.get().gridSize, _Metric.get().safeRect.top);
      Offset p2 = new Offset(_Metric.get().safeRect.left + columnIndex * _Metric.get().gridSize, _Metric.get().safeRect.bottom);
      canvas.drawLine(p1, p2, _paint);
    }
    _paint.color = Colors.yellow;
    for (int rowIndex = 0; rowIndex <= _Metric.get().square; rowIndex += 1) {
      Offset p1 = new Offset(_Metric.get().bodyNoPaddingRect.left, _Metric.get().bodyNoPaddingRect.top + rowIndex * _Metric.get().bodyCardSize);
      Offset p2 = new Offset(_Metric.get().bodyNoPaddingRect.right, _Metric.get().bodyNoPaddingRect.top + rowIndex * _Metric.get().bodyCardSize);
      canvas.drawLine(p1, p2, _paint);
    }
    for (int columnIndex = 0; columnIndex <= _Metric.get().square; columnIndex += 1) {
      Offset p1 = new Offset(_Metric.get().bodyNoPaddingRect.left + columnIndex * _Metric.get().bodyCardSize, _Metric.get().bodyNoPaddingRect.top);
      Offset p2 = new Offset(_Metric.get().bodyNoPaddingRect.left + columnIndex * _Metric.get().bodyCardSize, _Metric.get().bodyNoPaddingRect.bottom);
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
    canvas.drawRect(_Metric.get().screenRect, _paint);
    _paint.color = Colors.green;
    canvas.drawRect(_Metric.get().safeRect, _paint);
    _paint.color = Colors.red;
    canvas.drawRect(_Metric.get().bodyRect, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
