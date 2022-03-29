import 'dart:math';

import 'package:icon_font/icon_font.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Constructor', () {
    test('Construct without "command" and "isRelative" arguments', () {
      expect(
        () => MoveToCommand(
          commandArguments: CoordinatePairSequence(
            coordinatePairs: [],
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {command: "M"}', () {
      final commandName = 'M';
      final command = MoveToCommand(
        command: commandName,
        commandArguments: CoordinatePairSequence(
          coordinatePairs: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "m"}', () {
      final commandName = 'm';
      final command = MoveToCommand(
        command: commandName,
        commandArguments: CoordinatePairSequence(
          coordinatePairs: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "foo"}', () {
      expect(
        () => MoveToCommand(
          command: 'foo',
          commandArguments: CoordinatePairSequence(
            coordinatePairs: [],
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {isRelative: false}', () {
      final commandName = 'M';
      final isRelative = false;
      final command = MoveToCommand(
        isRelative: isRelative,
        commandArguments: CoordinatePairSequence(
          coordinatePairs: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {isRelative: true}', () {
      final commandName = 'm';
      final isRelative = true;
      final command = MoveToCommand(
        isRelative: isRelative,
        commandArguments: CoordinatePairSequence(
          coordinatePairs: [],
        ),
      );
      expect(command.command, equals(commandName));
    });
  });

  test('Absolute toString()', () {
    final command = _buildAbsoluteMoveToCommand();
    final toString = 'M20.00 10.00 10.00 20.00';
    expect(command.toString(), equals(toString));
  });

  test('Relative toString()', () {
    final command = _buildRelativeMoveToCommand();
    final toString = 'm10.00 0.00 -10.00 10.00';
    expect(command.toString(), equals(toString));
  });

  test('Absolute applyTransformation() - identity', () {
    final command = _buildAbsoluteMoveToCommand();
    final transform = Matrix3.identity();
    final startPoint = _buildStartPoint();
    final translated = MoveToCommand(
      isRelative: false,
      commandArguments: CoordinatePairSequence(
        coordinatePairs: [
          CoordinatePair(
            x: 20.0,
            y: 10.0,
          ),
          CoordinatePair(
            x: 10.0,
            y: 20.0,
          ),
        ],
      ),
    );
    expect(
      command.applyTransformation(transform, startPoint),
      equals([translated]),
    );
  });

  test('Relative applyTransformation() - identity', () {
    final command = _buildRelativeMoveToCommand();
    final transform = Matrix3.identity();
    final startPoint = _buildStartPoint();
    final translated = MoveToCommand(
      isRelative: true,
      commandArguments: CoordinatePairSequence(
        coordinatePairs: [
          CoordinatePair(
            x: 10.0,
            y: 0.0,
          ),
          CoordinatePair(
            x: -10.0,
            y: 10.0,
          ),
        ],
      ),
    );
    expect(
      command.applyTransformation(transform, startPoint),
      equals([translated]),
    );
  });

  test('Absolute applyTransformation() - translate x by 10, y by 20', () {
    final command = _buildAbsoluteMoveToCommand();
    final transform = _buildTranslationMatrix();
    final startPoint = _buildStartPoint();
    final translated = MoveToCommand(
      isRelative: false,
      commandArguments: CoordinatePairSequence(
        coordinatePairs: [
          CoordinatePair(
            x: 30.0,
            y: 30.0,
          ),
          CoordinatePair(
            x: 20.0,
            y: 40.0,
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
    final command = _buildRelativeMoveToCommand();
    final transform = _buildTranslationMatrix();
    final startPoint = _buildStartPoint();
    final translated = MoveToCommand(
      isRelative: true,
      commandArguments: CoordinatePairSequence(
        coordinatePairs: [
          CoordinatePair(
            x: 10.0,
            y: 0.0,
          ),
          CoordinatePair(
            x: -10.0,
            y: 10.0,
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
    final command = _buildAbsoluteMoveToCommand();
    final scale = _buildScaleMatrix();
    final startPoint = _buildStartPoint();
    final scaled = MoveToCommand(
      isRelative: false,
      commandArguments: CoordinatePairSequence(
        coordinatePairs: [
          CoordinatePair(
            x: 40.0,
            y: 30.0,
          ),
          CoordinatePair(
            x: 20.0,
            y: 60.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([scaled]));
  });

  test('Relative applyTransformation() - scale x by 2, y by 3', () {
    final command = _buildRelativeMoveToCommand();
    final scale = _buildScaleMatrix();
    final startPoint = _buildStartPoint();
    final scaled = MoveToCommand(
      isRelative: true,
      commandArguments: CoordinatePairSequence(
        coordinatePairs: [
          CoordinatePair(
            x: 20.0,
            y: 0.0,
          ),
          CoordinatePair(
            x: -20.0,
            y: 30.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([scaled]));
  });

  test('Absolute applyTransformation() - rotate by 45deg around point <20,30>',
      () {
    final command = _buildAbsoluteMoveToCommand();
    final rotate = _buildRotationMatrix();
    final startPoint = _buildStartPoint();
    final rotated = MoveToCommand(
      isRelative: false,
      commandArguments: CoordinatePairSequence(
        coordinatePairs: [
          CoordinatePair(
            x: 22.07,
            y: 15.0,
          ),
          CoordinatePair(
            x: 7.93,
            y: 15.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(rotate, startPoint), equals([rotated]));
  });

  test('Relative applyTransformation() - rotate by 45deg around point <20,30>',
      () {
    final command = _buildRelativeMoveToCommand();
    final rotate = _buildRotationMatrix();
    final startPoint = _buildStartPoint();
    final rotated = MoveToCommand(
      isRelative: true,
      commandArguments: CoordinatePairSequence(
        coordinatePairs: [
          CoordinatePair(
            x: 7.07,
            y: 7.07,
          ),
          CoordinatePair(
            x: -14.14,
            y: 0.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(rotate, startPoint), equals([rotated]));
  });

  test('Absolute applyTransformation() - skew by 45deg along x axis', () {
    final command = _buildAbsoluteMoveToCommand();
    final skewX = _buildSkewXMatrix();
    final startPoint = _buildStartPoint();
    final skewed = MoveToCommand(
      isRelative: false,
      commandArguments: CoordinatePairSequence(
        coordinatePairs: [
          CoordinatePair(
            x: 30.0,
            y: 10.0,
          ),
          CoordinatePair(
            x: 30.0,
            y: 20.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(skewX, startPoint), equals([skewed]));
  });

  test('Relative applyTransformation() - skew by 45deg along x axis', () {
    final command = _buildRelativeMoveToCommand();
    final skewX = _buildSkewXMatrix();
    final startPoint = _buildStartPoint();
    final skewed = MoveToCommand(
      isRelative: true,
      commandArguments: CoordinatePairSequence(
        coordinatePairs: [
          CoordinatePair(
            x: 10.0,
            y: 0.0,
          ),
          CoordinatePair(
            x: 0.0,
            y: 10.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(skewX, startPoint), equals([skewed]));
  });

  test('Absolute applyTransformation() - skew by 45deg along y axis', () {
    final command = _buildAbsoluteMoveToCommand();
    final scale = _buildSkewYMatrix();
    final startPoint = _buildStartPoint();
    final skewed = MoveToCommand(
      isRelative: false,
      commandArguments: CoordinatePairSequence(
        coordinatePairs: [
          CoordinatePair(
            x: 20.0,
            y: 30.0,
          ),
          CoordinatePair(
            x: 10.0,
            y: 30.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([skewed]));
  });

  test('Relative applyTransformation() - skew by 45deg along y axis', () {
    final command = _buildRelativeMoveToCommand();
    final scale = _buildSkewYMatrix();
    final startPoint = _buildStartPoint();
    final skewed = MoveToCommand(
      isRelative: true,
      commandArguments: CoordinatePairSequence(
        coordinatePairs: [
          CoordinatePair(
            x: 10.0,
            y: 10.0,
          ),
          CoordinatePair(
            x: -10.0,
            y: 0.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([skewed]));
  });

  test('Absolute getLastPoint()', () {
    final command = _buildAbsoluteMoveToCommand();
    final startPoint = _buildStartPoint();
    final lastPoint = CoordinatePair(
      x: 10.0,
      y: 20.0,
    );
    expect(command.getLastPoint(startPoint), equals(lastPoint));
  });

  test('Relative getLastPoint()', () {
    final command = _buildRelativeMoveToCommand();
    final startPoint = _buildStartPoint();
    final lastPoint = CoordinatePair(
      x: 10.0,
      y: 20.0,
    );
    expect(command.getLastPoint(startPoint), equals(lastPoint));
  });

  test('hashCode', () {
    final object = _buildAbsoluteMoveToCommand();
    final identicalObject = _buildAbsoluteMoveToCommand();
    final differentObject = _buildRelativeMoveToCommand();

    expect(object.hashCode, equals(identicalObject.hashCode));
    expect(object.hashCode, isNot(equals(differentObject.hashCode)));
  });

  test('== operator', () {
    final object = _buildAbsoluteMoveToCommand();
    final identicalObject = _buildAbsoluteMoveToCommand();
    final differentObject = _buildRelativeMoveToCommand();

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

MoveToCommand _buildAbsoluteMoveToCommand() {
  return MoveToCommand(
    isRelative: false,
    commandArguments: CoordinatePairSequence(
      coordinatePairs: [
        CoordinatePair(
          x: 20.0,
          y: 10.0,
        ),
        CoordinatePair(
          x: 10.0,
          y: 20.0,
        ),
      ],
    ),
  );
}

MoveToCommand _buildRelativeMoveToCommand() {
  return MoveToCommand(
    isRelative: true,
    commandArguments: CoordinatePairSequence(
      coordinatePairs: [
        CoordinatePair(
          x: 10.0,
          y: 0.0,
        ),
        CoordinatePair(
          x: -10.0,
          y: 10.0,
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
