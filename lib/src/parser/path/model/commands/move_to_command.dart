import 'package:icon_font/src/parser/path/model/arguments/coordinate_pair.dart';
import 'package:icon_font/src/parser/path/model/arguments/coordinate_pair_sequence.dart';
import 'package:icon_font/src/parser/path/model/command.dart';
import 'package:vector_math/vector_math_64.dart';

/// A `moveto` draw instruction.
///
/// An SVG path instruction that moves the "pen" to a different position on
/// canvas (unless its argument is a list of coordinate pair, in which case the
/// "pen" will be moved to the position of the first coordinate pair and
/// subsequent coordinate pairs will be treated as an implicit `lineto` command.
class MoveToCommand extends Command {
  /// Returns `'M'`
  @override
  String get absoluteCommandName => 'M';

  /// Returns `'m'`
  @override
  String get relativeCommandName => 'm';

  /// Creates a [MoveToCommand] instance.
  ///
  /// One of the [command] and [isRelative] parameters must be given.
  /// [command] must be either `'m'` or `'M'`.
  MoveToCommand({
    String? command,
    bool? isRelative,
    required CoordinatePairSequence commandArguments,
  }) : super(
          name: command,
          isRelative: isRelative,
          commandArguments: commandArguments,
        );

  /// Returns a single-element list containing transformed [MoveToCommand].
  ///
  /// The [MoveToCommand] can be easily transformed by applying transformation
  /// matrix to its argument, which is a sequence of points.
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
      coordinatePairs: (commandArguments as CoordinatePairSequence)
          .coordinatePairs
          .map((cp) {
        final Vector3 transformed =
            transformationMatrix.transform(Vector3(cp.x, cp.y, 1.0));
        return CoordinatePair(
          x: transformed.x,
          y: transformed.y,
        );
      }).toList(),
    );
    return [
      MoveToCommand(
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
      return (commandArguments as CoordinatePairSequence).coordinatePairs.last;
    }
    double x = previousPoint.x;
    double y = previousPoint.y;
    for (final CoordinatePair cp
        in (commandArguments as CoordinatePairSequence).coordinatePairs) {
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
    if (other is! MoveToCommand) {
      return false;
    }
    return command == other.command &&
        commandArguments as CoordinatePairSequence ==
            other.commandArguments as CoordinatePairSequence;
  }

  @override
  int get hashCode => Object.hash(command, commandArguments);
}
