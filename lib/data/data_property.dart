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
///  * [doubles] 关键帧数据.
///
///  * [propertyCalc] 属性计算.
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
    _PropertyData matrix4Entry32Data,
    _PropertyData rotateXData,
    _PropertyData rotateYData,
    _PropertyData scaleXData,
    _PropertyData scaleYData,
    _PropertyData elevationData,
    _PropertyData radiusData,
  }) : assert(value != null),
        assert(matrix4Entry32Data != null),
        assert(rotateXData != null),
        assert(rotateYData != null),
        assert(scaleXData != null),
        assert(scaleYData != null),
        assert(elevationData != null),
        assert(radiusData != null),
        matrix4Entry32 = matrix4Entry32Data.calc(value),
        rotateX = rotateXData.calc(value),
        rotateY = rotateYData.calc(value),
        scaleX = scaleXData.calc(value),
        scaleY = scaleYData.calc(value),
        elevation = elevationData.calc(value),
        radius = radiusData.calc(value);

  /// Matrix4.setEntry(3, 2, value).
  final double matrix4Entry32;
  final double rotateX;
  final double rotateY;
  final double scaleX;
  final double scaleY;
  final double elevation;
  final double radius;

  /// Transform.
  Matrix4 get transform => Matrix4.identity()
    ..setEntry(3, 2, matrix4Entry32)
    ..rotateX(rotateX)
    ..rotateY(rotateY)
    ..scale(scaleX, scaleY);
}

/// 属性不变化.
class _StaticProperty extends Property {
  _StaticProperty({
    double matrix4Entry32Double,
    double rotateXDouble,
    double rotateYDouble,
    double scaleXDouble,
    double scaleYDouble,
    double elevationDouble,
    double radiusDouble,
  }) : super(
    value: 0.0,
    matrix4Entry32Data: _PropertyData(
      doubles: [matrix4Entry32Double],
      propertyCalc: _propertyCalc0,
    ),
    rotateXData: _PropertyData(
      doubles: [rotateXDouble],
      propertyCalc: _propertyCalc0,
    ),
    rotateYData: _PropertyData(
      doubles: [rotateYDouble],
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
  matrix4Entry32Double: 0.005,
  rotateXDouble: 0.0,
  rotateYDouble: 0.0,
  scaleXDouble: 1.0,
  scaleYDouble: 1.0,
  elevationDouble: 1.0,
  radiusDouble: 4.0,
);

/// 用于演示.
class _SampleProperty extends Property {
  _SampleProperty({
    double value,
  }) : super(
    value: value,
    matrix4Entry32Data: _PropertyData(
      doubles: [0.005],
      propertyCalc: _propertyCalc0,
    ),
    rotateXData: _PropertyData(
      doubles: [0.0],
      propertyCalc: _propertyCalc0,
    ),
    rotateYData: _PropertyData(
      doubles: [0.0, 2.0 * pi],
      propertyCalc: _propertyCalc01,
    ),
    scaleXData: _PropertyData(
      doubles: [1.0, 2.0],
      propertyCalc: _propertyCalc010,
    ),
    scaleYData: _PropertyData(
      doubles: [1.0, 2.0],
      propertyCalc: _propertyCalc010,
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