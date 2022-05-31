import 'package:mrx_icon_font_gen/mrx_icon_font_gen.dart';
import 'package:test/test.dart';

void main() {
  final pathParser = PathGrammarDefinition().build();

  group('close_path', () {
    test('Absolute close path', () {
      final result = pathParser.parse('M 0 0 Z');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          ClosePathCommand(
            isRelative: false,
          ),
        ]),
      );
    });

    test('Relative close path', () {
      final result = pathParser.parse('M 0 0 z');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          ClosePathCommand(
            isRelative: true,
          ),
        ]),
      );
    });
  });

  group('move_to', () {
    test('Absolute move to, single pair of coordinates', () {
      final result = pathParser.parse('M 1.23, 2.34');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 1.23,
                  y: 2.34,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test('Absolute move to, two pairs of coordinates', () {
      final result = pathParser.parse('M 1.23, 2.34, 3.45, 4.56');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 1.23,
                  y: 2.34,
                ),
                CoordinatePair(
                  x: 3.45,
                  y: 4.56,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test('Relative move to, single pair of coordinates', () {
      final result = pathParser.parse('m 1.23, 2.34');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: true,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 1.23,
                  y: 2.34,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test('Relative move to, two pairs of coordinates', () {
      final result = pathParser.parse('m 1.23, 2.34, 3.45, 4.56');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: true,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 1.23,
                  y: 2.34,
                ),
                CoordinatePair(
                  x: 3.45,
                  y: 4.56,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test('Move to, incorrect number of arguments', () {
      var result = pathParser.parse('M');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(0),
      );

      result = pathParser.parse('M 1.23');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(0),
      );

      result = pathParser.parse('M 1.23, 2.34,');
      expect(
        result.isFailure,
        isTrue,
      );

      result = pathParser.parse('M 1.23, 2.34, 3.45');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(12),
      );
    });
  });

  group('line_to', () {
    test('Absolute line to, single pair of coordinates', () {
      final result = pathParser.parse('M 0 0 L 1.23, 2.34');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          LineToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 1.23,
                  y: 2.34,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test('Absolute line to, two pairs of coordinates', () {
      final result = pathParser.parse('M 0 0 L 1.23, 2.34, 3.45, 4.56');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          LineToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 1.23,
                  y: 2.34,
                ),
                CoordinatePair(
                  x: 3.45,
                  y: 4.56,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test('Relative line to, single pair of coordinates', () {
      final result = pathParser.parse('M 0 0 l 1.23, 2.34');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          LineToCommand(
            isRelative: true,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 1.23,
                  y: 2.34,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test('Relative line to, two pairs of coordinates', () {
      final result = pathParser.parse('M 0 0 l 1.23, 2.34, 3.45, 4.56');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          LineToCommand(
            isRelative: true,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 1.23,
                  y: 2.34,
                ),
                CoordinatePair(
                  x: 3.45,
                  y: 4.56,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test('Line to, incorrect number of arguments', () {
      var result = pathParser.parse('M 0 0 L');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      result = pathParser.parse('M 0 0 L 1.23');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      result = pathParser.parse('M 0 0 L 1.23,');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      result = pathParser.parse('M 0 0 L 1.23, 2.34, 3.45');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(18),
      );
    });
  });

  group('horizontal_line_to', () {
    test('Absolute horizontal line to, single coordinate', () {
      final result = pathParser.parse('M 0 0 H 1.23');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          HorizontalLineToCommand(
            isRelative: false,
            commandArguments: CoordinateSequence(
              coordinates: [
                1.23,
              ],
            ),
          )
        ]),
      );
    });

    test('Absolute horizontal move to, two coordinates', () {
      final result = pathParser.parse('M 0 0 H 1.23, 2.34');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          HorizontalLineToCommand(
            isRelative: false,
            commandArguments: CoordinateSequence(
              coordinates: [
                1.23,
                2.34,
              ],
            ),
          )
        ]),
      );
    });

    test('Relative horizontal line to, single coordinate', () {
      final result = pathParser.parse('M 0 0 h 1.23');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          HorizontalLineToCommand(
            isRelative: true,
            commandArguments: CoordinateSequence(
              coordinates: [
                1.23,
              ],
            ),
          )
        ]),
      );
    });

    test('Relative horizontal line to, two coordinates', () {
      final result = pathParser.parse('M 0 0 h 1.23, 2.34');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          HorizontalLineToCommand(
            isRelative: true,
            commandArguments: CoordinateSequence(
              coordinates: [
                1.23,
                2.34,
              ],
            ),
          )
        ]),
      );
    });

    test('Horizontal line to, incorrect number of arguments', () {
      var result = pathParser.parse('M 0 0 H');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        6,
      );

      result = pathParser.parse('M 0 0 H 1.23,');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        12,
      );
    });
  });

  group('vertical_line_to', () {
    test('Absolute vertical line to, single coordinate', () {
      final result = pathParser.parse('M 0 0 V 1.23');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          VerticalLineToCommand(
            isRelative: false,
            commandArguments: CoordinateSequence(
              coordinates: [
                1.23,
              ],
            ),
          )
        ]),
      );
    });

    test('Absolute vertical line to, two coordinates', () {
      final result = pathParser.parse('M 0 0 V 1.23, 2.34');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          VerticalLineToCommand(
            isRelative: false,
            commandArguments: CoordinateSequence(
              coordinates: [
                1.23,
                2.34,
              ],
            ),
          )
        ]),
      );
    });

    test('Relative vertical line to, single coordinate', () {
      final result = pathParser.parse('M 0 0 v 1.23');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          VerticalLineToCommand(
            isRelative: true,
            commandArguments: CoordinateSequence(
              coordinates: [
                1.23,
              ],
            ),
          )
        ]),
      );
    });

    test('Relative vertical line to, two coordinates', () {
      final result = pathParser.parse('M 0 0 v 1.23, 2.34');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          VerticalLineToCommand(
            isRelative: true,
            commandArguments: CoordinateSequence(
              coordinates: [
                1.23,
                2.34,
              ],
            ),
          )
        ]),
      );
    });

    test('Vertical line to, incorrect number of arguments', () {
      var result = pathParser.parse('M 0 0 V');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        6,
      );

      result = pathParser.parse('M 0 0 V 1.23,');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        12,
      );
    });
  });

  group('curve_to', () {
    test('Absolute curve to, single set of control points', () {
      final result =
          pathParser.parse('M 0 0 C 1.23, 2.34, 3.45, 4.56, 5.67, 6.78');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          CurveToCommand(
            isRelative: false,
            commandArguments: CurveToCoordinateSequence(
              coordinatePairTriplets: [
                CoordinatePairTriplet(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 1.23,
                      y: 2.34,
                    ),
                    CoordinatePair(
                      x: 3.45,
                      y: 4.56,
                    ),
                    CoordinatePair(
                      x: 5.67,
                      y: 6.78,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Absolute curve to, two sets of control points', () {
      final result = pathParser.parse(
        'M 0 0 C 1.23, 2.34, 3.45, 4.56, 5.67, 6.78, 7.89, 8.90, 9.01, 10.12, 11.23, 12.34',
      );
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          CurveToCommand(
            isRelative: false,
            commandArguments: CurveToCoordinateSequence(
              coordinatePairTriplets: [
                CoordinatePairTriplet(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 1.23,
                      y: 2.34,
                    ),
                    CoordinatePair(
                      x: 3.45,
                      y: 4.56,
                    ),
                    CoordinatePair(
                      x: 5.67,
                      y: 6.78,
                    ),
                  ],
                ),
                CoordinatePairTriplet(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 7.89,
                      y: 8.90,
                    ),
                    CoordinatePair(
                      x: 9.01,
                      y: 10.12,
                    ),
                    CoordinatePair(
                      x: 11.23,
                      y: 12.34,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Relative curve to, single set of control points', () {
      final result =
          pathParser.parse('M 0 0 c 1.23, 2.34, 3.45, 4.56, 5.67, 6.78');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          CurveToCommand(
            isRelative: true,
            commandArguments: CurveToCoordinateSequence(
              coordinatePairTriplets: [
                CoordinatePairTriplet(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 1.23,
                      y: 2.34,
                    ),
                    CoordinatePair(
                      x: 3.45,
                      y: 4.56,
                    ),
                    CoordinatePair(
                      x: 5.67,
                      y: 6.78,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Relative curve to, two pairs of coordinates', () {
      final result = pathParser.parse(
        'M 0 0 c 1.23, 2.34, 3.45, 4.56, 5.67, 6.78, 7.89, 8.90, 9.01, 10.12, 11.23, 12.34',
      );
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          CurveToCommand(
            isRelative: true,
            commandArguments: CurveToCoordinateSequence(
              coordinatePairTriplets: [
                CoordinatePairTriplet(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 1.23,
                      y: 2.34,
                    ),
                    CoordinatePair(
                      x: 3.45,
                      y: 4.56,
                    ),
                    CoordinatePair(
                      x: 5.67,
                      y: 6.78,
                    ),
                  ],
                ),
                CoordinatePairTriplet(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 7.89,
                      y: 8.90,
                    ),
                    CoordinatePair(
                      x: 9.01,
                      y: 10.12,
                    ),
                    CoordinatePair(
                      x: 11.23,
                      y: 12.34,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Curve to, incorrect number of arguments', () {
      var result = pathParser.parse('M 0 0 C');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      result = pathParser.parse('M 0 0 C 1.23, 2.34, 3.45, 4.56, 5.67');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      result = pathParser.parse('M 0 0 C 1.23, 2.34, 3.45, 4.56, 5.67, 6.78,');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(42),
      );

      result =
          pathParser.parse('M 0 0 C 1.23, 2.34, 3.45, 4.56, 5.67, 6.78, 7.89');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(42),
      );
    });
  });

  group('smooth_curve_to', () {
    test('Absolute smooth curve to, single set of control points', () {
      final result = pathParser.parse('M 0 0 S 1.23, 2.34, 3.45, 4.56');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          SmoothCurveToCommand(
            isRelative: false,
            commandArguments: SmoothCurveToCoordinateSequence(
              coordinatePairDoubles: [
                CoordinatePairDouble(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 1.23,
                      y: 2.34,
                    ),
                    CoordinatePair(
                      x: 3.45,
                      y: 4.56,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Absolute smooth curve to, two sets of control points', () {
      final result = pathParser.parse(
        'M 0 0 S 1.23, 2.34, 3.45, 4.56, 5.67, 6.78, 7.89, 8.90',
      );
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          SmoothCurveToCommand(
            isRelative: false,
            commandArguments: SmoothCurveToCoordinateSequence(
              coordinatePairDoubles: [
                CoordinatePairDouble(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 1.23,
                      y: 2.34,
                    ),
                    CoordinatePair(
                      x: 3.45,
                      y: 4.56,
                    ),
                  ],
                ),
                CoordinatePairDouble(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 5.67,
                      y: 6.78,
                    ),
                    CoordinatePair(
                      x: 7.89,
                      y: 8.90,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Relative smooth curve to, single pair of coordinates', () {
      final result = pathParser.parse('M 0 0 s 1.23, 2.34, 3.45, 4.56');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          SmoothCurveToCommand(
            isRelative: true,
            commandArguments: SmoothCurveToCoordinateSequence(
              coordinatePairDoubles: [
                CoordinatePairDouble(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 1.23,
                      y: 2.34,
                    ),
                    CoordinatePair(
                      x: 3.45,
                      y: 4.56,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Relative smooth curve to, two pairs of coordinates', () {
      final result = pathParser.parse(
        'M 0 0 s 1.23, 2.34, 3.45, 4.56, 5.67, 6.78, 7.89, 8.90',
      );
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          SmoothCurveToCommand(
            isRelative: true,
            commandArguments: SmoothCurveToCoordinateSequence(
              coordinatePairDoubles: [
                CoordinatePairDouble(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 1.23,
                      y: 2.34,
                    ),
                    CoordinatePair(
                      x: 3.45,
                      y: 4.56,
                    ),
                  ],
                ),
                CoordinatePairDouble(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 5.67,
                      y: 6.78,
                    ),
                    CoordinatePair(
                      x: 7.89,
                      y: 8.90,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Smooth curve to, incorrect number of arguments', () {
      var result = pathParser.parse('M 0 0 C');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      result = pathParser.parse('M 0 0 C 1.23, 2.34, 3.45, 4.56, 5.67');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      result = pathParser.parse('M 0 0 C 1.23, 2.34, 3.45, 4.56, 5.67, 6.78,');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(42),
      );

      result =
          pathParser.parse('M 0 0 C 1.23, 2.34, 3.45, 4.56, 5.67, 6.78, 7.89');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(42),
      );
    });
  });

  group('quadratic_bezier_curve_to', () {
    test('Absolute quadratic Bezier curve to, single set of control points',
        () {
      final result = pathParser.parse('M 0 0 Q 1.23, 2.34, 3.45, 4.56');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          QuadraticBezierCurveToCommand(
            isRelative: false,
            commandArguments: QuadraticBezierCurveToCoordinateSequence(
              coordinatePairDoubles: [
                CoordinatePairDouble(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 1.23,
                      y: 2.34,
                    ),
                    CoordinatePair(
                      x: 3.45,
                      y: 4.56,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Absolute quadratic Bezier curve to, two sets of control points', () {
      final result = pathParser.parse(
        'M 0 0 Q 1.23, 2.34, 3.45, 4.56, 5.67, 6.78, 7.89, 8.90',
      );
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          QuadraticBezierCurveToCommand(
            isRelative: false,
            commandArguments: QuadraticBezierCurveToCoordinateSequence(
              coordinatePairDoubles: [
                CoordinatePairDouble(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 1.23,
                      y: 2.34,
                    ),
                    CoordinatePair(
                      x: 3.45,
                      y: 4.56,
                    ),
                  ],
                ),
                CoordinatePairDouble(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 5.67,
                      y: 6.78,
                    ),
                    CoordinatePair(
                      x: 7.89,
                      y: 8.90,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Relative quadratic Bezier curve to, single pair of coordinates', () {
      final result = pathParser.parse('M 0 0 q 1.23, 2.34, 3.45, 4.56');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          QuadraticBezierCurveToCommand(
            isRelative: true,
            commandArguments: QuadraticBezierCurveToCoordinateSequence(
              coordinatePairDoubles: [
                CoordinatePairDouble(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 1.23,
                      y: 2.34,
                    ),
                    CoordinatePair(
                      x: 3.45,
                      y: 4.56,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Relative quadratic Bezier curve to, two pairs of coordinates', () {
      final result = pathParser.parse(
        'M 0 0 q 1.23, 2.34, 3.45, 4.56, 5.67, 6.78, 7.89, 8.90',
      );
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          QuadraticBezierCurveToCommand(
            isRelative: true,
            commandArguments: QuadraticBezierCurveToCoordinateSequence(
              coordinatePairDoubles: [
                CoordinatePairDouble(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 1.23,
                      y: 2.34,
                    ),
                    CoordinatePair(
                      x: 3.45,
                      y: 4.56,
                    ),
                  ],
                ),
                CoordinatePairDouble(
                  coordinatePairs: [
                    CoordinatePair(
                      x: 5.67,
                      y: 6.78,
                    ),
                    CoordinatePair(
                      x: 7.89,
                      y: 8.90,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Quadratic Bezier curve to, incorrect number of arguments', () {
      var result = pathParser.parse('M 0 0 Q');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      result = pathParser.parse('M 0 0 Q 1.23, 2.34, 3.45');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      result = pathParser.parse('M 0 0 Q 1.23, 2.34, 3.45, 4.56,');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(30),
      );

      result = pathParser.parse('M 0 0 C 1.23, 2.34, 3.45, 4.56, 5.67');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );
    });
  });

  group('smooth_quadratic_bezier_curve_to', () {
    test(
        'Absolute smooth quadratic Bezier curve to, single pair of coordinates',
        () {
      final result = pathParser.parse('M 0 0 T 1.23, 2.34');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          SmoothQuadraticBezierCurveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 1.23,
                  y: 2.34,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test('Absolute smooth quadratic Bezier curve to, two pairs of coordinates',
        () {
      final result = pathParser.parse('M 0 0 T 1.23, 2.34, 3.45, 4.56');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          SmoothQuadraticBezierCurveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 1.23,
                  y: 2.34,
                ),
                CoordinatePair(
                  x: 3.45,
                  y: 4.56,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test(
        'Relative smooth quadratic Bezier curve to, single pair of coordinates',
        () {
      final result = pathParser.parse('M 0 0 t 1.23, 2.34');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          SmoothQuadraticBezierCurveToCommand(
            isRelative: true,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 1.23,
                  y: 2.34,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test('Relative smooth quadratic Bezier curve to, two pairs of coordinates',
        () {
      final result = pathParser.parse('M 0 0 t 1.23, 2.34, 3.45, 4.56');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          SmoothQuadraticBezierCurveToCommand(
            isRelative: true,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 1.23,
                  y: 2.34,
                ),
                CoordinatePair(
                  x: 3.45,
                  y: 4.56,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test('Smooth quadratic Bezier curve to, incorrect number of arguments', () {
      var result = pathParser.parse('M 0 0 T');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      result = pathParser.parse('M 0 0 T 1.23');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      result = pathParser.parse('M 0 0 T 1.23, 2.34,');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(18),
      );

      result = pathParser.parse('M 0 0 T 1.23, 2.34, 3.45');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(18),
      );
    });
  });

  group('elliptical_arc', () {
    test('Absolute elliptical arc, single set of coordinates', () {
      final result =
          pathParser.parse('M 0 0 A 1.23, 2.34, 3.45, 0, 1, 4.56, 5.67');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          EllipticalArcCommand(
            isRelative: false,
            commandArguments: EllipticalArcArgumentSequence(
              ellipticalArcArguments: [
                EllipticalArcArgument(
                  rx: 1.23,
                  ry: 2.34,
                  xAxisRotation: 3.45,
                  largeArcFlag: 0,
                  sweepFlag: 1,
                  x: 4.56,
                  y: 5.67,
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Absolute elliptical arc, two pairs of coordinates', () {
      final result = pathParser.parse(
        'M 0 0 A 1.23, 2.34, 3.45, 0, 1, 4.56, 5.67, 6.78, 7.89, 8.90, 1, 0, 9.01, 10.12',
      );
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          EllipticalArcCommand(
            isRelative: false,
            commandArguments: EllipticalArcArgumentSequence(
              ellipticalArcArguments: [
                EllipticalArcArgument(
                  rx: 1.23,
                  ry: 2.34,
                  xAxisRotation: 3.45,
                  largeArcFlag: 0,
                  sweepFlag: 1,
                  x: 4.56,
                  y: 5.67,
                ),
                EllipticalArcArgument(
                  rx: 6.78,
                  ry: 7.89,
                  xAxisRotation: 8.90,
                  largeArcFlag: 1,
                  sweepFlag: 0,
                  x: 9.01,
                  y: 10.12,
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Relative elliptical arc, single pair of coordinates', () {
      final result =
          pathParser.parse('M 0 0 a 1.23, 2.34, 3.45, 0, 1, 4.56, 5.67');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          EllipticalArcCommand(
            isRelative: true,
            commandArguments: EllipticalArcArgumentSequence(
              ellipticalArcArguments: [
                EllipticalArcArgument(
                  rx: 1.23,
                  ry: 2.34,
                  xAxisRotation: 3.45,
                  largeArcFlag: 0,
                  sweepFlag: 1,
                  x: 4.56,
                  y: 5.67,
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Relative elliptical arc, two pairs of coordinates', () {
      final result = pathParser.parse(
        'M 0 0 a 1.23, 2.34, 3.45, 0, 1, 4.56, 5.67, 6.78, 7.89, 8.90, 1, 0, 9.01, 10.12',
      );
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          ),
          EllipticalArcCommand(
            isRelative: true,
            commandArguments: EllipticalArcArgumentSequence(
              ellipticalArcArguments: [
                EllipticalArcArgument(
                  rx: 1.23,
                  ry: 2.34,
                  xAxisRotation: 3.45,
                  largeArcFlag: 0,
                  sweepFlag: 1,
                  x: 4.56,
                  y: 5.67,
                ),
                EllipticalArcArgument(
                  rx: 6.78,
                  ry: 7.89,
                  xAxisRotation: 8.90,
                  largeArcFlag: 1,
                  sweepFlag: 0,
                  x: 9.01,
                  y: 10.12,
                ),
              ],
            ),
          ),
        ]),
      );
    });

    test('Elliptical arc, incorrect number of arguments', () {
      var result = pathParser.parse('M 0 0 A');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      result = pathParser.parse('M 0 0 A 1.23, 2.34, 3.45, 0, 1, 4.56');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      result = pathParser.parse('M 0 0 A 1.23, 2.34, 3.45, 0, 1, 4.56, 5.67,');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(42),
      );

      result = pathParser.parse(
        'M 0 0 A 1.23, 2.34, 3.45, 0, 1, 4.56, 5.67, 6.78, 7.89, 8.90, 1, 0, 9.01',
      );
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(42),
      );
    });

    test('Elliptical arc, incorrect flags', () {
      final result =
          pathParser.parse('M 0 0 A 1.23, 2.34, 3.45, 1.0, 0, 4.56, 5.67');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      pathParser.parse('M 0 0 A 1.23, 2.34, 3.45, 0, 1.0, 4.56, 5.67');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      pathParser.parse('M 0 0 A 1.23, 2.34, 3.45, 2, 0, 4.56, 5.67');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      pathParser.parse('M 0 0 A 1.23, 2.34, 3.45, 0, 2, 4.56, 5.67');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      pathParser.parse('M 0 0 A 1.23, 2.34, 3.45, -1, 0, 4.56, 5.67');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );

      pathParser.parse('M 0 0 A 1.23, 2.34, 3.45, 0, -1, 4.56, 5.67');
      expect(
        result.isFailure,
        isTrue,
      );
      expect(
        result.position,
        equals(6),
      );
    });
  });

  group('whitespace_and_comma', () {
    test('Different types of whitespace', () {
      final result = pathParser
          .parse('M\u{9}\u{20}\u{A}\u{C}\u{D}0\u{9}\u{20}\u{A}\u{C}\u{D}0');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 0.0,
                  y: 0.0,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test('Commas with different amounts of whitespace surrounding them', () {
      final result = pathParser.parse('M1,2 ,3, 4 , 5  ,  6');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 1.0,
                  y: 2.0,
                ),
                CoordinatePair(
                  x: 3.0,
                  y: 4.0,
                ),
                CoordinatePair(
                  x: 5.0,
                  y: 6.0,
                ),
              ],
            ),
          )
        ]),
      );
    });
  });

  group('number_formats', () {
    test('Integers', () {
      final result = pathParser.parse('M 1234567890 -9876543210');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 1234567890,
                  y: -9876543210,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test('Floats', () {
      final result = pathParser.parse('M 12345.67890 -98765.43210');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 12345.67890,
                  y: -98765.43210,
                ),
              ],
            ),
          )
        ]),
      );
    });

    test('Scientific notation', () {
      final result = pathParser.parse('M 12.34E5 -67.89e-10');
      expect(
        result.value,
        equals([
          MoveToCommand(
            isRelative: false,
            commandArguments: CoordinatePairSequence(
              coordinatePairs: [
                CoordinatePair(
                  x: 12.34E5,
                  y: -67.89e-10,
                ),
              ],
            ),
          )
        ]),
      );
    });
  });
}
