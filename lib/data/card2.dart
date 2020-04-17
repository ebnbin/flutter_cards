part of '../data.dart';

//*********************************************************************************************************************

/// 网格卡片.
class _GridCard2 extends _GridCard {
  _GridCard2(_Screen screen, {
    int verticalRowGridIndex = 0,
    int verticalColumnGridIndex = 0,
    int verticalRowGridSpan = 1,
    int verticalColumnGridSpan = 1,
    int horizontalRowGridIndex = 0,
    int horizontalColumnGridIndex = 0,
    int horizontalRowGridSpan = 1,
    int horizontalColumnGridSpan = 1,
    double rotateX = 0.0,
    double rotateY = 0.0,
    double rotateZ = 0.0,
    double translateX = 0.0,
    double translateY = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    int zIndex = 1,
    double radius = 4.0,
    double opacity = 1.0,
    double elevation = 1.0,
    bool visible = true,
    _GestureType gestureType = _GestureType.normal,
    void Function(_Card card) onTap,
    void Function(_Card card) onLongPress,
  }) : super(screen,
    zIndex: zIndex,
    visible: visible,
    mainRadius: radius,
    opacity: opacity,
    mainElevation: elevation,
    rotateX: rotateX,
    rotateY: rotateY,
    rotateZ: rotateZ,
    translateX: translateX,
    translateY: translateY,
    scaleX: scaleX,
    scaleY: scaleY,
    gestureType: gestureType,
    onTap: onTap,
    onLongPress: onLongPress,
    verticalRowGridIndex: verticalRowGridIndex,
    verticalColumnGridIndex: verticalColumnGridIndex,
    verticalRowGridSpan: verticalRowGridSpan,
    verticalColumnGridSpan: verticalColumnGridSpan,
    horizontalRowGridIndex: horizontalRowGridIndex,
    horizontalColumnGridIndex: horizontalColumnGridIndex,
    horizontalRowGridSpan: horizontalRowGridSpan,
    horizontalColumnGridSpan: horizontalColumnGridSpan,
  ) {
    this.onLongPress = (card) {
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
          gridCard.animateShow(
            duration: 200,
            beginDelay: 200,
          ).begin();
        } else {
          gridCard.animateHide(
            duration: 200,
          ).begin();
        }
      });
    };
  }

  //*******************************************************************************************************************

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

  Rect get mainRect {
    if (big) {
      return Metric.get().coreNoPaddingRect;
    } else {
      return smallRect;
    }
  }

  //*******************************************************************************************************************

  double get margin {
    if (big) {
      return 2.0 / 1.0 * Metric.get().gridSize;
    } else {
      return 2.0 / (Metric.coreNoPaddingGrid / min(rowGridSpan, columnGridSpan)) * Metric.get().gridSize;
    }
  }

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
        card.mainElevation = _ValueCalc.aba(1.0, 7.0 / 8.0).calc(value);
      },
      onBegin: (card) {
        card.zIndex = 0;
      },
      onEnd: (card) {
        card.zIndex = 1;
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
          card.mainRadius = _ValueCalc.ab(4.0, 4.0).calc(value);
          (card as _GridCard2).big = false;
        } else {
          card.translateX = _ValueCalc.ab(-translateXSmall, 0.0).calc(value);
          card.translateY = _ValueCalc.ab(-translateYSmall, 0.0).calc(value);
          card.rotateX = _ValueCalc.ab(-_VisibleAngle.counterClockwise180.value, 0.0).calc(value);
          card.scaleX = _ValueCalc.ab(1.0 / scaleXSmall, 1.0).calc(value);
          card.scaleY = _ValueCalc.ab(1.0 / scaleYSmall, 1.0).calc(value);
          card.mainRadius = _ValueCalc.ab(16.0, 16.0).calc(value);
          (card as _GridCard2).big = true;
        }
      },
      onBegin: (card) {
        card.mainElevation = 4.0;
        card.zIndex = 3;
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
          card.mainRadius = _ValueCalc.ab(16.0, 16.0).calc(value);
          (card as _GridCard2).big = true;
        } else {
          card.translateX = _ValueCalc.ab(translateXSmall, 0.0).calc(value);
          card.translateY = _ValueCalc.ab(translateYSmall, 0.0).calc(value);
          card.rotateX = _ValueCalc.ab(-_VisibleAngle.clockwise180.value, 0.0).calc(value);
          card.scaleX = _ValueCalc.ab(scaleXSmall, 1.0).calc(value);
          card.scaleY = _ValueCalc.ab(scaleYSmall, 1.0).calc(value);
          card.mainRadius = _ValueCalc.ab(4.0, 4.0).calc(value);
          (card as _GridCard2).big = false;
        }
      },
      onBegin: (card) {
      },
      onHalf: (card) {
      },
      onEnd: (card) {
        card.mainElevation = 1.0;
        card.zIndex = 1;
      },
    );
  }
}

//*********************************************************************************************************************

/// Core 卡片.
class _CoreCard extends _GridCard2 {
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
    int zIndex = 1,
    double radius = 4.0,
    double opacity = 1.0,
    bool visible = true,
    _GestureType gestureType = _GestureType.normal,
    void Function(_Card card) onTap,
    void Function(_Card card) onLongPress,
  }) : super(screen,
    translateX: translateX,
    translateY: translateY,
    rotateX: rotateX,
    rotateY: rotateY,
    rotateZ: rotateZ,
    scaleX: scaleX,
    scaleY: scaleY,
    elevation: elevation,
    zIndex: zIndex,
    radius: radius,
    opacity: opacity,
    visible: visible,
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
    _GestureType gestureType = _GestureType.normal,
    void Function(_Card card) onTap,
    void Function(_Card card) onLongPress,
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
    gestureType: gestureType,
    onTap: onTap,
    onLongPress: onLongPress,
  ) {
    this.onTap = (card) {
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
        card.mainElevation = _ValueCalc.ab(0.5, 1.0).calc(value);
      },
      onBegin: (card) {
        card.visible = true;
        card.rotateY = _InvisibleAngle.clockwise90.value;
        card.scaleX = 0.5;
        card.scaleY = 0.5;
        card.mainElevation = 0.5;
        card.zIndex = 0;
      },
      onEnd: (card) {
        card.zIndex = 1;
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
        card.mainElevation = _ValueCalc.ab(1.0, 0.5).calc(value);
      },
      onBegin: (card) {
        card.zIndex = 0;
      },
      onEnd: (card) {
        card.visible = false;
        card.rotateY = _InvisibleAngle.counterClockwise90.value;
        card.scaleX = 0.5;
        card.scaleY = 0.5;
        card.mainElevation = 0.5;
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
        card.mainElevation = _ValueCalc.ab(0.5, 1.0).calc(value);
      },
      onBegin: (card) {
        card.visible = true;
        card.rotateY = rotateY;
        card.scaleX = 0.5;
        card.scaleY = 0.5;
        card.mainElevation = 0.5;
        card.zIndex = 0;
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
        card.mainElevation = _ValueCalc.ab(1.0, 0.5).calc(value);
      },
      onBegin: (card) {
        card.zIndex = 0;
      },
      onEnd: (card) {
        card.visible = false;
        card.rotateY = rotateY;
        card.scaleX = 0.5;
        card.scaleY = 0.5;
        card.mainElevation = 0.5;
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
    _GestureType gestureType = _GestureType.normal,
    void Function(_Card card) onTap,
    void Function(_Card card) onLongPress,
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
