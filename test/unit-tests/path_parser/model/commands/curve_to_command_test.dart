import 'dart:math';

import 'package:icon_font/icon_font.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Constructor', () {
    test('Construct without "command" and "isRelative" arguments', () {
      expect(
        () => CurveToCommand(
          commandArguments: CurveToCoordinateSequence(
            coordinatePairTriplets: [],
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {command: "C"}', () {
      final commandName = 'C';
      final command = CurveToCommand(
        command: commandName,
        commandArguments: CurveToCoordinateSequence(
          coordinatePairTriplets: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "c"}', () {
      final commandName = 'c';
      final command = CurveToCommand(
        command: commandName,
        commandArguments: CurveToCoordinateSequence(
          coordinatePairTriplets: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "foo"}', () {
      expect(
        () => CurveToCommand(
          command: 'foo',
          commandArguments: CurveToCoordinateSequence(
            coordinatePairTriplets: [],
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {isRelative: false}', () {
      final commandName = 'C';
      final isRelative = false;
      final command = CurveToCommand(
        isRelative: isRelative,
        commandArguments: CurveToCoordinateSequence(
          coordinatePairTriplets: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {isRelative: true}', () {
      final commandName = 'c';
      final isRelative = true;
      final command = CurveToCommand(
        isRelative: isRelative,
        commandArguments: CurveToCoordinateSequence(
          coordinatePairTriplets: [],
        ),
      );
      expect(command.command, equals(commandName));
    });
  });

  test('Absolute toString()', () {
    final command = _buildAbsoluteCurveToCommand();
    final toString =
        'C10.00 10.00 30.00 30.00 20.00 30.00 10.00 30.00 30.00 50.00 30.00 40.00';
    expect(command.toString(), equals(toString));
  });

  test('Relative toString()', () {
    final command = _buildRelativeCurveToCommand();
    final toString =
        'c0.00 -10.00 20.00 10.00 10.00 10.00 -10.00 0.00 10.00 20.00 10.00 10.00';
    expect(command.toString(), equals(toString));
  });

  test('Absolute applyTransformation() - identity', () {
    final command = _buildAbsoluteCurveToCommand();
    final transform = Matrix3.identity();
    final startPoint = _buildStartPoint();
    expect(
      command.applyTransformation(transform, startPoint),
      equals([command]),
    );
  });

  test('Relative applyTransformation() - identity', () {
    final command = _buildRelativeCurveToCommand();
    final transform = Matrix3.identity();
    final startPoint = _buildStartPoint();
    expect(
      command.applyTransformation(transform, startPoint),
      equals([command]),
    );
  });

  test('Absolute applyTransformation() - translate x by 10, y by 20', () {
    final command = _buildAbsoluteCurveToCommand();
    final transform = _buildTranslationMatrix();
    final startPoint = _buildStartPoint();
    final translated = CurveToCommand(
      isRelative: false,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 20.0,
                y: 30.0,
              ),
              CoordinatePair(
                x: 40.0,
                y: 50.0,
              ),
              CoordinatePair(
                x: 30.0,
                y: 50.0,
              ),
            ],
          ),
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 20.0,
                y: 50.0,
              ),
              CoordinatePair(
                x: 40.0,
                y: 70.0,
              ),
              CoordinatePair(
                x: 40.0,
                y: 60.0,
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
    final command = _buildRelativeCurveToCommand();
    final transform = _buildTranslationMatrix();
    final startPoint = _buildStartPoint();
    expect(
      command.applyTransformation(transform, startPoint),
      equals([command]),
    );
  });

  test('Absolute applyTransformation() - scale x by 2, y by 3', () {
    final command = _buildAbsoluteCurveToCommand();
    final scale = _buildScaleMatrix();
    final startPoint = _buildStartPoint();
    final scaled = CurveToCommand(
      isRelative: false,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 20.0,
                y: 30.0,
              ),
              CoordinatePair(
                x: 60.0,
                y: 90.0,
              ),
              CoordinatePair(
                x: 40.0,
                y: 90.0,
              ),
            ],
          ),
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 20.0,
                y: 90.0,
              ),
              CoordinatePair(
                x: 60.0,
                y: 150.0,
              ),
              CoordinatePair(
                x: 60.0,
                y: 120.0,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([scaled]));
  });

  test('Relative applyTransformation() - scale x by 2, y by 3', () {
    final command = _buildRelativeCurveToCommand();
    final scale = _buildScaleMatrix();
    final startPoint = _buildStartPoint();
    final scaled = CurveToCommand(
      isRelative: true,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 0.0,
                y: -30.0,
              ),
              CoordinatePair(
                x: 40.0,
                y: 30.0,
              ),
              CoordinatePair(
                x: 20.0,
                y: 30.0,
              ),
            ],
          ),
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: -20.0,
                y: 0.0,
              ),
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

  test('Absolute applyTransformation() - rotate by 45deg around point <20,30>',
      () {
    final command = _buildAbsoluteCurveToCommand();
    final scale = _buildRotationMatrix();
    final startPoint = _buildStartPoint();
    final rotated = CurveToCommand(
      isRelative: false,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 27.07,
                y: 8.79,
              ),
              CoordinatePair(
                x: 27.07,
                y: 37.07,
              ),
              CoordinatePair(
                x: 20.0,
                y: 30.0,
              ),
            ],
          ),
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 12.93,
                y: 22.93,
              ),
              CoordinatePair(
                x: 12.93,
                y: 51.21,
              ),
              CoordinatePair(
                x: 20.0,
                y: 44.14,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([rotated]));
  });

  test('Relative applyTransformation() - rotate by 45deg around point <20,30>',
      () {
    final command = _buildRelativeCurveToCommand();
    final scale = _buildRotationMatrix();
    final startPoint = _buildStartPoint();
    final rotated = CurveToCommand(
      isRelative: true,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 7.07,
                y: -7.07,
              ),
              CoordinatePair(
                x: 7.07,
                y: 21.21,
              ),
              CoordinatePair(
                x: 0.0,
                y: 14.14,
              ),
            ],
          ),
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: -7.07,
                y: -7.07,
              ),
              CoordinatePair(
                x: -7.07,
                y: 21.21,
              ),
              CoordinatePair(
                x: 0.0,
                y: 14.14,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([rotated]));
  });

  test('Absolute applyTransformation() - skew by 45deg along x axis', () {
    final command = _buildAbsoluteCurveToCommand();
    final scale = _buildSkewXMatrix();
    final startPoint = _buildStartPoint();
    final skewed = CurveToCommand(
      isRelative: false,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 20.0,
                y: 10.0,
              ),
              CoordinatePair(
                x: 60.0,
                y: 30.0,
              ),
              CoordinatePair(
                x: 50.0,
                y: 30.0,
              ),
            ],
          ),
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 40.0,
                y: 30.0,
              ),
              CoordinatePair(
                x: 80.0,
                y: 50.0,
              ),
              CoordinatePair(
                x: 70.0,
                y: 40.0,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([skewed]));
  });

  test('Relative applyTransformation() - skew by 45deg along x axis', () {
    final command = _buildRelativeCurveToCommand();
    final scale = _buildSkewXMatrix();
    final startPoint = _buildStartPoint();
    final skewed = CurveToCommand(
      isRelative: true,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: -10.0,
                y: -10.0,
              ),
              CoordinatePair(
                x: 30.0,
                y: 10.0,
              ),
              CoordinatePair(
                x: 20.0,
                y: 10.0,
              ),
            ],
          ),
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: -10.0,
                y: 0.0,
              ),
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
    expect(command.applyTransformation(scale, startPoint), equals([skewed]));
  });

  test('Absolute applyTransformation() - skew by 45deg along y axis', () {
    final command = _buildAbsoluteCurveToCommand();
    final scale = _buildSkewYMatrix();
    final startPoint = _buildStartPoint();
    final skewed = CurveToCommand(
      isRelative: false,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 10.0,
                y: 20.0,
              ),
              CoordinatePair(
                x: 30.0,
                y: 60.0,
              ),
              CoordinatePair(
                x: 20.0,
                y: 50.0,
              ),
            ],
          ),
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 10.0,
                y: 40.0,
              ),
              CoordinatePair(
                x: 30.0,
                y: 80.0,
              ),
              CoordinatePair(
                x: 30.0,
                y: 70.0,
              ),
            ],
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([skewed]));
  });

  test('Relative applyTransformation() - skew by 45deg along y axis', () {
    final command = _buildRelativeCurveToCommand();
    final scale = _buildSkewYMatrix();
    final startPoint = _buildStartPoint();
    final skewed = CurveToCommand(
      isRelative: true,
      commandArguments: CurveToCoordinateSequence(
        coordinatePairTriplets: [
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: 0.0,
                y: -10.0,
              ),
              CoordinatePair(
                x: 20.0,
                y: 30.0,
              ),
              CoordinatePair(
                x: 10.0,
                y: 20.0,
              ),
            ],
          ),
          CoordinatePairTriplet(
            coordinatePairs: [
              CoordinatePair(
                x: -10.0,
                y: -10.0,
              ),
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

  test('Absolute getLastPoint()', () {
    final command = _buildAbsoluteCurveToCommand();
    final startPoint = _buildStartPoint();
    final lastPoint = CoordinatePair(
      x: 30.0,
      y: 40.0,
    );
    expect(command.getLastPoint(startPoint), equals(lastPoint));
  });

  test('Relative getLastPoint()', () {
    final command = _buildRelativeCurveToCommand();
    final startPoint = _buildStartPoint();
    final lastPoint = CoordinatePair(
      x: 30.0,
      y: 40.0,
    );
    expect(command.getLastPoint(startPoint), equals(lastPoint));
  });

  test('hashCode', () {
    final object = _buildAbsoluteCurveToCommand();
    final identicalObject = _buildAbsoluteCurveToCommand();
    final differentObject = _buildRelativeCurveToCommand();

    expect(object.hashCode, equals(identicalObject.hashCode));
    expect(object.hashCode, isNot(equals(differentObject.hashCode)));
  });

  test('== operator', () {
    final object = _buildAbsoluteCurveToCommand();
    final identicalObject = _buildAbsoluteCurveToCommand();
    final differentObject = _buildRelativeCurveToCommand();

    expect(object, equals(object));
    expect(object, equals(identicalObject));
    expect(object, isNot(equals(differentObject)));
  });
}

CoordinatePair _buildStartPoint() {
  return CoordinatePair(
    x: 10.0,
    y: 20.0,
  );
}

CurveToCommand _buildAbsoluteCurveToCommand() {
  return CurveToCommand(
    isRelative: false,
    commandArguments: CurveToCoordinateSequence(
      coordinatePairTriplets: [
        CoordinatePairTriplet(
          coordinatePairs: [
            CoordinatePair(
              x: 10.0,
              y: 10.0,
            ),
            CoordinatePair(
              x: 30.0,
              y: 30.0,
            ),
            CoordinatePair(
              x: 20.0,
              y: 30.0,
            ),
          ],
        ),
        CoordinatePairTriplet(
          coordinatePairs: [
            CoordinatePair(
              x: 10.0,
              y: 30.0,
            ),
            CoordinatePair(
              x: 30.0,
              y: 50.0,
            ),
            CoordinatePair(
              x: 30.0,
              y: 40.0,
            ),
          ],
        ),
      ],
    ),
  );
}

CurveToCommand _buildRelativeCurveToCommand() {
  return CurveToCommand(
    isRelative: true,
    commandArguments: CurveToCoordinateSequence(
      coordinatePairTriplets: [
        CoordinatePairTriplet(
          coordinatePairs: [
            CoordinatePair(
              x: 0.0,
              y: -10.0,
            ),
            CoordinatePair(
              x: 20.0,
              y: 10.0,
            ),
            CoordinatePair(
              x: 10.0,
              y: 10.0,
            ),
          ],
        ),
        CoordinatePairTriplet(
          coordinatePairs: [
            CoordinatePair(
              x: -10.0,
              y: 0.0,
            ),
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

Matrix3 _buildSkewXMatrix() {
  return Matrix3.identity()..setColumn(1, Vector3(1.0, 1.0, 0.0));
}

Matrix3 _buildSkewYMatrix() {
  return Matrix3.identity()..setColumn(0, Vector3(1.0, 1.0, 0.0));
}
