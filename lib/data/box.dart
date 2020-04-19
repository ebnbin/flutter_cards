part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************
// Everything is box.

abstract class _Box {
  _Box(this.screen, {
    this.rotateX = 0.0,
    this.rotateY = 0.0,
    this.rotateZ = 0.0,
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
  });

  final _Screen screen;

  /// 定位矩形.
  Rect get rect;

  /// Matrix4.setEntry(3, 2, value). 数值只与 [rect] 相关.
  double get matrix4Entry32 {
    // 数值越大, 3d 旋转镜头越近, 效果越明显, 但越容易绘制异常.
    return 0.4 / rect.longSize();
  }

  double rotateX;
  double rotateY;
  double rotateZ;
  double translateX;
  double translateY;
  double scaleX;
  double scaleY;

  /// 变换矩阵.
  Matrix4 get transform {
    return Matrix4.identity()..setEntry(3, 2, matrix4Entry32)
      ..rotateX(rotateX)
      ..rotateY(rotateY)
      ..rotateZ(rotateZ)
      ..leftTranslate(translateX, translateY)
      ..scale(scaleX, scaleY);
  }
}
