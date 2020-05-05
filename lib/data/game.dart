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

  /// 主尺寸透明度.
  ///
  /// 在详情尺寸动画中改变值. 显示详情尺寸卡片时其他卡片需要隐藏.
  double mainOpacity = 1.0;

  /// 详情尺寸透明度.
  ///
  /// 在详情尺寸动画中改变值. 显示详情尺寸卡片时其他卡片需要隐藏.
  double detailOpacity = 0.0;

  /// 正在显示详情尺寸的卡片, 可能为 null.
  _Card get detailingCard {
    return cards.firstWhere((element) {
      return element.detailing;
    }, orElse: () => null);
  }
}

/// 开屏.
class _SplashScreen extends _Screen {
  _SplashScreen(_Game game) : super(game,
    square: 4,
    cardLength: 14,
  ) {
    cards[0] = _CoreCard(this,
      name: 'Cards',
      rowIndex: 1,
      columnIndex: 0,
      rowSpan: 1,
      columnSpan: 3,
      onTap: (card) {
        card.screen.game.actionQueue.post<_CoreCard>(card, (thisRef, action) {
          if (thisRef.dimension == _CardDimension.main) {
            thisRef.screen.game.actionQueue.add(<_Action>[
              thisRef.animateSample().action(),
            ]);
          }
        });
      },
      onLongPress: (card) {
        if (card.dimension == _CardDimension.full) {
          card.animateFullToMain().begin();
        } else {
          card.animateMainToFull().begin();
        }
      },
    );

    cards[2] = _CoreCard(this,
      name: 'Play',
      rowIndex: 2,
      columnIndex: 3,
      rowSpan: 2,
      columnSpan: 1,
      onTap: (card) {
        card.screen.game.actionQueue.post(card, (thisRef, action) {
          card.animateMainToFull().begin(endCallback: () {
            game.screen = _SpriteScreen(game,
              square: 3,
            );
            game.callback.notifyStateChanged();
          },);
        });
      }
    );

    cards[3] = _CoreCard(this,
      rowIndex: 0,
      columnIndex: 0,
    );
    cards[4] = _CoreCard(this,
      rowIndex: 0,
      columnIndex: 1,
    );
    cards[5] = _CoreCard(this,
      rowIndex: 0,
      columnIndex: 2,
    );
    cards[6] = _CoreCard(this,
      rowIndex: 0,
      columnIndex: 3,
    );
    cards[7] = _CoreCard(this,
      rowIndex: 1,
      columnIndex: 3,
    );
    cards[8] = _CoreCard(this,
      rowIndex: 2,
      columnIndex: 0,
    );
    cards[9] = _CoreCard(this,
      rowIndex: 2,
      columnIndex: 1,
    );
    cards[10] = _CoreCard(this,
      rowIndex: 2,
      columnIndex: 2,
    );
    cards[11] = _CoreCard(this,
      rowIndex: 3,
      columnIndex: 0,
    );
    cards[12] = _CoreCard(this,
      rowIndex: 3,
      columnIndex: 1,
    );
    cards[13] = _CoreCard(this,
      rowIndex: 3,
      columnIndex: 2,
    );
  }
}

/// 游戏屏幕.
class _SpriteScreen extends _Screen {
  _SpriteScreen(_Game game, {
    @required
    int square,
  }) : super(game,
    square: square,
    cardLength: square * square + 2,
  ) {
    cards[cards.length - 1] = _Card(this,
      name: 'Back',
      verticalRowGridIndex: 6,
      verticalColumnGridIndex: 1,
      verticalRowGridSpan: 10,
      verticalColumnGridSpan: 10,
      horizontalRowGridIndex: 1,
      horizontalColumnGridIndex: 6,
      horizontalRowGridSpan: 10,
      horizontalColumnGridSpan: 10,
      onTap: (card) {
        game.screen = _SplashScreen(game);
        game.callback.notifyStateChanged();
      },
    );
    cards[cards.length - 2] = _Card(this,
      name: 'Close',
      verticalRowGridIndex: 80,
      verticalColumnGridIndex: 26,
      verticalRowGridSpan: 10,
      verticalColumnGridSpan: 10,
      horizontalRowGridIndex: 26,
      horizontalColumnGridIndex: 80,
      horizontalRowGridSpan: 10,
      horizontalColumnGridSpan: 10,
      radiusType: _CardRadiusType.round,
      detail: true,
      onTap: (card) {
        card.screen.game.actionQueue.post<_Card>(card, (thisRef, action) {
          thisRef.screen.detailingCard?.animateDetailToMain()?.begin();
        });
      },
    );
    actAddSpriteCards(this);
  }

  /// 从 [cards] 返回唯一玩家卡片.
  _SpriteCard get playerCard {
    return cards.singleWhere((element) {
      return element is _SpriteCard && element.sprite is _PlayerSprite;
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
  static void actAddSpriteCards(_SpriteScreen spriteScreen) {
    spriteScreen.game.actionQueue.post<_SpriteScreen>(spriteScreen, (thisRef, action) {
      _SpriteCard playerCard = _SpriteCard.player(thisRef);
      thisRef.cards[0] = playerCard;
      int index = 1;
      for (int rowIndex = 0; rowIndex < thisRef.square; rowIndex++) {
        for (int columnIndex = 0; columnIndex < thisRef.square; columnIndex++) {
          if (rowIndex == playerCard.rowIndex && columnIndex == playerCard.columnIndex) {
            continue;
          }
          thisRef.cards[index++] = _SpriteCard.next(thisRef,
            rowIndex: rowIndex,
            columnIndex: columnIndex,
          );
        }
      }
      thisRef.game.actionQueue.add(thisRef.spriteCards().map<_Action>((element) {
        if (element.sprite is _PlayerSprite) {
          return element.animateFullToMain().action();
        }
        return element.animateSpriteFirstEnter(
          beginDelayRandomCenter: 1000,
          beginDelayRandomRange: 600,
        ).action();
      }).toList(),
        addFirst: true,
      );
    });
  }

  /// 移除精灵卡片.
  static void actRemoveSpriteCards(_SpriteScreen spriteScreen) {
    spriteScreen.game.actionQueue.post<_SpriteScreen>(spriteScreen, (thisRef, action) {
      thisRef.game.actionQueue.add(<_Action>[
        _Action.run((action) {
          thisRef.spriteCards().forEach((element) {
            thisRef.cards[element.index] = null;
          });
        }),
      ],
        addFirst: true,
      );
      thisRef.game.actionQueue.add(thisRef.spriteCards().map<_Action>((element) {
        return element.animateSpriteLastExit().action();
      }).toList(),
        addFirst: true,
      );
    });
  }
}
