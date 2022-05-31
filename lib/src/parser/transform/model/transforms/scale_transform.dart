import 'package:mrx_icon_font_gen/src/parser/transform/model/transform.dart';
import 'package:vector_math/vector_math_64.dart';

class ScaleTransform extends Transform {
  ScaleTransform({
    required double sx,
    double? sy,
  }) : super(
          transformMatrix: Matrix3(
            sx,
            0.0,
            0.0,
            0.0,
            sy ?? sx,
            0.0,
            0.0,
            0.0,
            1.0,
          ),
        );

  @override
  String get name => 'scale';
}
