part of '../data.dart';

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
    mainElevation: elevation,
    mainRadius: radius,
    mainOpacity: opacity,
    // 精灵卡片初始化时是不可见的, 通过动画出现.
    visible: false,
    gestureType: gestureType,
    onTap: onTap,
    onLongPress: onLongPress,
  ) {
    this.onTap = (card) {
      if (dimension != _CardDimension.main) {
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
      onAnimating: (card, value, half) {
        if (half) {
          card.rowIndex += direction.y;
          card.columnIndex += direction.x;
        }
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
      onAnimating: (card, value, half) {
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
      onAnimating: (card, value, half) {
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
      onAnimating: (card, value, half) {
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
      onAnimating: (card, value, half) {
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
