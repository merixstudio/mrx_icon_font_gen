import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_pair.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_pair_sequence.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_sequence.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/command.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/commands/line_to_command.dart';
import 'package:vector_math/vector_math_64.dart';

/// A `vertical lineto` draw instruction.
///
/// An SVG path instruction that draws a vertical line.
class VerticalLineToCommand extends Command {
  /// Returns `'V'`
  @override
  String get absoluteCommandName => 'V';

  /// Returns `'v'`
  @override
  String get relativeCommandName => 'v';

  /// Creates a [VerticalLineToCommand] instance.
  ///
  /// One of the [command] and [isRelative] parameters must be given.
  /// [command] must be either `'v'` or `'V'`.
  VerticalLineToCommand({
    String? command,
    bool? isRelative,
    required CoordinateSequence commandArguments,
  }) : super(
          name: command,
          isRelative: isRelative,
          commandArguments: commandArguments,
        );

  /// Returns a single-element list containing a [LineToCommand].
  ///
  /// The [VerticalLineToCommand] can't be rotated or skewed in Y-axis, so
  /// it needs to be translated to a [LineToCommand] first.
  @override
  List<Command> applyTransformation(
    Matrix3 transform,
    CoordinatePair startPoint,
  ) {
    return isAbsolute
        ? _absoluteLineTo(transform, startPoint)
        : _relativeLineTo(transform, startPoint);
  }

  List<Command> _relativeLineTo(Matrix3 transform, CoordinatePair startPoint) {
    final Matrix3 transformationMatrix = transform.clone()
      ..setColumn(2, Vector3(0.0, 0.0, 1.0));
    final CoordinatePairSequence transformedCommandArguments =
        CoordinatePairSequence(
      coordinatePairs:
          (commandArguments! as CoordinateSequence).coordinates.map((c) {
        final Vector3 transformed =
            transformationMatrix.transform(Vector3(0.0, c, 1.0));
        return CoordinatePair(
          x: transformed.x,
          y: transformed.y,
        );
      }).toList(),
    );
    return [
      LineToCommand(
        isRelative: true,
        commandArguments: transformedCommandArguments,
      ),
    ];
  }

  List<Command> _absoluteLineTo(Matrix3 transform, CoordinatePair startPoint) {
    final CoordinatePairSequence transformedCommandArguments =
        CoordinatePairSequence(
      coordinatePairs:
          (commandArguments! as CoordinateSequence).coordinates.map((c) {
        final Vector3 transformed =
            transform.transform(Vector3(startPoint.x, c, 1.0));
        return CoordinatePair(
          x: transformed.x,
          y: transformed.y,
        );
      }).toList(),
    );
    return [
      LineToCommand(
        isRelative: false,
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
      final double y =
          (commandArguments! as CoordinateSequence).coordinates.last;
      return CoordinatePair(
        x: previousPoint.x,
        y: y,
      );
    }
    double y = previousPoint.y;
    for (final double dy
        in (commandArguments! as CoordinateSequence).coordinates) {
      y += dy;
    }
    return CoordinatePair(
      x: previousPoint.x,
      y: y,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! VerticalLineToCommand) {
      return false;
    }
    return command == other.command &&
        commandArguments! as CoordinateSequence ==
            other.commandArguments! as CoordinateSequence;
  }

  @override
  int get hashCode => Object.hash(command, commandArguments);
}
