import 'dart:math';

import 'package:icon_font/icon_font.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Constructor', () {
    test('Construct without "command" and "isRelative" arguments', () {
      expect(
        () => SmoothCurveToCommand(
          commandArguments: SmoothCurveToCoordinateSequence(
            coordinatePairDoubles: [],
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {command: "S"}', () {
      final commandName = 'S';
      final command = SmoothCurveToCommand(
        command: commandName,
        commandArguments: SmoothCurveToCoordinateSequence(
          coordinatePairDoubles: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "s"}', () {
      final commandName = 's';
      final command = SmoothCurveToCommand(
        command: commandName,
        commandArguments: SmoothCurveToCoordinateSequence(
          coordinatePairDoubles: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "foo"}', () {
      expect(
        () => SmoothCurveToCommand(
          command: 'foo',
          commandArguments: SmoothCurveToCoordinateSequence(
            coordinatePairDoubles: [],
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {isRelative: false}', () {
      final commandName = 'S';
      final isRelative = false;
      final command = SmoothCurveToCommand(
        isRelative: isRelative,
        commandArguments: SmoothCurveToCoordinateSequence(
          coordinatePairDoubles: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {isRelative: true}', () {
      final commandName = 's';
      final isRelative = true;
      final command = SmoothCurveToCommand(
        isRelative: isRelative,
        commandArguments: SmoothCurveToCoordinateSequence(
          coordinatePairDoubles: [],
        ),
      );
      expect(command.command, equals(commandName));
    });
  });

  test('Absolute toString()', () {
    final command = _buildAbsoluteSmoothCurveToCommand();
    final toString = 'S20.00 10.00 15.00 15.00 10.00 10.00 10.00 10.00';
    expect(command.toString(), equals(toString));
  });

  test('Relative toString()', () {
    final command = _buildRelativeSmoothCurveToCommand();
    final toString = 's10.00 0.00 5.00 5.00 -5.00 -5.00 -5.00 -5.00';
    expect(command.toString(), equals(toString));
  });

  test('Absolute applyTransformation() - identity', () {
    final command = _buildAbsoluteSmoothCurveToCommand();
    final transform = Matrix3.identity();
    final startPoint = _buildStartPoint();
    expect(
      command.applyTransformation(transform, startPoint),
      equals([command]),
    );
  });

  test('Relative applyTransformation() - identity', () {
    final command = _buildRelativeSmoothCurveToCommand();
    final transform = Matrix3.identity();
    final startPoint = _buildStartPoint();
    expect(
      command.applyTransformation(transform, startPoint),
      equals([command]),
    );
  });

  test('Absolute applyTransformation() - translate x by 10, y by 20', () {
    final command = _buildAbsoluteSmoothCurveToCommand();
    final transform = _buildTranslationMatrix();
    final startPoint = _buildStartPoint();
    final translated = SmoothCurveToCommand(
      isRelative: false,
      commandArguments: SmoothCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 30.0,
                y: 30.0,
              ),
              CoordinatePair(
                x: 25.0,
                y: 35.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 20.0,
                y: 30.0,
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
    final command = _buildRelativeSmoothCurveToCommand();
    final transform = _buildTranslationMatrix();
    final startPoint = _buildStartPoint();
    final translated = SmoothCurveToCommand(
      isRelative: true,
      commandArguments: SmoothCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 10.0,
                y: 0.0,
              ),
              CoordinatePair(
                x: 5.0,
                y: 5.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: -5.0,
                y: -5.0,
              ),
              CoordinatePair(
                x: -5.0,
                y: -5.0,
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
    final command = _buildAbsoluteSmoothCurveToCommand();
    final scale = _buildScaleMatrix();
    final startPoint = _buildStartPoint();
    final scaled = SmoothCurveToCommand(
      isRelative: false,
      commandArguments: SmoothCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 40.0,
                y: 30.0,
              ),
              CoordinatePair(
                x: 30.0,
                y: 45.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 20.0,
                y: 30.0,
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
    final command = _buildRelativeSmoothCurveToCommand();
    final scale = _buildScaleMatrix();
    final startPoint = _buildStartPoint();
    final scaled = SmoothCurveToCommand(
      isRelative: true,
      commandArguments: SmoothCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 20.0,
                y: 0.0,
              ),
              CoordinatePair(
                x: 10.0,
                y: 15.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: -10.0,
                y: -15.0,
              ),
              CoordinatePair(
                x: -10.0,
                y: -15.0,
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
    final command = _buildAbsoluteSmoothCurveToCommand();
    final rotate = _buildRotationMatrix();
    final startPoint = _buildStartPoint();
    final rotated = SmoothCurveToCommand(
      isRelative: false,
      commandArguments: SmoothCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 22.07,
                y: 15.0,
              ),
              CoordinatePair(
                x: 15.0,
                y: 15.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 15.0,
                y: 7.93,
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
    final command = _buildRelativeSmoothCurveToCommand();
    final rotate = _buildRotationMatrix();
    final startPoint = _buildStartPoint();
    final rotated = SmoothCurveToCommand(
      isRelative: true,
      commandArguments: SmoothCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 7.07,
                y: 7.07,
              ),
              CoordinatePair(
                x: 0.0,
                y: 7.07,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 0.0,
                y: -7.07,
              ),
              CoordinatePair(
                x: 0.0,
                y: -7.07,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(rotate, startPoint), equals([rotated]));
  });

  test('Absolute applyTransformation() - skew by 45deg along x axis', () {
    final command = _buildAbsoluteSmoothCurveToCommand();
    final skewX = _buildSkewXMatrix();
    final startPoint = _buildStartPoint();
    final skewed = SmoothCurveToCommand(
      isRelative: false,
      commandArguments: SmoothCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 30.0,
                y: 10.0,
              ),
              CoordinatePair(
                x: 30.0,
                y: 15.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 20.0,
                y: 10.0,
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
    final command = _buildRelativeSmoothCurveToCommand();
    final skewX = _buildSkewXMatrix();
    final startPoint = _buildStartPoint();
    final skewed = SmoothCurveToCommand(
      isRelative: true,
      commandArguments: SmoothCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 10.0,
                y: 0.0,
              ),
              CoordinatePair(
                x: 10.0,
                y: 5.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: -10.0,
                y: -5.0,
              ),
              CoordinatePair(
                x: -10.0,
                y: -5.0,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(skewX, startPoint), equals([skewed]));
  });

  test('Absolute applyTransformation() - skew by 45deg along y axis', () {
    final command = _buildAbsoluteSmoothCurveToCommand();
    final scale = _buildSkewYMatrix();
    final startPoint = _buildStartPoint();
    final skewed = SmoothCurveToCommand(
      isRelative: false,
      commandArguments: SmoothCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 20.0,
                y: 30.0,
              ),
              CoordinatePair(
                x: 15.0,
                y: 30.0,
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
    final command = _buildRelativeSmoothCurveToCommand();
    final scale = _buildSkewYMatrix();
    final startPoint = _buildStartPoint();
    final skewed = SmoothCurveToCommand(
      isRelative: true,
      commandArguments: SmoothCurveToCoordinateSequence(
        coordinatePairDoubles: [
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: 10.0,
                y: 10.0,
              ),
              CoordinatePair(
                x: 5.0,
                y: 10.0,
              ),
            ],
          ),
          CoordinatePairDouble(
            coordinatePairs: [
              CoordinatePair(
                x: -5.0,
                y: -10.0,
              ),
              CoordinatePair(
                x: -5.0,
                y: -10.0,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([skewed]));
  });

  test('Absolute getLastPoint()', () {
    final command = _buildAbsoluteSmoothCurveToCommand();
    final startPoint = _buildStartPoint();
    final lastPoint = CoordinatePair(
      x: 10.0,
      y: 10.0,
    );
    expect(command.getLastPoint(startPoint), equals(lastPoint));
  });

  test('Relative getLastPoint()', () {
    final command = _buildRelativeSmoothCurveToCommand();
    final startPoint = _buildStartPoint();
    final lastPoint = CoordinatePair(
      x: 10.0,
      y: 10.0,
    );
    expect(command.getLastPoint(startPoint), equals(lastPoint));
  });

  test('hashCode', () {
    final object = _buildAbsoluteSmoothCurveToCommand();
    final identicalObject = _buildAbsoluteSmoothCurveToCommand();
    final differentObject = _buildRelativeSmoothCurveToCommand();

    expect(object.hashCode, equals(identicalObject.hashCode));
    expect(object.hashCode, isNot(equals(differentObject.hashCode)));
  });

  test('== operator', () {
    final object = _buildAbsoluteSmoothCurveToCommand();
    final identicalObject = _buildAbsoluteSmoothCurveToCommand();
    final differentObject = _buildRelativeSmoothCurveToCommand();

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

SmoothCurveToCommand _buildAbsoluteSmoothCurveToCommand() {
  return SmoothCurveToCommand(
    isRelative: false,
    commandArguments: SmoothCurveToCoordinateSequence(
      coordinatePairDoubles: [
        CoordinatePairDouble(
          coordinatePairs: [
            CoordinatePair(
              x: 20.0,
              y: 10.0,
            ),
            CoordinatePair(
              x: 15.0,
              y: 15.0,
            ),
          ],
        ),
        CoordinatePairDouble(
          coordinatePairs: [
            CoordinatePair(
              x: 10.0,
              y: 10.0,
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

SmoothCurveToCommand _buildRelativeSmoothCurveToCommand() {
  return SmoothCurveToCommand(
    isRelative: true,
    commandArguments: SmoothCurveToCoordinateSequence(
      coordinatePairDoubles: [
        CoordinatePairDouble(
          coordinatePairs: [
            CoordinatePair(
              x: 10.0,
              y: 0.0,
            ),
            CoordinatePair(
              x: 5.0,
              y: 5.0,
            ),
          ],
        ),
        CoordinatePairDouble(
          coordinatePairs: [
            CoordinatePair(
              x: -5.0,
              y: -5.0,
            ),
            CoordinatePair(
              x: -5.0,
              y: -5.0,
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
