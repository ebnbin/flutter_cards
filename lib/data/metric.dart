part of '../data.dart';

//*********************************************************************************************************************

/// 网格标尺. 单例.
class _Metric {
  /// 边距.
  static const int padding = 1;
  /// 主体 (不包含 padding).
  static const int bodyNoPadding = 60;
  /// Header footer (不包含 padding).
  static const int headerFooterNoPadding = 15;
  /// 主体 (包含 padding).
  static const int body = bodyNoPadding + padding * 2;
  /// Header footer (包含 padding).
  static const int headerFooter = headerFooterNoPadding + padding * 2;
  /// Header + body + footer.
  static const int safe = body + headerFooter * 2;

  static Size sizeCache;
  static EdgeInsets paddingCache;
  static int squareCache;

  static _Metric metricCache;

  /// 在 [_Game.build] 中调用.
  static void build(_Game game) {
    MediaQueryData mediaQueryData = MediaQuery.of(game.callback.context);
    if (sizeCache == mediaQueryData.size && paddingCache == mediaQueryData.padding && squareCache == game.square) {
      return;
    }

    // TODO.

    sizeCache = mediaQueryData.size;
    paddingCache = mediaQueryData.padding;
    squareCache = game.square;
    metricCache = _Metric();
  }

  /// 返回单例. 必须在第一次 [build] 后调用.
  static _Metric get() {
    if (metricCache == null) {
      throw Exception();
    }
    return metricCache;
  }

  /// 在 [_Game.dispose] 中调用.
  static void dispose() {
    metricCache = null;
    squareCache = null;
    paddingCache = null;
    sizeCache = null;
  }
}
