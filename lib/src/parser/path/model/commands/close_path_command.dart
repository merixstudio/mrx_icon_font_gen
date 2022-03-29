import 'package:icon_font/src/parser/path/model/arguments/coordinate_pair.dart';
import 'package:icon_font/src/parser/path/model/command.dart';
import 'package:vector_math/vector_math_64.dart';

/// A `closepath` draw instruction.
///
/// An SVG path instruction that closes the current sub-path. Closing a sub-path
/// implicitly starts a new sub-path.
class ClosePathCommand extends Command {
  /// Returns `'Z'`
  @override
  String get absoluteCommandName => 'Z';

  /// Returns `'z'`
  @override
  String get relativeCommandName => 'z';

  /// Creates a [ClosePathCommand] instance.
  ///
  /// One of the [command] and [isRelative] parameters must be given.
  /// [command] must be either `'z'` or `'Z'`.
  ClosePathCommand({
    String? command,
    bool? isRelative,
  }) : super(
          name: command,
          isRelative: isRelative,
        );

  /// Returns a single-element list containing `this`.
  ///
  /// The [ClosePathCommand] doesn't use any arguments, so it's not affected by
  /// transformations.
  @override
  List<Command> applyTransformation(
    Matrix3 transform,
    CoordinatePair startPoint,
  ) {
    return [this];
  }

  /// Returns the staring point of a sub-path.
  ///
  /// The [ClosePathCommand], as the name suggests, closes the path.
  @override
  CoordinatePair getLastPoint(
    CoordinatePair previousPoint, {
    CoordinatePair? startPoint,
  }) {
    return startPoint ?? previousPoint;
  }

  @override
  bool operator ==(Object other) {
    if (other is! ClosePathCommand) {
      return false;
    }
    return command == other.command;
  }

  @override
  int get hashCode => Object.hash(command, commandArguments);
}
