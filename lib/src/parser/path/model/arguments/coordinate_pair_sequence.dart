import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_pair.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/command_arguments.dart';

/// A sequence of [CoordinatePair]s.
///
/// Used as an argument for [LineToCommand] and
/// [SmoothQuadraticBezierCurveToCommand].
///
/// See also:
///  * [CoordinatePairDouble], a [CoordinatePair] list with a fixed length of
///    two.
///  * [CoordinatePairTriplet], a [CoordinatePair] list with a fixed length of
///    three.
class CoordinatePairSequence extends CommandArguments {
  /// A list of coordinate pairs.
  final List<CoordinatePair> coordinatePairs;

  /// Creates a [CoordinatePairSequence] containing given list of
  /// [CoordinatePair]s.
  CoordinatePairSequence({
    required this.coordinatePairs,
  });

  /// Generates a text representation of the coordinate pairs sequence in
  /// __"[coordinatePairs]\[0\].x [coordinatePairs]\[0\].y [coordinatePairs]\[1\].x [coordinatePairs]\[1\].y ..."__
  /// format, that can be used to generate an SVG path.
  @override
  String toString() {
    return coordinatePairs.join(' ');
  }

  /// Compares two lists of coordinate pairs and returns true if all their
  /// elements are equal, and the lists are the same length.
  @override
  bool operator ==(Object other) {
    if (other is! CoordinatePairSequence) {
      return false;
    }
    if (other.coordinatePairs.length != coordinatePairs.length) {
      return false;
    }
    for (int i = 0; i < coordinatePairs.length; i++) {
      if (other.coordinatePairs[i] != coordinatePairs[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(coordinatePairs);
}

/// An extension of [CoordinatePairSequence] that contains a list of
/// [CoordinatePair]s with a fixed length of two.
class CoordinatePairDouble extends CoordinatePairSequence {
  /// Creates a [CoordinatePairSequence] containing given list of
  /// [CoordinatePair]s. Accepts only a list with a length of two.
  CoordinatePairDouble({
    required List<CoordinatePair> coordinatePairs,
  })  : assert(coordinatePairs.length == 2),
        super(
          coordinatePairs: coordinatePairs,
        );
}

/// An extension of [CoordinatePairSequence] that contains a list of
/// [CoordinatePair]s with a fixed length of three.
class CoordinatePairTriplet extends CoordinatePairSequence {
  /// Creates a [CoordinatePairSequence] containing given list of
  /// [CoordinatePair]s. Accepts only a list with a length of three.
  CoordinatePairTriplet({
    required List<CoordinatePair> coordinatePairs,
  })  : assert(coordinatePairs.length == 3),
        super(
          coordinatePairs: coordinatePairs,
        );
}
