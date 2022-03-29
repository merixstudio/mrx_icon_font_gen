import 'package:icon_font/src/parser/path/model/arguments/coordinate_pair.dart';
import 'package:icon_font/src/parser/path/model/arguments/coordinate_pair_sequence.dart';
import 'package:icon_font/src/parser/path/model/arguments/coordinate_sequence.dart';
import 'package:icon_font/src/parser/path/model/arguments/curve_to_coordinate_sequence.dart';
import 'package:icon_font/src/parser/path/model/arguments/elliptical_arc_argument.dart';
import 'package:icon_font/src/parser/path/model/arguments/elliptical_arc_argument_sequence.dart';
import 'package:icon_font/src/parser/path/model/arguments/quadratic_bezier_curve_to_coordinate_sequence.dart';
import 'package:icon_font/src/parser/path/model/arguments/smooth_curve_to_coordinate_sequence.dart';
import 'package:icon_font/src/parser/path/model/command.dart';
import 'package:icon_font/src/parser/path/model/commands/close_path_command.dart';
import 'package:icon_font/src/parser/path/model/commands/curve_to_command.dart';
import 'package:icon_font/src/parser/path/model/commands/elliptical_arc_command.dart';
import 'package:icon_font/src/parser/path/model/commands/horizontal_line_to_command.dart';
import 'package:icon_font/src/parser/path/model/commands/line_to_command.dart';
import 'package:icon_font/src/parser/path/model/commands/move_to_command.dart';
import 'package:icon_font/src/parser/path/model/commands/quadratic_bezier_curve_to_command.dart';
import 'package:icon_font/src/parser/path/model/commands/smooth_curve_to_command.dart';
import 'package:icon_font/src/parser/path/model/commands/smooth_quadratic_bezier_curve_to_command.dart';
import 'package:icon_font/src/parser/path/model/commands/vertical_line_to_command.dart';
import 'package:icon_font/src/util/list_util.dart';
import 'package:petitparser/petitparser.dart';

/// SVG path grammar definition.
///
/// A `petitparser` grammar constructed according to
/// ["The grammar for path data"](https://www.w3.org/TR/SVG/paths.html#PathDataBNF)
/// from W3C SVG documentation.
class PathGrammarDefinition extends GrammarDefinition {
  @override
  Parser start() => (ref0(svgPath)).end();

  Parser svgPath() => (((ref0(moveto) & ref0(wsp).star()).plus() &
                  (ref0(drawtoCommand) & ref0(wsp).star()).star())
              .map((value) {
            return value.flatten().whereType<Command>().toList();
          }) |
          string('none').map((value) => null))
      .trim();

  Parser drawtoCommand() =>
      ref0(moveto) |
      ref0(closepath) |
      ref0(lineto) |
      ref0(horizontalLineto) |
      ref0(verticalLineto) |
      ref0(curveto) |
      ref0(smoothCurveto) |
      ref0(quadraticBezierCurveto) |
      ref0(smoothQuadraticBezierCurveto) |
      ref0(ellipticalArc);

  Parser moveto() => ((char('M') | char('m')) &
              ref0(wsp).star() &
              ref0(coordinatePairSequence))
          .map((value) {
        return MoveToCommand(
          command: value[0],
          commandArguments: value[2],
        );
      });

  Parser closepath() => (char('Z') | char('z')).map((value) {
        return ClosePathCommand(
          command: value[0],
        );
      });

  Parser lineto() => ((char('L') | char('l')) &
              ref0(wsp).star() &
              ref0(coordinatePairSequence))
          .map((value) {
        return LineToCommand(
          command: value[0],
          commandArguments: value[2],
        );
      });

  Parser horizontalLineto() =>
      ((char('H') | char('h')) & ref0(wsp).star() & ref0(coordinateSequence))
          .map((value) {
        return HorizontalLineToCommand(
          command: value[0],
          commandArguments: CoordinateSequence(
            coordinates: value[2],
          ),
        );
      });

  Parser verticalLineto() =>
      ((char('V') | char('v')) & ref0(wsp).star() & ref0(coordinateSequence))
          .map((value) {
        return VerticalLineToCommand(
          command: value[0],
          commandArguments: CoordinateSequence(
            coordinates: value[2],
          ),
        );
      });

  Parser curveto() => ((char('C') | char('c')) &
              ref0(wsp).star() &
              ref0(curvetoCoordinateSequence))
          .map((value) {
        return CurveToCommand(
          command: value[0],
          commandArguments: CurveToCoordinateSequence(
            coordinatePairTriplets: value[2],
          ),
        );
      });

  Parser curvetoCoordinateSequence() =>
      (ref0(coordinatePairTriplet) &
              ref0(commaWsp).optional() &
              ref0(curvetoCoordinateSequence))
          .map((value) {
        return <CoordinatePairTriplet>[
              value[0],
            ] +
            value[2];
      }) |
      ref0(coordinatePairTriplet).map((value) {
        return <CoordinatePairTriplet>[value];
      });

  Parser smoothCurveto() => ((char('S') | char('s')) &
              ref0(wsp).star() &
              ref0(smoothCurvetoCoordinateSequence))
          .map((value) {
        return SmoothCurveToCommand(
          command: value[0],
          commandArguments: SmoothCurveToCoordinateSequence(
            coordinatePairDoubles: value[2],
          ),
        );
      });

  Parser smoothCurvetoCoordinateSequence() =>
      (ref0(coordinatePairDouble) &
              ref0(commaWsp).optional() &
              ref0(smoothCurvetoCoordinateSequence))
          .map((value) {
        return <CoordinatePairDouble>[
              value[0],
            ] +
            value[2];
      }) |
      ref0(coordinatePairDouble).map((value) => <CoordinatePairDouble>[value]);

  Parser quadraticBezierCurveto() => ((char('Q') | char('q')) &
              ref0(wsp).star() &
              ref0(quadraticBezierCurvetoCoordinateSequence))
          .map((value) {
        return QuadraticBezierCurveToCommand(
          command: value[0],
          commandArguments: QuadraticBezierCurveToCoordinateSequence(
            coordinatePairDoubles: value[2],
          ),
        );
      });

  Parser quadraticBezierCurvetoCoordinateSequence() =>
      (ref0(coordinatePairDouble) &
              ref0(commaWsp).optional() &
              ref0(quadraticBezierCurvetoCoordinateSequence))
          .map((value) {
        return <CoordinatePairDouble>[
              value[0],
            ] +
            value[2];
      }) |
      ref0(coordinatePairDouble).map((value) => <CoordinatePairDouble>[value]);

  Parser smoothQuadraticBezierCurveto() => ((char('T') | char('t')) &
              ref0(wsp).star() &
              ref0(coordinatePairSequence))
          .map((value) {
        return SmoothQuadraticBezierCurveToCommand(
          command: value[0],
          commandArguments: value[2],
        );
      });

  Parser ellipticalArc() => ((char('A') | char('a')) &
              ref0(wsp).star() &
              ref0(ellipticalArcArgumentSequence))
          .map((value) {
        return EllipticalArcCommand(
          command: value[0],
          commandArguments: EllipticalArcArgumentSequence(
            ellipticalArcArguments: value[2],
          ),
        );
      });

  Parser ellipticalArcArgumentSequence() =>
      (ref0(ellipticalArcArgument) &
              ref0(commaWsp).optional() &
              ref0(ellipticalArcArgumentSequence))
          .map((value) {
        return <EllipticalArcArgument>[
              value[0],
            ] +
            value[2];
      }) |
      ref0(ellipticalArcArgument).map((value) {
        return <EllipticalArcArgument>[value];
      });

  Parser ellipticalArcArgument() => (ref0(number) &
              ref0(commaWsp).optional() &
              ref0(number) &
              ref0(commaWsp).optional() &
              ref0(number) &
              ref0(commaWsp).optional() &
              ref0(flag) &
              ref0(commaWsp).optional() &
              ref0(flag) &
              ref0(commaWsp).optional() &
              ref0(coordinatePair))
          .map((value) {
        return EllipticalArcArgument(
          rx: value[0],
          ry: value[2],
          xAxisRotation: value[4],
          largeArcFlag: value[6],
          sweepFlag: value[8],
          x: value[10].x,
          y: value[10].y,
        );
      });

  Parser coordinatePairDouble() =>
      (ref0(coordinatePair) & ref0(commaWsp).optional() & ref0(coordinatePair))
          .map((value) {
        return CoordinatePairDouble(
          coordinatePairs: <CoordinatePair>[
            value[0],
            value[2],
          ],
        );
      });

  Parser coordinatePairTriplet() => (ref0(coordinatePair) &
              ref0(commaWsp).optional() &
              ref0(coordinatePair) &
              ref0(commaWsp).optional() &
              ref0(coordinatePair))
          .map((value) {
        return CoordinatePairTriplet(
          coordinatePairs: <CoordinatePair>[
            value[0],
            value[2],
            value[4],
          ],
        );
      });

  Parser coordinatePairSequence() =>
      (ref0(coordinatePair) &
              ref0(commaWsp).optional() &
              ref0(coordinatePairSequence))
          .map((value) {
        return CoordinatePairSequence(
          coordinatePairs: <CoordinatePair>[
                value[0],
              ] +
              value[2].coordinatePairs,
        );
      }) |
      ref0(coordinatePair).map((value) {
        return CoordinatePairSequence(
          coordinatePairs: <CoordinatePair>[value],
        );
      });

  Parser coordinateSequence() =>
      (ref0(coordinate) & ref0(commaWsp).optional() & ref0(coordinateSequence))
          .map((value) {
        return <double>[
              value[0],
            ] +
            value[2];
      }) |
      ref0(coordinate).map((value) {
        return <double>[value];
      });

  Parser coordinatePair() =>
      (ref0(coordinate) & ref0(commaWsp).optional() & ref0(coordinate))
          .map((value) {
        return CoordinatePair(
          x: value[0],
          y: value[2],
        );
      });

  Parser coordinate() => ref0(number);

  Parser sign() => char('+') | char('-');

  Parser number() => (ref0(sign).optional() &
          ((char('.') & digit().plus()) |
              (digit().plus() & char('.') & digit().star()) |
              digit().plus()) &
          ((char('E') | char('e')) & ref0(sign).optional() & digit().plus())
              .optional())
      .flatten()
      .map(double.parse);

  Parser flag() => (char('0') | char('1')).map((value) => int.parse(value));

  Parser commaWsp() =>
      ((ref0(wsp).plus() & char(',').optional() & ref0(wsp).star()) |
              (char(',') & ref0(wsp).star()))
          .map((_) => null);

  Parser wsp() => (char(String.fromCharCode(0x9)) |
          char(String.fromCharCode(0x20)) |
          char(String.fromCharCode(0xA)) |
          char(String.fromCharCode(0xC)) |
          char(String.fromCharCode(0xD)))
      .map((_) => null);
}
