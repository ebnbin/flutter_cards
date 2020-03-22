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
    double value = 0.0,
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

/// 无动画时的默认属性.
final Property defaultProperty = Property(
  value: 0.0,
  matrix4Entry32Data: _PropertyData(
    doubles: [0.005],
    propertyCalc: _propertyCalc0,
  ),
  rotateXData: _PropertyData(
    doubles: [0.0],
    propertyCalc: _propertyCalc0,
  ),
  rotateYData: _PropertyData(
    doubles: [0.0],
    propertyCalc: _propertyCalc0,
  ),
  scaleXData: _PropertyData(
    doubles: [1.0],
    propertyCalc: _propertyCalc0,
  ),
  scaleYData: _PropertyData(
    doubles: [1.0],
    propertyCalc: _propertyCalc0,
  ),
  elevationData: _PropertyData(
    doubles: [1.0],
    propertyCalc: _propertyCalc0,
  ),
  radiusData: _PropertyData(
    doubles: [4.0],
    propertyCalc: _propertyCalc0,
  ),
);
