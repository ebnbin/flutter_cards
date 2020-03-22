part of 'data.dart';

//*********************************************************************************************************************
// 游戏中所有元素都由卡片组成.

abstract class CardData implements Comparable<CardData> {
  CardData({
    this.gameData,
    this.defaultProperty,
  }) : assert(gameData != null),
        assert(defaultProperty != null) {
    _resetProperty();
    _updateAnimationTimestamp();
  }

  //*******************************************************************************************************************

  final GameData gameData;

  //*******************************************************************************************************************

  /// 是否可见.
  bool get visible => _visible;
  bool _visible = true;

  //*******************************************************************************************************************
  // 位置.

  /// 在 Stack 中的位置. Positioned.fromRect().
  Rect rect(BuildContext context);

  //*******************************************************************************************************************
  // 属性.

  /// 默认属性.
  final Property defaultProperty;

  /// 属性.
  Property get property => _property;
  Property _property;

  /// 重设默认属性.
  void _resetProperty() {
    _property = defaultProperty;
  }

  //*******************************************************************************************************************

  int _animationTimestamp;

  /// 每次动画结束后调用.
  ///
  /// 因为动画可能导致 Card z-index 变化, 在 Stack 中的表现是 children 顺序发生变化, Card 相关的动画 (阴影, 圆角) 更新是异步的,
  /// 更新 Stack 中的 children 顺序可能导致 Card 动画渲染出现位置错乱, 比如点击的是第 n 个 Card, 更新的却是第 n + 1 个 Card
  /// 的阴影效果. 而通常情况下动画会导致当前 Card 的 elevation 变大, 也就是在 Stack 中的 index 变大, 因此每次动画完成后更新
  /// _animationTimestamp 可以在动画结束时保持 index 而不是还原, 具体算法在 [compareTo] 方法中.
  void _updateAnimationTimestamp() {
    _animationTimestamp = DateTime.now().microsecondsSinceEpoch;
  }

  /// 优先比较 elevation, elevation 越大表示 z-index 越大, 在 Stack 中越后绘制, 也就在越上层. 其次比较时间戳, 保证 compareTo
  /// 始终不返回 0, 每次动画后需要更新时间戳, 具体参见 [_updateAnimationTimestamp].
  @override
  int compareTo(CardData other) {
    if (_property.elevation == other._property.elevation) {
      return (_animationTimestamp - other._animationTimestamp).sign;
    }
    return (_property.elevation - other._property.elevation).sign.toInt();
  }
}

//*********************************************************************************************************************

/// 带索引的卡片.
class IndexedCardData extends CardData {
  IndexedCardData({
    GameData gameData,
    Property defaultProperty,
    int rowIndex,
    int columnIndex,
    int rowSpan = 1,
    int columnSpan = 1,
  }) : assert(rowIndex != null),
        assert(columnIndex != null),
        assert(rowSpan != null),
        assert(columnSpan != null),
        super(
        gameData: gameData,
        defaultProperty: defaultProperty,
      ) {
    _rowIndex = rowIndex;
    _columnIndex = columnIndex;
    _rowSpan = rowSpan;
    _columnSpan = columnSpan;
  }

  /// 所在行.
  int _rowIndex;

  /// 所在列.
  int _columnIndex;

  /// 跨行.
  int _rowSpan;

  /// 跨列.
  int _columnSpan;

  @override
  Rect rect(BuildContext context) {
    const double padding = 8.0;
    Size safeSize = util.safeSize(context,
      padding: padding,
    );
    if (safeSize.width < safeSize.height) {
      // 竖屏.
    } else {
      // 横屏.
    }
    // 卡片宽高.
    double cardSize = min(safeSize.width / gameData._columnCount, safeSize.height / gameData._rowCount);
    // 左边距.
    double spaceLeft = (safeSize.width - cardSize * gameData._columnCount) / 2.0 + padding;
    // 上边距.
    double spaceTop = (safeSize.height - cardSize * gameData._rowCount) / 2.0 + padding;
    return Rect.fromLTWH(
      spaceLeft + cardSize * _columnIndex,
      spaceTop + cardSize * _rowIndex,
      cardSize * _columnSpan,
      cardSize * _rowSpan,
    );
  }

  @override
  String toString() {
    return '$_rowIndex,$_columnIndex';
  }
}
