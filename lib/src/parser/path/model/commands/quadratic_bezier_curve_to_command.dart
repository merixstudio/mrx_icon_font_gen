import 'package:icon_font/src/parser/path/model/arguments/coordinate_pair.dart';
import 'package:icon_font/src/parser/path/model/arguments/coordinate_pair_sequence.dart';
import 'package:icon_font/src/parser/path/model/arguments/quadratic_bezier_curve_to_coordinate_sequence.dart';
import 'package:icon_font/src/parser/path/model/command.dart';
import 'package:vector_math/vector_math_64.dart';

/// A `quadratic bezier curveto` draw instruction.
///
/// An SVG path instruction that draws a quadratic Bezier curve.
class QuadraticBezierCurveToCommand extends Command {
  /// Returns `'Q'`
  @override
  String get absoluteCommandName => 'Q';

  /// Returns `'q'`
  @override
  String get relativeCommandName => 'q';

  /// Creates a [QuadraticBezierCurveToCommand] instance.
  ///
  /// One of the [command] and [isRelative] parameters must be given.
  /// [command] must be either `'q'` or `'Q'`.
  QuadraticBezierCurveToCommand({
    String? command,
    bool? isRelative,
    required QuadraticBezierCurveToCoordinateSequence commandArguments,
  }) : super(
          name: command,
          isRelative: isRelative,
          commandArguments: commandArguments,
        );

  /// Returns a single-element list containing transformed
  /// [QuadraticBezierCurveToCommand].
  ///
  /// The [QuadraticBezierCurveToCommand] can be easily transformed by applying
  /// transformation matrix to its argument, which is a sequence of pairs of
  /// points.
  @override
  List<Command> applyTransformation(
    Matrix3 transform,
    CoordinatePair startPoint,
  ) {
    final Matrix3 transformationMatrix = isAbsolute
        ? transform
        : (transform.clone()..setColumn(2, Vector3(0.0, 0.0, 1.0)));
    final QuadraticBezierCurveToCoordinateSequence transformedCommandArguments =
        QuadraticBezierCurveToCoordinateSequence(
      coordinatePairDoubles:
          (commandArguments as QuadraticBezierCurveToCoordinateSequence)
              .coordinatePairDoubles
              .map((cpd) {
        return CoordinatePairDouble(
          coordinatePairs: cpd.coordinatePairs.map((cp) {
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
      QuadraticBezierCurveToCommand(
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
      return (commandArguments as QuadraticBezierCurveToCoordinateSequence)
          .coordinatePairDoubles
          .last
          .coordinatePairs
          .last;
    }
    double x = previousPoint.x;
    double y = previousPoint.y;
    for (final CoordinatePairDouble cpd
        in (commandArguments as QuadraticBezierCurveToCoordinateSequence)
            .coordinatePairDoubles) {
      x += cpd.coordinatePairs.last.x;
      y += cpd.coordinatePairs.last.y;
    }
    return CoordinatePair(
      x: x,
      y: y,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! QuadraticBezierCurveToCommand) {
      return false;
    }
    return command == other.command &&
        commandArguments as QuadraticBezierCurveToCoordinateSequence ==
            other.commandArguments as QuadraticBezierCurveToCoordinateSequence;
  }

  @override
  int get hashCode => Object.hash(command, commandArguments);
}
