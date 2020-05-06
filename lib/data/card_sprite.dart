part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 精灵卡片.
class _SpriteCard extends _Card {
  _SpriteCard(_SpriteScreen screen, {
    String name,
    double rotateX = 0.0,
    double rotateY = 0.0,
    double rotateZ = 0.0,
    double translateX = 0.0,
    double translateY = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    int zIndex = 1,
    /// 默认不可见, 通过动画进入.
    bool visible = false,
    _CardDimension dimension = _CardDimension.main,
    double mainOpacity = 1.0,
    _GestureType gestureType = _GestureType.normal,
//    void Function(_Card card) onTap,
//    void Function(_Card card) onLongPress,
    @required
    int rowIndex,
    @required
    int columnIndex,
    double mainElevation = 2.0,
    _CardRadiusType radiusType = _CardRadiusType.none,
    @required
    _Sprite Function(_SpriteCard card) createSprite,
  }) : super.core(screen,
    name: name,
    rotateX: rotateX,
    rotateY: rotateY,
    rotateZ: rotateZ,
    translateX: translateX,
    translateY: translateY,
    scaleX: scaleX,
    scaleY: scaleY,
    zIndex: zIndex,
    visible: visible,
    dimension: dimension,
    /// 固定为主尺寸卡片.
    detail: false,
    selfOpacity: mainOpacity,
    gestureType: gestureType,
    mainOnTap: (card) {
      card.post<_SpriteCard>((card) {
        if (card.index < 0) {
          return;
        }
        card.sprite.onTap();
      });
    },
    detailOnTap: null,
    mainOnLongPress: (card) {
      card.post<_SpriteCard>((card) {
        if (card.index < 0) {
          return;
        }
        card.game.actionQueue.addSingleFirst(card.animateMainToDetail().action());
      });
    },
    detailOnLongPress: null,
    rowIndex: rowIndex,
    columnIndex: columnIndex,
    /// 固定为 1.
    rowSpan: 1,
    /// 固定为 1.
    columnSpan: 1,
    mainElevation: mainElevation,
    radiusType: radiusType,
  ) {
    sprite = createSprite(this);
  }

  /// 玩家.
  factory _SpriteCard.player(_SpriteScreen screen) {
    /// 随机非边缘位置.
    ///
    /// 3 * 3 始终在中间一格, 4 * 4 中间 4 格之一随机, 5 * 5 中间 9 格之一随机.
    int _randomRowColumnIndex() {
      return _random.nextIntFromTo(1, screen.square - 2);
    }

    return _SpriteCard(screen,
      name: 'Player',
      rowIndex: _randomRowColumnIndex(),
      columnIndex: _randomRowColumnIndex(),
      zIndex: 3,
      visible: true,
      dimension: _CardDimension.full,
      createSprite: (card) {
        return _PlayerSprite(card);
      },
    );
  }

  /// 随机.
  factory _SpriteCard.next(_SpriteScreen screen, {
    @required
    int rowIndex,
    @required
    int columnIndex,
  }) {
    return _SpriteCard(screen,
      rowIndex: rowIndex,
      columnIndex: columnIndex,
      createSprite: (card) {
        int random = _random.nextIntFromTo(0, 2);
        if (random == 0) {
          return _DiamondSwordSprite(card,
            amount: _random.nextIntFromTo(1, 99),
          );
        } else if (random == 1) {
          return _GoldNuggetSprite(card,
            amount: _random.nextIntFromTo(1, 99),
          );
        } else if (random == 2) {
          return _ZombieSprite(card,
            healthValue: _random.nextIntFromTo(1, 99),
          );
        }
        return _Sprite(card);
      },
    );
  }

  /// 强转为 [_SpriteScreen].
  _SpriteScreen get spriteScreen {
    return screen as _SpriteScreen;
  }

  /// 是否在指定方向边缘.
  bool edge(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.up:
        return rowIndex <= 0;
      case AxisDirection.right:
        return columnIndex >= screen.square - 1;
      case AxisDirection.down:
        return rowIndex >= screen.square - 1;
      case AxisDirection.left:
        return columnIndex <= 0;
      default:
        throw Exception();
    }
  }

  /// 返回在指定方向上与当前卡片相邻的卡片. 如果没有符合条件的卡片则返回 null. 不会返回 [visible] 为 false 的卡片.
  ///
  /// 例如 direction = left 表示返回当前卡片左边相邻的卡片.
  _SpriteCard adjacentCard(AxisDirection direction) {
    assert(direction != null);
    if (edge(direction)) {
      return null;
    }
    return spriteScreen.spriteCards(
      exceptCard: this,
      exceptInvisible: true,
    ).singleWhere((element) {
      switch (direction) {
        case AxisDirection.up:
          return element.rowIndex == rowIndex - 1 && element.columnIndex == columnIndex;
        case AxisDirection.right:
          return element.rowIndex == rowIndex && element.columnIndex == columnIndex + 1;
        case AxisDirection.down:
          return element.rowIndex == rowIndex + 1 && element.columnIndex == columnIndex;
        case AxisDirection.left:
          return element.rowIndex == rowIndex && element.columnIndex == columnIndex - 1;
        default:
          throw Exception();
      }
    }, orElse: () => null);
  }

  /// 返回指定卡片与当前卡片的相对相邻位置. 如果不相邻则返回 null.
  ///
  /// 例如指定卡片在当前卡片的左边相邻则返回 left.
  AxisDirection adjacentDirection(_SpriteCard card) {
    assert(card != null);
    if (identical(card, adjacentCard(AxisDirection.up))) {
      return AxisDirection.up;
    }
    if (identical(card, adjacentCard(AxisDirection.right))) {
      return AxisDirection.right;
    }
    if (identical(card, adjacentCard(AxisDirection.down))) {
      return AxisDirection.down;
    }
    if (identical(card, adjacentCard(AxisDirection.left))) {
      return AxisDirection.left;
    }
    return null;
  }

  /// 返回当前卡片指定方向上的所有卡片. 如果没有符合条件的卡片则返回空列表. 不会返回 [visible] 为 false 的卡片.
  ///
  /// 例如 direction = left 表示返回当前卡片左边一格, 左边两格, 左边三格... 的列表.
  List<_SpriteCard> adjacentCardAll(AxisDirection direction) {
    assert(direction != null);
    if (edge(direction)) {
      return List<_SpriteCard>.unmodifiable(<_SpriteCard>[]);
    }

    List<_SpriteCard> result = <_SpriteCard>[];
    List<_SpriteCard> spriteCards = spriteScreen.spriteCards(
      exceptCard: this,
      exceptInvisible: true,
    );

    /// 添加 [spriteCards] 中指定行列的卡片到 [result] 中.
    void addSpriteCard(int targetRowIndex, int targetColumnIndex) {
      result.addNotNull(spriteCards.singleWhere((element) {
        return element.rowIndex == targetRowIndex && element.columnIndex == targetColumnIndex;
      }, orElse: () => null));
    }

    switch (direction) {
      case AxisDirection.up:
        for (int targetRowIndex = rowIndex - 1; targetRowIndex >= 0; targetRowIndex--) {
          addSpriteCard(targetRowIndex, columnIndex);
        }
        break;
      case AxisDirection.right:
        for (int targetColumnIndex = columnIndex + 1; targetColumnIndex <= screen.square - 1; targetColumnIndex++) {
          addSpriteCard(rowIndex, targetColumnIndex);
        }
        break;
      case AxisDirection.down:
        for (int targetRowIndex = rowIndex + 1; targetRowIndex <= screen.square - 1; targetRowIndex++) {
          addSpriteCard(targetRowIndex, columnIndex);
        }
        break;
      case AxisDirection.left:
        for (int targetColumnIndex = columnIndex - 1; targetColumnIndex >= 0; targetColumnIndex--) {
          addSpriteCard(rowIndex, targetColumnIndex);
        }
        break;
      default:
        throw Exception();
    }
    return List<_SpriteCard>.unmodifiable(result);
  }

  /// 按照 [clockwise] 顺时针或逆时针方向从当前方向依次寻找下一个不是边缘的方向, 不会返回与 [direction] 相反的方向.
  ///
  /// 例如: direction = left, clockwise = false, 当前卡片在左下角, 则按照 left (在边缘), down (在边缘), right (与 left 相反),
  /// up 顺序, 返回第一个符合条件的方向 up.
  AxisDirection nextNonEdgeDirection(AxisDirection direction, {
    bool clockwise = false,
  }) {
    assert(direction != null);
    List<AxisDirection> directions = clockwise
        ? AxisDirection.values
        : List.unmodifiable(AxisDirection.values.reversed);
    int start = directions.indexOf(direction);
    for (AxisDirection nextDirection in (directions + directions).sublist(start, start + directions.length)) {
      if (nextDirection != flipAxisDirection(direction) && !edge(nextDirection)) {
        return nextDirection;
      }
    }
    throw Exception();
  }

  //*******************************************************************************************************************

  /// 精灵卡片移动动画.
  ///
  /// [direction] 移动方向.
  _Animation<_SpriteCard> animateSpriteMove({
    int duration = 400,
    int beginDelay = 0,
    int endDelay = 0,
    @required
    AxisDirection direction,
  }) {
    return _Animation<_SpriteCard>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeInOut,
      listener: (card, value, first, half, last) {
        if (value < 0.5) {
          card.translateX = _ValueCalc.ab(0.0, _Metric.get().squareSizeMap[card.screen.square] * direction.x)
              .calc(value);
          card.translateY = _ValueCalc.ab(0.0, _Metric.get().squareSizeMap[card.screen.square] * direction.y)
              .calc(value);
        } else {
          card.translateX = _ValueCalc.ab(_Metric.get().squareSizeMap[card.screen.square] * -direction.x, 0.0)
              .calc(value);
          card.translateY = _ValueCalc.ab(_Metric.get().squareSizeMap[card.screen.square] * -direction.y, 0.0)
              .calc(value);
        }
        if (half) {
          card.rowIndex += direction.y;
          card.columnIndex += direction.x;
        }
      },
    );
  }

  /// 精灵卡片进入动画.
  _Animation<_SpriteCard> animateSpriteEnter({
    int duration = 400,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_SpriteCard>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeIn,
      listener: (card, value, first, half, last) {
        if (first) {
          card.zIndex = 0;
          card.visible = true;
        }
        card.rotateY = _ValueCalc.ab(_InvisibleAngle.clockwise90.value, 0.0).calc(value);
        card.scaleX = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.scaleY = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.mainElevation = _ValueCalc.ab(0.0, 2.0).calc(value);
        if (last) {
          card.zIndex = 1;
        }
      },
    );
  }

  /// 精灵卡片退出动画.
  _Animation<_SpriteCard> animateSpriteExit({
    int duration = 400,
    int beginDelay = 0,
    int endDelay = 0,
  }) {
    return _Animation<_SpriteCard>(this,
      duration: duration,
      beginDelay: beginDelay,
      endDelay: endDelay,
      curve: Curves.easeOut,
      listener: (card, value, first, half, last) {
        if (first) {
          card.zIndex = 0;
        }
        card.rotateY = _ValueCalc.ab(0.0, _InvisibleAngle.counterClockwise90.value).calc(value);
        card.scaleX = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.scaleY = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.mainElevation = _ValueCalc.ab(2.0, 0.0).calc(value);
        if (last) {
          card.visible = false;
        }
      },
    );
  }

  /// 精灵卡片第一次进入动画.
  _Animation<_SpriteCard> animateSpriteFirstEnter({
    int durationRandomCenter = 600,
    int durationRandomRange = 200,
    int beginDelayRandomCenter = 200,
    int beginDelayRandomRange = 200,
    int endDelay = 0,
  }) {
    double rotateYA = _random.nextListItem(<_InvisibleAngle>[
      _InvisibleAngle.clockwise90,
      _InvisibleAngle.clockwise270,
    ]).value;
    return _Animation<_SpriteCard>(this,
      duration: _random.nextIntCenterRange(durationRandomCenter, durationRandomRange),
      beginDelay: _random.nextIntCenterRange(beginDelayRandomCenter, beginDelayRandomRange),
      endDelay: endDelay,
      curve: Curves.easeIn,
      listener: (card, value, first, half, last) {
        if (first) {
          card.zIndex = 0;
          card.visible = true;
        }
        card.rotateY = _ValueCalc.ab(rotateYA, 0.0).calc(value);
        card.scaleX = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.scaleY = _ValueCalc.ab(0.5, 1.0).calc(value);
        card.mainElevation = _ValueCalc.ab(0.0, 2.0).calc(value);
        if (last) {
          card.zIndex = 1;
        }
      },
    );
  }

  /// 精灵卡片最后一次退出动画.
  _Animation<_SpriteCard> animateSpriteLastExit({
    int durationRandomCenter = 600,
    int durationRandomRange = 200,
    int beginDelayRandomCenter = 200,
    int beginDelayRandomRange = 200,
    int endDelay = 0,
  }) {
    double rotateYB = _random.nextListItem(<_InvisibleAngle>[
      _InvisibleAngle.counterClockwise90,
      _InvisibleAngle.counterClockwise270,
    ]).value;
    return _Animation<_SpriteCard>(this,
      duration: _random.nextIntCenterRange(durationRandomCenter, durationRandomRange),
      beginDelay: _random.nextIntCenterRange(beginDelayRandomCenter, beginDelayRandomRange),
      endDelay: endDelay,
      curve: Curves.easeOut,
      listener: (card, value, first, half, last) {
        if (first) {
          card.zIndex = 0;
        }
        card.rotateY = _ValueCalc.ab(0.0, rotateYB).calc(value);
        card.scaleX = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.scaleY = _ValueCalc.ab(1.0, 0.5).calc(value);
        card.mainElevation = _ValueCalc.ab(2.0, 0.0).calc(value);
        if (last) {
          card.visible = false;
        }
      },
    );
  }

  //*******************************************************************************************************************

  /// 精灵. 不为 null.
  _Sprite sprite;
}

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

  _Game get game {
    return card.game;
  }

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
      game.actionQueue.addSingleFirst(card.animateTremble().action());
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
    game.actionQueue.addFirst(actions);
    game.actionQueue.addFirst(<_Action>[
      card.animateSpriteExit().action(),
      playerCard.animateSpriteMove(
        direction: direction,
        beginDelay: 200,
      ).action(),
    ]);
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************

/// 玩家.
class _PlayerSprite extends _Sprite {
  _PlayerSprite(_SpriteCard card) : super(card,
    body: 'images/steve.png',
//    shield: 'images/gold_nugget.png',
//    shieldValue: 88,
    healthValue: 88,
    maxHealthValue: 88,
//    effect: 'images/diamond_sword.png',
//    effectValue: 88,
//    amount: 88,
//    power: 'images/diamond_sword.png',
//    powerValue: 88,
  );
}

/// 金粒.
class _GoldNuggetSprite extends _Sprite {
  _GoldNuggetSprite(_SpriteCard card, {
    @required
    int amount,
  }) : super(card,
    body: 'images/gold_nugget.png',
    amount: amount,
  );
}

/// 钻石剑.
class _DiamondSwordSprite extends _Sprite {
  _DiamondSwordSprite(_SpriteCard card, {
    @required
    int amount,
  }) : super(card,
    body: 'images/diamond_sword.png',
    amount: amount,
  );

  @override
  void onTap() {
    _SpriteCard playerCard = card.spriteScreen.playerCard;
    AxisDirection direction = playerCard.adjacentDirection(card);
    if (direction == null) {
      game.actionQueue.addSingleFirst(card.animateTremble().action());
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
    game.actionQueue.addFirst(actions);
    game.actionQueue.addFirst(<_Action>[
      card.animateSpriteExit().action(),
      _Action.run((action) {
        playerCard.sprite.weapon = body;
        playerCard.sprite.weaponValue = amount;
        game.callback.notifyStateChanged();
      }),
      playerCard.animateSpriteMove(
        direction: direction,
        beginDelay: 200,
      ).action(),
    ]);
  }
}

/// 僵尸.
class _ZombieSprite extends _Sprite {
  _ZombieSprite(_SpriteCard card, {
    @required
    int healthValue,
  }) : initHealthValue = healthValue, super(card,
    body: 'images/husk.png',
    healthValue: healthValue,
  );

  /// 初始生命值.
  final int initHealthValue;

  @override
  void onTap() {
    _SpriteCard playerCard = card.spriteScreen.playerCard;
    AxisDirection direction = playerCard.adjacentDirection(card);
    if (direction == null) {
      game.actionQueue.addSingleFirst(card.animateTremble().action());
      return;
    }
    bool hasWeapon;
    if (playerCard.sprite.weaponValue != null) {
      hasWeapon = true;
      int diffValue = min(playerCard.sprite.weaponValue, healthValue);
      playerCard.sprite.weaponValue -= diffValue;
      healthValue -= diffValue;
      if (playerCard.sprite.weaponValue <= 0) {
        playerCard.sprite.weapon = null;
        playerCard.sprite.weaponValue = null;
      }
    } else {
      hasWeapon = false;
      int diffValue = min(playerCard.sprite.healthValue, healthValue);
      playerCard.sprite.healthValue -= diffValue;
      healthValue -= diffValue;
    }
    game.callback.notifyStateChanged();
    if (playerCard.sprite.healthValue <= 0) {
      // 玩家死亡.
      game.screen = _SplashScreen(game);
      game.callback.notifyStateChanged();
      return;
    }
    if (healthValue <= 0) {
      // 僵尸死亡.
      if  (hasWeapon) {
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
        game.actionQueue.addSingleFirst(action);
      } else {
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
        game.actionQueue.addFirst(actions);
        game.actionQueue.addFirst(<_Action>[
          card.animateSpriteExit().action(),
          playerCard.animateSpriteMove(
            direction: direction,
            beginDelay: 200,
          ).action(),
        ]);
      }
    }
  }
}
