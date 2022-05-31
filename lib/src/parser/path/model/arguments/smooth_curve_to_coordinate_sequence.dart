import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_pair_sequence.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/command_arguments.dart';

/// A sequence of [CoordinatePairDouble]s.
///
/// Used as an argument for [SmoothCurveToCommand].
class SmoothCurveToCoordinateSequence extends CommandArguments {
  /// A list of coordinate pair doubles.
  final List<CoordinatePairDouble> coordinatePairDoubles;

  /// Creates a [SmoothCurveToCoordinateSequence] containing given list of
  /// [CoordinatePairDouble]s.
  SmoothCurveToCoordinateSequence({
    required this.coordinatePairDoubles,
  });

  /// Generates a text representation of the coordinate pair doubles sequence in
  /// __"[coordinatePairDoubles]\[0\] [coordinatePairDoubles]\[1\] ..."__
  /// format, that can be used to generate an SVG path.
  @override
  String toString() {
    return coordinatePairDoubles.join(' ');
  }

  /// Compares two lists of coordinate pair doubles and returns true if all
  /// their elements are equal, and the lists are the same length.
  @override
  bool operator ==(Object other) {
    if (other is! SmoothCurveToCoordinateSequence) {
      return false;
    }
    if (other.coordinatePairDoubles.length != coordinatePairDoubles.length) {
      return false;
    }
    for (int i = 0; i < coordinatePairDoubles.length; i++) {
      if (other.coordinatePairDoubles[i] != coordinatePairDoubles[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(coordinatePairDoubles);
}
