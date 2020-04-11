part of '../data.dart';

//*********************************************************************************************************************

class Card {
  Card._(this._card);

  final _Card _card;

  bool get absorbPointer {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.absorbPointer;
    }
    return null;
  }

  Color get color => Colors.white;

  double get elevation {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.elevation;
    }
    return null;
  }

  bool get ignorePointer {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.ignorePointer;
    }
    return null;
  }

  double get margin {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.margin;
    }
    return null;
  }

  GestureLongPressCallback get onLongPress {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.onLongPress;
    }
    return null;
  }

  GestureTapCallback get onTap {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.onTap;
    }
    return null;
  }

  double get opacity {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.opacity;
    }
    return null;
  }

  double get radius {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.radius;
    }
    return null;
  }

  Rect get rect => _card.rect;

  Matrix4 get transform {
    if (_card is _GridCard) {
      _GridCard gridCard = _card as _GridCard;
      return gridCard.transform;
    }
    return null;
  }

  bool Function(int zIndex) get zIndexVisible => _card.zIndexVisible;

  @override
  String toString() {
    return _card.toString();
  }
}

//*********************************************************************************************************************

class _Card {
  const _Card();

  static const int placeholderIndex = -2;

  static final _Card placeholder = const _Card();

  Rect get rect => Rect.zero;

  bool Function(int zIndex) get zIndexVisible => (_) => false;

  int get index => placeholderIndex;

  //*******************************************************************************************************************

  @override
  String toString() {
    return '$index';
  }
}

//*********************************************************************************************************************

/// 网格卡片.
class _GridCard extends _Card {
  _GridCard(this.screen, {
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
  }) {
    this.onLongPress = () {
      if (big) {
        _Animation.gridSmall(this).begin();
      } else {
        _Animation.gridBig(this).begin();
      }
      screen.cards.forEach((element) {
        if (element is! _GridCard) {
          return;
        }
        if (identical(this, element)) {
          return;
        }
        if (big) {
          _Animation.gridShow(element).begin();
        } else {
          _Animation.gridHide(element).begin();
        }
      });
    };
  }

  final _Screen screen;

  //*******************************************************************************************************************

  /// 当前卡片在 [screen.cards] 中的 index.
  int get index => screen.cards.indexOf(this);

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
//    if (big) {
//      return Metric.coreNoPaddingGrid / Metric.coreNoPaddingGrid / 800.0;
//    } else {
      return Metric.coreNoPaddingGrid / maxGridSpan / 800.0;
//    }
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
        Metric.get().coreCardGrid(screen.square);
  }
  set rowIndex(int coreRowIndex) {
    verticalRowGridIndex = Metric.get().coreCardGrid(screen.square) * coreRowIndex + Metric.paddingGrid + Metric.headerFooterGrid;
    horizontalRowGridIndex = Metric.get().coreCardGrid(screen.square) * coreRowIndex + Metric.paddingGrid;
  }

  /// 列.
  int get columnIndex {
    return (columnGridIndex - Metric.paddingGrid - (Metric.get().isVertical ? 0 : Metric.headerFooterGrid)) ~/
        Metric.get().coreCardGrid(screen.square);
  }
  set columnIndex(int coreColumnIndex) {
    verticalColumnGridIndex = Metric.get().coreCardGrid(screen.square) * coreColumnIndex + Metric.paddingGrid;
    horizontalColumnGridIndex = Metric.get().coreCardGrid(screen.square) * coreColumnIndex + Metric.paddingGrid +
        Metric.headerFooterGrid;
  }

  /// 跨行.
  int get rowSpan {
    return rowGridSpan ~/ Metric.get().coreCardGrid(screen.square);
  }
  set rowSpan(int coreRowSpan) {
    rowGridSpan = Metric.get().coreCardGrid(screen.square) * coreRowSpan;
  }

  /// 跨列.
  int get columnSpan {
    return columnGridSpan ~/ Metric.get().coreCardGrid(screen.square);
  }
  set columnSpan(int coreColumnSpan) {
    columnGridSpan = Metric.get().coreCardGrid(screen.square) * coreColumnSpan;
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
  _SpriteCard(_GameScreen screen, {
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
    // 精灵卡片必须是可交互的.
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
        _Animation.gridTremble(this).begin();
        return;
      }
      AxisDirection nextDirection = playerCard.nextNonEdge(flipAxisDirection(direction), notDirection: direction);
      BuiltList<_SpriteCard> adjacentCardAll = playerCard.adjacentCardAll(nextDirection);
      assert(adjacentCardAll.isNotEmpty);
      _SpriteCard newCard = _SpriteCard(gameScreen,
        rowIndex: adjacentCardAll.last.rowIndex,
        columnIndex: adjacentCardAll.last.columnIndex,
      );
      int index = this.index;

      List<_Action> actions0 = <_Action>[
        _Animation.spriteExit(this).action(),
        _Animation.spriteMove(playerCard, direction: direction, beginDelay: 250).action(),
      ];
      List<_Action> actions1 = <_Action>[
        _Action.run((action) {
          gameScreen.cards[index] = newCard;
        }),
      ];
      adjacentCardAll.forEach((element) {
        actions1.add(_Animation.spriteMove(element, direction: flipAxisDirection(nextDirection)).action());
      });
      actions1.add(_Animation.spriteEnter(newCard, beginDelay: 250).action());

      screen.actionQueue.addList(actions0);
      screen.actionQueue.addList(actions1);
    };
  }

  _GameScreen get gameScreen => screen as _GameScreen;

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
    return gameScreen.spriteCards.firstWhere((element) {
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
  BuiltList<_SpriteCard> adjacentCardAll(AxisDirection direction) {
    List<_SpriteCard> list = <_SpriteCard>[];
    if (!edge(direction)) {
      List<_SpriteCard> spriteCards = gameScreen.spriteCards;
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
    return list.build();
  }

  /// 如果指定方向在边缘, 按 [clockwise] 顺序返回第一个不是边缘的方向.
  AxisDirection nextNonEdge(AxisDirection direction, {
    AxisDirection notDirection,
    bool clockwise = false,
  }) {
    for (AxisDirection currentDirection in direction.turns(clockwise: clockwise)) {
      if (currentDirection != notDirection && !edge(currentDirection)) {
        return currentDirection;
      }
    }
    return null;
  }
}

//*********************************************************************************************************************

/// 玩家卡片.
class _PlayerCard extends _SpriteCard {
  _PlayerCard(_GameScreen screen, {
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
  static _PlayerCard random(_GameScreen screen) {
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

extension _AxisDirectionExtension on AxisDirection {
  /// 按照 [clockwise] 顺时针或逆时针顺序依次返回从当前方向开始的四个方向列表.
  BuiltList<AxisDirection> turns({
    bool clockwise = false,
  }) {
    List<AxisDirection> list = AxisDirection.values + AxisDirection.values;
    if (!clockwise) {
      list = list.reversed.toList();
    }
    int start = list.indexOf(this);
    return list.sublist(start, start + AxisDirection.values.length).toBuiltList();
  }

  int get x {
    switch (this) {
      case AxisDirection.up:
        return 0;
      case AxisDirection.right:
        return 1;
      case AxisDirection.down:
        return 0;
      case AxisDirection.left:
        return -1;
      default:
        throw Exception();
    }
  }

  int get y {
    switch (this) {
      case AxisDirection.up:
        return -1;
      case AxisDirection.right:
        return 0;
      case AxisDirection.down:
        return 1;
      case AxisDirection.left:
        return 0;
      default:
        throw Exception();
    }
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
