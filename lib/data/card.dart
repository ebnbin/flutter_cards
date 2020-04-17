part of '../data.dart';

//*********************************************************************************************************************

class _Card {
  _Card(this.screen);

  final _Screen screen;

  Rect get rect => Rect.zero;

  bool Function(int zIndex) get zIndexVisible => (_) => false;

  /// 当前卡片在 [screen.cards] 中的 index.
  int get index => screen.cards.indexOf(this);

  //*******************************************************************************************************************

  @override
  String toString() {
    return '$index';
  }
}

//*********************************************************************************************************************

/// 网格卡片.
class _GridCard extends _Card {
  _GridCard(_Screen screen, {
    this.verticalRowGridIndex = 0,
    this.verticalColumnGridIndex = 0,
    this.verticalRowGridSpan = 1,
    this.verticalColumnGridSpan = 1,
    this.horizontalRowGridIndex = 0,
    this.horizontalColumnGridIndex = 0,
    this.horizontalRowGridSpan = 1,
    this.horizontalColumnGridSpan = 1,
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
    this.touchable = true,
    this.gestureType = _CardGestureType.normal,
    this.onTap,
    this.onLongPress,
  }) : super(screen) {
    this.onLongPress = () {
      if (big) {
        animateSmall().begin();
      } else {
        animateBig().begin();
      }
      screen.cards.forEach((element) {
        if (element == null) {
          return;
        }
        if (element is! _GridCard) {
          return;
        }
        if (identical(this, element)) {
          return;
        }
        _GridCard gridCard = element;
        if (big) {
          gridCard.animateShow().begin();
        } else {
          gridCard.animateHide().begin();
        }
      });
    };
  }

  //*******************************************************************************************************************

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
  set rowGridIndex(int rowIndex) {
    horizontalRowGridIndex = rowIndex;
    verticalRowGridIndex = rowIndex;
  }

  /// 当前屏幕旋转方向的网格列.
  int get columnGridIndex {
    return Metric.get().isVertical ? verticalColumnGridIndex : horizontalColumnGridIndex;
  }
  set columnGridIndex(int columnIndex) {
    horizontalColumnGridIndex = columnIndex;
    verticalColumnGridIndex = columnIndex;
  }

  /// 当前屏幕旋转方向的网格跨行.
  int get rowGridSpan {
    return Metric.get().isVertical ? verticalRowGridSpan : horizontalRowGridSpan;
  }
  set rowGridSpan(int rowSpan) {
    horizontalRowGridSpan = rowSpan;
    verticalRowGridSpan = rowSpan;
  }

  /// 当前屏幕旋转方向的网格跨列.
  int get columnGridSpan {
    return Metric.get().isVertical ? verticalColumnGridSpan : horizontalColumnGridSpan;
  }
  set columnGridSpan(int columnSpan) {
    horizontalColumnGridSpan = columnSpan;
    verticalColumnGridSpan = columnSpan;
  }

  /// 当前屏幕旋转方向的网格跨行跨列取小值.
  int get minGridSpan => min(rowGridSpan, columnGridSpan);
  /// 当前屏幕旋转方向的网格跨行跨列取大值.
  int get maxGridSpan => max(rowGridSpan, columnGridSpan);

  /// 当前是否是大卡片.
  bool big = false;

  Rect get smallRect {
    return Rect.fromLTWH(
      Metric.get().safeRect.left + columnGridIndex * Metric.get().gridSize,
      Metric.get().safeRect.top + rowGridIndex * Metric.get().gridSize,
      columnGridSpan * Metric.get().gridSize,
      rowGridSpan * Metric.get().gridSize,
    );
  }

  /// 网格矩形.
  Rect get rect {
    if (big) {
      return Metric.get().coreNoPaddingRect;
    } else {
      return smallRect;
    }
  }

  //*******************************************************************************************************************

  /// Matrix4.setEntry(3, 2, value);
  double get matrix4Entry32 {
    if (big) {
      return Metric.coreNoPaddingGrid / Metric.coreNoPaddingGrid / 800.0;
    } else {
      return Metric.coreNoPaddingGrid / maxGridSpan / 800.0;
    }
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
    ..rotateX(rotateX)
    ..rotateY(rotateY)
    ..rotateZ(rotateZ)
    ..leftTranslate(translateX, translateY)
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
  ///
  /// [zIndex] 范围 0 ~ 5.
  bool Function(int zIndex) get zIndexVisible => (zIndex) {
    assert(zIndex >= 0 && zIndex <= 5);
    return visible && this.zIndex == zIndex;
  };

  double get margin {
    if (big) {
      return 2.0 / 1.0 * Metric.get().gridSize;
    } else {
      return 2.0 / (Metric.coreNoPaddingGrid / minGridSpan) * Metric.get().gridSize;
    }
  }

  /// 是否可点击 (卡片是否可交互). 初始化后不可改变.
  final bool touchable;

  /// 手势类型.
  _CardGestureType gestureType;

  /// 是否拦截手势.
  bool get absorbPointer {
    if (!touchable) {
      return false;
    }
    return gestureType == _CardGestureType.absorb;
  }

  /// 是否忽略手势.
  bool get ignorePointer {
    if (!touchable) {
      return true;
    }
    return gestureType == _CardGestureType.ignore;
  }

  //*******************************************************************************************************************

  GestureTapCallback onTap;

  GestureLongPressCallback onLongPress;

  //*******************************************************************************************************************
//
//  @override
//  String toString() {
//    return '$verticalRowGridIndex,$verticalColumnGridIndex,$verticalRowGridSpan,$verticalColumnGridSpan\n'
//        '$horizontalRowGridIndex,$horizontalColumnGridIndex,$horizontalRowGridSpan,$horizontalColumnGridSpan';
//  }

  @override
  String toString() {
    String result = super.toString();
    if (big) {
      result += '\nBIG';
    }
    return result;
  }

  //*******************************************************************************************************************

  /// 用于演示.
  _Animation<_GridCard> animateSample() {
    return _Animation<_GridCard>(this,
      duration: 1000,
      curve: Curves.easeInOut,
      onAnimating: (card, value) {
        card.rotateY = _ValueCalc.ab(0.0, _VisibleAngle.clockwise360.value).calc(value);
        card.scaleX = _ValueCalc.aba(1.0, 2.0).calc(value);
        card.scaleY = _ValueCalc.aba(1.0, 2.0).calc(value);
        card.elevation = _ValueCalc.aba(1.0, 4.0).calc(value);
        card.radius = _ValueCalc.aba(4.0, 16.0).calc(value);
      },
      onEnd: (card) {
        card.rotateY = 0.0;
      },
    );
  }

  /// 卡片不可点击.
  _Animation<_GridCard> animateTremble({
    int duration = 250,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_GridCard>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeInOut,
      onAnimating: (card, value) {
        card.rotateY = _ValueCalc.aba(0.0, 1.0 / 8.0 * pi).calc(value);
        card.scaleX = _ValueCalc.aba(1.0, 7.0 / 8.0).calc(value);
        card.scaleY = _ValueCalc.aba(1.0, 7.0 / 8.0).calc(value);
        card.elevation = _ValueCalc.aba(1.0, 7.0 / 8.0).calc(value);
      },
    );
  }

  /// 小卡片 -> 大卡片.
  _Animation<_GridCard> animateBig() {
    double translateXSmall = Metric.get().coreNoPaddingRect.center.dx - smallRect.center.dx;
    double translateYSmall = Metric.get().coreNoPaddingRect.center.dy - smallRect.center.dy;
    double scaleXSmall = Metric.get().coreNoPaddingRect.width / smallRect.width;
    double scaleYSmall = Metric.get().coreNoPaddingRect.height / smallRect.height;
    return _Animation<_GridCard>(this,
      duration: 500,
      curve: Curves.easeInOut,
      onAnimating: (card, value) {
        if (value < 0.5) {
          card.translateX = _ValueCalc.ab(0.0, translateXSmall).calc(value);
          card.translateY = _ValueCalc.ab(0.0, translateYSmall).calc(value);
          card.rotateX = _ValueCalc.ab(0.0, _VisibleAngle.counterClockwise180.value).calc(value);
          card.scaleX = _ValueCalc.ab(1.0, scaleXSmall).calc(value);
          card.scaleY = _ValueCalc.ab(1.0, scaleYSmall).calc(value);
          card.radius = _ValueCalc.ab(4.0, 4.0).calc(value);
          card.big = false;
        } else {
          card.translateX = _ValueCalc.ab(-translateXSmall, 0.0).calc(value);
          card.translateY = _ValueCalc.ab(-translateYSmall, 0.0).calc(value);
          card.rotateX = _ValueCalc.ab(-_VisibleAngle.counterClockwise180.value, 0.0).calc(value);
          card.scaleX = _ValueCalc.ab(1.0 / scaleXSmall, 1.0).calc(value);
          card.scaleY = _ValueCalc.ab(1.0 / scaleYSmall, 1.0).calc(value);
          card.radius = _ValueCalc.ab(16.0, 16.0).calc(value);
          card.big = true;
        }
      },
      onBegin: (card) {
        card.elevation = 4.0;
      },
      onHalf: (card) {
      },
      onEnd: (card) {
      },
    );
  }

  /// 大卡片 -> 小卡片.
  _Animation<_GridCard> animateSmall() {
    double translateXSmall = Metric.get().coreNoPaddingRect.center.dx - smallRect.center.dx;
    double translateYSmall = Metric.get().coreNoPaddingRect.center.dy - smallRect.center.dy;
    double scaleXSmall = Metric.get().coreNoPaddingRect.width / smallRect.width;
    double scaleYSmall = Metric.get().coreNoPaddingRect.height / smallRect.height;
    return _Animation<_GridCard>(this,
      duration: 500,
      curve: Curves.easeInOut,
      onAnimating: (card, value) {
        if (value < 0.5) {
          card.translateX = _ValueCalc.ab(0.0, -translateXSmall).calc(value);
          card.translateY = _ValueCalc.ab(0.0, -translateYSmall).calc(value);
          card.rotateX = _ValueCalc.ab(0.0, _VisibleAngle.clockwise180.value).calc(value);
          card.scaleX = _ValueCalc.ab(1.0, 1.0 / scaleXSmall).calc(value);
          card.scaleY = _ValueCalc.ab(1.0, 1.0 / scaleYSmall).calc(value);
          card.radius = _ValueCalc.ab(16.0, 16.0).calc(value);
          card.big = true;
        } else {
          card.translateX = _ValueCalc.ab(translateXSmall, 0.0).calc(value);
          card.translateY = _ValueCalc.ab(translateYSmall, 0.0).calc(value);
          card.rotateX = _ValueCalc.ab(-_VisibleAngle.clockwise180.value, 0.0).calc(value);
          card.scaleX = _ValueCalc.ab(scaleXSmall, 1.0).calc(value);
          card.scaleY = _ValueCalc.ab(scaleYSmall, 1.0).calc(value);
          card.radius = _ValueCalc.ab(4.0, 4.0).calc(value);
          card.big = false;
        }
      },
      onBegin: (card) {
      },
      onHalf: (card) {
      },
      onEnd: (card) {
        card.elevation = 1.0;
      },
    );
  }

  /// 卡片隐藏.
  _Animation<_GridCard> animateHide({
    int duration = 500,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_GridCard>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeOut,
      onAnimating: (card, value) {
//        card.rotateX = _ValueCalc.ab(0.0, _InvisibleRotateXY.counterClockwise90.value).calc(value);
//        card.scaleX = _ValueCalc.ab(1.0, 0.5).calc(value);
//        card.scaleY = _ValueCalc.ab(1.0, 0.5).calc(value);
//        card.elevation = _ValueCalc.ab(1.0, 0.5).calc(value);
        if (value < 0.5) {
          card.opacity = _ValueCalc.ab(1.0, 0.0).calc(value * 2.0);
        }
      },
      onHalf: (card) {
        card.opacity = 0.0;
      },
      onEnd: (card) {
//        card.visible = false;
//        card.rotateX = _InvisibleRotateXY.counterClockwise90.value;
//        card.scaleX = 0.5;
//        card.scaleY = 0.5;
//        card.elevation = 0.5;
      },
    );
  }

  /// 卡片显示.
  _Animation<_GridCard> animateShow({
    int duration = 500,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_GridCard>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeIn,
      onAnimating: (card, value) {
//        card.rotateX = _ValueCalc.ab(_InvisibleRotateXY.clockwise90.value, 0.0).calc(value);
//        card.scaleX = _ValueCalc.ab(0.5, 1.0).calc(value);
//        card.scaleY = _ValueCalc.ab(0.5, 1.0).calc(value);
//        card.elevation = _ValueCalc.ab(0.5, 1.0).calc(value);
        if (value >= 0.5) {
          card.opacity = _ValueCalc.ab(0.0, 1.0).calc(value * 2.0 - 1.0);
        }
      },
      onBegin: (card) {
//        card.visible = true;
//        card.rotateX = _InvisibleRotateXY.clockwise90.value;
//        card.scaleX = 0.5;
//        card.scaleY = 0.5;
//        card.elevation = 0.5;
      },
      onEnd: (card) {
        card.opacity = 1.0;
      },
    );
  }
}

//*********************************************************************************************************************

/// Core 卡片.
class _CoreCard extends _GridCard {
  _CoreCard(_Screen screen, {
    int rowIndex = 0,
    int columnIndex = 0,
    int rowSpan = 1,
    int columnSpan = 1,
    double translateX = 0.0,
    double translateY = 0.0,
    double rotateX = 0.0,
    double rotateY = 0.0,
    double rotateZ = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    double elevation = 1.0,
    double radius = 4.0,
    double opacity = 1.0,
    bool visible = true,
    bool touchable = true,
    _CardGestureType gestureType = _CardGestureType.normal,
    GestureTapCallback onTap,
    GestureLongPressCallback onLongPress,
  }) : super(screen,
    translateX: translateX,
    translateY: translateY,
    rotateX: rotateX,
    rotateY: rotateY,
    rotateZ: rotateZ,
    scaleX: scaleX,
    scaleY: scaleY,
    elevation: elevation,
    radius: radius,
    opacity: opacity,
    visible: visible,
    touchable: touchable,
    gestureType: gestureType,
    onTap: onTap,
    onLongPress: onLongPress,
  ) {
    this.rowIndex = rowIndex;
    this.columnIndex = columnIndex;
    this.rowSpan = rowSpan;
    this.columnSpan = columnSpan;
  }

  //*******************************************************************************************************************

  /// 行.
  int get rowIndex {
    return (rowGridIndex - Metric.paddingGrid - (Metric.get().isVertical ? Metric.headerFooterGrid : 0)) ~/
        Metric.squareGridMap[screen.square];
  }
  set rowIndex(int coreRowIndex) {
    verticalRowGridIndex = Metric.squareGridMap[screen.square] * coreRowIndex + Metric.paddingGrid + Metric.headerFooterGrid;
    horizontalRowGridIndex = Metric.squareGridMap[screen.square] * coreRowIndex + Metric.paddingGrid;
  }

  /// 列.
  int get columnIndex {
    return (columnGridIndex - Metric.paddingGrid - (Metric.get().isVertical ? 0 : Metric.headerFooterGrid)) ~/
        Metric.squareGridMap[screen.square];
  }
  set columnIndex(int coreColumnIndex) {
    verticalColumnGridIndex = Metric.squareGridMap[screen.square] * coreColumnIndex + Metric.paddingGrid;
    horizontalColumnGridIndex = Metric.squareGridMap[screen.square] * coreColumnIndex + Metric.paddingGrid +
        Metric.headerFooterGrid;
  }

  /// 跨行.
  int get rowSpan {
    return rowGridSpan ~/ Metric.squareGridMap[screen.square];
  }
  set rowSpan(int coreRowSpan) {
    rowGridSpan = Metric.squareGridMap[screen.square] * coreRowSpan;
  }

  /// 跨列.
  int get columnSpan {
    return columnGridSpan ~/ Metric.squareGridMap[screen.square];
  }
  set columnSpan(int coreColumnSpan) {
    columnGridSpan = Metric.squareGridMap[screen.square] * coreColumnSpan;
  }

  //*******************************************************************************************************************
//
//  @override
//  String toString() {
//    return '${super.toString()}\n$rowIndex,$columnIndex,$rowSpan,$columnSpan';
//  }
}

//*********************************************************************************************************************

/// 精灵卡片.
class _SpriteCard extends _CoreCard {
  _SpriteCard(_SpriteScreen screen, {
    int rowIndex = 0,
    int columnIndex = 0,
    double translateX = 0.0,
    double translateY = 0.0,
    double rotateX = 0.0,
    double rotateY = 0.0,
    double rotateZ = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    double elevation = 1.0,
    double radius = 4.0,
    double opacity = 1.0,
    _CardGestureType gestureType = _CardGestureType.normal,
    GestureTapCallback onTap,
    GestureLongPressCallback onLongPress,
  }) : super(screen,
    rowIndex: rowIndex,
    columnIndex: columnIndex,
    // 精灵卡片只能占用一行.
    rowSpan: 1,
    // 精灵卡片只能占用一列.
    columnSpan: 1,
    translateX: translateX,
    translateY: translateY,
    rotateX: rotateX,
    rotateY: rotateY,
    rotateZ: rotateZ,
    scaleX: scaleX,
    scaleY: scaleY,
    elevation: elevation,
    radius: radius,
    opacity: opacity,
    // 精灵卡片初始化时是不可见的, 通过动画出现.
    visible: false,
    // 精灵卡片必需是可交互的.
    touchable: true,
    gestureType: gestureType,
    onTap: onTap,
    onLongPress: onLongPress,
  ) {
    this.onTap = () {
      if (big) {
        return;
      }
      _PlayerCard playerCard = screen.playerCard;
      assert(playerCard != null);
      AxisDirection direction = playerCard.adjacentDirection(this);
      if (direction == null) {
        animateTremble().begin();
        return;
      }
      AxisDirection nextDirection = playerCard.nextNonEdge(flipAxisDirection(direction), notDirection: direction);
      List<_SpriteCard> adjacentCardAll = playerCard.adjacentCardAll(nextDirection);
      assert(adjacentCardAll.isNotEmpty);
      _SpriteCard newCard = _SpriteCard(spriteScreen,
        rowIndex: adjacentCardAll.last.rowIndex,
        columnIndex: adjacentCardAll.last.columnIndex,
      );
      int index = this.index;

      List<_Action> actions0 = <_Action>[
        animateSpriteExit().action(),
        playerCard.animateSpriteMove(direction: direction, beginDelay: 250).action(),
      ];
      List<_Action> actions1 = <_Action>[
        _Action.run((action) {
          spriteScreen.cards[index] = newCard;
        }),
      ];
      adjacentCardAll.forEach((element) {
        actions1.add(element.animateSpriteMove(direction: flipAxisDirection(nextDirection)).action());
      });
      actions1.add(newCard.animateSpriteEnter(beginDelay: 250).action());

      screen.game.actionQueue.add(actions0);
      screen.game.actionQueue.add(actions1);
    };
  }

  _SpriteScreen get spriteScreen => screen as _SpriteScreen;

  //*******************************************************************************************************************

  /// 是否在指定方向 [direction] 边缘.
  bool edge(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.up:
        return rowIndex <= 0;
      case AxisDirection.right:
        return columnIndex >= screen.square - 1;
      case AxisDirection.down:
        return rowIndex >= screen.square - 1;
      case AxisDirection.left:
        return columnIndex <= 0;
      default:
        throw Exception();
    }
  }

  /// 从 [screen.spriteCards] 中返回当前卡片指定方向 [direction] 的卡片. 如果没符合条件的卡片则返回 null.
  _SpriteCard adjacentCard(AxisDirection direction) {
    if (edge(direction)) {
      return null;
    }
    return spriteScreen.spriteCards.firstWhere((element) {
      if (!element.visible) {
        return false;
      }
      switch (direction) {
        case AxisDirection.up:
          return element.rowIndex == rowIndex - 1 && element.columnIndex == columnIndex;
        case AxisDirection.right:
          return element.rowIndex == rowIndex && element.columnIndex == columnIndex + 1;
        case AxisDirection.down:
          return element.rowIndex == rowIndex + 1 && element.columnIndex == columnIndex;
        case AxisDirection.left:
          return element.rowIndex == rowIndex && element.columnIndex == columnIndex - 1;
        default:
          return false;
      }
    }, orElse: () => null);
  }

  /// 返回 [card] 在当前卡片的相邻方向. 如果不在任何方向则返回 null.
  AxisDirection adjacentDirection(_SpriteCard card) {
    if (card == null) {
      return null;
    }
    if (identical(adjacentCard(AxisDirection.up), card)) {
      return AxisDirection.up;
    }
    if (identical(adjacentCard(AxisDirection.right), card)) {
      return AxisDirection.right;
    }
    if (identical(adjacentCard(AxisDirection.down), card)) {
      return AxisDirection.down;
    }
    if (identical(adjacentCard(AxisDirection.left), card)) {
      return AxisDirection.left;
    }
    return null;
  }

  /// 从 [screen.spriteCards] 中返回当前卡片指定方向 [direction] 的所有卡片. 如果没符合条件的卡片则返回空列表.
  List<_SpriteCard> adjacentCardAll(AxisDirection direction) {
    List<_SpriteCard> list = <_SpriteCard>[];
    if (!edge(direction)) {
      List<_SpriteCard> spriteCards = spriteScreen.spriteCards;
      switch (direction) {
        case AxisDirection.up:
          for (int targetRow = rowIndex - 1; targetRow >= 0; targetRow--) {
            spriteCards.forEach((element) {
              if (!element.visible) {
                return;
              }
              if (element.rowIndex == targetRow && element.columnIndex == columnIndex) {
                list.add(element);
              }
            });
          }
          break;
        case AxisDirection.right:
          for (int targetColumn = columnIndex + 1; targetColumn <= screen.square - 1; targetColumn++) {
            spriteCards.forEach((element) {
              if (!element.visible) {
                return;
              }
              if (element.rowIndex == rowIndex && element.columnIndex == targetColumn) {
                list.add(element);
              }
            });
          }
          break;
        case AxisDirection.down:
          for (int targetRow = rowIndex + 1; targetRow <= screen.square - 1; targetRow++) {
            spriteCards.forEach((element) {
              if (!element.visible) {
                return;
              }
              if (element.rowIndex == targetRow && element.columnIndex == columnIndex) {
                list.add(element);
              }
            });
          }
          break;
        case AxisDirection.left:
          for (int targetColumn = columnIndex - 1; targetColumn >= 0; targetColumn--) {
            spriteCards.forEach((element) {
              if (!element.visible) {
                return;
              }
              if (element.rowIndex == rowIndex && element.columnIndex == targetColumn) {
                list.add(element);
              }
            });
          }
          break;
        default:
          throw Exception();
      }
    }
    return List.unmodifiable(list);
  }

  /// 如果指定方向在边缘, 按 [clockwise] 顺序返回第一个不是边缘的方向.
  AxisDirection nextNonEdge(AxisDirection direction, {
    AxisDirection notDirection,
    bool clockwise = false,
  }) {
    /// 按照 [clockwise] 从当前方向依次返回除了 [except] 之外的所有方向列表.
    ///
    /// 例如:
    ///
    /// up.sequence(clockwise: true, except: null) = [up, right, down, left]
    ///
    /// left.sequence(clockwise: false, except: up) = [left, down, right]
    List<AxisDirection> sequence(AxisDirection direction, {
      bool clockwise = false,
      AxisDirection except,
    }) {
      final List<AxisDirection> values = clockwise
          ? AxisDirection.values
          : List.unmodifiable(AxisDirection.values.reversed);
      final int start = values.indexOf(direction);
      return List.unmodifiable((values + values).sublist(start, start + values.length)
        ..removeWhere((element) => element == except));
    }

    for (AxisDirection currentDirection in sequence(direction, clockwise: clockwise, except: notDirection)) {
      if (!edge(currentDirection)) {
        return currentDirection;
      }
    }
    return null;
  }

  //*******************************************************************************************************************

  /// 精灵卡片移动.
  _Animation<_SpriteCard> animateSpriteMove({
    int beginDelay = 0,
    int endDelay = 0,
    @required
    AxisDirection direction,
  }) {
    return _Animation<_SpriteCard>(this,
      duration: 500,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeInOut,
      onAnimating: (card, value) {
        if (value < 0.5) {
          card.translateX = _ValueCalc.ab(0.0, Metric.get().squareSizeMap[card.screen.square] * direction.x)
              .calc(value);
          card.translateY = _ValueCalc.ab(0.0, Metric.get().squareSizeMap[card.screen.square] * direction.y)
              .calc(value);
        } else {
          card.translateX = _ValueCalc.ab(-Metric.get().squareSizeMap[card.screen.square] * direction.x, 0.0)
              .calc(value);
          card.translateY = _ValueCalc.ab(-Metric.get().squareSizeMap[card.screen.square] * direction.y, 0.0)
              .calc(value);
        }
      },
      onHalf: (card) {
        card.rowIndex += direction.y;
        card.columnIndex += direction.x;
        card.translateX = _ValueCalc.ab(-Metric.get().squareSizeMap[card.screen.square] * direction.x, 0.0)
            .calc(0.5);
        card.translateY = _ValueCalc.ab(-Metric.get().squareSizeMap[card.screen.square] * direction.y, 0.0)
            .calc(0.5);
      },
    );
  }

  /// 精灵卡片进入.
  _Animation<_SpriteCard> animateSpriteEnter({
    int duration = 500,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_SpriteCard>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeIn,
      onAnimating: (card, value) {
        card.rotateY = _ValueCalc.ab(_InvisibleAngle.clockwise90.value, 0.0).calc(value);
        card.scaleX = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.scaleY = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.elevation = _ValueCalc.ab(0.5, 1.0).calc(value);
      },
      onBegin: (card) {
        card.visible = true;
        card.rotateY = _InvisibleAngle.clockwise90.value;
        card.scaleX = 0.5;
        card.scaleY = 0.5;
        card.elevation = 0.5;
      },
    );
  }

  /// 精灵卡片退出.
  _Animation<_SpriteCard> animateSpriteExit({
    int duration = 500,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_SpriteCard>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeOut,
      onAnimating: (card, value) {
        card.rotateY = _ValueCalc.ab(0.0, _InvisibleAngle.counterClockwise90.value).calc(value);
        card.scaleX = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.scaleY = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.elevation = _ValueCalc.ab(1.0, 0.5).calc(value);
      },
      onEnd: (card) {
        card.visible = false;
        card.rotateY = _InvisibleAngle.counterClockwise90.value;
        card.scaleX = 0.5;
        card.scaleY = 0.5;
        card.elevation = 0.5;
      },
    );
  }

  /// 精灵卡片第一次进入.
  _Animation<_SpriteCard> animateSpriteFirstEnter() {
    double rotateY = _random.nextListItem(<double>[
      _InvisibleAngle.clockwise90.value,
      _InvisibleAngle.clockwise270.value,
    ]);
    return _Animation<_SpriteCard>(this,
      duration: _random.nextIntFromTo(500, 1000),
      beginDelay: _random.nextIntFromTo(0, 500),
      curve: Curves.easeOut,
      onAnimating: (card, value) {
        card.rotateY = _ValueCalc.ab(rotateY, 0.0).calc(value);
        card.scaleX = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.scaleY = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.elevation = _ValueCalc.ab(0.5, 1.0).calc(value);
      },
      onBegin: (card) {
        card.visible = true;
        card.rotateY = rotateY;
        card.scaleX = 0.5;
        card.scaleY = 0.5;
        card.elevation = 0.5;
      },
    );
  }

  /// 精灵卡片最后一次退出.
  _Animation<_SpriteCard> animateSpriteLastExit() {
    double rotateY = _random.nextListItem(<double>[
      _InvisibleAngle.counterClockwise90.value,
      _InvisibleAngle.counterClockwise270.value,
    ]);
    return _Animation<_SpriteCard>(this,
      duration: _random.nextIntFromTo(500, 1000),
      beginDelay: _random.nextIntFromTo(0, 500),
      curve: Curves.easeIn,
      onAnimating: (card, value) {
        card.rotateY = _ValueCalc.ab(0.0, rotateY).calc(value);
        card.scaleX = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.scaleY = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.elevation = _ValueCalc.ab(1.0, 0.5).calc(value);
      },
      onEnd: (card) {
        card.visible = false;
        card.rotateY = rotateY;
        card.scaleX = 0.5;
        card.scaleY = 0.5;
        card.elevation = 0.5;
      },
    );
  }
}

//*********************************************************************************************************************

/// 玩家卡片.
class _PlayerCard extends _SpriteCard {
  _PlayerCard(_SpriteScreen screen, {
    int rowIndex = 0,
    int columnIndex = 0,
    double translateX = 0.0,
    double translateY = 0.0,
    double rotateX = 0.0,
    double rotateY = 0.0,
    double rotateZ = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    double elevation = 1.0,
    double radius = 4.0,
    double opacity = 1.0,
    _CardGestureType gestureType = _CardGestureType.normal,
    GestureTapCallback onTap,
    GestureLongPressCallback onLongPress,
  }) : super(screen,
    rowIndex: rowIndex,
    columnIndex: columnIndex,
    translateX: translateX,
    translateY: translateY,
    rotateX: rotateX,
    rotateY: rotateY,
    rotateZ: rotateZ,
    scaleX: scaleX,
    scaleY: scaleY,
    elevation: elevation,
    radius: radius,
    opacity: opacity,
    gestureType: gestureType,
    onTap: onTap,
    onLongPress: onLongPress,
  );

  /// 创建一个随机位置的玩家卡片.
  static _PlayerCard random(_SpriteScreen screen) {
    int from = screen.square > 2 ? 1 : 0;
    int to = screen.square > 2 ? (screen.square - 2) : (screen.square - 1);
    return _PlayerCard(screen,
      rowIndex: _random.nextIntFromTo(from, to),
      columnIndex: _random.nextIntFromTo(from, to),
    );
  }

  @override
  String toString() {
    return '${super.toString()}\nPlayer';
  }
}

//*********************************************************************************************************************

/// 卡片手势类型.
enum _CardGestureType {
  /// 正常接收处理手势.
  normal,
  /// 拦截手势, 自己不处理, 下层 Widget 也无法处理.
  absorb,
  /// 忽略手势, 自己不处理, 下层 Widget 可以处理.
  ignore,
}
