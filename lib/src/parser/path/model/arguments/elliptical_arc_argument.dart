import 'package:icon_font/src/parser/path/model/command_arguments.dart';

/// A set of elliptical arc parameters.
///
/// Used in combination with [EllipticalArcArgumentSequence] as an argument for
/// [EllipticalArcCommand].
///
/// For more information about the meaning behind each parameter see
/// https://www.w3.org/TR/SVG/paths.html#PathDataEllipticalArcCommands
class EllipticalArcArgument extends CommandArguments {
  /// Ellipsis X radius.
  final double rx;

  /// Ellipsis Y radius.
  final double ry;

  /// Ellipsis X-axis rotation in degrees, relative to X-axis.
  final double xAxisRotation;

  /// A flag determining if the larger part of ellipsis should be drawn by the
  /// [EllipticalArcCommand].
  ///
  /// The possible values are:
  ///  * `0` - shorter arc will be drawn.
  ///  * `1` - larger arc will be drawn.
  final int largeArcFlag;

  /// A flag determining if the arc should be drawn in a clockwise or
  /// counter-clockwise direction.
  ///
  /// The possible values are:
  ///  * `0` - the arc will be drawn in a counter-clockwise direction.
  ///  * `1` - the arc will be drawn in a clockwise direction.
  final int sweepFlag;

  /// The x coordinate of the ending point of the arc.
  ///
  /// In case of the relative command, the value represents the offset from the
  /// starting point on the X-axis.
  final double x;

  /// The y coordinate of the ending point of the arc.
  ///
  /// In case of the relative command, the value represents the offset from the
  /// starting point on the Y-axis.
  final double y;

  /// Creates a set of parameters and applies a rounding to two decimal
  /// digits for [rx], [ry], [xAxisRotation], [x], and [y] parameters. Non-zero
  /// [largeArcFlag] and [sweepFlag] parameters are converted to `1`.
  EllipticalArcArgument({
    required double rx,
    required double ry,
    required double xAxisRotation,
    required int largeArcFlag,
    required int sweepFlag,
    required double x,
    required double y,
  })  : rx = double.parse(rx.toStringAsFixed(2)),
        ry = double.parse(ry.toStringAsFixed(2)),
        xAxisRotation = double.parse(xAxisRotation.toStringAsFixed(2)),
        largeArcFlag = largeArcFlag == 0 ? 0 : 1,
        sweepFlag = sweepFlag == 0 ? 0 : 1,
        x = double.parse(x.toStringAsFixed(2)),
        y = double.parse(y.toStringAsFixed(2));

  /// Generates a text representation of the coordinates in
  /// __"[rx] [ry] [xAxisRotation] [largeArcFlag] [sweepFlag] [x] [y]"__ format,
  /// that can be used to generate an SVG path.
  @override
  String toString() {
    return '${rx.toStringAsFixed(2)} ${ry.toStringAsFixed(2)} ${xAxisRotation.toStringAsFixed(2)} $largeArcFlag $sweepFlag ${x.toStringAsFixed(2)} ${y.toStringAsFixed(2)}';
  }

  /// Compares two sets of parameters and returns true if all their respective
  /// components are equal.
  @override
  bool operator ==(Object other) {
    if (other is! EllipticalArcArgument) {
      return false;
    }
    return rx == other.rx &&
        ry == other.ry &&
        xAxisRotation == other.xAxisRotation &&
        largeArcFlag == other.largeArcFlag &&
        sweepFlag == other.sweepFlag &&
        x == other.x &&
        y == other.y;
  }

  @override
  int get hashCode => Object.hash(
        rx,
        ry,
        xAxisRotation,
        largeArcFlag,
        sweepFlag,
        x,
        y,
      );
}
