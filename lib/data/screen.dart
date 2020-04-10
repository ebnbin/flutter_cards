part of '../data.dart';

//*********************************************************************************************************************

/// 屏幕.
abstract class _Screen {
  _Screen(this.type, {
    this.square,
  }) : cards = List.filled(length(type, square), _Card.placeholder,
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
      _Animation.sample(sampleCard).begin();
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

  static int length(_ScreenType type, int square) {
    int length = 0;
    length += square * square;
    length += 1; // sample.
    length += 6; // dev.
    return length;
  }

  /// 屏幕类型.
  final _ScreenType type;

  /// Core 卡片行列数. 2 ~ 6.
  final int square;

  /// 所有卡片.
  final List<_Card> cards;
}

//*********************************************************************************************************************

/// 开屏.
class _SplashScreen extends _Screen {
  _SplashScreen() : super(
    _ScreenType.splash,
    square: 4,
  );
}

//*********************************************************************************************************************

/// 一局游戏.
class _GameScreen extends _Screen {
  _GameScreen({
    int square,
  }) : super(_ScreenType.game,
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
      _Animation.spriteFirstEnter(spriteCard).begin();
    });
  }

  void removeSpriteCards() {
    spriteCards.build().forEach((spriteCard) {
      _Animation.spriteLastExit(spriteCard,
        endCallback: () {
          cards[spriteCard.index] = _SpriteCard.placeholder(this);
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
