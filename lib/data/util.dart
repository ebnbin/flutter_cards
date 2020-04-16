part of '../data.dart';

//*********************************************************************************************************************
//*********************************************************************************************************************
// 方向.

extension _AxisDirectionExtension on AxisDirection {
  /// 水平方向值.
  int get x {
    switch (this) {
      case AxisDirection.up:
        return 0;
      case AxisDirection.right:
        return 1;
      case AxisDirection.down:
        return 0;
      case AxisDirection.left:
        return -1;
      default:
        throw Exception();
    }
  }

  /// 垂直方向值.
  int get y {
    switch (this) {
      case AxisDirection.up:
        return -1;
      case AxisDirection.right:
        return 0;
      case AxisDirection.down:
        return 1;
      case AxisDirection.left:
        return 0;
      default:
        throw Exception();
    }
  }
}

//*********************************************************************************************************************
//*********************************************************************************************************************
// 旋转角度.

/// 可见的旋转角度. -360, -180, 180, 360.
enum _VisibleAngle {
  counterClockwise360,
  counterClockwise180,
  clockwise180,
  clockwise360,
}

extension _VisibleAngleExtension on _VisibleAngle {
  /// 值.
  double get value {
    switch (this) {
      case _VisibleAngle.counterClockwise360:
        return -2.0 * pi;
      case _VisibleAngle.counterClockwise180:
        return -pi;
      case _VisibleAngle.clockwise180:
        return pi;
      case _VisibleAngle.clockwise360:
        return 2.0 * pi;
      default:
        throw Exception();
    }
  }
}

/// 不可见的旋转角度. -270, -90, 90, 270.
enum _InvisibleAngle {
  counterClockwise270,
  counterClockwise90,
  clockwise90,
  clockwise270,
}

extension _InvisibleAngleExtension on _InvisibleAngle {
  /// 值.
  double get value {
    switch (this) {
      case _InvisibleAngle.counterClockwise270:
        return -1.5 * pi;
      case _InvisibleAngle.counterClockwise90:
        return -0.5 * pi;
      case _InvisibleAngle.clockwise90:
        return 0.5 * pi;
      case _InvisibleAngle.clockwise270:
        return 1.5 * pi;
      default:
        throw Exception();
    }
  }
}
