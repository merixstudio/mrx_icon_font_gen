import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_pair.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/command_arguments.dart';
import 'package:vector_math/vector_math_64.dart';

/// An abstract drawing command.
///
/// SVG path is represented by a series of drawing commands, each consisting of
/// a single letter name, and in most cases an unlimited lit of parameters.
///
/// Commands come in to variants:
///  * Absolute (uppercase name) - indicates that the following parameters are
///    to be treated as absolute coordinates.
///  * Relative (lowercase name) - coordinates of these commands represent an
///    offset from the current position of the "pen" (a point, where the
///    preceding command finished drawing).
abstract class Command {
  /// A command name.
  ///
  /// Each command defines its own pair of valid names (one for absolute form,
  /// another for relative), however, the standard SVG commands stick to the
  /// convention of using a single letter, lower- or uppercase.
  late final String command;

  /// Command arguments.
  ///
  /// Most of the commands define a specific set of parameters that can be used
  /// in sequences. See the command implementation's constructor for more info
  /// on its parameters.
  final CommandArguments? commandArguments;

  /// Creates a command instance.
  ///
  /// When creating a command, either one of [name] or [isRelative] parameters
  /// is required. If none is provided,the command constructor throws an
  /// [ArgumentError] exception.
  ///
  /// The [name] parameter, if given, must be equal to the value returned by the
  /// [relativeCommandName] or [absoluteCommandName].
  /// The [isRelative] parameter takes precedence over the [name] parameter when
  /// setting the [command] field value, while both parameters are used.
  Command({
    String? name,
    bool? isRelative,
    this.commandArguments,
  }) {
    if (name == null && isRelative == null) {
      throw ArgumentError(
        'One of "command" and "isRelative" arguments must be not null',
      );
    }
    if (name != null &&
        name != absoluteCommandName &&
        name != relativeCommandName) {
      throw ArgumentError(
        'Unsupported command "$name". Acceptable commands are $absoluteCommandName and $relativeCommandName',
      );
    }
    command = name ??
        ((isRelative ?? false) ? relativeCommandName : absoluteCommandName);
  }

  /// Returns a name of a absolute version of the command.
  ///
  /// It is a name, that is used in the SVG path description.
  String get absoluteCommandName;

  /// Returns a name of a relative version of the command.
  ///
  /// It is a name, that is used in the SVG path description.
  String get relativeCommandName;

  /// Applies a transformation matrix to [commandArguments] and returns a new
  /// set of [Command]s
  ///
  /// [transform] is a 3x3 transformation matrix.
  /// [startPoint] is a current "pen" position - a point where the command
  /// starts drawing from.
  /// Most of the commands will return a single instance of the same class but
  /// with updated command arguments. However, there are commands that cannot be
  /// rotated or skewed. They will return an instance of another class or even a
  /// list of commands.
  List<Command> applyTransformation(
    Matrix3 transform,
    CoordinatePair startPoint,
  );

  /// Return a point where the command finished drawing.
  ///
  /// [previousPoint] is a point where the last command finished drawing. It's
  /// mostly relevant to relative commands.
  /// [startPoint] is a point where a current sub-path started. It's only
  /// relevant to the [ClosePathCommand] which returns to this point when used.
  CoordinatePair getLastPoint(
    CoordinatePair previousPoint, {
    CoordinatePair? startPoint,
  });

  /// Returns `true` if command is relative, `false` otherwise.
  bool get isRelative => command == relativeCommandName;

  /// Returns `true` if command is absolute, `false` otherwise.
  bool get isAbsolute => command == absoluteCommandName;

  /// Returns a textual representation of a command.
  ///
  /// The returned string is compatible with SVG specification for paths.
  @override
  String toString() {
    return '$command${commandArguments ?? ''}';
  }
}
