part of 'data.dart';

//*********************************************************************************************************************
// 属性. 描述 Widget 属性在动画时如何变化.

/// 属性计算. 根据 [doubles] 中的多个数据和 Animation.value 计算当前值.
typedef _PropertyCalc = double Function(List<double> doubles, double value);

final _PropertyCalc _propertyCalc0 = (List<double> doubles, double value) {
  assert(doubles.length >= 1);
  return doubles[0];
};

final _PropertyCalc _propertyCalc01 = (List<double> doubles, double value) {
  assert(doubles.length >= 2);
  return doubles[0] + (doubles[1] - doubles[0]) * value;
};

final _PropertyCalc _propertyCalc010 = (List<double> doubles, double value) {
  assert(doubles.length >= 2);
  return doubles[0] + (doubles[1] - doubles[0]) * (1.0 - (2.0 * value - 1.0).abs());
};

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

  final List<double> doubles;
  final _PropertyCalc propertyCalc;

  double calc(double value) {
    return propertyCalc(doubles, value);
  }
}

/// 根据 Animation.value 计算属性.
class Property {
  Property({
    double value,
    _PropertyData rotateXData,
    _PropertyData rotateYData,
    _PropertyData rotateZData,
    _PropertyData scaleXData,
    _PropertyData scaleYData,
    _PropertyData opacityData,
    _PropertyData elevationData,
    _PropertyData radiusData,
  }) : assert(value != null),
        assert(rotateXData != null),
        assert(rotateYData != null),
        assert(rotateZData != null),
        assert(scaleXData != null),
        assert(scaleYData != null),
        assert(opacityData != null),
        assert(elevationData != null),
        assert(radiusData != null),
        rotateX = rotateXData.calc(value),
        rotateY = rotateYData.calc(value),
        rotateZ = rotateZData.calc(value),
        scaleX = scaleXData.calc(value),
        scaleY = scaleYData.calc(value),
        opacity = opacityData.calc(value),
        elevation = elevationData.calc(value),
        radius = radiusData.calc(value);

  /// 通过 [rotateX], [rotateY] 进场.
  ///
  /// [rotateXDegree], [rotateYDegree] 表示视觉上的进场效果旋转角度. 只能是 -270, -90, 0, 90, 270 之一.
  Property._rotateXYIn({
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
        rotateX = _PropertyData(
          doubles: [-rotateXDegree / 180.0 * pi, 0.0],
          propertyCalc: _propertyCalc01,
        ).calc(value),
        rotateY = _PropertyData(
          doubles: [-rotateYDegree / 180.0 * pi, 0.0],
          propertyCalc: _propertyCalc01,
        ).calc(value),
        rotateZ = 0.0,
        scaleX = _PropertyData(
          doubles: [scale0, 1.0],
          propertyCalc: _propertyCalc01,
        ).calc(value),
        scaleY = _PropertyData(
          doubles: [scale0, 1.0],
          propertyCalc: _propertyCalc01,
        ).calc(value),
        opacity = _PropertyData(
          doubles: [opacity0, 1.0],
          propertyCalc: _propertyCalc01,
        ).calc(value),
        elevation = _PropertyData(
          doubles: [elevation0, 1.0],
          propertyCalc: _propertyCalc01,
        ).calc(value),
        radius = 4.0;

  /// Matrix4.setEntry(3, 2, value).
  static final double matrix4Entry32 = 0.005;

  final double rotateX;
  final double rotateY;
  final double rotateZ;
  final double scaleX;
  final double scaleY;
  final double opacity;
  final double elevation;
  final double radius;

  /// Transform.
  Matrix4 get transform => Matrix4.identity()
    ..setEntry(3, 2, matrix4Entry32)
    ..rotateX(rotateX)
    ..rotateY(rotateY)
    ..rotateZ(rotateZ)
    ..scale(scaleX, scaleY);
}

/// 属性不变化.
class _StaticProperty extends Property {
  _StaticProperty({
    double rotateXDouble,
    double rotateYDouble,
    double rotateZDouble,
    double scaleXDouble,
    double scaleYDouble,
    double opacityDouble,
    double elevationDouble,
    double radiusDouble,
  }) : super(
    value: 0.0,
    rotateXData: _PropertyData(
      doubles: [rotateXDouble],
      propertyCalc: _propertyCalc0,
    ),
    rotateYData: _PropertyData(
      doubles: [rotateYDouble],
      propertyCalc: _propertyCalc0,
    ),
    rotateZData: _PropertyData(
      doubles: [rotateZDouble],
      propertyCalc: _propertyCalc0,
    ),
    scaleXData: _PropertyData(
      doubles: [scaleXDouble],
      propertyCalc: _propertyCalc0,
    ),
    scaleYData: _PropertyData(
      doubles: [scaleYDouble],
      propertyCalc: _propertyCalc0,
    ),
    opacityData: _PropertyData(
      doubles: [opacityDouble],
      propertyCalc: _propertyCalc0,
    ),
    elevationData: _PropertyData(
      doubles: [elevationDouble],
      propertyCalc: _propertyCalc0,
    ),
    radiusData: _PropertyData(
      doubles: [radiusDouble],
      propertyCalc: _propertyCalc0,
    ),
  );
}

/// 无动画时的默认属性.
final Property defaultProperty = _StaticProperty(
  rotateXDouble: 0.0,
  rotateYDouble: 0.0,
  rotateZDouble: 0.0,
  scaleXDouble: 1.0,
  scaleYDouble: 1.0,
  opacityDouble: 1.0,
  elevationDouble: 1.0,
  radiusDouble: 4.0,
);

/// 用于演示.
class _SampleProperty extends Property {
  _SampleProperty({
    double value,
  }) : super(
    value: value,
    rotateXData: _PropertyData(
      doubles: [0.0],
      propertyCalc: _propertyCalc0,
    ),
    rotateYData: _PropertyData(
      doubles: [0.0, 2.0 * pi],
      propertyCalc: _propertyCalc01,
    ),
    rotateZData: _PropertyData(
      doubles: [0.0],
      propertyCalc: _propertyCalc0,
    ),
    scaleXData: _PropertyData(
      doubles: [1.0, 2.0],
      propertyCalc: _propertyCalc010,
    ),
    scaleYData: _PropertyData(
      doubles: [1.0, 2.0],
      propertyCalc: _propertyCalc010,
    ),
    opacityData: _PropertyData(
      doubles: [1.0],
      propertyCalc: _propertyCalc0,
    ),
    elevationData: _PropertyData(
      doubles: [1.0, 4.0],
      propertyCalc: _propertyCalc010,
    ),
    radiusData: _PropertyData(
      doubles: [4.0, 16.0],
      propertyCalc: _propertyCalc010,
    ),
  );
}
