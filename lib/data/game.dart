part of '../data.dart';

//*********************************************************************************************************************

/// 游戏数据.
///
/// 有效行列范围: 2 ~ 6. Header footer 固定都是 2 * 6. 网格粒度 60. 2, 3, 4, 5, 6 都是 60 的约数.
class _Game implements Game {
  _Game({
    this.callback,
  }) {
//    build();
    initCards();
  }

  final GameCallback callback;

  //*******************************************************************************************************************

  /// 行数. 不包括 header footer.
  int rowCount = 6;
  /// 列数. 不包括 header footer.
  int columnCount = 6;

  //*******************************************************************************************************************

  void initCards() {
//    print(calcMap['gridPerCard']);
    for (int rowIndex = 0; rowIndex < rowCount; rowIndex++) {
      for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
//        if (rowIndex == 2 && (columnIndex == 1 || columnIndex == 2)) {
//          continue;
//        }
        _IndexCard card = _IndexCard(
          game: this,
          rowIndex: rowIndex,
          columnIndex: columnIndex,
          rowSpan: 1,
          columnSpan: 1,
        );
        _cards.add(card);
      }
    }
//    _cards.add(_IndexCard(
//      game: this,
//      rowIndex: 2,
//      columnIndex: 1,
//      rowSpan: 1,
//      columnSpan: 2,
//    ));
    _cards.add(_GridCard(
      game: this,
      rowGrid: (isVertical) => isVertical ? 0 : 0,
      columnGrid: (isVertical) => isVertical ? 0 : 0,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cards.add(_GridCard(
      game: this,
      rowGrid: (isVertical) => isVertical ? 10 : 10,
      columnGrid: (isVertical) => isVertical ? 0 : 0,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 20 : 20,
    ));
    _cards.add(_GridCard(
      game: this,
      rowGrid: (isVertical) => isVertical ? 88 : 0,
      columnGrid: (isVertical) => isVertical ? 0 : 88,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cards.add(_GridCard(
      game: this,
      rowGrid: (isVertical) => isVertical ? 88 : 10,
      columnGrid: (isVertical) => isVertical ? 10 : 88,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cards.add(_GridCard(
      game: this,
      rowGrid: (isVertical) => isVertical ? 88 : 20,
      columnGrid: (isVertical) => isVertical ? 20 : 88,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cards.add(_GridCard(
      game: this,
      rowGrid: (isVertical) => isVertical ? 88 : 30,
      columnGrid: (isVertical) => isVertical ? 30 : 88,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cards.add(_GridCard(
      game: this,
      rowGrid: (isVertical) => isVertical ? 88 : 40,
      columnGrid: (isVertical) => isVertical ? 40 : 88,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 10 : 10,
    ));
    _cards.add(_GridCard(
      game: this,
      rowGrid: (isVertical) => isVertical ? 88 : 50,
      columnGrid: (isVertical) => isVertical ? 50 : 88,
      rowGridSpan: (isVertical) => isVertical ? 10 : 10,
      columnGridSpan: (isVertical) => isVertical ? 10 : 10,
    ));
  }

  //*******************************************************************************************************************

  /// 存储所有卡片.
  List<_Card> _cards = [];
  @override
  BuiltList<Card> get cards {
    return _cards.build();
  }

  //*******************************************************************************************************************

  /// 安全矩形.
  @override
  Rect get safeRect {
    return calcMap['safeRect'];
  }

  /// 游戏面板矩形.
  @override
  Rect get boardRect {
    return calcMap['boardRect'];
  }

  //*******************************************************************************************************************

  /// 事件管理.
  final _ActionQueue actionQueue = _ActionQueue(
//    max: 1,
  );

  //*******************************************************************************************************************
  // 用户操作.

  @override
  Function onTap({
    @required
    Card card,
  }) {
    assert(card != null);
    return () {
      if (card is _IndexCard) {
        card._color = Colors.grey;
        callback.setState(() {
        });
        actionQueue.add(_Action.run((_Action action) {
          card._color = Colors.green;
          callback.setState(() {
          });
        }));
        actionQueue.add(
          _PropertyAnimation.flipOut(
            angleY: _InvisibleAngle.counterClockwise90,
          ).action(card)
        );
        if (card.rightCard != null && card.rightCard is _IndexCard) {
          _IndexCard rightCard = card.rightCard;
          _IndexCard newCard = _IndexCard(
            game: this,
            rowIndex: rightCard.rowIndex,
            columnIndex: rightCard.columnIndex,
            rowSpan: 1,
            columnSpan: 1,
            initProperty: _Property.def(/*opacity: 0.0*/),
          );

          actionQueue.add(
            _PropertyAnimation.moveCoreCard(
              metrics: metrics,
              x: -1,
            ).action(rightCard)
          );
          actionQueue.add(_Action.run((_Action action) {
            rightCard.left();
            rightCard._property = _Property.def();

            _cards[card.index] = newCard;

            callback.setState(() {
            });
          },
          )
          );
          actionQueue.add(
            _PropertyAnimation.flipIn(
              angleY: _InvisibleAngle.counterClockwise90,
            ).action(newCard)
          );
        }
      } else {
        List<_PropertyAnimation> animations = <_PropertyAnimation>[
          _PropertyAnimation.sample(),
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

  @override
  Function onLongPress({
    @required
    Card card,
  }) {
    assert(card != null);
    return null;
  }

  //*******************************************************************************************************************

  Map<String, dynamic> calc() {
    const double padding = 8.0;
    // 默认网格数. 竖屏时水平方向的网格数, 或横屏时垂直方向的网格数.
    const int defaultGridCount = 60;
    // Header 和 footer 占用的网格数. 竖屏时占用高度, 横屏时占用宽度. 其中 8 格是 header footer 和 body 的间距.
    const int headerFooterGridCount = 48;

    MediaQueryData mediaQueryData = MediaQuery.of(callback.context);
    double safeWidth = mediaQueryData.size.width - mediaQueryData.padding.horizontal;
    double safeHeight = mediaQueryData.size.height - mediaQueryData.padding.vertical;
    bool isVertical = safeWidth <= safeHeight;
    // 水平方向网格数量.
    int horizontalGridCount;
    // 垂直方向网格数量.
    int verticalGridCount;
    // 游戏面板水平方向网格数量.
    int boardHorizontalGridCount;
    // 游戏面板垂直方向网格数量.
    int boardVerticalGridCount;
    // 每个卡片占用几个网格.
    int gridPerCard;
    if (isVertical) {
      // 竖屏.
      horizontalGridCount = defaultGridCount;
      verticalGridCount = defaultGridCount ~/ columnCount * rowCount + headerFooterGridCount;
      boardHorizontalGridCount = horizontalGridCount;
      boardVerticalGridCount = verticalGridCount - headerFooterGridCount;
      gridPerCard = defaultGridCount ~/ columnCount;
    } else {
      // 横屏.
      verticalGridCount = defaultGridCount;
      horizontalGridCount = defaultGridCount ~/ rowCount * columnCount + headerFooterGridCount;
      boardHorizontalGridCount = horizontalGridCount - headerFooterGridCount;
      boardVerticalGridCount = verticalGridCount;
      gridPerCard = defaultGridCount ~/ rowCount;
    }
    // 网格宽高.
    double gridSize = min(
      (safeWidth - padding * 2.0) / horizontalGridCount,
      (safeHeight - padding * 2.0) / verticalGridCount,
    );

    double safeRectWidth = gridSize * horizontalGridCount + padding * 2.0;
    double safeRectHeight = gridSize * verticalGridCount + padding * 2.0;
    Rect safeRect = Rect.fromLTWH(
      (safeWidth - safeRectWidth) / 2.0,
      (safeHeight - safeRectHeight) / 2.0,
      safeRectWidth,
      safeRectHeight,
    );

    double boardRectWidth = gridSize * boardHorizontalGridCount + padding * 2.0;
    double boardRectHeight = gridSize * boardVerticalGridCount + padding * 2.0;
    Rect boardRect = Rect.fromLTWH(
      (safeWidth - boardRectWidth) / 2.0,
      (safeHeight - boardRectHeight) / 2.0,
      boardRectWidth,
      boardRectHeight,
    );

    // 左边距.
    double gridCardSpaceLeft = ((safeWidth - padding * 2.0) - gridSize * horizontalGridCount) / 2.0 + padding;
    // 上边距.
    double gridCardSpaceTop = ((safeHeight - padding * 2.0) - gridSize * verticalGridCount) / 2.0 + padding;

    // 卡片宽高.
    double cardSize = gridSize * gridPerCard;
    double headerFooterCardSize = gridSize * 10;

    metrics = {
      Metric.gridSize: gridSize,
      Metric.coreCardSize: cardSize,
      Metric.headerFooterCardSize: headerFooterCardSize,
    };

    return {
      'safeRect': safeRect,
      'boardRect': boardRect,
      'gridCardSpaceLeft': gridCardSpaceLeft,
      'gridCardSpaceTop': gridCardSpaceTop,
      'gridSize': gridSize,
      'isVertical': isVertical,
      'gridPerCard': gridPerCard,
      'cardSize': cardSize,
    };
  }
  
  Map<String, dynamic> calcMap;

  Map<Metric, dynamic> metrics;

  @override
  void build() {
    calcMap = calc();
  }

  //*******************************************************************************************************************
}

enum Metric {
  gridSize,
  coreCardSize,
  headerFooterCardSize,
}
