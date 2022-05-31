import 'dart:math';

import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_pair.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_pair_sequence.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/curve_to_coordinate_sequence.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/elliptical_arc_argument.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/elliptical_arc_argument_sequence.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/command.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/commands/curve_to_command.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/commands/line_to_command.dart';
import 'package:vector_math/vector_math_64.dart';

/// An `elliptical arc` draw instruction.
///
/// An SVG path instruction that draws an elliptical arc.
class EllipticalArcCommand extends Command {
  /// Returns `'A'`
  @override
  String get absoluteCommandName => 'A';

  /// Returns `'a'`
  @override
  String get relativeCommandName => 'a';

  /// Creates a [CurveToCommand] instance.
  ///
  /// One of the [command] and [isRelative] parameters must be given.
  /// [command] must be either `'a'` or `'A'`.
  EllipticalArcCommand({
    String? command,
    bool? isRelative,
    required EllipticalArcArgumentSequence commandArguments,
  }) : super(
          name: command,
          isRelative: isRelative,
          commandArguments: commandArguments,
        );

  /// Returns a list of [CurveToCommand]s being an approximation of transformed
  /// arc.
  ///
  /// The [EllipticalArcCommand] cannot be skewed or rotated and scaled at the
  /// same time, so it needs to be translated into a set of curves. Each
  /// [EllipticalArcArgument] from [commandArguments] is translated into at
  /// least one and up to four Bezier curves. The curves themselves are then
  /// transformed using the [transform] matrix.
  @override
  List<Command> applyTransformation(
    Matrix3 transform,
    CoordinatePair startPoint,
  ) {
    final EllipticalArcArgumentSequence argumentSequence =
        commandArguments! as EllipticalArcArgumentSequence;
    final List<Command> bezierCurves = [];
    CoordinatePair lastPoint = startPoint;
    for (final arguments in argumentSequence.ellipticalArcArguments) {
      final List<Command> newBezierCurves =
          _convertToBezierCurves(arguments, lastPoint);
      for (final Command curve in newBezierCurves) {
        bezierCurves.addAll(curve.applyTransformation(transform, lastPoint));
        lastPoint = curve.getLastPoint(lastPoint);
      }
    }
    return bezierCurves;
  }

  // This function is a port of SVGAndroidRenderer::arcTo method from
  // BigBadaboom's androidsvg library (Apache 2 license).
  List<Command> _convertToBezierCurves(
    EllipticalArcArgument arguments,
    CoordinatePair startPoint,
  ) {
    final double x = arguments.x + (isAbsolute ? 0 : startPoint.x);
    final double y = arguments.y + (isAbsolute ? 0 : startPoint.y);

    if ((startPoint.x == x && startPoint.y == y) ||
        arguments.rx == 0.0 ||
        arguments.ry == 0.0) {
      return [
        LineToCommand(
          isRelative: isRelative,
          commandArguments: CoordinatePairSequence(
            coordinatePairs: [
              CoordinatePair(
                x: x,
                y: y,
              ),
            ],
          ),
        ),
      ];
    }

    // Sign of the radii is ignored (behaviour specified by the spec)
    double rx = arguments.rx.abs();
    double ry = arguments.ry.abs();

    const double twoPi = pi * 2.0;

    // Convert angle from degrees to radians
    final double angleRad =
        arguments.xAxisRotation.remainder(360.0) * twoPi / 360.0;
    final double cosAngle = cos(angleRad);
    final double sinAngle = sin(angleRad);

    // We simplify the calculations by transforming the arc so that the origin is at the
    // midpoint calculated above followed by a rotation to line up the coordinate axes
    // with the axes of the ellipse.

    // Compute the midpoint of the line between the current and the end point
    final double dx2 = (startPoint.x - x) / 2.0;
    final double dy2 = (startPoint.y - y) / 2.0;

    // Step 1 : Compute (x1', y1')
    // x1,y1 is the midpoint vector rotated to take the arc's angle out of consideration
    final double x1 = cosAngle * dx2 + sinAngle * dy2;
    final double y1 = -sinAngle * dx2 + cosAngle * dy2;

    double rxSq = rx * rx;
    double rySq = ry * ry;
    final double x1Sq = x1 * x1;
    final double y1Sq = y1 * y1;

    // Check that radii are large enough.
    // If they are not, the spec says to scale them up so they are.
    // This is to compensate for potential rounding errors/differences between SVG implementations.
    final double radiiCheck = x1Sq / rxSq + y1Sq / rySq;
    if (radiiCheck > 0.99999) {
      final double radiiScale = sqrt(radiiCheck) * 1.00001;
      rx = radiiScale * rx;
      ry = radiiScale * ry;
      rxSq = rx * rx;
      rySq = ry * ry;
    }

    // Step 2 : Compute (cx1, cy1) - the transformed centre point
    double sign = (arguments.largeArcFlag == arguments.sweepFlag) ? -1 : 1;
    final double sq = max(
      0,
      ((rxSq * rySq) - (rxSq * y1Sq) - (rySq * x1Sq)) /
          ((rxSq * y1Sq) + (rySq * x1Sq)),
    );
    final double coefficient = sign * sqrt(sq);
    final double cx1 = coefficient * ((rx * y1) / ry);
    final double cy1 = coefficient * -((ry * x1) / rx);

    // Step 3 : Compute (cx, cy) from (cx1, cy1)
    final double sx2 = (startPoint.x + x) / 2.0;
    final double sy2 = (startPoint.y + y) / 2.0;
    final double cx = sx2 + (cosAngle * cx1 - sinAngle * cy1);
    final double cy = sy2 + (sinAngle * cx1 + cosAngle * cy1);

    // Step 4 : Compute the angleStart (angle1) and the angleExtent (dangle)
    final double ux = (x1 - cx1) / rx;
    final double uy = (y1 - cy1) / ry;
    final double vx = (-x1 - cx1) / rx;
    final double vy = (-y1 - cy1) / ry;

    // Angle between two vectors is +/- arcCos( u.v / len(u) * len(v))
    // Where '.' is the dot product. And +/- is calculated from the sign of the cross product (u x v)

    // Compute the start angle
    // The angle between (ux,uy) and the 0deg angle (1,0)
    double n = sqrt((ux * ux) + (uy * uy)); // len(u) * len(1,0) == len(u)
    double p = ux; // u.v == (ux,uy).(1,0) == (1 * ux) + (0 * uy) == ux
    sign = (uy < 0) ? -1.0 : 1.0; // u x v == (1 * uy - ux * 0) == uy
    // No need for checkedArcCos() here. (p >= n) should always be true.
    double angleStart = sign * acos(p / n);

    // Compute the angle extent
    n = sqrt((ux * ux + uy * uy) * (vx * vx + vy * vy));
    p = ux * vx + uy * vy;
    sign = (ux * vy - uy * vx < 0) ? -1.0 : 1.0;
    double angleExtent = sign * _checkedArcCos(p / n);

    if (arguments.sweepFlag == 0 && angleExtent > 0) {
      angleExtent -= twoPi;
    } else if (arguments.sweepFlag == 1 && angleExtent < 0) {
      angleExtent += twoPi;
    }
    angleExtent = angleExtent.remainder(twoPi);
    angleStart = angleStart.remainder(twoPi);

    // Many elliptical arc implementations including the Java2D and Android ones, only
    // support arcs that are axis aligned. Therefore we need to substitute the arc
    // with bezier curves. The following method call will generate the beziers for
    // a unit circle that covers the arc angles we want.
    final List<CoordinatePair> bezierPoints = _arcToBeziers(angleStart, angleExtent);

    // Calculate a transformation matrix that will move and scale these bezier points to the correct location.
    // translate
    final Matrix3 m = Matrix3.identity()..setColumn(2, Vector3(cx, cy, 1.0));
    // rotate
    m.multiply(
      Matrix3.identity()
        ..setRow(0, Vector3(cosAngle, -sinAngle, 0.0))
        ..setRow(1, Vector3(sinAngle, cosAngle, 0.0)),
    );
    // scale
    m.multiply(
      Matrix3.identity()
        ..setRow(0, Vector3(rx, 0.0, 0.0))
        ..setRow(1, Vector3(0.0, ry, 0.0)),
    );

    for (int i = 0; i < bezierPoints.length; i++) {
      final Vector3 transformedPoint =
          m.transform(Vector3(bezierPoints[i].x, bezierPoints[i].y, 1.0));
      bezierPoints[i] = CoordinatePair(
        x: transformedPoint.x,
        y: transformedPoint.y,
      );
    }

    // The last point in the bezier set should match exactly the last coordinates pair in the arc (ie: x,y). But
    // considering all the mathematical manipulation we have been doing, it is bound to be off by a tiny
    // fraction. Experiments show that it can be up to around 0.00002.  So why don't we just set it to
    // exactly what it ought to be.
    bezierPoints[bezierPoints.length - 1] = CoordinatePair(
      x: x,
      y: y,
    );

    final List<Command> bezierCurves = [];
    // Final step is to add the bezier curves to the path
    for (int i = 0; i < bezierPoints.length; i += 3) {
      bezierCurves.add(
        CurveToCommand(
          isRelative: false,
          commandArguments: CurveToCoordinateSequence(
            coordinatePairTriplets: [
              CoordinatePairTriplet(
                coordinatePairs: [
                  bezierPoints[i],
                  bezierPoints[i + 1],
                  bezierPoints[i + 2],
                ],
              )
            ],
          ),
        ),
      );
    }
    return bezierCurves;
  }

  double _checkedArcCos(double val) {
    return (val < -1.0)
        ? pi
        : (val > 1.0)
            ? 0
            : acos(val);
  }

  List<CoordinatePair> _arcToBeziers(double angleStart, double angleExtent) {
    final int numSegments =
        (angleExtent.abs() * 2.0 / pi).ceil(); // (angleExtent / 90deg)

    final double angleIncrement = angleExtent / numSegments;

    // The length of each control point vector is given by the following formula.
    final double controlLength = 4.0 /
        3.0 *
        sin(angleIncrement / 2.0) /
        (1.0 + cos(angleIncrement / 2.0));

    final List<CoordinatePair> coordinatePairs = [];

    for (int i = 0; i < numSegments; i++) {
      double angle = angleStart + i * angleIncrement;
      // Calculate the control vector at this angle
      double dx = cos(angle);
      double dy = sin(angle);
      // First control point
      coordinatePairs.add(
        CoordinatePair(
          x: dx - controlLength * dy,
          y: dy + controlLength * dx,
        ),
      );
      // Second control point
      angle += angleIncrement;
      dx = cos(angle);
      dy = sin(angle);
      coordinatePairs.add(
        CoordinatePair(
          x: dx + controlLength * dy,
          y: dy - controlLength * dx,
        ),
      );
      // Endpoint of bezier
      coordinatePairs.add(
        CoordinatePair(
          x: dx,
          y: dy,
        ),
      );
    }
    return coordinatePairs;
  }

  @override
  CoordinatePair getLastPoint(
    CoordinatePair previousPoint, {
    CoordinatePair? startPoint,
  }) {
    if (isAbsolute) {
      final EllipticalArcArgument lastPoint =
          (commandArguments! as EllipticalArcArgumentSequence)
              .ellipticalArcArguments
              .last;
      return CoordinatePair(
        x: lastPoint.x,
        y: lastPoint.y,
      );
    }
    double x = previousPoint.x;
    double y = previousPoint.y;
    for (final EllipticalArcArgument eaa
        in (commandArguments! as EllipticalArcArgumentSequence)
            .ellipticalArcArguments) {
      x += eaa.x;
      y += eaa.y;
    }
    return CoordinatePair(
      x: x,
      y: y,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! EllipticalArcCommand) {
      return false;
    }
    return command == other.command &&
        commandArguments! as EllipticalArcArgumentSequence ==
            other.commandArguments! as EllipticalArcArgumentSequence;
  }

  @override
  int get hashCode => Object.hash(command, commandArguments);
}
