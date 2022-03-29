import 'package:icon_font/src/parser/path/model/arguments/coordinate_pair.dart';
import 'package:icon_font/src/parser/path/model/arguments/coordinate_pair_sequence.dart';
import 'package:icon_font/src/parser/path/model/arguments/curve_to_coordinate_sequence.dart';
import 'package:icon_font/src/parser/path/model/command.dart';
import 'package:vector_math/vector_math_64.dart';

/// A `curveto` draw instruction.
///
/// An SVG path instruction that draws a Bezier curve.
class CurveToCommand extends Command {
  /// Returns `'C'`
  @override
  String get absoluteCommandName => 'C';

  /// Returns `'c'`
  @override
  String get relativeCommandName => 'c';

  /// Creates a [CurveToCommand] instance.
  ///
  /// One of the [command] and [isRelative] parameters must be given.
  /// [command] must be either `'c'` or `'C'`.
  CurveToCommand({
    String? command,
    bool? isRelative,
    required CurveToCoordinateSequence commandArguments,
  }) : super(
          name: command,
          isRelative: isRelative,
          commandArguments: commandArguments,
        );

  /// Returns a single-element list containing transformed [CurveToCommand].
  ///
  /// The [CurveToCommand] can be easily transformed by applying transformation
  /// matrix to its argument, which is a sequence of triplets of points.
  @override
  List<Command> applyTransformation(
    Matrix3 transform,
    CoordinatePair startPoint,
  ) {
    final Matrix3 transformationMatrix = isAbsolute
        ? transform
        : (transform.clone()..setColumn(2, Vector3(0.0, 0.0, 1.0)));
    final CurveToCoordinateSequence transformedCommandArguments =
        CurveToCoordinateSequence(
      coordinatePairTriplets: (commandArguments as CurveToCoordinateSequence)
          .coordinatePairTriplets
          .map((cpt) {
        return CoordinatePairTriplet(
          coordinatePairs: cpt.coordinatePairs.map((cp) {
            final Vector3 transformedCoordinates =
                transformationMatrix.transform(Vector3(cp.x, cp.y, 1.0));
            return CoordinatePair(
              x: transformedCoordinates.x,
              y: transformedCoordinates.y,
            );
          }).toList(),
        );
      }).toList(),
    );
    return [
      CurveToCommand(
        command: command,
        commandArguments: transformedCommandArguments,
      ),
    ];
  }

  @override
  CoordinatePair getLastPoint(
    CoordinatePair previousPoint, {
    CoordinatePair? startPoint,
  }) {
    if (isAbsolute) {
      return (commandArguments as CurveToCoordinateSequence)
          .coordinatePairTriplets
          .last
          .coordinatePairs
          .last;
    }
    double x = previousPoint.x;
    double y = previousPoint.y;
    for (final CoordinatePairTriplet cpt
        in (commandArguments as CurveToCoordinateSequence)
            .coordinatePairTriplets) {
      x += cpt.coordinatePairs.last.x;
      y += cpt.coordinatePairs.last.y;
    }
    return CoordinatePair(
      x: x,
      y: y,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! CurveToCommand) {
      return false;
    }
    return command == other.command &&
        commandArguments as CurveToCoordinateSequence ==
            other.commandArguments as CurveToCoordinateSequence;
  }

  @override
  int get hashCode => Object.hash(command, commandArguments);
}
