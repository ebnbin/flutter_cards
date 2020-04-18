part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************
// 游戏.

/// 游戏.
class _Game {
  _Game(this.callback) {
    screen = _SplashScreen(this);
  }

  final GameCallback callback;

  /// 事件队列.
  final _ActionQueue actionQueue = _ActionQueue();

  /// 当前屏幕. 始终不为 null.
  _Screen screen;
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 屏幕.

/// 屏幕.
abstract class _Screen {
  _Screen(this.game, {
    @required
    this.square,
    @required
    int cardLength,
  }) : cards = List<_Card>.filled(cardLength, null, growable: false);

  final _Game game;

  /// 方格数. 范围 3, 4, 5.
  final int square;

  /// 所有卡片.
  final List<_Card> cards;

  /// 值为 0.0 表示当前显示主尺寸卡片, 值为 1.0 表示当前显示副尺寸卡片.
  ///
  /// 在副尺寸动画中改变值. 显示副尺寸卡片时其他卡片需要隐藏.
  double viceOpacity = 0.0;
}

/// 开屏.
class _SplashScreen extends _Screen {
  _SplashScreen(_Game game) : super(game,
    square: 4,
    /// Test: 2.
    cardLength: 2,
  ) {
    _CoreCard card = _CoreCard(this,
      rowIndex: 1,
      columnIndex: 0,
      rowSpan: 1,
      columnSpan: 3,
      onTap: (card) {
        game.screen = _SpriteScreen(game,
          square: 4,
        );
        game.callback.notifyStateChanged();
      },
    );
    cards[0] = card;

    _GridCard sampleCard = _GridCard(this,
      verticalRowGridIndex: 1,
      verticalColumnGridIndex: 1,
      verticalRowGridSpan: 15,
      verticalColumnGridSpan: 15,
      horizontalRowGridIndex: 1,
      horizontalColumnGridIndex: 1,
      horizontalRowGridSpan: 15,
      horizontalColumnGridSpan: 15,
      onTap: (card) {
        card.animateMainToVice().begin();
      },
      onLongPress: (card) {
        card.animateViceToMain().begin();
      }
    );
    cards[1] = sampleCard;
  }
}

/// 游戏屏幕.
class _SpriteScreen extends _Screen {
  _SpriteScreen(_Game game, {
    @required
    int square,
  }) : super(game,
    square: square,
    /// Test: 2.
    cardLength: square * square + 2,
  ) {
    cards[16] = _GridCard(this,
      verticalRowGridIndex: 80,
      verticalColumnGridIndex: 1,
      verticalRowGridSpan: 10,
      verticalColumnGridSpan: 10,
      horizontalRowGridIndex: 1,
      horizontalColumnGridIndex: 80,
      horizontalRowGridSpan: 10,
      horizontalColumnGridSpan: 10,
      onTap: (card) {
        addSpriteCards();
      },
    );
    cards[17] = _GridCard(this,
      verticalRowGridIndex: 80,
      verticalColumnGridIndex: 11,
      verticalRowGridSpan: 10,
      verticalColumnGridSpan: 10,
      horizontalRowGridIndex: 11,
      horizontalColumnGridIndex: 80,
      horizontalRowGridSpan: 10,
      horizontalColumnGridSpan: 10,
      onTap: (card) {
        removeSpriteCards();
      },
    );
  }

  /// 从 [cards] 返回唯一 [_PlayerCard].
  _PlayerCard get playerCard {
    return cards.singleWhere((element) {
      return element is _PlayerCard;
    });
  }

  /// 从 [cards] 返回全部 [_SpriteCard].
  ///
  /// [exceptCard] 排除的卡片. 可以为 null.
  ///
  /// [exceptInvisible] 是否排除不可见的卡片.
  List<_SpriteCard> spriteCards({
    _SpriteCard exceptCard,
    bool exceptInvisible = false,
  }) {
    return List<_SpriteCard>.unmodifiable(cards.where((element) {
      if (element is! _SpriteCard) {
        return false;
      }
      _SpriteCard spriteCard = element as _SpriteCard;
      if (identical(spriteCard, exceptCard)) {
        return false;
      }
      if (exceptInvisible && !spriteCard.visible) {
        return false;
      }
      return true;
    }));
  }

  /// 添加精灵卡片.
  void addSpriteCards() {
    game.actionQueue.add([
      _Action.run((action) {
        _PlayerCard playerCard = _PlayerCard.random(this);
        cards[0] = playerCard;
        int index = 1;
        for (int rowIndex = 0; rowIndex < square; rowIndex++) {
          for (int columnIndex = 0; columnIndex < square; columnIndex++) {
            if (rowIndex == playerCard.rowIndex && columnIndex == playerCard.columnIndex) {
              continue;
            }
            _SpriteCard spriteCard = _SpriteCard(this,
              rowIndex: rowIndex,
              columnIndex: columnIndex,
            );
            cards[index++] = spriteCard;
          }
        }
      }),
    ]);
    game.actionQueue.add(spriteCards().map<_Action>((element) {
      return element.animateSpriteFirstEnter().action();
    }).toList());
  }

  /// 移除精灵卡片.
  void removeSpriteCards() {
    game.actionQueue.add(spriteCards().map<_Action>((element) {
      return element.animateSpriteLastExit().action();
    }).toList());
    game.actionQueue.add(<_Action>[
      _Action.run((action) {
        spriteCards().forEach((element) {
          cards[element.index] = null;
        });
      }),
    ]);
  }
}
