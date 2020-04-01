part of '../data.dart';

//*********************************************************************************************************************

/// 接收 [Animation.value] 计算当前属性值.
class _PropertyCalc {
  const _PropertyCalc(this.calc) : assert(calc != null);

  /// a -> b.
  _PropertyCalc.ab(double a, double b) : this((value) {
    return a + (b - a) * value;
  });

  /// a -> b -> a.
  _PropertyCalc.aba(double a, double b) : this((value) {
    return a + (b - a) * (1.0 - (2.0 * value - 1.0).abs());
  });

  final double Function(double value) calc;
}

//*********************************************************************************************************************

/// 属性.
class _Property {
  _Property({
    @required
    this.grid,
    this.matrix4Entry32 = 0.004,
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.rotateX = 0.0,
    this.rotateY = 0.0,
    this.rotateZ = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.elevation = 1.0,
    this.radius = 4.0,
    this.opacity = 1.0,
    this.visible = true,
    this.margin = 4.0,
    this.color = Colors.white,
  });

  void reset() {
    translateX = 0.0;
    translateY = 0.0;
    rotateX = 0.0;
    rotateY = 0.0;
    rotateZ = 0.0;
    scaleX = 1.0;
    scaleY = 1.0;
    elevation = 1.0;
    radius = 4.0;
    opacity = 1.0;
  }

  _Grid grid;

  /// Matrix4.setEntry(3, 2, value);
  double matrix4Entry32;

  double translateX;
  double translateY;
  double rotateX;
  double rotateY;
  double rotateZ;
  double scaleX;
  double scaleY;

  Matrix4 get transform => Matrix4.identity()
    ..setEntry(3, 2, matrix4Entry32 ?? 0.0)
    ..translate(translateX ?? 0.0, translateY ?? 0.0)
    ..rotateX(rotateX ?? 0.0)
    ..rotateY(rotateY ?? 0.0)
    ..rotateZ(rotateZ ?? 0.0)
    ..scale(scaleX ?? 1.0, scaleY ?? 1.0);

  double elevation;

  /// 范围 0 ~ 5.
  int get zIndex {
    if (elevation < 1.0) {
      return 0;
    }
    if (elevation == 1.0) {
      return 1;
    }
    if (elevation > 4.0) {
      return 5;
    }
    return elevation.ceil();
  }

  double radius;
  double opacity;

  bool visible;

  bool Function(int zIndex) get zIndexVisible {
    assert(zIndex >= 0 && zIndex <= 5);
    return (zIndex) {
      return visible && this.zIndex == zIndex;
    };
  }

  double margin;

  Color color;
}
