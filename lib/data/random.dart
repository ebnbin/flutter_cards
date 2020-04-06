part of '../data.dart';

//*********************************************************************************************************************

/// 随机数.
final Random _random = Random();

extension _Random on Random {
  /// 包含 [from] 和 [to].
  int nextIntFromTo(int from, int to) {
    return this.nextInt(to - from + 1) + from;
  }

  /// 列表中随机的一个 item.
  T nextListItem<T>(List<T> list) {
    if (list.isEmpty) {
      return null;
    }
    return list[this.nextInt(list.length)];
  }
}
