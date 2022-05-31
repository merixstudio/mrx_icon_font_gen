import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_pair_sequence.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/command_arguments.dart';

/// A sequence of coordinate pair triplets.
///
/// Used as an argument for [CurveToCommand].
class CurveToCoordinateSequence extends CommandArguments {
  /// A list of coordinate pair triplets.
  final List<CoordinatePairTriplet> coordinatePairTriplets;

  /// Creates a [CurveToCoordinateSequence] containing given list of
  /// [CoordinatePairTriplet]s.
  CurveToCoordinateSequence({
    required this.coordinatePairTriplets,
  });

  /// Generates a text representation of the coordinate pair triplets sequence
  /// in
  /// __"[coordinatePairTriplets]\[0\] [coordinatePairTriplets]\[1\] ..."__
  /// format, that can be used to generate an SVG path.
  @override
  String toString() {
    return coordinatePairTriplets.join(' ');
  }

  /// Compares two lists of coordinate pair triplets and returns true if all
  /// their elements are equal, and the lists are the same length.
  @override
  bool operator ==(Object other) {
    if (other is! CurveToCoordinateSequence) {
      return false;
    }
    if (other.coordinatePairTriplets.length != coordinatePairTriplets.length) {
      return false;
    }
    for (int i = 0; i < coordinatePairTriplets.length; i++) {
      if (other.coordinatePairTriplets[i] != coordinatePairTriplets[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(coordinatePairTriplets);
}
