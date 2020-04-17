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

    _GridCard sampleCard = _GridCard2(this,
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
    cards[16] = _GridCard2(this,
      verticalRowGridIndex: 80,
      verticalColumnGridIndex: 1,
      verticalRowGridSpan: 10,
      verticalColumnGridSpan: 10,
      horizontalRowGridIndex: 1,
      horizontalColumnGridIndex: 80,
      horizontalRowGridSpan: 10,
      horizontalColumnGridSpan: 10,
    );
    cards[17] = _GridCard2(this,
      verticalRowGridIndex: 80,
      verticalColumnGridIndex: 11,
      verticalRowGridSpan: 10,
      verticalColumnGridSpan: 10,
      horizontalRowGridIndex: 11,
      horizontalColumnGridIndex: 80,
      horizontalRowGridSpan: 10,
      horizontalColumnGridSpan: 10,
    );
  }

  /// 从 [cards] 返回唯一 [_PlayerCard].
  _PlayerCard get playerCard {
    return cards.singleWhere((element) {
      return element is _PlayerCard;
    });
  }

  /// 从 [cards] 返回全部 [_SpriteCard].
  List<_SpriteCard> get spriteCards {
    return List<_SpriteCard>.unmodifiable(cards.where((element) {
      return element is _SpriteCard;
    }));
  }
}
