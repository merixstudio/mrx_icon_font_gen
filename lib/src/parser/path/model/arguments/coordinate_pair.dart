import 'package:mrx_icon_font_gen/src/parser/path/model/command_arguments.dart';

/// A pair of decimal coordinates.
///
/// Used mostly in sequences as an argument for various drawing commands.
///
/// See also:
///  * [CoordinatePairSequence], which is a wrapper for a [CoordinatePair] list.
///  * [CoordinatePairDouble], a [CoordinatePair] list with a fixed length of
///    two.
///  * [CoordinatePairTriplet], a [CoordinatePair] list with a fixed length of
///    three.
class CoordinatePair extends CommandArguments {
  /// X-axis coordinate value, stored with precision of two decimal places.
  final double x;

  /// Y-axis coordinate value, stored with precision of two decimal places.
  final double y;

  /// Creates a pair of coordinates and applies a rounding to two decimal
  /// digits.
  CoordinatePair({
    required double x,
    required double y,
  })  : x = double.parse(x.toStringAsFixed(2)),
        y = double.parse(y.toStringAsFixed(2));

  /// Generates a text representation of the coordinates in __"[x] [y]"__ format,
  /// that can be used to generate an SVG path.
  @override
  String toString() {
    return '${x.toStringAsFixed(2)} ${y.toStringAsFixed(2)}';
  }

  /// Compares two pairs of coordinates and returns true if all their respective
  /// components are equal.
  @override
  bool operator ==(Object other) {
    if (other is! CoordinatePair) {
      return false;
    }
    return x == other.x && y == other.y;
  }

  @override
  int get hashCode => Object.hash(x, y);
}
