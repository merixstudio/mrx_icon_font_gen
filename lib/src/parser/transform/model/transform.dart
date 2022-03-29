import 'package:vector_math/vector_math_64.dart';

/// An abstract matrix transform.
///
/// Many SVG elements can specify a `transform` attribute which affects nested
///
abstract class Transform {
  final Matrix3 transformMatrix;

  Transform({
    required this.transformMatrix,
  });

  String get name;
}
