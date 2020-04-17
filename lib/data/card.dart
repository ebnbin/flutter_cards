part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************

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

  /// 演示动画.
  _Animation<_Card> animateSample() {
    return _Animation<_Card>(this,
      duration: 800,
      curve: Curves.easeInOut,
      onAnimating: (card, value) {
        card.rotateY = _ValueCalc.ab(0.0, _VisibleAngle.clockwise360.value).calc(value);
        card.scaleX = _ValueCalc.aba(1.0, 2.0).calc(value);
        card.scaleY = _ValueCalc.aba(1.0, 2.0).calc(value);
        card.elevation = _ValueCalc.aba(1.0, 2.0).calc(value);
        card.radius = _ValueCalc.aba(4.0, 8.0).calc(value);
      },
      onBegin: (card) {
        card.zIndex = 2;
      },
      onEnd: (card) {
        card.zIndex = 1;
        card.rotateY = 0.0;
      },
    );
  }

  /// 透明度隐藏动画.
  _Animation<_Card> animateHide({
    int duration = 400,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeOut,
      onAnimating: (card, value) {
        card.opacity = _ValueCalc.ab(1.0, 0.0).calc(value);
      },
    );
  }

  /// 透明度显示动画.
  _Animation<_Card> animateShow({
    int duration = 400,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeIn,
      onAnimating: (card, value) {
        card.opacity = _ValueCalc.ab(0.0, 1.0).calc(value);
      },
    );
  }

  //*******************************************************************************************************************

  @override
  String toString() {
    return '$index';
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 通过网格定位的卡片.
abstract class _GridCard extends _Card {
  _GridCard(_Screen screen, {
    int zIndex = 1,
    bool visible = true,
    double rotateX = 0.0,
    double rotateY = 0.0,
    double rotateZ = 0.0,
    double translateX = 0.0,
    double translateY = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    double opacity = 1.0,
    double elevation = 1.0,
    double radius = 4.0,
    _GestureType gestureType = _GestureType.normal,
    void Function(_Card card) onTap,
    void Function(_Card card) onLongPress,
    this.verticalRowGridIndex = 0,
    this.verticalColumnGridIndex = 0,
    this.verticalRowGridSpan = 1,
    this.verticalColumnGridSpan = 1,
    this.horizontalRowGridIndex = 0,
    this.horizontalColumnGridIndex = 0,
    this.horizontalRowGridSpan = 1,
    this.horizontalColumnGridSpan = 1,
  }) : super(screen,
    zIndex: zIndex,
    visible: visible,
    rotateX: rotateX,
    rotateY: rotateY,
    rotateZ: rotateZ,
    translateX: translateX,
    translateY: translateY,
    scaleX: scaleX,
    scaleY: scaleY,
    opacity: opacity,
    elevation: elevation,
    radius: radius,
    gestureType: gestureType,
    onTap: onTap,
    onLongPress: onLongPress,
  );

  /// 竖屏网格行.
  int verticalRowGridIndex;
  /// 竖屏网格列.
  int verticalColumnGridIndex;
  /// 竖屏网格跨行.
  int verticalRowGridSpan;
  /// 竖屏网格跨列.
  int verticalColumnGridSpan;
  /// 横屏网格行.
  int horizontalRowGridIndex;
  /// 横屏网格列.
  int horizontalColumnGridIndex;
  /// 横屏网格跨行.
  int horizontalRowGridSpan;
  /// 横屏网格跨列.
  int horizontalColumnGridSpan;

  /// 当前屏幕旋转方向的网格行.
  int get rowGridIndex {
    return Metric.get().isVertical ? verticalRowGridIndex : horizontalRowGridIndex;
  }
  set rowGridIndex(int rowGridIndex) {
    verticalRowGridIndex = rowGridIndex;
    horizontalRowGridIndex = rowGridIndex;
  }

  /// 当前屏幕旋转方向的网格列.
  int get columnGridIndex {
    return Metric.get().isVertical ? verticalColumnGridIndex : horizontalColumnGridIndex;
  }
  set columnGridIndex(int columnGridIndex) {
    verticalColumnGridIndex = columnGridIndex;
    horizontalColumnGridIndex = columnGridIndex;
  }

  /// 当前屏幕旋转方向的网格跨行.
  int get rowGridSpan {
    return Metric.get().isVertical ? verticalRowGridSpan : horizontalRowGridSpan;
  }
  set rowGridSpan(int rowGridSpan) {
    verticalRowGridSpan = rowGridSpan;
    horizontalRowGridSpan = rowGridSpan;
  }

  /// 当前屏幕旋转方向的网格跨列.
  int get columnGridSpan {
    return Metric.get().isVertical ? verticalColumnGridSpan : horizontalColumnGridSpan;
  }
  set columnGridSpan(int columnGridSpan) {
    verticalColumnGridSpan = columnGridSpan;
    horizontalColumnGridSpan = columnGridSpan;
  }
}
