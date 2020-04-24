part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************
// 精灵.

class _Sprite {
  _Sprite(this.card, {
    this.body,
    this.weapon,
    this.weaponValue,
    this.shield,
    this.shieldValue,
    this.healthValue,
    this.maxHealthValue,
    this.effect,
    this.effectValue,
    this.amount,
    this.power,
    this.powerValue,
  });

  final _SpriteCard card;

  /// 主体.
  String body;

  /// 武器.
  String weapon;

  /// 武器值.
  int weaponValue;

  /// 盾牌.
  String shield;

  /// 盾牌值.
  int shieldValue;

  /// 生命值.
  int healthValue;

  /// 最大生命值.
  int maxHealthValue;

  /// 效果.
  String effect;

  /// 效果值.
  int effectValue;

  /// 数量.
  int amount;

  /// 能力.
  String power;

  /// 能力值.
  int powerValue;

  void onTap() {
    _SpriteCard playerCard = card.spriteScreen.playerCard;
    AxisDirection direction = playerCard.adjacentDirection(card);
    if (direction == null) {
      card.screen.game.actionQueue.add(<_Action>[
        card.animateTremble().action(),
      ]);
      return;
    }
    AxisDirection nextDirection = playerCard.nextNonEdgeDirection(flipAxisDirection(direction));
    List<_SpriteCard> adjacentCardAll = playerCard.adjacentCardAll(nextDirection);
    _SpriteCard newSpriteCard = _SpriteCard.next(card.spriteScreen,
      rowIndex: adjacentCardAll.last.rowIndex,
      columnIndex: adjacentCardAll.last.columnIndex,
    );
    int index = card.index;

    List<_Action> actions = <_Action>[];
    actions.add(_Action.run((action) {
      card.spriteScreen.cards[index] = newSpriteCard;
    }));
    actions.addAll(adjacentCardAll.map<_Action>((element) {
      return element.animateSpriteMove(direction: flipAxisDirection(nextDirection)).action();
    }).toList());
    actions.add(newSpriteCard.animateSpriteEnter(
      beginDelay: 200,
    ).action());
    card.screen.game.actionQueue.add(actions,
      addFirst: true,
    );
    card.screen.game.actionQueue.add(<_Action>[
      card.animateSpriteExit().action(),
      playerCard.animateSpriteMove(
        direction: direction,
        beginDelay: 200,
      ).action(),
    ],
      addFirst: true,
    );
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 玩家.
class _PlayerSprite extends _Sprite {
  _PlayerSprite(_SpriteCard card) : super(card,
    body: 'assets/steve.png',
//    shield: 'assets/shield.png',
//    shieldValue: 88,
    healthValue: 88,
    maxHealthValue: 88,
//    effect: 'assets/poison.png',
//    effectValue: 88,
//    amount: 88,
//    power: 'assets/absorption.png',
//    powerValue: 88,
  );
}

/// 金粒.
class _GoldNuggetSprite extends _Sprite {
  _GoldNuggetSprite(_SpriteCard card, {
    @required
    int amount,
  }) : super(card,
    body: 'assets/gold_nugget.png',
    amount: amount,
  );
}

/// 钻石剑.
class _DiamondSwordSprite extends _Sprite {
  _DiamondSwordSprite(_SpriteCard card, {
    @required
    int amount,
  }) : super(card,
    body: 'assets/diamond_sword.png',
    amount: amount,
  );

  @override
  void onTap() {
    _SpriteCard playerCard = card.spriteScreen.playerCard;
    AxisDirection direction = playerCard.adjacentDirection(card);
    if (direction == null) {
      card.screen.game.actionQueue.add(<_Action>[
        card.animateTremble().action(),
      ]);
      return;
    }
    AxisDirection nextDirection = playerCard.nextNonEdgeDirection(flipAxisDirection(direction));
    List<_SpriteCard> adjacentCardAll = playerCard.adjacentCardAll(nextDirection);
    _SpriteCard newSpriteCard = _SpriteCard.next(card.spriteScreen,
      rowIndex: adjacentCardAll.last.rowIndex,
      columnIndex: adjacentCardAll.last.columnIndex,
    );
    int index = card.index;

    List<_Action> actions = <_Action>[];
    actions.add(_Action.run((action) {
      card.spriteScreen.cards[index] = newSpriteCard;
    }));
    actions.addAll(adjacentCardAll.map<_Action>((element) {
      return element.animateSpriteMove(direction: flipAxisDirection(nextDirection)).action();
    }).toList());
    actions.add(newSpriteCard.animateSpriteEnter(
      beginDelay: 200,
    ).action());
    card.screen.game.actionQueue.add(actions,
      addFirst: true,
    );
    card.screen.game.actionQueue.add(<_Action>[
      card.animateSpriteExit().action(),
      _Action.run((action) {
        playerCard.sprite.weapon = body;
        playerCard.sprite.weaponValue = amount;
        card.screen.game.callback.notifyStateChanged();
      }),
      playerCard.animateSpriteMove(
        direction: direction,
        beginDelay: 200,
      ).action(),
    ],
      addFirst: true,
    );
  }
}

/// 僵尸.
class _ZombieSprite extends _Sprite {
  _ZombieSprite(_SpriteCard card, {
    @required
    int healthValue,
  }) : initHealthValue = healthValue, super(card,
    body: 'assets/zombie.png',
    healthValue: healthValue,
  );

  /// 初始生命值.
  final int initHealthValue;

  @override
  void onTap() {
    _SpriteCard playerCard = card.spriteScreen.playerCard;
    AxisDirection direction = playerCard.adjacentDirection(card);
    if (direction == null) {
      card.screen.game.actionQueue.add(<_Action>[
        card.animateTremble().action(),
      ]);
      return;
    }
    if (playerCard.sprite.weaponValue != null) {
      int diffValue = min(playerCard.sprite.weaponValue, healthValue);
      playerCard.sprite.weaponValue -= diffValue;
      healthValue -= diffValue;
      if (playerCard.sprite.weaponValue <= 0) {
        playerCard.sprite.weapon = null;
        playerCard.sprite.weaponValue = null;
      }
    } else {
      int diffValue = min(playerCard.sprite.healthValue, healthValue);
      playerCard.sprite.healthValue -= diffValue;
      healthValue -= diffValue;
    }
    card.screen.game.callback.notifyStateChanged();
    if (playerCard.sprite.healthValue <= 0) {
      // 玩家死亡.
      card.screen.game.screen = _SplashScreen(card.screen.game);
      card.screen.game.callback.notifyStateChanged();
      return;
    }
    if (healthValue <= 0) {
      // 僵尸死亡.
      _Action action = _Animation<_SpriteCard>(card,
        duration: 400,
        beginDelay: 0,
        curve: Curves.easeInOut,
        listener: (card, value, first, half, last) {
          if (first) {
            card.zIndex = 2;
          }
          if (value < 0.5) {
            card.rotateX = _ValueCalc.ab(0.0, _VisibleAngle.counterClockwise180.value).calc(value);
          } else {
            card.rotateX = _ValueCalc.ab(_VisibleAngle.clockwise180.value, 0.0).calc(value);
          }
          card.mainElevation = _ValueCalc.ab(2.0, 4.0).calc(value);
          if (half) {
            card.sprite = _GoldNuggetSprite(card,
              amount: initHealthValue,
            );
          }
          if (last) {
            card.zIndex = 1;
          }
        },
      ).action();
      card.screen.game.actionQueue.add(<_Action>[
        action,
      ],
        addFirst: true,
      );
    }
  }
}
