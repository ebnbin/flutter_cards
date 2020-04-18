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
}
