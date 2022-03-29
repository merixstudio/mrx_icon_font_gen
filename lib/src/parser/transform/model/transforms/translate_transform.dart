import 'package:icon_font/src/parser/transform/model/transform.dart';
import 'package:vector_math/vector_math_64.dart';

class TranslateTransform extends Transform {
  TranslateTransform({
    required double tx,
    required double ty,
  }) : super(
          transformMatrix: Matrix3(
            1.0,
            0.0,
            0.0,
            0.0,
            1.0,
            0.0,
            tx,
            ty,
            1.0,
          ),
        );

  @override
  String get name => 'translate';
}
