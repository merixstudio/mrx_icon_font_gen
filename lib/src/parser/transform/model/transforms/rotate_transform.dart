import 'dart:math';

import 'package:icon_font/src/parser/transform/model/transform.dart';
import 'package:vector_math/vector_math_64.dart';

class RotateTransform extends Transform {
  RotateTransform({
    required double a,
    double? cx,
    double? cy,
  }) : super(
          transformMatrix: (Matrix3.identity()
            ..setColumn(
              2,
              Vector3((cx ?? 0.0), (cy ?? 0.0), 1.0),
            ))
            ..multiply(
              Matrix3.identity()..setRotationZ(2.0 * pi * a / 360.0),
            )
            ..multiply(
              Matrix3.identity()
                ..setColumn(
                  2,
                  Vector3(-(cx ?? 0.0), -(cy ?? 0.0), 1.0),
                ),
            ),
        );

  @override
  String get name => 'rotate';
}
