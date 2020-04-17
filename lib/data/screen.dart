part of '../data.dart';

//*********************************************************************************************************************

/// 屏幕.
abstract class _Screen {
  _Screen(this.game, {
    this.square,
  }) : cards = List.filled(length(square), null,
    growable: false,
  ) {
    _GridCard sampleCard = _GridCard(this,
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
      sampleCard.animateSample().begin();
    };
    cards[0] = sampleCard;
    for (int i = 0; i < 6; i++) {
      _GridCard devCard = _GridCard(this,
        verticalRowGridIndex: 80,
        verticalColumnGridIndex: 1 + i * 10,
        verticalRowGridSpan: 10,
        verticalColumnGridSpan: 10,
        horizontalRowGridIndex: 1 + i * 10,
        horizontalColumnGridIndex: 80,
        horizontalRowGridSpan: 10,
        horizontalColumnGridSpan: 10,
      );
      cards[i + 1] = devCard;
    }
  }

  final _Game game;

  static int length(int square) {
    int length = 0;
    length += square * square;
    length += 1; // sample.
    length += 6; // dev.
    return length;
  }

  /// Core 卡片行列数. 3 ~ 5.
  final int square;

  /// 所有卡片.
  final List<_Card> cards;

  final _ActionQueue actionQueue = _ActionQueue();
}

//*********************************************************************************************************************

/// 开屏.
class _SplashScreen extends _Screen {
  _SplashScreen(_Game game) : super(game,
    square: 4,
  );
}

//*********************************************************************************************************************

/// 一局游戏.
class _GameScreen extends _Screen {
  _GameScreen(_Game game, {
    int square,
  }) : super(game,
    square: square,
  ) {
    (cards[1] as _GridCard).onTap = () {
      addSpriteCards();
    };
    (cards[2] as _GridCard).onTap = () {
      removeSpriteCards();
    };
  }

  /// 精灵卡片.
  List<_SpriteCard> get spriteCards {
    List<_SpriteCard> list = <_SpriteCard>[];
    cards.forEach((element) {
      if (element is _SpriteCard) {
        list.add(element);
      }
    });
    return list;
  }

  /// 玩家卡片.
  _PlayerCard get playerCard {
    return cards.firstWhere((element) {
      return element is _PlayerCard;
    }) as _PlayerCard;
  }

  void addSpriteCards() {
    int index = 7;
    _PlayerCard playerCard = _PlayerCard.random(this);
    cards[index++] = playerCard;
    for (int rowIndex = 0; rowIndex < square; rowIndex++) {
      for (int columnIndex = 0; columnIndex < square; columnIndex++) {
        if (rowIndex == playerCard.rowIndex && columnIndex == playerCard.columnIndex) {
          continue;
        }
        cards[index++] = _SpriteCard(this,
          rowIndex: rowIndex,
          columnIndex: columnIndex,
        );
      }
    }
    spriteCards.forEach((spriteCard) {
      spriteCard.animateSpriteFirstEnter().begin();
    });
  }

  void removeSpriteCards() {
    List<_Action> actions0 = <_Action>[];
    List.unmodifiable(spriteCards).forEach((spriteCard) {
      actions0.add(spriteCard.animateSpriteLastExit().action());
    });
    List<_Action> actions1 = [
      _Action.run((action) {
        spriteCards.forEach((element) {
          cards[element.index] = null;
        });
      }),
    ];
    actionQueue.add(actions0);
    actionQueue.add(actions1);
  }
}
