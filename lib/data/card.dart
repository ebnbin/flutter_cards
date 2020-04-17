part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************
// 卡片.

/// 卡片.
abstract class _Card {
  _Card(this.screen, {
    this.zIndex = 1,
    this.visible = true,
    this.rotateX = 0.0,
    this.rotateY = 0.0,
    this.rotateZ = 0.0,
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.opacity = 1.0,
    this.elevation = 1.0,
    this.radius = 4.0,
    this.gestureType = _GestureType.normal,
    this.onTap,
    this.onLongPress,
  });

  final _Screen screen;

  /// 当前卡片在 [screen.cards] 中的索引.
  int get index {
    return screen.cards.indexOf(this);
  }

  /// [Stack] 中的索引. 数字越大在越上层. 范围 0 ~ 3.
  ///
  /// 0: 在做下沉动画.
  ///
  /// 1: 默认.
  ///
  /// 2: 在做上升动画.
  ///
  /// 3: 在顶层做动画.
  int zIndex;

  /// 是否可见.
  bool visible;

  /// 在 [Stack] 的 [zIndex] 上是否可见.
  ///
  /// [zIndex] 范围 0 ~ 3.
  bool Function(int zIndex) get zIndexVisible {
    return (zIndex) {
      assert(zIndex >= 0 && zIndex <= 3);
      return max(0, min(3, this.zIndex)) == zIndex && visible;
    };
  }

  /// 定位矩形.
  Rect get rect;

  /// Matrix4.setEntry(3, 2, value). 数值只与卡片尺寸相关.
  double get matrix4Entry32 {
    // 数值越大, 3d 旋转镜头越近, 效果越明显, 但越容易绘制异常.
    return 0.4 / max(rect.width, rect.height);
  }

  double rotateX;
  double rotateY;
  double rotateZ;
  double translateX;
  double translateY;
  double scaleX;
  double scaleY;

  /// 卡片变换.
  Matrix4 get transform {
    return Matrix4.identity()..setEntry(3, 2, matrix4Entry32)
      ..rotateX(rotateX)
      ..rotateY(rotateY)
      ..rotateZ(rotateZ)
      ..leftTranslate(translateX, translateY)
      ..scale(scaleX, scaleY);
  }

  /// 透明度.
  double opacity;

  /// 厚度. 建议范围 0.0 ~ 4.0.
  double elevation;

  /// 圆角. 建议范围 4.0.
  double radius;

  //*******************************************************************************************************************

  /// 手势类型.
  _GestureType gestureType;

  /// 是否拦截手势.
  bool get absorbPointer {
    return gestureType == _GestureType.absorb;
  }

  /// 是否忽略手势.
  bool get ignorePointer {
    return gestureType == _GestureType.ignore;
  }

  /// 点击事件.
  void Function(_Card card) onTap;

  /// 长按事件.
  void Function(_Card card) onLongPress;

  //*******************************************************************************************************************

  @override
  String toString() {
    return '$index';
  }
}
