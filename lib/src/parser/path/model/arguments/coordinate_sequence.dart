import 'package:mrx_icon_font_gen/src/parser/path/model/command_arguments.dart';

/// A list of decimal coordinates.
///
/// Used as an argument of [HorizontalLineToCommand] and [VerticalLineToCommand]
/// command, it specifies a list of decimal numbers interpreted as offsets.
class CoordinateSequence extends CommandArguments {
  /// A list of coordinates.
  final List<double> coordinates;

  /// Creates a [CoordinateSequence] containing given list of coordinates
  /// (`double`s).
  CoordinateSequence({
    required this.coordinates,
  });

  /// Generates a text representation of the coordinate sequence in
  /// __"[coordinates]\[0\] [coordinates]\[1\] ..."__
  /// format, that can be used to generate an SVG path.
  @override
  String toString() {
    return coordinates.map((c) => c.toStringAsFixed(2)).join(' ');
  }

  /// Compares two lists of coordinates and returns true if all their
  /// elements are equal, and the lists are the same length.
  @override
  bool operator ==(Object other) {
    if (other is! CoordinateSequence) {
      return false;
    }
    if (other.coordinates.length != coordinates.length) {
      return false;
    }
    for (int i = 0; i < coordinates.length; i++) {
      if (other.coordinates[i] != coordinates[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(coordinates);
}
