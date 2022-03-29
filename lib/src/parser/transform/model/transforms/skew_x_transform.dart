import 'dart:math';

import 'package:icon_font/src/parser/transform/model/transform.dart';
import 'package:vector_math/vector_math_64.dart';

class SkewXTransform extends Transform {
  SkewXTransform({
    required double a,
  }) : super(
          transformMatrix: Matrix3(
            1.0,
            0.0,
            0.0,
            tan(a * 2.0 * pi / 360.0),
            1.0,
            0.0,
            0.0,
            0.0,
            1.0,
          ),
        );

  @override
  String get name => 'skewX';
}
