part of '../data.dart';

//*********************************************************************************************************************

/// 卡片行列范围. 包含 [from] 和 [to]. [to] 必须大等于 [from], 否则 [isValid] 为 false.
class _CardRowColumnRange {
  _CardRowColumnRange(this.from, this.to);

  final int from;
  final int to;

  bool contain(_CardRowColumnRange other) {
    for (int i = from; i <= to; i++) {
      for (int j = other.from; j <= other.to; j++) {
        if (i == j) {
          return true;
        }
      }
    }
    return false;
  }

  bool containValue(int value) {
    return value >= from && value <= to;
  }

  bool isValid() {
    return to >= from;
  }
}

enum _LTRB {
  left,
  top,
  right,
  bottom,
}

extension _LTRBExtension on _LTRB {
  /// 按照 [clockwise] 顺时针或逆时针顺序依次返回从当前方向开始的四个方向列表.
  BuiltList<_LTRB> turns({
    bool clockwise = false,
  }) {
    List<_LTRB> list = _LTRB.values + _LTRB.values;
    if (!clockwise) {
      list = list.reversed.toList();
    }
    int start = list.indexOf(this);
    return list.sublist(start, start + _LTRB.values.length).toBuiltList();
  }

  int get x {
    switch (this) {
      case _LTRB.left:
        return -1;
      case _LTRB.top:
        return 0;
      case _LTRB.right:
        return 1;
      case _LTRB.bottom:
        return 0;
      default:
        throw Exception();
    }
  }

  int get y {
    switch (this) {
      case _LTRB.left:
        return 0;
      case _LTRB.top:
        return -1;
      case _LTRB.right:
        return 0;
      case _LTRB.bottom:
        return 1;
      default:
        throw Exception();
    }
  }
}

/// 卡片类型.
enum _CardType {
  core,
  headerFooter,
}
