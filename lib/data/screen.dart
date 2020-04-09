part of '../data.dart';

//*********************************************************************************************************************

/// 屏幕.
abstract class _Screen {
  _Screen(this.type, {
    this.square,
  });

  void init() {
    testCards.add(_Card(this,
      type: _CardType.sample,
      verticalRowGridIndex: 1,
      verticalColumnGridIndex: 1,
      verticalRowGridSpan: 15,
      verticalColumnGridSpan: 10,
      horizontalRowGridIndex: 1,
      horizontalColumnGridIndex: 1,
      horizontalRowGridSpan: 10,
      horizontalColumnGridSpan: 15,
    ));
    List<_CardType> cardTypes = <_CardType>[
      _CardType.dev0,
      _CardType.dev1,
      _CardType.dev2,
      _CardType.dev3,
      _CardType.dev4,
      _CardType.dev5,
    ];
    for (int i = 0; i < 6; i++) {
      testCards.add(_Card(this,
        type: cardTypes[i],
        verticalRowGridIndex: 80,
        verticalColumnGridIndex: 1 + i * 10,
        verticalRowGridSpan: 10,
        verticalColumnGridSpan: 10,
        horizontalRowGridIndex: 1 + i * 10,
        horizontalColumnGridIndex: 80,
        horizontalRowGridSpan: 10,
        horizontalColumnGridSpan: 10,
      ));
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

  //*******************************************************************************************************************

  GestureTapCallback onTap(_Card card) {
    if (card.type == _CardType.sample) {
      return () {
        _Animation.sample(card).begin();
      };
    }
    return null;
  }

  GestureLongPressCallback onLongPress(_Card card) {
    return null;
  }
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
  }

  @override
  onTap(_Card card) {
    if (card.type == _CardType.dev0) {
      return () {
        addSpriteCards();
      };
    } else if (card.type == _CardType.dev1) {
      return () {
        removeSpriteCards();
      };
    }
    return super.onTap(card);
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
      if (spriteCard.type == _CardType.placeholder) {
        return;
      }
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
