import 'dart:math';

import 'package:mrx_icon_font_gen/mrx_icon_font_gen.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Constructor', () {
    test('Construct without "command" and "isRelative" arguments', () {
      expect(
        () => EllipticalArcCommand(
          commandArguments: EllipticalArcArgumentSequence(
            ellipticalArcArguments: [],
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {command: "A"}', () {
      const commandName = 'A';
      final command = EllipticalArcCommand(
        command: commandName,
        commandArguments: EllipticalArcArgumentSequence(
          ellipticalArcArguments: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "a"}', () {
      const commandName = 'a';
      final command = EllipticalArcCommand(
        command: commandName,
        commandArguments: EllipticalArcArgumentSequence(
          ellipticalArcArguments: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "foo"}', () {
      expect(
        () => EllipticalArcCommand(
          command: 'foo',
          commandArguments: EllipticalArcArgumentSequence(
            ellipticalArcArguments: [],
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {isRelative: false}', () {
      const commandName = 'A';
      const isRelative = false;
      final command = EllipticalArcCommand(
        isRelative: isRelative,
        commandArguments: EllipticalArcArgumentSequence(
          ellipticalArcArguments: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {isRelative: true}', () {
      const commandName = 'a';
      const isRelative = true;
      final command = EllipticalArcCommand(
        isRelative: isRelative,
        commandArguments: EllipticalArcArgumentSequence(
          ellipticalArcArguments: [],
        ),
      );
      expect(command.command, equals(commandName));
    });
  });

  test('Absolute toString()', () {
    final command = _buildAbsoluteEllipticalArcCommand();
    const toString =
        'A12.00 6.00 0.00 0 0 30.00 10.00 12.00 6.00 45.00 0 1 30.00 30.00 12.00 6.00 180.00 1 0 10.00 30.00 12.00 6.00 45.00 1 1 10.00 10.00';
    expect(command.toString(), equals(toString));
  });

  test('Relative toString()', () {
    final command = _buildRelativeEllipticalArcCommand();
    const toString =
        'a12.00 6.00 0.00 0 0 20.00 0.00 12.00 6.00 45.00 0 1 0.00 20.00 12.00 6.00 180.00 1 0 -20.00 0.00 12.00 6.00 45.00 1 1 0.00 -20.00';
    expect(command.toString(), equals(toString));
  });

  test('Absolute applyTransformation() - identity', () {
    final EllipticalArcCommand command = _buildAbsoluteEllipticalArcCommand();
    final transform = Matrix3.identity();
    final startPoint = _buildStartPoint();
    expect(
      command.applyTransformation(transform, startPoint),
      equals(_getCurves()),
    );
  });

  test('Relative applyTransformation() - identity', () {
    final command = _buildRelativeEllipticalArcCommand();
    final transform = Matrix3.identity();
    final startPoint = _buildStartPoint();
    expect(
      command.applyTransformation(transform, startPoint),
      equals(_getCurves()),
    );
  });

  test('Absolute applyTransformation() - translate x by 10, y by 20', () {
    final command = _buildAbsoluteEllipticalArcCommand();
    final transform = _buildTranslationMatrix();
    final startPoint = _buildStartPoint();
    final translated = _buildTranslationResult();
    expect(
      command.applyTransformation(transform, startPoint),
      equals(translated),
    );
  });

  test('Relative applyTransformation() - translate x by 10, y by 20', () {
    final command = _buildRelativeEllipticalArcCommand();
    final transform = _buildTranslationMatrix();
    final startPoint = _buildStartPoint();
    final translated = _buildTranslationResult();
    expect(
      command.applyTransformation(transform, startPoint),
      equals(translated),
    );
  });

  test('Absolute applyTransformation() - scale x by 2, y by 3', () {
    final command = _buildAbsoluteEllipticalArcCommand();
    final scale = _buildScaleMatrix();
    final startPoint = _buildStartPoint();
    final scaled = _buildScaleResult();
    expect(command.applyTransformation(scale, startPoint), equals(scaled));
  });

  test('Relative applyTransformation() - scale x by 2, y by 3', () {
    final command = _buildRelativeEllipticalArcCommand();
    final rotate = _buildScaleMatrix();
    final startPoint = _buildStartPoint();
    final scaled = _buildScaleResult();
    expect(command.applyTransformation(rotate, startPoint), equals(scaled));
  });

  test('Absolute applyTransformation() - rotate by 45deg around point <20,30>',
      () {
    final command = _buildAbsoluteEllipticalArcCommand();
    final rotate = _buildRotationMatrix();
    final startPoint = _buildStartPoint();
    final rotated = _buildRotationResult();
    expect(command.applyTransformation(rotate, startPoint), equals(rotated));
  });

  test('Relative applyTransformation() - rotate by 45deg around point <20,30>',
      () {
    final command = _buildRelativeEllipticalArcCommand();
    final skew = _buildRotationMatrix();
    final startPoint = _buildStartPoint();
    final rotated = _buildRotationResult();
    expect(command.applyTransformation(skew, startPoint), equals(rotated));
  });

  test('Absolute applyTransformation() - skew by 45deg along x axis', () {
    final command = _buildAbsoluteEllipticalArcCommand();
    final skew = _buildSkewXMatrix();
    final startPoint = _buildStartPoint();
    final skewed = _buildSkewXResult();
    expect(command.applyTransformation(skew, startPoint), equals(skewed));
  });

  test('Relative applyTransformation() - skew by 45deg along x axis', () {
    final command = _buildRelativeEllipticalArcCommand();
    final skew = _buildSkewXMatrix();
    final startPoint = _buildStartPoint();
    final skewed = _buildSkewXResult();
    expect(command.applyTransformation(skew, startPoint), equals(skewed));
  });

  test('Absolute applyTransformation() - skew by 45deg along y axis', () {
    final command = _buildAbsoluteEllipticalArcCommand();
    final skew = _buildSkewYMatrix();
    final startPoint = _buildStartPoint();
    final skewed = _buildSkewYResult();
    expect(command.applyTransformation(skew, startPoint), equals(skewed));
  });

  test('Relative applyTransformation() - skew by 45deg along y axis', () {
    final command = _buildRelativeEllipticalArcCommand();
    final skew = _buildSkewYMatrix();
    final startPoint = _buildStartPoint();
    final skewed = _buildSkewYResult();
    expect(command.applyTransformation(skew, startPoint), equals(skewed));
  });

  test('applyTransformation() - draw a single point', () {
    final command = EllipticalArcCommand(
      isRelative: false,
      commandArguments: EllipticalArcArgumentSequence(
        ellipticalArcArguments: [
          EllipticalArcArgument(
            rx: 12.0,
            ry: 6.0,
            xAxisRotation: 0.0,
            largeArcFlag: 0,
            sweepFlag: 0,
            x: 30.0,
            y: 10.0,
          ),
        ],
      ),
    );
    final transform = Matrix3.identity();
    final startPoint = CoordinatePair(
      x: 30.0,
      y: 10.0,
    );
    expect(
      command.applyTransformation(transform, startPoint),
      equals([
        LineToCommand(
          isRelative: false,
          commandArguments: CoordinatePairSequence(
            coordinatePairs: [
              CoordinatePair(
                x: 30.0,
                y: 10.0,
              ),
            ],
          ),
        ),
      ]),
    );
  });

  test('Absolute getLastPoint()', () {
    final command = _buildAbsoluteEllipticalArcCommand();
    final startPoint = _buildStartPoint();
    final lastPoint = CoordinatePair(
      x: 10.0,
      y: 10.0,
    );
    expect(command.getLastPoint(startPoint), equals(lastPoint));
  });

  test('Relative getLastPoint()', () {
    final command = _buildRelativeEllipticalArcCommand();
    final startPoint = _buildStartPoint();
    final lastPoint = CoordinatePair(
      x: 10.0,
      y: 10.0,
    );
    expect(command.getLastPoint(startPoint), equals(lastPoint));
  });

  test('hashCode', () {
    final object = _buildAbsoluteEllipticalArcCommand();
    final identicalObject = _buildAbsoluteEllipticalArcCommand();
    final differentObject = _buildRelativeEllipticalArcCommand();

    expect(object.hashCode, equals(identicalObject.hashCode));
    expect(object.hashCode, isNot(equals(differentObject.hashCode)));
  });

  test('== operator', () {
    final object = _buildAbsoluteEllipticalArcCommand();
    final identicalObject = _buildAbsoluteEllipticalArcCommand();
    final differentObject = _buildRelativeEllipticalArcCommand();

    expect(object, equals(object));
    expect(object, equals(identicalObject));
    expect(object, isNot(equals(differentObject)));
  });
}

CoordinatePair _buildStartPoint() {
  return CoordinatePair(
    x: 10.0,
    y: 10.0,
  );
}

EllipticalArcCommand _buildAbsoluteEllipticalArcCommand() {
  return EllipticalArcCommand(
    isRelative: false,
    commandArguments: EllipticalArcArgumentSequence(
      ellipticalArcArguments: [
        EllipticalArcArgument(
          rx: 12.0,
          ry: 6.0,
          xAxisRotation: 0.0,
          largeArcFlag: 0,
          sweepFlag: 0,
          x: 30.0,
          y: 10.0,
        ),
        EllipticalArcArgument(
          rx: 12.0,
          ry: 6.0,
          xAxisRotation: 45.0,
          largeArcFlag: 0,
          sweepFlag: 1,
          x: 30.0,
          y: 30.0,
        ),
        EllipticalArcArgument(
          rx: 12.0,
          ry: 6.0,
          xAxisRotation: 180.0,
          largeArcFlag: 1,
          sweepFlag: 0,
          x: 10.0,
          y: 30.0,
        ),
        EllipticalArcArgument(
          rx: 12.0,
          ry: 6.0,
          xAxisRotation: 45.0,
          largeArcFlag: 1,
          sweepFlag: 1,
          x: 10.0,
          y: 10.0,
        ),
      ],
    ),
  );
}

EllipticalArcCommand _buildRelativeEllipticalArcCommand() {
  return EllipticalArcCommand(
    isRelative: true,
    commandArguments: EllipticalArcArgumentSequence(
      ellipticalArcArguments: [
        EllipticalArcArgument(
          rx: 12.0,
          ry: 6.0,
          xAxisRotation: 0.0,
          largeArcFlag: 0,
          sweepFlag: 0,
          x: 20.0,
          y: 0.0,
        ),
        EllipticalArcArgument(
          rx: 12.0,
          ry: 6.0,
          xAxisRotation: 45.0,
          largeArcFlag: 0,
          sweepFlag: 1,
          x: 0.0,
          y: 20.0,
        ),
        EllipticalArcArgument(
          rx: 12.0,
          ry: 6.0,
          xAxisRotation: 180.0,
          largeArcFlag: 1,
          sweepFlag: 0,
          x: -20.0,
          y: 0.0,
        ),
        EllipticalArcArgument(
          rx: 12.0,
          ry: 6.0,
          xAxisRotation: 45.0,
          largeArcFlag: 1,
          sweepFlag: 1,
          x: 0.0,
          y: -20.0,
        ),
      ],
    ),
  );
}

Matrix3 _buildTranslationMatrix() {
  return Matrix3.identity()..setColumn(2, Vector3(10.0, 20.0, 1.0));
}

List<Command> _getCurves() {
  return [
    CurveToCommand(
      isRelative: false,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 12.20,
                y: 11.66,
              ),
              CoordinatePair(
                x: 15.92,
                y: 12.68,
              ),
              CoordinatePair(
                x: 20.00,
                y: 12.68,
              ),
            ],
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
                x: 24.08,
                y: 12.68,
              ),
              CoordinatePair(
                x: 27.80,
                y: 11.66,
              ),
              CoordinatePair(
                x: 30.00,
                y: 10.00,
              ),
            ],
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
                x: 36.88,
                y: 14.15,
              ),
              CoordinatePair(
                x: 42.47,
                y: 21.98,
              ),
              CoordinatePair(
                x: 42.41,
                y: 27.40,
              ),
            ],
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
                x: 42.41,
                y: 32.99,
              ),
              CoordinatePair(
                x: 36.88,
                y: 34.05,
              ),
              CoordinatePair(
                x: 30.00,
                y: 30.00,
              ),
            ],
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
                x: 33.32,
                y: 27.52,
              ),
              CoordinatePair(
                x: 32.48,
                y: 24.16,
              ),
              CoordinatePair(
                x: 27.92,
                y: 22.18,
              ),
            ],
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
                x: 23.36,
                y: 20.20,
              ),
              CoordinatePair(
                x: 16.64,
                y: 20.20,
              ),
              CoordinatePair(
                x: 12.08,
                y: 22.18,
              ),
            ],
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
                x: 7.52,
                y: 24.16,
              ),
              CoordinatePair(
                x: 6.68,
                y: 27.52,
              ),
              CoordinatePair(
                x: 10.00,
                y: 30.00,
              ),
            ],
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
                x: 5.53,
                y: 27.29,
              ),
              CoordinatePair(
                x: 1.39,
                y: 22.93,
              ),
              CoordinatePair(
                x: -0.90,
                y: 18.51,
              ),
            ],
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
                x: -3.14,
                y: 14.04,
              ),
              CoordinatePair(
                x: -3.14,
                y: 10.24,
              ),
              CoordinatePair(
                x: -0.90,
                y: 8.45,
              ),
            ],
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
                x: 1.34,
                y: 6.66,
              ),
              CoordinatePair(
                x: 5.58,
                y: 7.33,
              ),
              CoordinatePair(
                x: 10.00,
                y: 10.00,
              ),
            ],
          ),
        ],
      ),
    ),
  ];
}

List<Command> _buildTranslationResult() {
  return [
    CurveToCommand(
      isRelative: false,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 22.20,
                y: 31.66,
              ),
              CoordinatePair(
                x: 25.92,
                y: 32.68,
              ),
              CoordinatePair(
                x: 30.00,
                y: 32.68,
              ),
            ],
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
                x: 34.08,
                y: 32.68,
              ),
              CoordinatePair(
                x: 37.80,
                y: 31.66,
              ),
              CoordinatePair(
                x: 40.00,
                y: 30.00,
              ),
            ],
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
                x: 46.88,
                y: 34.15,
              ),
              CoordinatePair(
                x: 52.47,
                y: 41.98,
              ),
              CoordinatePair(
                x: 52.41,
                y: 47.40,
              ),
            ],
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
                x: 52.41,
                y: 52.99,
              ),
              CoordinatePair(
                x: 46.88,
                y: 54.05,
              ),
              CoordinatePair(
                x: 40.00,
                y: 50.00,
              ),
            ],
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
                x: 43.32,
                y: 47.52,
              ),
              CoordinatePair(
                x: 42.48,
                y: 44.16,
              ),
              CoordinatePair(
                x: 37.92,
                y: 42.18,
              ),
            ],
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
                x: 33.36,
                y: 40.20,
              ),
              CoordinatePair(
                x: 26.64,
                y: 40.20,
              ),
              CoordinatePair(
                x: 22.08,
                y: 42.18,
              ),
            ],
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
                x: 17.52,
                y: 44.16,
              ),
              CoordinatePair(
                x: 16.68,
                y: 47.52,
              ),
              CoordinatePair(
                x: 20.00,
                y: 50.00,
              ),
            ],
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
                x: 15.53,
                y: 47.29,
              ),
              CoordinatePair(
                x: 11.39,
                y: 42.93,
              ),
              CoordinatePair(
                x: 9.10,
                y: 38.51,
              ),
            ],
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
                x: 6.86,
                y: 34.04,
              ),
              CoordinatePair(
                x: 6.86,
                y: 30.24,
              ),
              CoordinatePair(
                x: 9.10,
                y: 28.45,
              ),
            ],
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
                x: 11.34,
                y: 26.66,
              ),
              CoordinatePair(
                x: 15.58,
                y: 27.33,
              ),
              CoordinatePair(
                x: 20.00,
                y: 30.00,
              ),
            ],
          ),
        ],
      ),
    ),
  ];
}

Matrix3 _buildScaleMatrix() {
  return Matrix3.identity()
    ..setColumn(0, Vector3(2.0, 0.0, 0.0))
    ..setColumn(1, Vector3(0.0, 3.0, 0.0));
}

List<Command> _buildScaleResult() {
  return [
    CurveToCommand(
      isRelative: false,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 24.40,
                y: 34.98,
              ),
              CoordinatePair(
                x: 31.84,
                y: 38.04,
              ),
              CoordinatePair(
                x: 40.00,
                y: 38.04,
              ),
            ],
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
                x: 48.16,
                y: 38.04,
              ),
              CoordinatePair(
                x: 55.60,
                y: 34.98,
              ),
              CoordinatePair(
                x: 60.00,
                y: 30.00,
              ),
            ],
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
                x: 73.76,
                y: 42.45,
              ),
              CoordinatePair(
                x: 84.94,
                y: 65.94,
              ),
              CoordinatePair(
                x: 84.82,
                y: 82.20,
              ),
            ],
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
                x: 84.82,
                y: 98.97,
              ),
              CoordinatePair(
                x: 73.76,
                y: 102.15,
              ),
              CoordinatePair(
                x: 60.00,
                y: 90.00,
              ),
            ],
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
                x: 66.64,
                y: 82.56,
              ),
              CoordinatePair(
                x: 64.96,
                y: 72.48,
              ),
              CoordinatePair(
                x: 55.84,
                y: 66.54,
              ),
            ],
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
                x: 46.72,
                y: 60.60,
              ),
              CoordinatePair(
                x: 33.28,
                y: 60.60,
              ),
              CoordinatePair(
                x: 24.16,
                y: 66.54,
              ),
            ],
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
                x: 15.04,
                y: 72.48,
              ),
              CoordinatePair(
                x: 13.36,
                y: 82.56,
              ),
              CoordinatePair(
                x: 20.00,
                y: 90.00,
              ),
            ],
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
                x: 11.06,
                y: 81.87,
              ),
              CoordinatePair(
                x: 2.78,
                y: 68.79,
              ),
              CoordinatePair(
                x: -1.80,
                y: 55.53,
              ),
            ],
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
                x: -6.28,
                y: 42.12,
              ),
              CoordinatePair(
                x: -6.28,
                y: 30.72,
              ),
              CoordinatePair(
                x: -1.80,
                y: 25.35,
              ),
            ],
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
                x: 2.68,
                y: 19.98,
              ),
              CoordinatePair(
                x: 11.16,
                y: 21.99,
              ),
              CoordinatePair(
                x: 20.00,
                y: 30.00,
              ),
            ],
          ),
        ],
      ),
    ),
  ];
}

Matrix3 _buildRotationMatrix() {
  return Matrix3.identity()
    ..setColumn(
      2,
      Vector3((20.0), (30.0), 1.0),
    )
    ..multiply(Matrix3.identity()..setRotationZ(2.0 * pi * 45.0 / 360.0))
    ..multiply(
      Matrix3.identity()
        ..setColumn(
          2,
          Vector3(-20.0, -30.0, 1),
        ),
    );
}

List<Command> _buildRotationResult() {
  return [
    CurveToCommand(
      isRelative: false,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 27.45,
                y: 11.52,
              ),
              CoordinatePair(
                x: 29.36,
                y: 14.87,
              ),
              CoordinatePair(
                x: 32.25,
                y: 17.75,
              ),
            ],
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
                x: 35.13,
                y: 20.64,
              ),
              CoordinatePair(
                x: 38.48,
                y: 22.55,
              ),
              CoordinatePair(
                x: 41.21,
                y: 22.93,
              ),
            ],
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
                x: 43.14,
                y: 30.73,
              ),
              CoordinatePair(
                x: 41.56,
                y: 40.22,
              ),
              CoordinatePair(
                x: 37.68,
                y: 44.01,
              ),
            ],
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
                x: 33.73,
                y: 47.96,
              ),
              CoordinatePair(
                x: 29.07,
                y: 44.80,
              ),
              CoordinatePair(
                x: 27.07,
                y: 37.07,
              ),
            ],
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
                x: 31.17,
                y: 37.67,
              ),
              CoordinatePair(
                x: 32.95,
                y: 34.70,
              ),
              CoordinatePair(
                x: 31.13,
                y: 30.07,
              ),
            ],
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
                x: 29.31,
                y: 25.45,
              ),
              CoordinatePair(
                x: 24.55,
                y: 20.69,
              ),
              CoordinatePair(
                x: 19.93,
                y: 18.87,
              ),
            ],
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
                x: 15.30,
                y: 17.05,
              ),
              CoordinatePair(
                x: 12.33,
                y: 18.83,
              ),
              CoordinatePair(
                x: 12.93,
                y: 22.93,
              ),
            ],
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
                x: 11.68,
                y: 17.85,
              ),
              CoordinatePair(
                x: 11.84,
                y: 11.84,
              ),
              CoordinatePair(
                x: 13.35,
                y: 7.10,
              ),
            ],
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
                x: 14.92,
                y: 2.35,
              ),
              CoordinatePair(
                x: 17.61,
                y: -0.33,
              ),
              CoordinatePair(
                x: 20.46,
                y: -0.02,
              ),
            ],
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
                x: 23.31,
                y: 0.30,
              ),
              CoordinatePair(
                x: 25.83,
                y: 3.77,
              ),
              CoordinatePair(
                x: 27.07,
                y: 8.79,
              ),
            ],
          ),
        ],
      ),
    ),
  ];
}

Matrix3 _buildSkewXMatrix() {
  return Matrix3.identity()..setColumn(1, Vector3(1.0, 1.0, 0.0));
}

List<Command> _buildSkewXResult() {
  return [
    CurveToCommand(
      isRelative: false,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 23.86,
                y: 11.66,
              ),
              CoordinatePair(
                x: 28.60,
                y: 12.68,
              ),
              CoordinatePair(
                x: 32.68,
                y: 12.68,
              ),
            ],
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
                x: 36.76,
                y: 12.68,
              ),
              CoordinatePair(
                x: 39.46,
                y: 11.66,
              ),
              CoordinatePair(
                x: 40.00,
                y: 10.00,
              ),
            ],
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
                x: 51.03,
                y: 14.15,
              ),
              CoordinatePair(
                x: 64.45,
                y: 21.98,
              ),
              CoordinatePair(
                x: 69.81,
                y: 27.40,
              ),
            ],
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
                x: 75.40,
                y: 32.99,
              ),
              CoordinatePair(
                x: 70.93,
                y: 34.05,
              ),
              CoordinatePair(
                x: 60.00,
                y: 30.00,
              ),
            ],
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
                x: 60.84,
                y: 27.52,
              ),
              CoordinatePair(
                x: 56.64,
                y: 24.16,
              ),
              CoordinatePair(
                x: 50.10,
                y: 22.18,
              ),
            ],
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
                x: 43.56,
                y: 20.20,
              ),
              CoordinatePair(
                x: 36.84,
                y: 20.20,
              ),
              CoordinatePair(
                x: 34.26,
                y: 22.18,
              ),
            ],
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
                x: 31.68,
                y: 24.16,
              ),
              CoordinatePair(
                x: 34.20,
                y: 27.52,
              ),
              CoordinatePair(
                x: 40.00,
                y: 30.00,
              ),
            ],
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
                x: 32.82,
                y: 27.29,
              ),
              CoordinatePair(
                x: 24.32,
                y: 22.93,
              ),
              CoordinatePair(
                x: 17.61,
                y: 18.51,
              ),
            ],
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
                x: 10.90,
                y: 14.04,
              ),
              CoordinatePair(
                x: 7.10,
                y: 10.24,
              ),
              CoordinatePair(
                x: 7.55,
                y: 8.45,
              ),
            ],
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
                x: 8.00,
                y: 6.66,
              ),
              CoordinatePair(
                x: 12.91,
                y: 7.33,
              ),
              CoordinatePair(
                x: 20.00,
                y: 10.00,
              ),
            ],
          ),
        ],
      ),
    ),
  ];
}

Matrix3 _buildSkewYMatrix() {
  return Matrix3.identity()..setColumn(0, Vector3(1.0, 1.0, 0.0));
}

List<Command> _buildSkewYResult() {
  return [
    CurveToCommand(
      isRelative: false,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 12.20,
                y: 23.86,
              ),
              CoordinatePair(
                x: 15.92,
                y: 28.60,
              ),
              CoordinatePair(
                x: 20.00,
                y: 32.68,
              ),
            ],
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
                x: 24.08,
                y: 36.76,
              ),
              CoordinatePair(
                x: 27.80,
                y: 39.46,
              ),
              CoordinatePair(
                x: 30.00,
                y: 40.00,
              ),
            ],
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
                x: 36.88,
                y: 51.03,
              ),
              CoordinatePair(
                x: 42.47,
                y: 64.45,
              ),
              CoordinatePair(
                x: 42.41,
                y: 69.81,
              ),
            ],
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
                x: 42.41,
                y: 75.40,
              ),
              CoordinatePair(
                x: 36.88,
                y: 70.93,
              ),
              CoordinatePair(
                x: 30.00,
                y: 60.00,
              ),
            ],
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
                x: 33.32,
                y: 60.84,
              ),
              CoordinatePair(
                x: 32.48,
                y: 56.64,
              ),
              CoordinatePair(
                x: 27.92,
                y: 50.10,
              ),
            ],
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
                x: 23.36,
                y: 43.56,
              ),
              CoordinatePair(
                x: 16.64,
                y: 36.84,
              ),
              CoordinatePair(
                x: 12.08,
                y: 34.26,
              ),
            ],
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
                x: 7.52,
                y: 31.68,
              ),
              CoordinatePair(
                x: 6.68,
                y: 34.20,
              ),
              CoordinatePair(
                x: 10.00,
                y: 40.00,
              ),
            ],
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
                x: 5.53,
                y: 32.82,
              ),
              CoordinatePair(
                x: 1.39,
                y: 24.32,
              ),
              CoordinatePair(
                x: -0.90,
                y: 17.61,
              ),
            ],
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
                x: -3.14,
                y: 10.90,
              ),
              CoordinatePair(
                x: -3.14,
                y: 7.10,
              ),
              CoordinatePair(
                x: -0.90,
                y: 7.55,
              ),
            ],
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
                x: 1.34,
                y: 8.00,
              ),
              CoordinatePair(
                x: 5.58,
                y: 12.91,
              ),
              CoordinatePair(
                x: 10.00,
                y: 20.00,
              ),
            ],
          ),
        ],
      ),
    ),
  ];
}
