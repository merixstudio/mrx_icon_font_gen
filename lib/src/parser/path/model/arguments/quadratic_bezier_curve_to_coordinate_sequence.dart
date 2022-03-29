import 'package:icon_font/src/parser/path/model/arguments/coordinate_pair_sequence.dart';
import 'package:icon_font/src/parser/path/model/command_arguments.dart';


class QuadraticBezierCurveToCoordinateSequence extends CommandArguments {
  final List<CoordinatePairDouble> coordinatePairDoubles;

  QuadraticBezierCurveToCoordinateSequence({
    required this.coordinatePairDoubles,
  });

  @override
  String toString() {
    return coordinatePairDoubles.join(' ');
  }

  @override
  bool operator ==(Object other) {
    if (other is! QuadraticBezierCurveToCoordinateSequence) {
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
