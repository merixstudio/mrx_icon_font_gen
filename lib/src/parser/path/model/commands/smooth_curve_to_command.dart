import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_pair.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_pair_sequence.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/smooth_curve_to_coordinate_sequence.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/command.dart';
import 'package:vector_math/vector_math_64.dart';

/// A `smooth curveto` draw instruction.
///
/// An SVG path instruction that draws a smooth Bezier curve.
class SmoothCurveToCommand extends Command {
  /// Returns `'S'`
  @override
  String get absoluteCommandName => 'S';

  /// Returns `'s'`
  @override
  String get relativeCommandName => 's';

  /// Creates a [SmoothCurveToCommand] instance.
  ///
  /// One of the [command] and [isRelative] parameters must be given.
  /// [command] must be either `'s'` or `'S'`.
  SmoothCurveToCommand({
    String? command,
    bool? isRelative,
    required SmoothCurveToCoordinateSequence commandArguments,
  }) : super(
          name: command,
          isRelative: isRelative,
          commandArguments: commandArguments,
        );

  /// Returns a single-element list containing transformed
  /// [SmoothCurveToCommand].
  ///
  /// The [SmoothCurveToCommand] can be easily transformed by applying
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
    final SmoothCurveToCoordinateSequence transformedCommandArguments =
        SmoothCurveToCoordinateSequence(
      coordinatePairDoubles:
          (commandArguments! as SmoothCurveToCoordinateSequence)
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
      SmoothCurveToCommand(
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
      return (commandArguments! as SmoothCurveToCoordinateSequence)
          .coordinatePairDoubles
          .last
          .coordinatePairs
          .last;
    }
    double x = previousPoint.x;
    double y = previousPoint.y;
    for (final CoordinatePairDouble cpd
        in (commandArguments! as SmoothCurveToCoordinateSequence)
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
    if (other is! SmoothCurveToCommand) {
      return false;
    }
    return command == other.command &&
        commandArguments! as SmoothCurveToCoordinateSequence ==
            other.commandArguments! as SmoothCurveToCoordinateSequence;
  }

  @override
  int get hashCode => Object.hash(command, commandArguments);
}
