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
      child: Image.asset(game.background,
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
//                  shadowColor: Colors.cyanAccent,
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
          /// 主体 (中间).
          _buildSpriteFaceImage(context, face.body),
          /// 武器 (左边, 右手).
          _buildSpriteFaceImage(context, face.weapon),
          _buildSpriteFaceDigit(context, face.weaponDigit0),
          _buildSpriteFaceDigit(context, face.weaponDigit1),
          /// 盾牌 (右边, 左手).
          _buildSpriteFaceImage(context, face.shield),
          _buildSpriteFaceDigit(context, face.shieldDigit0),
          _buildSpriteFaceDigit(context, face.shieldDigit1),
          /// 生命值 (右上角).
          _buildSpriteFaceImage(context, face.health),
          _buildSpriteFaceDigit(context, face.healthDigit0),
          _buildSpriteFaceDigit(context, face.healthDigit1),
          _buildSpriteFaceDigit(context, face.healthDigit2),
          _buildSpriteFaceDigit(context, face.healthDigit3),
          _buildSpriteFaceDigit(context, face.healthDigit4),
          /// 效果 (右下角).
          _buildSpriteFaceImage(context, face.effect),
          _buildSpriteFaceDigit(context, face.effectDigit0),
          _buildSpriteFaceDigit(context, face.effectDigit1),
          /// 数量 (左下角).
          _buildSpriteFaceDigit(context, face.amountDigit0),
          _buildSpriteFaceDigit(context, face.amountDigit1),
          /// 能力 (左上角).
          _buildSpriteFaceImage(context, face.power),
          _buildSpriteFaceDigit(context, face.powerDigit0),
          _buildSpriteFaceDigit(context, face.powerDigit1),
        ],
      ),
    );
  }

  /// 精灵图片.
  Widget _buildSpriteFaceImage(BuildContext context, SpriteFaceImage spriteFaceImage) {
    if (!spriteFaceImage.visible) {
      return _buildInvisible(context);
    }
    return Positioned.fromRect(
      rect: spriteFaceImage.rect,
      child: Image.asset(spriteFaceImage.image,
        fit: BoxFit.contain,
      ),
    );
  }

  /// 精灵数字.
  Widget _buildSpriteFaceDigit(BuildContext context, SpriteFaceDigit spriteFaceDigit) {
    if (!spriteFaceDigit.visible) {
      return _buildInvisible(context);
    }
    return Positioned.fromRect(
      rect: spriteFaceDigit.rect,
      child: Image.asset(spriteFaceDigit.image,
        color: spriteFaceDigit.color,
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
