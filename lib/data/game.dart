part of '../data.dart';

//*********************************************************************************************************************

/// 游戏数据.
///
/// 有效行列范围: 2 ~ 6. Header footer 固定都是 2 * 6. 网格粒度 60. 2, 3, 4, 5, 6 都是 60 的约数.
class _Game implements Game {
  _Game({
    this.callback,
  }) {
    this.data = _GameData(this);
  }

  final GameCallback callback;

  //*******************************************************************************************************************

  /// 行列数. 不包括 header footer.
  int square = 4;

  //*******************************************************************************************************************

  void initCards() {
    for (int rowIndex = 0; rowIndex < square; rowIndex++) {
      for (int columnIndex = 0; columnIndex < square; columnIndex++) {
        coreCards.add(_CoreCard(
          game: this,
          rowIndex: rowIndex,
          columnIndex: columnIndex,
          sprite: _CardSprite(isPlayer: rowIndex == 0 && columnIndex == 0),
        ));
      }
    }
    cards.add(_Card(
      game: this,
      verticalRowGridIndex: 6,
      verticalColumnGridIndex: 1,
      verticalRowGridSpan: 10,
      verticalColumnGridSpan: 10,
      horizontalRowGridIndex: 1,
      horizontalColumnGridIndex: 6,
      horizontalRowGridSpan: 10,
      horizontalColumnGridSpan: 10,
      type: _CardType.headerFooter,
      sprite: _CardSprite(),
    ));
    cards.add(_Card(
      game: this,
      verticalRowGridIndex: 6,
      verticalColumnGridIndex: 11,
      verticalRowGridSpan: 10,
      verticalColumnGridSpan: 15,
      horizontalRowGridIndex: 11,
      horizontalColumnGridIndex: 1,
      horizontalRowGridSpan: 10,
      horizontalColumnGridSpan: 15,
      type: _CardType.headerFooter,
      sprite: _CardSprite(),
    ));
  }

  //*******************************************************************************************************************

  /// 存储所有卡片.
  List<_Card> cards = <_Card>[];
  List<_CoreCard> coreCards = <_CoreCard>[];

  //*******************************************************************************************************************

  /// 事件管理.
  final _ActionQueue actionQueue = _ActionQueue(
    max: 1,
  );

  //*******************************************************************************************************************

  _GridPainter gridPainter;
  _GridForegroundPainter gridForegroundPainter;

  //*******************************************************************************************************************
  // 用户操作.

  Function onTap(_Card card) {
    assert(card != null);
    return () {
      if (card.type == _CardType.core) {
//        _LTRB ltrb = playerCard.grid.coreRelative(card);
//        switch (ltrb) {
//          case _LTRB.left:
//            break;
//          case _LTRB.top:
//            break;
//          case _LTRB.right:
//            break;
//          case _LTRB.bottom:
//            break;
//          default:
//            break;
//        }
//
//        if (card.state != _CardState.idle || !actionQueue.canAdd()) {
//          return;
//        }
//        _Card rightCard = card.rightCard;
//        if (rightCard == null || rightCard.state != _CardState.idle) {
//          return;
//        }
//        _Card newCard = _Card(
//          game: this,
//          /*opacity: 0.0*/
//          grid: _CardGrid.core(rowIndex: rightCard.grid.coreRowIndex, columnIndex: rightCard.grid.coreColumnIndex, rowSpan: 1, columnSpan: 1),
//          property: _CardProperty(),
//          isCoreCard: true,
//          sprite: _Sprite(),
//        );
//        int oldIndex = card.index;
//
//        card.state = _CardState.pending;
//        rightCard.state = _CardState.pending;
//        newCard.state = _CardState.pending;
//        callback.setState(() {
//        });
//
//        List<_Action> actions0 = [
//          _CardAnimation.flipOut(
//            duration: 500,
//            angleY: _InvisibleAngle.counterClockwise90,
//            beginProperty: (card, value) {
//              card.state = _CardState.acting;
//            },
//            endProperty: (card, value) {
//              card.state = _CardState.idle;
//            },
//          ).action(card),
//          _CardAnimation.moveCoreCard(
//            duration: 500,
//            x: -1,
//            beginDelay: 250,
//            beginProperty: (card, value) {
//              card.state = _CardState.acting;
//            },
//            endProperty: (card, value) {
//              card.grid.coreColumnIndex = card.grid.coreColumnIndex - 1;
//              card.property.translateX = 0.0;
//              card.property.translateY = 0.0;
//              card.state = _CardState.idle;
//            },
//          ).action(rightCard),
//        ];
//        List<_Action> actions1 = [
//          _CardAnimation.flipIn(
//            duration: 500,
//            beginDelay: 500,
//            angleY: _InvisibleAngle.counterClockwise90,
//            beginProperty: (card, value) {
//              coreCards[oldIndex] = card;
//              card.state = _CardState.acting;
//            },
//            endProperty: (card, value) {
//              card.state = _CardState.idle;
//            },
//          ).action(newCard)
//        ];
//        actionQueue.addList(actions0);
//        actionQueue.addList(actions1);
        _Animation.coreEnter(card).begin();
      } else {
        _Animation.sample(card).begin();
      }
    };
  }

  Function onLongPress(_Card card) {
    assert(card != null);
    return null;
  }

  //*******************************************************************************************************************

  bool firstBuild = true;

  void build() {
    _Metric.build(this);

    if (firstBuild) {
      firstBuild = false;
      initCards();
      gridPainter = _GridPainter();
      gridForegroundPainter = _GridForegroundPainter();
    }
  }

  void dispose() {
    _Metric.dispose();
  }
  
  @override
  GameData data;
}

class _GameData implements GameData {
  _GameData(this.game);
  
  final _Game game;
  
  @override
  void build() {
    game.build();
  }

  @override
  void dispose() {
    game.dispose();
  }

  @override
  BuiltList<Card> get cards => (<_Card>[]..addAll(game.coreCards)..addAll(game.cards)).build();

  @override
  CustomPainter get foregroundPainter => game.gridForegroundPainter;

  @override
  CustomPainter get painter => game.gridPainter;

  @override
  Rect get headerRect => _Metric.get().headerUnsafeRect;

  @override
  Rect get footerRect => _Metric.get().footerUnsafeRect;
}
