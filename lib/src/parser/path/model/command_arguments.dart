/// Base class for SVG path command arguments.
abstract class CommandArguments {
  /// Returns a textual representation of a command arguments.
  ///
  /// The returned string is compatible with SVG specification for paths.
  @override
  String toString();
}
