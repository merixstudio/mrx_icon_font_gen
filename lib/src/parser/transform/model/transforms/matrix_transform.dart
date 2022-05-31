import 'package:mrx_icon_font_gen/src/parser/transform/model/transform.dart';
import 'package:vector_math/vector_math_64.dart';

class MatrixTransform extends Transform {
  MatrixTransform({
    required double a,
    required double b,
    required double c,
    required double d,
    required double e,
    required double f,
  }) : super(
          transformMatrix: Matrix3(
            a,
            b,
            0.0,
            c,
            d,
            0.0,
            e,
            f,
            1.0,
          ),
        );

  @override
  String get name => 'matrix';
}
