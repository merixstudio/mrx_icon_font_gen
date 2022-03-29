import 'package:icon_font/src/parser/path/model/arguments/elliptical_arc_argument.dart';
import 'package:icon_font/src/parser/path/model/command_arguments.dart';

/// A sequence of [EllipticalArcArgument]s.
///
/// Used as an argument for [EllipticalArcCommand].
class EllipticalArcArgumentSequence extends CommandArguments {
  /// A list of arguments for consecutive elliptical arcs.
  final List<EllipticalArcArgument> ellipticalArcArguments;

  /// Creates an [EllipticalArcArgumentSequence] containing given list of
  /// [EllipticalArcArgument]s.
  EllipticalArcArgumentSequence({
    required this.ellipticalArcArguments,
  });

  /// Generates a text representation of the elliptical arc arguments sequence
  /// in __"[ellipticalArcArguments]\[0\] [ellipticalArcArguments]\[1\] ..."__
  /// format, that can be used to generate an SVG path.
  @override
  String toString() {
    return ellipticalArcArguments.join(' ');
  }

  /// Compares two lists of elliptical arc arguments and returns true if all
  /// their elements are equal, and the lists are the same length.
  @override
  bool operator ==(Object other) {
    if (other is! EllipticalArcArgumentSequence) {
      return false;
    }
    if (other.ellipticalArcArguments.length != ellipticalArcArguments.length) {
      return false;
    }
    for (int i = 0; i < ellipticalArcArguments.length; i++) {
      if (other.ellipticalArcArguments[i] != ellipticalArcArguments[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(ellipticalArcArguments);
}
