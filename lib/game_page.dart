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
    List<Card> cards = game.buildCards(context);
    return Stack(
      children: <int>[0, 1, 2, 3,].map<Widget>((zIndex) {
        return Stack(
          children: cards.map<Widget>((card) {
            return _buildCard(context, zIndex, card);
          }).toList(),
        );
      }).toList(),
    );
  }

  /// 卡片.
  Widget _buildCard(BuildContext context, int zIndex, Card card) {
    if (card.zIndexVisible(zIndex)) {
      VisibleCard visibleCard = card.buildVisibleCard();
      return _buildVisibleCard(context, visibleCard);
    } else {
      return _buildInvisibleCard(context);
    }
  }

  /// 可见的卡片.
  Widget _buildVisibleCard(BuildContext context, VisibleCard visibleCard) {
    return Positioned.fromRect(
      rect: visibleCard.rect,
      child: Transform(
        transform: visibleCard.transform,
        alignment: Alignment.center,
        child: AbsorbPointer(
          absorbing: visibleCard.absorbPointer,
          child: IgnorePointer(
            ignoring: visibleCard.ignorePointer,
            child: Opacity(
              opacity: visibleCard.opacity,
              child: _buildMaterialCard(context, visibleCard),
            ),
          ),
        ),
      ),
    );
  }

  /// Material 卡片.
  Widget _buildMaterialCard(BuildContext context, VisibleCard visibleCard) {
    return Container(
      margin: EdgeInsets.all(visibleCard.marginA),
      child: Material(
        shadowColor: Colors.cyanAccent,
        elevation: visibleCard.elevation,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(visibleCard.radius),
        clipBehavior: Clip.antiAlias,
        animationDuration: Duration.zero,
        child: Container(
          margin: EdgeInsets.all(visibleCard.marginB),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(visibleCard.radius),
            child: GestureDetector(
              child: Stack(
                children: <Widget>[
                  _buildMaterialCardBackground(context, visibleCard),
                  _buildMaterialCardChildren(context, visibleCard),
                ],
              ),
              onTap: visibleCard.onTap,
              onLongPress: visibleCard.onLongPress,
            ),
          ),
        ),
      ),
    );
  }

  /// Material 卡片背景.
  Widget _buildMaterialCardBackground(BuildContext context, VisibleCard visibleCard) {
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

  Widget _buildMaterialCardChildren(BuildContext context, VisibleCard visibleCard) {
    Object face = visibleCard.buildFace();
    if (face is EmptyFace) {
      return _buildEmptyFace(context, face);
    }
    // TODO
    return CustomPaint();
//    if (visibleCard.isSplashTitleCard) {
//      SplashTitleCard splashTitleCard = visibleCard.buildSplashTitleCard();
//      return _buildSplashTitleCard(context, splashTitleCard);
//    }
//    if (visibleCard.isSpriteCard) {
//      SpriteCard spriteCard = visibleCard.buildSpriteCard();
//      return _buildSpriteCard(context, spriteCard);
//    }
  }

  /// 空卡片内容.
  Widget _buildEmptyFace(BuildContext context, EmptyFace face) {
    return CustomPaint();
  }

  /// 开屏 Cards 标题.
  Widget _buildSplashTitleCard(BuildContext context, SplashTitleCard splashTitleCard) {
    return Center(
      child: SizedBox.fromSize(
        child: Image.asset('assets/cards.png',
          fit: BoxFit.contain,
        ),
        size: splashTitleCard.size,
      ),
    );
  }

  /// 精灵卡片.
  Widget _buildSpriteCard(BuildContext context, SpriteCard spriteCard) {
    return Positioned.fromRelativeRect(
      rect: RelativeRect.fill,
      child: Stack(
        children: <Widget>[
          /// 主体 (中间).
          Positioned.fromRect(
            rect: spriteCard.bodyRect,
            child: Image.asset('assets/steve.png',
              fit: BoxFit.contain,
            ),
          ),
          /// 数量 (左下角).
          Positioned.fromRect(
            rect: spriteCard.amountDigit0Rect,
            child: Image.asset('assets/digit_0.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: spriteCard.amountDigit1Rect,
            child: Image.asset('assets/digit_0.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          /// 生命值 (右上角).
          Positioned.fromRect(
            rect: spriteCard.healthRect,
            child: Image.asset('assets/health.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: spriteCard.healthDigit0Rect,
            child: Image.asset('assets/digit_0.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: spriteCard.healthDigit1Rect,
            child: Image.asset('assets/digit_0.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: spriteCard.healthDigit2Rect,
            child: Image.asset('assets/digit_slash.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: spriteCard.healthDigit3Rect,
            child: Image.asset('assets/digit_0.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: spriteCard.healthDigit4Rect,
            child: Image.asset('assets/digit_0.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          /// 武器 (左边, 右手).
          Positioned.fromRect(
            rect: spriteCard.weaponRect,
            child: Image.asset('assets/diamond_sword.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: spriteCard.weaponDigit0Rect,
            child: Image.asset('assets/digit_0.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: spriteCard.weaponDigit1Rect,
            child: Image.asset('assets/digit_0.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          /// 盾牌 (右边, 左手).
          Positioned.fromRect(
            rect: spriteCard.shieldRect,
            child: Image.asset('assets/shield.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: spriteCard.shieldDigit0Rect,
            child: Image.asset('assets/digit_0.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: spriteCard.shieldDigit1Rect,
            child: Image.asset('assets/digit_0.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          /// 效果 (右下角).
          Positioned.fromRect(
            rect: spriteCard.effectRect,
            child: Image.asset('assets/poison.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: spriteCard.effectDigit0Rect,
            child: Image.asset('assets/digit_0.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: spriteCard.effectDigit1Rect,
            child: Image.asset('assets/digit_0.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          /// 能力 (左上角).
          Positioned.fromRect(
            rect: spriteCard.powerRect,
            child: Image.asset('assets/absorption.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: spriteCard.powerDigit0Rect,
            child: Image.asset('assets/digit_0.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fromRect(
            rect: spriteCard.powerDigit1Rect,
            child: Image.asset('assets/digit_0.png',
              color: spriteCard.digitColor,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  /// 不可见的卡片.
  Widget _buildInvisibleCard(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(),
    );
  }
}
