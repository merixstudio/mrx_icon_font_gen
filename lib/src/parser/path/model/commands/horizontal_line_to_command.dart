import 'package:icon_font/src/parser/path/model/arguments/coordinate_pair.dart';
import 'package:icon_font/src/parser/path/model/arguments/coordinate_pair_sequence.dart';
import 'package:icon_font/src/parser/path/model/arguments/coordinate_sequence.dart';
import 'package:icon_font/src/parser/path/model/command.dart';
import 'package:icon_font/src/parser/path/model/commands/line_to_command.dart';
import 'package:vector_math/vector_math_64.dart';

/// A `horizontal lineto` draw instruction.
///
/// An SVG path instruction that draws a horizontal line.
class HorizontalLineToCommand extends Command {
  /// Returns `'H'`
  @override
  String get absoluteCommandName => 'H';

  /// Returns `'h'`
  @override
  String get relativeCommandName => 'h';

  /// Creates a [HorizontalLineToCommand] instance.
  ///
  /// One of the [command] and [isRelative] parameters must be given.
  /// [command] must be either `'h'` or `'H'`.
  HorizontalLineToCommand({
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
  /// The [HorizontalLineToCommand] can't be rotated or skewed in Y-axis, so
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
          (commandArguments as CoordinateSequence).coordinates.map((c) {
        final Vector3 transformed =
            transformationMatrix.transform(Vector3(c, 0.0, 1.0));
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
          (commandArguments as CoordinateSequence).coordinates.map((c) {
        final Vector3 transformed =
            transform.transform(Vector3(c, startPoint.y, 1.0));
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
      final double x =
          (commandArguments as CoordinateSequence).coordinates.last;
      return CoordinatePair(
        x: x,
        y: previousPoint.y,
      );
    }
    double x = previousPoint.x;
    for (final double dx
        in (commandArguments as CoordinateSequence).coordinates) {
      x += dx;
    }
    return CoordinatePair(
      x: x,
      y: previousPoint.y,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! HorizontalLineToCommand) {
      return false;
    }
    return command == other.command &&
        commandArguments as CoordinateSequence ==
            other.commandArguments as CoordinateSequence;
  }

  @override
  int get hashCode => Object.hash(command, commandArguments);
}
