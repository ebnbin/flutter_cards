import 'package:flutter/material.dart';

class MaterialCard extends Card {
  const MaterialCard({
    Key key,
    Color color,
    Color shadowColor,
    double elevation,
    ShapeBorder shape,
    bool borderOnForeground = true,
    EdgeInsetsGeometry margin,
    Clip clipBehavior,
    Widget child,
    bool semanticContainer = true,
  }) : super(
    key: key,
    color: color,
    shadowColor: shadowColor,
    elevation: elevation,
    shape: shape,
    borderOnForeground: borderOnForeground,
    margin: margin,
    clipBehavior: clipBehavior,
    child: child,
    semanticContainer: semanticContainer,
  );
}
