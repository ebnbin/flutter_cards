import 'package:cards/data.dart';
import 'package:cards/metric.dart';
import 'package:flutter/material.dart' hide Card;

/// 游戏页面.
class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin implements GameCallback {
  @override
  Widget build(BuildContext context) {
    Metric.build(context);
    Game game = _data.buildGame(context);
    return Scaffold(
      body: _GameWidget(game),
    );
  }

  Data _data;

  @override
  void initState() {
    super.initState();
    _data = Data(this);
  }

  @override
  void notifyStateChanged() {
    setState(() {
    });
  }
}

/// 根据 [Game] 生成视图.
class _GameWidget extends StatelessWidget {
  _GameWidget(this.game);

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildBackground(context),
        Positioned.fromRelativeRect(
          rect: RelativeRect.fill,
          child: CustomPaint(
//            painter: Metric.get().debugPainter,
//            foregroundPainter: Metric.get().debugForegroundPainter,
            child: _buildCards(context),
          ),
        ),
      ],
    );
  }

  /// 背景
  Widget _buildBackground(BuildContext context) {
    return Positioned.fromRelativeRect(
      rect: RelativeRect.fill,
      child: Image.asset(
        'assets/stone_bricks.png',
        scale: Metric.get().imageScale(48, 8.0),
        /// 不需要设置宽高.
//        width: ,
//        height: ,
        color: Colors.black.withOpacity(0.5),
        colorBlendMode: BlendMode.darken,
        fit: BoxFit.none,
        repeat: ImageRepeat.repeat,
      ),
    );
  }

  /// 全部卡片.
  Widget _buildCards(BuildContext context) {
    List<NullableCard> nullableCards = game.buildNullableCards(context);
    return Stack(
      children: <int>[0, 1, 2, 3,].map<Widget>((zIndex) {
        return Stack(
          children: nullableCards.map<Widget>((nullableCard) {
            if (!nullableCard.zIndexVisible(zIndex)) {
              return _buildInvisible(context);
            }
            Card card = nullableCard.buildCard();
            return _buildCard(context, card);
          }).toList(),
        );
      }).toList(),
    );
  }

  /// 卡片.
  Widget _buildCard(BuildContext context, Card card) {
    return Positioned.fromRect(
      rect: card.rect,
      child: Transform(
        transform: card.transform,
        alignment: Alignment.center,
        child: AbsorbPointer(
          absorbing: card.absorbPointer,
          child: IgnorePointer(
            ignoring: card.ignorePointer,
            child: Opacity(
              opacity: card.opacity,
              child: Container(
                margin: EdgeInsets.all(card.marginA),
                child: Material(
                  elevation: card.elevation,
                  color: Colors.transparent,
                  shadowColor: Colors.cyanAccent,
                  borderRadius: BorderRadius.circular(card.radius),
                  clipBehavior: Clip.antiAlias,
                  animationDuration: Duration.zero,
                  child: Container(
                    margin: EdgeInsets.all(card.marginB),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(card.radius),
                      child: GestureDetector(
                        child: Stack(
                          children: <Widget>[
                            _buildCardBackground(context, card),
                            _buildCardFace(context, card),
                          ],
                        ),
                        onTap: card.onTap,
                        onLongPress: card.onLongPress,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 卡片背景.
  Widget _buildCardBackground(BuildContext context, Card card) {
    return Positioned.fromRelativeRect(
      rect: RelativeRect.fill,
      child: Image.asset(
        'assets/oak_planks.png',
        scale: Metric.get().imageScale(96, 16.0),
        /// 不需要设置宽高.
//        width: ,
//        height: ,
        color: Colors.black.withOpacity(0.25),
        colorBlendMode: BlendMode.darken,
        fit: BoxFit.none,
        repeat: ImageRepeat.repeat,
      ),
    );
  }

  /// 卡片内容.
  Widget _buildCardFace(BuildContext context, Card card) {
    Object face = card.buildFace();
    if (face is SplashFullFace) {
      return _buildSplashFullFace(context, face);
    }
    if (face is SplashTitleFace) {
      return _buildSplashTitleFace(context, face);
    }
    if (face is SpriteFace) {
      return _buildSpriteFace(context, face);
    }
    return _buildInvisible(context);
  }

  /// 开屏全屏.
  Widget _buildSplashFullFace(BuildContext context, SplashFullFace face) {
    return Positioned.fromRect(
      rect: face.rect,
      child: Image.asset('assets/cards.png',
        fit: BoxFit.contain,
      ),
    );
  }

  /// 开屏 Cards 标题.
  Widget _buildSplashTitleFace(BuildContext context, SplashTitleFace face) {
    return Center(
      child: SizedBox.fromSize(
        child: Image.asset('assets/cards.png',
          fit: BoxFit.contain,
        ),
        size: face.size,
      ),
    );
  }

  /// 玩家.
  Widget _buildSpriteFace(BuildContext context, SpriteFace face) {
    return Positioned.fromRelativeRect(
      rect: RelativeRect.fill,
      child: Stack(
        children: <Widget>[
          _buildSpriteFaceBody(context, face),
          _buildSpriteFaceWeapon(context, face),
          _buildSpriteFaceWeaponValue0(context, face),
          _buildSpriteFaceWeaponValue1(context, face),
          /// 盾牌 (右边, 左手).
          Positioned.fromRect(
            rect: face.shieldRect,
            child: Image.asset('assets/shield.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: face.shieldDigit0Rect,
            child: Image.asset('assets/digit_0.png',
              color: face.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: face.shieldDigit1Rect,
            child: Image.asset('assets/digit_0.png',
              color: face.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          /// 生命值 (右上角).
          Positioned.fromRect(
            rect: face.healthRect,
            child: Image.asset('assets/health.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: face.healthDigit0Rect,
            child: Image.asset('assets/digit_0.png',
              color: face.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: face.healthDigit1Rect,
            child: Image.asset('assets/digit_0.png',
              color: face.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: face.healthDigit2Rect,
            child: Image.asset('assets/digit_slash.png',
              color: face.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: face.healthDigit3Rect,
            child: Image.asset('assets/digit_0.png',
              color: face.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: face.healthDigit4Rect,
            child: Image.asset('assets/digit_0.png',
              color: face.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          /// 效果 (右下角).
          Positioned.fromRect(
            rect: face.effectRect,
            child: Image.asset('assets/poison.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: face.effectDigit0Rect,
            child: Image.asset('assets/digit_0.png',
              color: face.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: face.effectDigit1Rect,
            child: Image.asset('assets/digit_0.png',
              color: face.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          /// 数量 (左下角).
          Positioned.fromRect(
            rect: face.amountDigit0Rect,
            child: Image.asset('assets/digit_0.png',
              color: face.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: face.amountDigit1Rect,
            child: Image.asset('assets/digit_0.png',
              color: face.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          /// 能力 (左上角).
          Positioned.fromRect(
            rect: face.powerRect,
            child: Image.asset('assets/absorption.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: face.powerDigit0Rect,
            child: Image.asset('assets/digit_0.png',
              color: face.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: face.powerDigit1Rect,
            child: Image.asset('assets/digit_0.png',
              color: face.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  /// 主体 (中间).
  Widget _buildSpriteFaceBody(BuildContext context, SpriteFace face) {
    if (!face.bodyVisible) {
      return _buildInvisible(context);
    }
    return Positioned.fromRect(
      rect: face.bodyRect,
      child: Image.asset(face.body,
        fit: BoxFit.contain,
      ),
    );
  }

  /// 武器 (左边, 右手).
  Widget _buildSpriteFaceWeapon(BuildContext context, SpriteFace face) {
    if (!face.weaponVisible) {
      return _buildInvisible(context);
    }
    return Positioned.fromRect(
      rect: face.weaponRect,
      child: Image.asset(face.weapon,
        fit: BoxFit.contain,
      ),
    );
  }

  /// 武器值 0.
  Widget _buildSpriteFaceWeaponValue0(BuildContext context, SpriteFace face) {
    if (!face.weaponValue0Visible) {
      return _buildInvisible(context);
    }
    return Positioned.fromRect(
      rect: face.weaponValue0Rect,
      child: Image.asset(face.weaponValue0,
        color: face.digitColor,
        colorBlendMode: BlendMode.srcIn,
        fit: BoxFit.contain,
      ),
    );
  }

  /// 武器值 1.
  Widget _buildSpriteFaceWeaponValue1(BuildContext context, SpriteFace face) {
    if (!face.weaponValue1Visible) {
      return _buildInvisible(context);
    }
    return Positioned.fromRect(
      rect: face.weaponValue1Rect,
      child: Image.asset(face.weaponValue1,
        color: face.digitColor,
        colorBlendMode: BlendMode.srcIn,
        fit: BoxFit.contain,
      ),
    );
  }

  /// 不可见的 Widget.
  Widget _buildInvisible(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(),
    );
  }
}
