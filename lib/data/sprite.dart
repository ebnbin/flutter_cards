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
    shield: 'assets/shield.png',
    shieldValue: 88,
    healthValue: 88,
    maxHealthValue: 88,
    effect: 'assets/poison.png',
    effectValue: 88,
    amount: 88,
    power: 'assets/absorption.png',
    powerValue: 88,
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
