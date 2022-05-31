import 'dart:math';

import 'package:mrx_icon_font_gen/mrx_icon_font_gen.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Constructor', () {
    test('Construct without "command" and "isRelative" arguments', () {
      expect(
        () => QuadraticBezierCurveToCommand(
          commandArguments: QuadraticBezierCurveToCoordinateSequence(
            coordinatePairDoubles: [],
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {command: "Q"}', () {
      const commandName = 'Q';
      final command = QuadraticBezierCurveToCommand(
        command: commandName,
        commandArguments: QuadraticBezierCurveToCoordinateSequence(
          coordinatePairDoubles: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "q"}', () {
      const commandName = 'q';
      final command = QuadraticBezierCurveToCommand(
        command: commandName,
        commandArguments: QuadraticBezierCurveToCoordinateSequence(
          coordinatePairDoubles: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "foo"}', () {
      expect(
        () => QuadraticBezierCurveToCommand(
          command: 'foo',
          commandArguments: QuadraticBezierCurveToCoordinateSequence(
            coordinatePairDoubles: [],
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {isRelative: false}', () {
      const commandName = 'Q';
      const isRelative = false;
      final QuadraticBezierCurveToCommand command = QuadraticBezierCurveToCommand(
        isRelative: isRelative,
        commandArguments: QuadraticBezierCurveToCoordinateSequence(
          coordinatePairDoubles: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {isRelative: true}', () {
      const commandName = 'q';
      const isRelative = true;
      final command = QuadraticBezierCurveToCommand(
        isRelative: isRelative,
        commandArguments: QuadraticBezierCurveToCoordinateSequence(
          coordinatePairDoubles: [],
        ),
      );
      expect(command.command, equals(commandName));
    });
  });

  test('Absolute toString()', () {
    final command = _buildAbsoluteQuadraticBezierCurveToCommand();
    const toString = 'Q20.00 10.00 20.00 20.00 10.00 20.00 10.00 10.00';
    expect(command.toString(), equals(toString));
  });

  test('Relative toString()', () {
    final command = _buildRelativeQuadraticBezierCurveToCommand();
    const toString = 'q10.00 0.00 10.00 10.00 -10.00 0.00 -10.00 -10.00';
    expect(command.toString(), equals(toString));
  });

  test('Absolute applyTransformation() - identity', () {
    final command = _buildAbsoluteQuadraticBezierCurveToCommand();
    final transform = Matrix3.identity();
    final startPoint = _buildStartPoint();
    expect(
      command.applyTransformation(transform, startPoint),
      equals([command]),
    );
  });

  test('Relative applyTransformation() - identity', () {
    final command = _buildRelativeQuadraticBezierCurveToCommand();
    final transform = Matrix3.identity();
    final startPoint = _buildStartPoint();
    expect(
      command.applyTransformation(transform, startPoint),
      equals([command]),
    );
  });

  test('Absolute applyTransformation() - translate x by 10, y by 20', () {
    final command = _buildAbsoluteQuadraticBezierCurveToCommand();
    final transform = _buildTranslationMatrix();
    final startPoint = _buildStartPoint();
    final translated = QuadraticBezierCurveToCommand(
      isRelative: false,
      commandArguments: QuadraticBezierCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 30.0,
                y: 30.0,
              ),
              CoordinatePair(
                x: 30.0,
                y: 40.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 20.0,
                y: 40.0,
              ),
              CoordinatePair(
                x: 20.0,
                y: 30.0,
              ),
            ],
          ),
        ],
      ),
    );
    expect(
      command.applyTransformation(transform, startPoint),
      equals([translated]),
    );
  });

  test('Relative applyTransformation() - translate x by 10, y by 20', () {
    final command = _buildRelativeQuadraticBezierCurveToCommand();
    final transform = _buildTranslationMatrix();
    final startPoint = _buildStartPoint();
    final translated = QuadraticBezierCurveToCommand(
      isRelative: true,
      commandArguments: QuadraticBezierCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 10.0,
                y: 0.0,
              ),
              CoordinatePair(
                x: 10.0,
                y: 10.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: -10.0,
                y: 0.0,
              ),
              CoordinatePair(
                x: -10.0,
                y: -10.0,
              ),
            ],
          ),
        ],
      ),
    );
    expect(
      command.applyTransformation(transform, startPoint),
      equals([translated]),
    );
  });

  test('Absolute applyTransformation() - scale x by 2, y by 3', () {
    final command = _buildAbsoluteQuadraticBezierCurveToCommand();
    final scale = _buildScaleMatrix();
    final startPoint = _buildStartPoint();
    final scaled = QuadraticBezierCurveToCommand(
      isRelative: false,
      commandArguments: QuadraticBezierCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 40.0,
                y: 30.0,
              ),
              CoordinatePair(
                x: 40.0,
                y: 60.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 20.0,
                y: 60.0,
              ),
              CoordinatePair(
                x: 20.0,
                y: 30.0,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([scaled]));
  });

  test('Relative applyTransformation() - scale x by 2, y by 3', () {
    final command = _buildRelativeQuadraticBezierCurveToCommand();
    final scale = _buildScaleMatrix();
    final startPoint = _buildStartPoint();
    final scaled = QuadraticBezierCurveToCommand(
      isRelative: true,
      commandArguments: QuadraticBezierCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 20.0,
                y: 0.0,
              ),
              CoordinatePair(
                x: 20.0,
                y: 30.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: -20.0,
                y: 0.0,
              ),
              CoordinatePair(
                x: -20.0,
                y: -30.0,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([scaled]));
  });

  test('Absolute applyTransformation() - rotate by 45deg around point <20,30>',
      () {
    final command = _buildAbsoluteQuadraticBezierCurveToCommand();
    final rotate = _buildRotationMatrix();
    final startPoint = _buildStartPoint();
    final rotated = QuadraticBezierCurveToCommand(
      isRelative: false,
      commandArguments: QuadraticBezierCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 22.07,
                y: 15.0,
              ),
              CoordinatePair(
                x: 15.0,
                y: 22.07,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 7.93,
                y: 15.0,
              ),
              CoordinatePair(
                x: 15.0,
                y: 7.93,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(rotate, startPoint), equals([rotated]));
  });

  test('Relative applyTransformation() - rotate by 45deg around point <20,30>',
      () {
    final command = _buildRelativeQuadraticBezierCurveToCommand();
    final rotate = _buildRotationMatrix();
    final startPoint = _buildStartPoint();
    final rotated = QuadraticBezierCurveToCommand(
      isRelative: true,
      commandArguments: QuadraticBezierCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 7.07,
                y: 7.07,
              ),
              CoordinatePair(
                x: 0.0,
                y: 14.14,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: -7.07,
                y: -7.07,
              ),
              CoordinatePair(
                x: 0.0,
                y: -14.14,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(rotate, startPoint), equals([rotated]));
  });

  test('Absolute applyTransformation() - skew by 45deg along x axis', () {
    final command = _buildAbsoluteQuadraticBezierCurveToCommand();
    final skewX = _buildSkewXMatrix();
    final startPoint = _buildStartPoint();
    final skewed = QuadraticBezierCurveToCommand(
      isRelative: false,
      commandArguments: QuadraticBezierCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 30.0,
                y: 10.0,
              ),
              CoordinatePair(
                x: 40.0,
                y: 20.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 30.0,
                y: 20.0,
              ),
              CoordinatePair(
                x: 20.0,
                y: 10.0,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(skewX, startPoint), equals([skewed]));
  });

  test('Relative applyTransformation() - skew by 45deg along x axis', () {
    final command = _buildRelativeQuadraticBezierCurveToCommand();
    final skewX = _buildSkewXMatrix();
    final startPoint = _buildStartPoint();
    final skewed = QuadraticBezierCurveToCommand(
      isRelative: true,
      commandArguments: QuadraticBezierCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 10.0,
                y: 0.0,
              ),
              CoordinatePair(
                x: 20.0,
                y: 10.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: -10.0,
                y: 0.0,
              ),
              CoordinatePair(
                x: -20.0,
                y: -10.0,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(skewX, startPoint), equals([skewed]));
  });

  test('Absolute applyTransformation() - skew by 45deg along y axis', () {
    final command = _buildAbsoluteQuadraticBezierCurveToCommand();
    final scale = _buildSkewYMatrix();
    final startPoint = _buildStartPoint();
    final skewed = QuadraticBezierCurveToCommand(
      isRelative: false,
      commandArguments: QuadraticBezierCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 20.0,
                y: 30.0,
              ),
              CoordinatePair(
                x: 20.0,
                y: 40.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 10.0,
                y: 30.0,
              ),
              CoordinatePair(
                x: 10.0,
                y: 20.0,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([skewed]));
  });

  test('Relative applyTransformation() - skew by 45deg along y axis', () {
    final command = _buildRelativeQuadraticBezierCurveToCommand();
    final scale = _buildSkewYMatrix();
    final startPoint = _buildStartPoint();
    final skewed = QuadraticBezierCurveToCommand(
      isRelative: true,
      commandArguments: QuadraticBezierCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 10.0,
                y: 10.0,
              ),
              CoordinatePair(
                x: 10.0,
                y: 20.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: -10.0,
                y: -10.0,
              ),
              CoordinatePair(
                x: -10.0,
                y: -20.0,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([skewed]));
  });

  test('Absolute getLastPoint()', () {
    final command = _buildAbsoluteQuadraticBezierCurveToCommand();
    final startPoint = _buildStartPoint();
    final lastPoint = CoordinatePair(
      x: 10.0,
      y: 10.0,
    );
    expect(command.getLastPoint(startPoint), equals(lastPoint));
  });

  test('Relative getLastPoint()', () {
    final command = _buildRelativeQuadraticBezierCurveToCommand();
    final startPoint = _buildStartPoint();
    final lastPoint = CoordinatePair(
      x: 10.0,
      y: 10.0,
    );
    expect(command.getLastPoint(startPoint), equals(lastPoint));
  });

  test('hashCode', () {
    final object = _buildAbsoluteQuadraticBezierCurveToCommand();
    final identicalObject = _buildAbsoluteQuadraticBezierCurveToCommand();
    final differentObject = _buildRelativeQuadraticBezierCurveToCommand();

    expect(object.hashCode, equals(identicalObject.hashCode));
    expect(object.hashCode, isNot(equals(differentObject.hashCode)));
  });

  test('== operator', () {
    final object = _buildAbsoluteQuadraticBezierCurveToCommand();
    final identicalObject = _buildAbsoluteQuadraticBezierCurveToCommand();
    final differentObject = _buildRelativeQuadraticBezierCurveToCommand();

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

QuadraticBezierCurveToCommand _buildAbsoluteQuadraticBezierCurveToCommand() {
  return QuadraticBezierCurveToCommand(
    isRelative: false,
    commandArguments: QuadraticBezierCurveToCoordinateSequence(
      coordinatePairDoubles: [
        CoordinatePairDouble(
          coordinatePairs: [
            CoordinatePair(
              x: 20.0,
              y: 10.0,
            ),
            CoordinatePair(
              x: 20.0,
              y: 20.0,
            ),
          ],
        ),
        CoordinatePairDouble(
          coordinatePairs: [
            CoordinatePair(
              x: 10.0,
              y: 20.0,
            ),
            CoordinatePair(
              x: 10.0,
              y: 10.0,
            ),
          ],
        ),
      ],
    ),
  );
}

QuadraticBezierCurveToCommand _buildRelativeQuadraticBezierCurveToCommand() {
  return QuadraticBezierCurveToCommand(
    isRelative: true,
    commandArguments: QuadraticBezierCurveToCoordinateSequence(
      coordinatePairDoubles: [
        CoordinatePairDouble(
          coordinatePairs: [
            CoordinatePair(
              x: 10.0,
              y: 0.0,
            ),
            CoordinatePair(
              x: 10.0,
              y: 10.0,
            ),
          ],
        ),
        CoordinatePairDouble(
          coordinatePairs: [
            CoordinatePair(
              x: -10.0,
              y: 0.0,
            ),
            CoordinatePair(
              x: -10.0,
              y: -10.0,
            ),
          ],
        ),
      ],
    ),
  );
}

Matrix3 _buildTranslationMatrix() {
  return Matrix3.identity()..setColumn(2, Vector3(10.0, 20.0, 1.0));
}

Matrix3 _buildScaleMatrix() {
  return Matrix3.identity()
    ..setColumn(0, Vector3(2.0, 0.0, 0.0))
    ..setColumn(1, Vector3(0.0, 3.0, 0.0));
}

Matrix3 _buildRotationMatrix() {
  return Matrix3.identity()
    ..setColumn(
      2,
      Vector3((15.0), (15.0), 1.0),
    )
    ..multiply(Matrix3.identity()..setRotationZ(2.0 * pi * 45.0 / 360.0))
    ..multiply(
      Matrix3.identity()
        ..setColumn(
          2,
          Vector3(-15.0, -15.0, 1),
        ),
    );
}

Matrix3 _buildSkewXMatrix() {
  return Matrix3.identity()..setColumn(1, Vector3(1.0, 1.0, 0.0));
}

Matrix3 _buildSkewYMatrix() {
  return Matrix3.identity()..setColumn(0, Vector3(1.0, 1.0, 0.0));
}
