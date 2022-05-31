import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_pair.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_pair_sequence.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/command.dart';
import 'package:vector_math/vector_math_64.dart';

/// A `smooth quadratic bezier curveto` draw instruction.
///
/// An SVG path instruction that draws a quadratic Bezier curve.
class SmoothQuadraticBezierCurveToCommand extends Command {
  /// Returns `'T'`
  @override
  String get absoluteCommandName => 'T';

  /// Returns `'t'`
  @override
  String get relativeCommandName => 't';

  /// Creates a [SmoothQuadraticBezierCurveToCommand] instance.
  ///
  /// One of the [command] and [isRelative] parameters must be given.
  /// [command] must be either `'t'` or `'T'`.
  SmoothQuadraticBezierCurveToCommand({
    String? command,
    bool? isRelative,
    required CoordinatePairSequence commandArguments,
  }) : super(
          name: command,
          isRelative: isRelative,
          commandArguments: commandArguments,
        );

  /// Returns a single-element list containing transformed
  /// [SmoothQuadraticBezierCurveToCommand].
  ///
  /// The [SmoothQuadraticBezierCurveToCommand] can be easily transformed by
  /// applying transformation matrix to its argument, which is a sequence of
  /// points.
  @override
  List<Command> applyTransformation(
    Matrix3 transform,
    CoordinatePair startPoint,
  ) {
    final Matrix3 transformationMatrix = isAbsolute
        ? transform
        : (transform.clone()..setColumn(2, Vector3(0.0, 0.0, 1.0)));
    final CoordinatePairSequence transformedCommandArguments =
        CoordinatePairSequence(
      coordinatePairs: (commandArguments! as CoordinatePairSequence)
          .coordinatePairs
          .map((cp) {
        final Vector3 transformedCoordinates =
            transformationMatrix.transform(Vector3(cp.x, cp.y, 1.0));
        return CoordinatePair(
          x: transformedCoordinates.x,
          y: transformedCoordinates.y,
        );
      }).toList(),
    );
    return [
      SmoothQuadraticBezierCurveToCommand(
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
      return (commandArguments! as CoordinatePairSequence).coordinatePairs.last;
    }
    double x = previousPoint.x;
    double y = previousPoint.y;
    for (final CoordinatePair cp
        in (commandArguments! as CoordinatePairSequence).coordinatePairs) {
      x += cp.x;
      y += cp.y;
    }
    return CoordinatePair(
      x: x,
      y: y,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! SmoothQuadraticBezierCurveToCommand) {
      return false;
    }
    return command == other.command &&
        commandArguments! as CoordinatePairSequence ==
            other.commandArguments! as CoordinatePairSequence;
  }

  @override
  int get hashCode => Object.hash(command, commandArguments);
}
