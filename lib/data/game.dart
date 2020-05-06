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

  /// 全屏尺寸内容.
  String full = 'Cards';
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
  }) : cards = List<_Card>.filled(cardLength, null, growable: false) {
    game.full = null;
  }

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
    cards[0] = _Card.core(this,
      name: 'Title',
      rowIndex: 1,
      columnIndex: 0,
      rowSpan: 1,
      columnSpan: 3,
      mainOnTap: (card) {
        card.post<_Card>((card) {
          card.game.actionQueue.addSingleFirst(card.animateSample().action());
        });
      },
      mainOnLongPress: (card) {
        card.post<_Card>((card) {
          card.animateMainToFull().begin(
            endCallback: () {
              card.animateFullToMain(
                beginDelay: 1000,
              ).begin();
            },
          );
        });
      }
    );

    cards[2] = _Card.core(this,
      name: 'Play',
      rowIndex: 2,
      columnIndex: 3,
      rowSpan: 2,
      columnSpan: 1,
      mainOnTap: (card) {
        card.post<_Card>((thisRef) {
          thisRef.game.screen = _LevelScreen(thisRef.game);
          thisRef.game.callback.notifyStateChanged();
        });
      },
    );

    cards[3] = _Card.core(this,
      rowIndex: 0,
      columnIndex: 0,
      name: 'Game Center',
    );
    cards[4] = _Card.core(this,
      rowIndex: 0,
      columnIndex: 1,
      rowSpan: 1,
      columnSpan: 2,
      name: 'Money\nStore',
    );
    cards[6] = _Card.core(this,
      rowIndex: 0,
      columnIndex: 3,
      name: 'Settings',
    );
    cards[7] = _Card.core(this,
      rowIndex: 1,
      columnIndex: 3,
      name: 'Special Event',
    );
    cards[8] = _Card.core(this,
      rowIndex: 2,
      columnIndex: 0,
      name: 'Cards',
    );
    cards[9] = _Card.core(this,
      rowIndex: 2,
      columnIndex: 1,
      name: 'Roles',
    );
    cards[10] = _Card.core(this,
      rowIndex: 2,
      columnIndex: 2,
      name: 'Skills',
    );
    cards[11] = _Card.core(this,
      rowIndex: 3,
      columnIndex: 0,
      name: 'Statistics'
    );
    cards[12] = _Card.core(this,
      rowIndex: 3,
      columnIndex: 1,
      name: 'Achievement',
    );
    cards[13] = _Card.core(this,
      rowIndex: 3,
      columnIndex: 2,
      name: 'Daily Task',
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
    cards[cards.length - 1] = _Card.grid(this,
      name: 'Home',
      verticalRowGridIndex: 7,
      verticalColumnGridIndex: 1,
      verticalRowGridSpan: 10,
      verticalColumnGridSpan: 10,
      horizontalRowGridIndex: 1,
      horizontalColumnGridIndex: 7,
      horizontalRowGridSpan: 10,
      horizontalColumnGridSpan: 10,
      mainOnTap: (card) {
        card.post<_Card>((card) {
          card.game.screen = _SplashScreen(card.game);
          card.game.callback.notifyStateChanged();
        });
      },
    );
    cards[cards.length - 2] = _Card.grid(this,
      name: 'Close',
      verticalRowGridIndex: 81,
      verticalColumnGridIndex: 26,
      verticalRowGridSpan: 10,
      verticalColumnGridSpan: 10,
      horizontalRowGridIndex: 26,
      horizontalColumnGridIndex: 81,
      horizontalRowGridSpan: 10,
      horizontalColumnGridSpan: 10,
      radiusType: _CardRadiusType.round,
      detail: true,
      mainOnTap: (card) {
        card.post<_Card>((card) {
          card.screen.detailingCard?.animateDetailToMain()?.begin();
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
    spriteScreen.game.actionQueue.post<_SpriteScreen>(spriteScreen, (thisRef) {
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
      thisRef.game.actionQueue.addFirst(thisRef.spriteCards().map<_Action>((element) {
        if (element.sprite is _PlayerSprite) {
          return element.animateFullToMain().action();
        }
        return element.animateSpriteFirstEnter(
          beginDelayRandomCenter: 1000,
          beginDelayRandomRange: 600,
        ).action();
      }).toList());
    });
  }

  /// 移除精灵卡片.
  static void actRemoveSpriteCards(_SpriteScreen spriteScreen) {
    spriteScreen.game.actionQueue.post<_SpriteScreen>(spriteScreen, (thisRef) {
      thisRef.game.actionQueue.addSingleFirst(_Action.run((action) {
        thisRef.spriteCards().forEach((element) {
          thisRef.cards[element.index] = null;
        });
      }));
      thisRef.game.actionQueue.addFirst(thisRef.spriteCards().map<_Action>((element) {
        return element.animateSpriteLastExit().action();
      }).toList());
    });
  }
}

/// 选关屏幕.
class _LevelScreen extends _Screen {
  _LevelScreen(_Game game) : super(game,
    square: 4,
    cardLength: 7,
  ) {
    cards[1] = _Card.grid(this,
      name: 'Home',
      verticalRowGridIndex: 7,
      verticalColumnGridIndex: 1,
      verticalRowGridSpan: 10,
      verticalColumnGridSpan: 10,
      horizontalRowGridIndex: 1,
      horizontalColumnGridIndex: 7,
      horizontalRowGridSpan: 10,
      horizontalColumnGridSpan: 10,
      mainOnTap: (card) {
        card.post<_Card>((card) {
          card.game.screen = _SplashScreen(card.game);
          card.game.callback.notifyStateChanged();
        });
      },
    );
    cards[2] = _Card.grid(this,
      name: 'Level',
      verticalRowGridIndex: 9,
      verticalColumnGridIndex: 23,
      verticalRowGridSpan: 8,
      verticalColumnGridSpan: 16,
      horizontalRowGridIndex: 27,
      horizontalColumnGridIndex: 1,
      horizontalRowGridSpan: 8,
      horizontalColumnGridSpan: 16,
    );
    cards[3] = _Card.core(this,
      name: '3*3',
      rowIndex: 0,
      columnIndex: 0,
      rowSpan: 2,
      columnSpan: 2,
      mainOnTap: (card) {
        card.post<_Card>((card) {
          card.animateMainToFull().begin(endCallback: () {
            card.game.screen = _SpriteScreen(card.game,
              square: 3,
            );
            card.game.callback.notifyStateChanged();
          });
        });
      },
    );
    cards[4] = _Card.core(this,
      name: '4*4',
      rowIndex: 0,
      columnIndex: 2,
      rowSpan: 2,
      columnSpan: 2,
      mainOnTap: (card) {
        card.post<_Card>((card) {
          card.animateMainToFull().begin(endCallback: () {
            card.game.screen = _SpriteScreen(card.game,
              square: 4,
            );
            card.game.callback.notifyStateChanged();
          });
        });
      },
    );
    cards[5] = _Card.core(this,
      name: '5*5',
      rowIndex: 2,
      columnIndex: 0,
      rowSpan: 2,
      columnSpan: 2,
      mainOnTap: (card) {
        card.post<_Card>((card) {
          card.animateMainToFull().begin(endCallback: () {
            card.game.screen = _SpriteScreen(card.game,
              square: 5,
            );
            card.game.callback.notifyStateChanged();
          });
        });
      },
    );
  }
}
