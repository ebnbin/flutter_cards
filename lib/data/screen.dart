part of '../data.dart';

//*********************************************************************************************************************

/// 屏幕.
abstract class _Screen {
  _Screen(this.type, {
    this.square,
  });

  void init() {
    _Card sampleCard = _Card(this,
      verticalRowGridIndex: 1,
      verticalColumnGridIndex: 1,
      verticalRowGridSpan: 15,
      verticalColumnGridSpan: 10,
      horizontalRowGridIndex: 1,
      horizontalColumnGridIndex: 1,
      horizontalRowGridSpan: 10,
      horizontalColumnGridSpan: 15,
    );
    sampleCard.onTap = () {
      _Animation.sample(sampleCard).begin();
    };
    testCards.add(sampleCard);
    for (int i = 0; i < 6; i++) {
      _Card devCard = _Card(this,
        verticalRowGridIndex: 80,
        verticalColumnGridIndex: 1 + i * 10,
        verticalRowGridSpan: 10,
        verticalColumnGridSpan: 10,
        horizontalRowGridIndex: 1 + i * 10,
        horizontalColumnGridIndex: 80,
        horizontalRowGridSpan: 10,
        horizontalColumnGridSpan: 10,
      );
      testCards.add(devCard);
    }
  }

  /// 屏幕类型.
  final _ScreenType type;

  /// Core 卡片行列数. 2 ~ 6.
  final int square;

  /// 开发用.
  List<_Card> testCards = <_Card>[];

  /// 返回所有卡片.
  BuiltList<_Card> get cards;
}

//*********************************************************************************************************************

/// 开屏.
class _SplashScreen extends _Screen {
  _SplashScreen() : super(
    _ScreenType.splash,
    square: 4,
  );

  @override
  BuiltList<_Card> get cards {
    return (<_Card>[]..addAll(testCards)).build();
  }
}

//*********************************************************************************************************************

/// 一局游戏.
class _GameScreen extends _Screen {
  _GameScreen({
    int square,
  }) : super(_ScreenType.game,
    square: square,
  );

  /// 精灵卡片.
  List<_SpriteCard> spriteCards;

  @override
  BuiltList<_Card> get cards {
    return (<_Card>[]..addAll(spriteCards)..addAll(testCards)).build();
  }

  @override
  void init() {
    super.init();
    spriteCards = List.filled(square * square, _SpriteCard.placeholder(this),
      growable: false,
    );
    testCards[1].onTap = () {
      addSpriteCards();
    };
    testCards[2].onTap = () {
      removeSpriteCards();
    };
  }

  void addSpriteCards() {
    int index = 0;
    _PlayerCard playerCard = _PlayerCard.random(this);
    spriteCards[index++] = playerCard;
    for (int rowIndex = 0; rowIndex < square; rowIndex++) {
      for (int columnIndex = 0; columnIndex < square; columnIndex++) {
        if (rowIndex == playerCard.rowIndex && columnIndex == playerCard.columnIndex) {
          continue;
        }
        spriteCards[index++] = _SpriteCard(this,
          rowIndex: rowIndex,
          columnIndex: columnIndex,
        );
      }
    }
    spriteCards.forEach((spriteCard) {
      _Animation.spriteFirstEnter(spriteCard).begin();
    });
  }

  void removeSpriteCards() {
    spriteCards.build().forEach((spriteCard) {
      _Animation.spriteLastExit(spriteCard,
        endCallback: () {
          spriteCards[spriteCard.index] = _SpriteCard.placeholder(this);
        },
      ).begin();
    });
  }
}

/// 屏幕类型.
enum _ScreenType {
  splash,
  game,
}
