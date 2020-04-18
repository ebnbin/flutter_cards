part of '../data.dart';

//*********************************************************************************************************************

/// 精灵卡片.
class _SpriteCard2 extends _SpriteCard {
  _SpriteCard2(_SpriteScreen screen, {
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
      AxisDirection nextDirection = playerCard.nextNonEdgeDirection(flipAxisDirection(direction));
      List<_SpriteCard2> adjacentCardAll = playerCard.adjacentCardAll(nextDirection);
      assert(adjacentCardAll.isNotEmpty);
      _SpriteCard2 newCard = _SpriteCard2(spriteScreen,
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

  //*******************************************************************************************************************

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
      listener: (card, value, first, half, last) {
        if (first) {
          card.zIndex = 0;
        }
        if (last) {
          card.visible = false;
          card.rotateY = _InvisibleAngle.counterClockwise90.value;
          card.scaleX = 0.5;
          card.scaleY = 0.5;
          card.mainElevation = 0.5;
        }
        card.rotateY = _ValueCalc.ab(0.0, _InvisibleAngle.counterClockwise90.value).calc(value);
        card.scaleX = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.scaleY = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.mainElevation = _ValueCalc.ab(1.0, 0.5).calc(value);
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
      listener: (card, value, first, half, last) {
        if (first) {
          card.visible = true;
          card.rotateY = rotateY;
          card.scaleX = 0.5;
          card.scaleY = 0.5;
          card.mainElevation = 0.5;
          card.zIndex = 0;
        }
        card.rotateY = _ValueCalc.ab(rotateY, 0.0).calc(value);
        card.scaleX = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.scaleY = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.mainElevation = _ValueCalc.ab(0.5, 1.0).calc(value);
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
      listener: (card, value, first, half, last) {
        if (first) {
          card.zIndex = 0;
        }
        if (last) {
          card.visible = false;
          card.rotateY = rotateY;
          card.scaleX = 0.5;
          card.scaleY = 0.5;
          card.mainElevation = 0.5;
        }
        card.rotateY = _ValueCalc.ab(0.0, rotateY).calc(value);
        card.scaleX = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.scaleY = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.mainElevation = _ValueCalc.ab(1.0, 0.5).calc(value);
      },
    );
  }
}

//*********************************************************************************************************************

/// 玩家卡片.
class _PlayerCard extends _SpriteCard2 {
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
