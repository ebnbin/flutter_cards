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
            foregroundPainter: Metric.get().debugForegroundPainter,
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
      return _buildVisibleCard(visibleCard);
    } else {
      return _buildInvisibleCard();
    }
  }

  /// 可见的卡片.
  Widget _buildVisibleCard(VisibleCard visibleCard) {
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
              child: _buildGridCardOr(visibleCard),
            ),
          ),
        ),
      ),
    );
  }

  /// TODO.
  Widget _buildGridCardOr(VisibleCard visibleCard) {
    if (visibleCard.isGridCard) {
      GridCard gridCard = visibleCard.buildGridCard();
      return _buildGridCard(gridCard);
    } else {
      return CustomPaint();
    }
  }

  /// 根据网格定位的卡片, 渲染为 Material 卡片.
  Widget _buildGridCard(GridCard gridCard) {
    return Container(
      margin: EdgeInsets.all(gridCard.margin),
      child: Material(
        elevation: gridCard.elevation,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(gridCard.radius),
        clipBehavior: Clip.hardEdge,
        animationDuration: Duration.zero,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              _buildGridCardBackground(gridCard),
              _buildGridCardChildren(gridCard),
            ],
          ),
          onTap: gridCard.onTap,
          onLongPress: gridCard.onLongPress,
        ),
      ),
    );
  }

  /// 网格卡片背景.
  Widget _buildGridCardBackground(GridCard gridCard) {
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

  Widget _buildGridCardChildren(GridCard gridCard) {
    if (gridCard.isSplashTitleCard) {
      SplashTitleCard splashTitleCard = gridCard.buildSplashTitleCard();
      return _buildSplashTitleCard(splashTitleCard);
    }
    if (gridCard.isSpriteCard) {
      SpriteCard spriteCard = gridCard.buildSpriteCard();
      return _buildSpriteCard(spriteCard);
    }
    return CustomPaint();
  }

  /// 开屏 Cards 标题.
  Widget _buildSplashTitleCard(SplashTitleCard splashTitleCard) {
    return Positioned.fromRect(
      rect: splashTitleCard.rect,
      child: Image.asset('assets/cards.png',
        fit: BoxFit.contain,
      ),
    );
  }

  /// 精灵卡片.
  Widget _buildSpriteCard(SpriteCard spriteCard) {
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
  Widget _buildInvisibleCard() {
    return Positioned.fill(
      child: CustomPaint(),
    );
  }
}
