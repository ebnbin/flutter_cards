part of '../data.dart';

//*********************************************************************************************************************
// 属性. 描述 Widget 属性在动画时如何变化.

/// 属性计算. 根据 [doubles] 中的多个数据和 Animation.value 计算当前值.
typedef _PropertyCalc = double Function(List<double> doubles, double value);

/// 属性数据.
///
/// [doubles] 关键帧数据.
///
/// [propertyCalc] 属性计算.
class _PropertyData {
  const _PropertyData({
    this.doubles,
    this.propertyCalc,
  });

  _PropertyData.calc0({
    double double0 = 0.0,
  }) : this(
    doubles: [double0],
    propertyCalc: (List<double> doubles, double value) {
      assert(doubles.length >= 1);
      return doubles[0];
    },
  );

  _PropertyData.calc01({
    double double0 = 0.0,
    double double1 = 0.0,
  }) : this(
    doubles: [double0, double1],
    propertyCalc: (List<double> doubles, double value) {
      assert(doubles.length >= 2);
      return doubles[0] + (doubles[1] - doubles[0]) * value;
    },
  );

  _PropertyData.calc010({
    double double0 = 0.0,
    double double1 = 0.0,
  }) : this(
    doubles: [double0, double1],
    propertyCalc: (List<double> doubles, double value) {
      assert(doubles.length >= 2);
      return doubles[0] + (doubles[1] - doubles[0]) * (1.0 - (2.0 * value - 1.0).abs());
    },
  );

  final List<double> doubles;
  final _PropertyCalc propertyCalc;

  double calc(double value) {
    return propertyCalc(doubles, value);
  }
}

/// 根据 Animation.value 计算属性.
class _Property implements Property {
  const _Property({
    this.rotateX = 0.0,
    this.rotateY = 0.0,
    this.rotateZ = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.opacity = 1.0,
    this.elevation = 1.0,
    this.radius = 4.0,
  });

  /// 通过 _PropertyData 初始化.
  _Property.data({
    double value,
    _PropertyData rotateXData,
    _PropertyData rotateYData,
    _PropertyData rotateZData,
    _PropertyData scaleXData,
    _PropertyData scaleYData,
    _PropertyData opacityData,
    _PropertyData elevationData,
    _PropertyData radiusData,
  }) : this(
    rotateX: rotateXData.calc(value),
    rotateY: rotateYData.calc(value),
    rotateZ: rotateZData.calc(value),
    scaleX: scaleXData.calc(value),
    scaleY: scaleYData.calc(value),
    opacity: opacityData.calc(value),
    elevation: elevationData.calc(value),
    radius: radiusData.calc(value),
  );

  /// 用于演示.
  _Property.sample({
    double value,
  }) : this.data(
    value: value,
    rotateXData: _PropertyData.calc0(double0: 0.0),
    rotateYData: _PropertyData.calc01(double0: 0.0, double1: 2.0 * pi),
    rotateZData: _PropertyData.calc0(double0: 0.0),
    scaleXData: _PropertyData.calc010(
      double0: 1.0,
      double1: 2.0,
    ),
    scaleYData: _PropertyData.calc010(
      double0: 1.0,
      double1: 2.0
    ),
    opacityData: _PropertyData.calc0(double0: 1.0),
    elevationData: _PropertyData.calc010(
      double0: 1.0,
      double1: 40.0,
    ),
    radiusData: _PropertyData.calc010(
      double0: 4.0,
      double1: 160.0,
    ),
  );

  /// 通过 [rotateX], [rotateY] 进场.
  ///
  /// [rotateXDegree], [rotateYDegree] 表示视觉上的进场效果旋转角度. 只能是 -270, -90, 0, 90, 270 之一.
  _Property.rotateXYIn({
    @required
    double value,
    double rotateXDegree = 0.0,
    double rotateYDegree = 0.0,
    double scale0 = 0.5,
    double opacity0 = 1.0,
    double elevation0 = 0.5,
  }) : assert(rotateXDegree == 0.0 || rotateXDegree == 90.0 || rotateXDegree == 270.0 || rotateXDegree == -90 ||
      rotateXDegree == -270),
        assert(rotateYDegree == 0.0 || rotateYDegree == 90.0 || rotateYDegree == 270.0 || rotateYDegree == -90 ||
            rotateYDegree == -270),
        rotateX = _PropertyData.calc01(
          double0: -rotateXDegree / 180.0 * pi,
          double1: 0.0,
        ).calc(value),
        rotateY = _PropertyData.calc01(
          double0: -rotateYDegree / 180.0 * pi,
          double1: 0.0,
        ).calc(value),
        rotateZ = 0.0,
        scaleX = _PropertyData.calc01(
          double0: scale0,
          double1: 1.0,
        ).calc(value),
        scaleY = _PropertyData.calc01(
          double0: scale0,
          double1: 1.0,
        ).calc(value),
        opacity = _PropertyData.calc01(
          double0: opacity0,
          double1: 1.0,
        ).calc(value),
        elevation = _PropertyData.calc01(
          double0: elevation0,
          double1: 1.0,
        ).calc(value),
        radius = 4.0;

  /// Matrix4.setEntry(3, 2, value).
  static final double matrix4Entry32 = 0.005;

  @override
  final double rotateX;
  @override
  final double rotateY;
  @override
  final double rotateZ;
  @override
  final double scaleX;
  @override
  final double scaleY;
  @override
  final double opacity;
  @override
  final double elevation;
  @override
  final double radius;

  /// Transform.
  @override
  Matrix4 get transform => Matrix4.identity()
    ..setEntry(3, 2, matrix4Entry32)
    ..rotateX(rotateX)
    ..rotateY(rotateY)
    ..rotateZ(rotateZ)
    ..scale(scaleX, scaleY);
}
