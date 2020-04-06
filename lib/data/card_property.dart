part of '../data.dart';

//*********************************************************************************************************************

/// 卡片属性.
class _CardProperty {
  _CardProperty({
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
    this.gestureType = _CardGestureType.normal,
  });

  /// 所属卡片.
  _Card card;

  /// Matrix4.setEntry(3, 2, value);
  double get matrix4Entry32 {
    return _Metric.coreNoPaddingGrid / card.grid.maxSpan / 1000.0;
  }

  double translateX;
  double translateY;
  double rotateX;
  double rotateY;
  double rotateZ;
  double scaleX;
  double scaleY;

  Matrix4 get transform => Matrix4.identity()
    ..setEntry(3, 2, matrix4Entry32)
    ..translate(translateX, translateY)
    ..rotateX(rotateX)
    ..rotateY(rotateY)
    ..rotateZ(rotateZ)
    ..scale(scaleX, scaleY);

  /// Z 方向高度. 建议范围 0.0 ~ 4.0.
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

  /// 圆角.
  double radius;

  /// 透明度.
  double opacity;

  /// 是否可见.
  bool visible;

  /// 在 [zIndex] 上是否可见.
  bool Function(int zIndex) get zIndexVisible => (zIndex) {
    assert(zIndex >= 0 && zIndex <= 5);
    return visible && this.zIndex == zIndex;
  };

  double get margin {
    return 2.0 / (_Metric.coreNoPaddingGrid / card.grid.minSpan) * _Metric.get().gridSize;
  }

  /// 手势类型.
  _CardGestureType gestureType;

  /// 是否拦截手势.
  bool get absorbPointer => gestureType == _CardGestureType.absorb;

  /// 是否忽略手势.
  bool get ignorePointer => gestureType == _CardGestureType.ignore;
}

/// 卡片手势类型.
enum _CardGestureType {
  /// 正常接收处理手势.
  normal,
  /// 拦截手势, 自己不处理, 下层 Widget 也无法处理.
  absorb,
  /// 忽略手势, 自己不处理, 下层 Widget 可以处理.
  ignore,
}
