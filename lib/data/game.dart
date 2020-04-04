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
  int size = 4;

  //*******************************************************************************************************************

  void initCards() {
    for (int rowIndex = 0; rowIndex < size; rowIndex++) {
      for (int columnIndex = 0; columnIndex < size; columnIndex++) {
        _Card card = _Card(
          game: this,
          grid: _Grid.coreCard(metric: metric, rowIndex: rowIndex, columnIndex: columnIndex, rowSpan: 1, columnSpan: 1),
        );
        cards.add(card);
      }
    }
    cards.add(_Card(
      game: this,
      grid: _Grid(metric: metric, verticalRowIndex: 6, verticalColumnIndex: 1, verticalRowSpan: 10, verticalColumnSpan: 10,
          horizontalRowIndex: 1, horizontalColumnIndex: 6, horizontalRowSpan: 10, horizontalColumnSpan: 10),
    ));
    cards.add(_Card(
      game: this,
      grid: _Grid(metric: metric, verticalRowIndex: 6, verticalColumnIndex: 11, verticalRowSpan: 10, verticalColumnSpan: 15,
          horizontalRowIndex: 11, horizontalColumnIndex: 1, horizontalRowSpan: 10, horizontalColumnSpan: 15),
    ));
  }

  //*******************************************************************************************************************

  /// 存储所有卡片.
  List<_Card> cards = [];

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

  Function onTap({
    @required
    _Card card,
  }) {
    assert(card != null);
    return () {
      if (card.grid.isCoreCard) {
        if (card.state != _CardState.idle || !actionQueue.canAdd()) {
          return;
        }
        _Card rightCard = card.rightCard;
        if (rightCard == null || rightCard.state != _CardState.idle) {
          return;
        }
        _Card newCard = _Card(
          game: this,
          /*opacity: 0.0*/
          grid: _Grid.coreCard(metric: metric, rowIndex: rightCard.grid.coreCardRowIndex, columnIndex: rightCard.grid.coreCardColumnIndex, rowSpan: 1, columnSpan: 1),
        );
        int oldIndex = card.index;

        card.state = _CardState.pending;
        rightCard.state = _CardState.pending;
        newCard.state = _CardState.pending;
        callback.setState(() {
        });

        _Action action0 = _CardAnimation.flipOut(
          duration: 500,
          angleY: _InvisibleAngle.counterClockwise90,
          beginProperty: (card, value) {
            card.state = _CardState.acting;
          },
          endProperty: (card, value) {
            card.state = _CardState.idle;
          },
        ).action(card);
        _Action action1 = _CardAnimation.moveCoreCard(
          duration: 500,
          x: -1,
          beginDelay: 250,
          beginProperty: (card, value) {
            card.state = _CardState.acting;
          },
          endProperty: (card, value) {
            card.grid.coreCardColumnIndex = card.grid.coreCardColumnIndex - 1;
            card.reset();
            card.state = _CardState.idle;
          },
        ).action(rightCard);
        _Action action2 = _CardAnimation.flipIn(
          duration: 500,
          beginDelay: 500,
          angleY: _InvisibleAngle.counterClockwise90,
          beginProperty: (card, value) {
            cards[oldIndex] = card;
            card.state = _CardState.acting;
          },
          endProperty: (card, value) {
            card.state = _CardState.idle;
          },
        ).action(newCard);
        List<_Action> actions = [action0, action1, action2];
        actionQueue.addList(actions);
      } else {
        _CardAnimation.sample().begin(card);
      }
    };
  }

  Function onLongPress({
    @required
    _Card card,
  }) {
    assert(card != null);
    return null;
  }

  //*******************************************************************************************************************

  _Metric metric;
  _MetricCache metricCache;

  bool firstBuild = true;

  void build() {
    MediaQueryData mediaQueryData = MediaQuery.of(callback.context);
    _MetricCache metricCache = _MetricCache(mediaQueryData, size);
    if (this.metricCache != metricCache) {
      this.metricCache = metricCache;
      metric = _Metric.build(mediaQueryData, size);
    }

    if (firstBuild) {
      firstBuild = false;
      initCards();
      gridPainter = _GridPainter(
        metric: metric,
      );
      gridForegroundPainter = _GridForegroundPainter(
        metric: metric,
      );
    } else {
      cards.forEach((element) {
        element.grid.metric = metric;
      });
      gridPainter.metric = metric;
      gridForegroundPainter.metric = metric;
    }
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
  BuiltList<Card> get cards => game.cards.build();

  @override
  CustomPainter get foregroundPainter => game.gridForegroundPainter;

  @override
  CustomPainter get painter => game.gridPainter;

  @override
  Rect get headerRect => game.metric.headerBoardUnsafeRect;

  @override
  Rect get footerRect => game.metric.footerBoardUnsafeRect;
}
