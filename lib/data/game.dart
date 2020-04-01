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
//    print(calcMap['gridPerCard']);
    for (int rowIndex = 0; rowIndex < size; rowIndex++) {
      for (int columnIndex = 0; columnIndex < size; columnIndex++) {
//        if (rowIndex == 2 && (columnIndex == 1 || columnIndex == 2)) {
//          continue;
//        }
        _Card card = _Card(
          game: this,
          initProperty: _Property(
            grid: _Grid.coreCard(metric: metric, rowIndex: rowIndex, columnIndex: columnIndex, rowSpan: 1, columnSpan: 1),
          ),
        );
        cards.add(card);
      }
    }
//    _cards.add(_IndexCard(
//      game: this,
//      rowIndex: 2,
//      columnIndex: 1,
//      rowSpan: 1,
//      columnSpan: 2,
//    ));
    cards.add(_Card(
      game: this,
      initProperty: _Property(
        grid: _Grid(metric: metric, verticalRowIndex: 6, verticalColumnIndex: 1, verticalRowSpan: 10, verticalColumnSpan: 10,
            horizontalRowIndex: 1, horizontalColumnIndex: 6, horizontalRowSpan: 10, horizontalColumnSpan: 10),
      ),
    ));
//    _cards.add(_Card(
//      game: this,
//      initProperty: _Property(
//        grid: _Grid(metric: _metric, verticalRowIndex: 17, verticalColumnIndex: 2, verticalRowSpan: 15, verticalColumnSpan: 30,
//          horizontalRowIndex: 17, horizontalColumnIndex: 2, horizontalRowSpan: 15, horizontalColumnSpan: 30,),
//      ),
//    ));
//    _cards.add(_Card(
//      game: this,
//      initProperty: _Property(
//        metric: _metric,
//        orientationGrid: (isVertical) => isVertical
//            ? _Grid(verticalRowIndex: 160, verticalColumnIndex: 2, verticalRowSpan: 20, verticalColumnSpan: 20)
//            : _Grid(verticalRowIndex: 2, verticalColumnIndex: 160, verticalRowSpan: 20, verticalColumnSpan: 20),
//      ),
//    ));
//    _cards.add(_Card(
//      game: this,
//      initProperty: _Property(
//        metric: _metric,
//        orientationGrid: (isVertical) => isVertical
//            ? _Grid(verticalRowIndex: 160, verticalColumnIndex: 22, verticalRowSpan: 20, verticalColumnSpan: 20)
//            : _Grid(verticalRowIndex: 22, verticalColumnIndex: 160, verticalRowSpan: 20, verticalColumnSpan: 20),
//      ),
//    ));
//    _cards.add(_Card(
//      game: this,
//      initProperty: _Property(
//        metric: _metric,
//        orientationGrid: (isVertical) => isVertical
//            ? _Grid(verticalRowIndex: 160, verticalColumnIndex: 42, verticalRowSpan: 20, verticalColumnSpan: 20)
//            : _Grid(verticalRowIndex: 42, verticalColumnIndex: 160, verticalRowSpan: 20, verticalColumnSpan: 20),
//      ),
//    ));
//    _cards.add(_Card(
//      game: this,
//      initProperty: _Property(
//        metric: _metric,
//        orientationGrid: (isVertical) => isVertical
//            ? _Grid(verticalRowIndex: 160, verticalColumnIndex: 62, verticalRowSpan: 20, verticalColumnSpan: 20)
//            : _Grid(verticalRowIndex: 62, verticalColumnIndex: 160, verticalRowSpan: 20, verticalColumnSpan: 20),
//      ),
//    ));
//    _cards.add(_Card(
//      game: this,
//      initProperty: _Property(
//        metric: _metric,
//        orientationGrid: (isVertical) => isVertical
//            ? _Grid(verticalRowIndex: 160, verticalColumnIndex: 82, verticalRowSpan: 20, verticalColumnSpan: 20)
//            : _Grid(verticalRowIndex: 82, verticalColumnIndex: 160, verticalRowSpan: 20, verticalColumnSpan: 20),
//      ),
//    ));
//    _cards.add(_Card(
//      game: this,
//      initProperty: _Property(
//        metric: _metric,
//        orientationGrid: (isVertical) => isVertical
//            ? _Grid(verticalRowIndex: 160, verticalColumnIndex: 102, verticalRowSpan: 20, verticalColumnSpan: 20)
//            : _Grid(verticalRowIndex: 102, verticalColumnIndex: 160, verticalRowSpan: 20, verticalColumnSpan: 20),
//      ),
//    ));
  }

  //*******************************************************************************************************************

  /// 存储所有卡片.
  List<_Card> cards = [];

  //*******************************************************************************************************************

  /// 事件管理.
  final _ActionQueue actionQueue = _ActionQueue(
//    max: 1,
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
      if (card.property.grid.isCoreCard) {
        card.property.color = Colors.grey;
        callback.setState(() {
        });
        actionQueue.add(_Action.run((_Action action) {
          card.property.color = Colors.green;
          callback.setState(() {
          });
        }));
        actionQueue.add(
          _CardAnimation.flipOut(
            angleY: _InvisibleAngle.counterClockwise90,
          ).action(card)
        );
        if (card.rightCard != null && card.rightCard.property.grid.isCoreCard) {
          _Card rightCard = card.rightCard;
          _Card newCard = _Card(
            game: this,
            initProperty: _Property(/*opacity: 0.0*/
              grid: _Grid.coreCard(metric: metric, rowIndex: rightCard.property.grid.coreCardRowIndex, columnIndex: rightCard.property.grid.coreCardColumnIndex, rowSpan: 1, columnSpan: 1),
            ),
          );

          actionQueue.add(
            _CardAnimation.moveCoreCard(
              metric: metric,
              x: -1,
            ).action(rightCard)
          );
          actionQueue.add(_Action.run((_Action action) {
            rightCard.property.grid.coreCardColumnIndex = rightCard.property.grid.coreCardColumnIndex - 1;
            rightCard.property.reset();

            cards[card.index] = newCard;

            callback.setState(() {
            });
          },
          )
          );
          actionQueue.add(
            _CardAnimation.flipIn(
              angleY: _InvisibleAngle.counterClockwise90,
            ).action(newCard)
          );
        }
      } else {
        List<_CardAnimation> animations = <_CardAnimation>[
          _CardAnimation.sample(),
//          _PropertyAnimation.rotateXYIn(
//            invisibleRotateY: _InvisibleRotate.clockwise270,
//          ),
//          _PropertyAnimation.rotateXYOut(
//            invisibleRotateX: _InvisibleRotate.counterClockwise90,
//          ),
//          _PropertyAnimation.translate(
//            translateX: -metrics[Metric.cardSize],
//            translateY: metrics[Metric.cardSize],
//          ),
//          _PropertyAnimation.translateIndex(
//            metrics: metrics,
//            indexX: -1,
//          ),
        ];
        animations[Random().nextInt(animations.length)].begin(card);
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
        element.property.grid.metric = metric;
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
}
