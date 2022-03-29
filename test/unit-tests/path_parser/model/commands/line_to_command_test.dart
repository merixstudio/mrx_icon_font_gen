import 'dart:math';

import 'package:icon_font/icon_font.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Constructor', () {
    test('Construct without "command" and "isRelative" arguments', () {
      expect(
        () => LineToCommand(
          commandArguments: CoordinatePairSequence(
            coordinatePairs: [],
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {command: "L"}', () {
      final commandName = 'L';
      final command = LineToCommand(
        command: commandName,
        commandArguments: CoordinatePairSequence(
          coordinatePairs: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "l"}', () {
      final commandName = 'l';
      final command = LineToCommand(
        command: commandName,
        commandArguments: CoordinatePairSequence(
          coordinatePairs: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "foo"}', () {
      expect(
        () => LineToCommand(
          command: 'foo',
          commandArguments: CoordinatePairSequence(
            coordinatePairs: [],
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {isRelative: false}', () {
      final commandName = 'L';
      final isRelative = false;
      final command = LineToCommand(
        isRelative: isRelative,
        commandArguments: CoordinatePairSequence(
          coordinatePairs: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {isRelative: true}', () {
      final commandName = 'l';
      final isRelative = true;
      final command = LineToCommand(
        isRelative: isRelative,
        commandArguments: CoordinatePairSequence(
          coordinatePairs: [],
        ),
      );
      expect(command.command, equals(commandName));
    });
  });

  test('Absolute toString()', () {
    final command = _buildAbsoluteLineToCommand();
    final toString = 'L20.00 10.00 10.00 20.00';
    expect(command.toString(), equals(toString));
  });

  test('Relative toString()', () {
    final command = _buildRelativeLineToCommand();
    final toString = 'l10.00 0.00 -10.00 10.00';
    expect(command.toString(), equals(toString));
  });

  test('Absolute applyTransformation() - identity', () {
    final command = _buildAbsoluteLineToCommand();
    final transform = Matrix3.identity();
    final startPoint = _buildStartPoint();
    final translated = LineToCommand(
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
    final command = _buildRelativeLineToCommand();
    final transform = Matrix3.identity();
    final startPoint = _buildStartPoint();
    final translated = LineToCommand(
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
    final command = _buildAbsoluteLineToCommand();
    final transform = _buildTranslationMatrix();
    final startPoint = _buildStartPoint();
    final translated = LineToCommand(
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
    final command = _buildRelativeLineToCommand();
    final transform = _buildTranslationMatrix();
    final startPoint = _buildStartPoint();
    final translated = LineToCommand(
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
    final command = _buildAbsoluteLineToCommand();
    final scale = _buildScaleMatrix();
    final startPoint = _buildStartPoint();
    final scaled = LineToCommand(
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
    final command = _buildRelativeLineToCommand();
    final scale = _buildScaleMatrix();
    final startPoint = _buildStartPoint();
    final scaled = LineToCommand(
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
    final command = _buildAbsoluteLineToCommand();
    final rotate = _buildRotationMatrix();
    final startPoint = _buildStartPoint();
    final rotated = LineToCommand(
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
    final command = _buildRelativeLineToCommand();
    final rotate = _buildRotationMatrix();
    final startPoint = _buildStartPoint();
    final rotated = LineToCommand(
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
    final command = _buildAbsoluteLineToCommand();
    final skewX = _buildSkewXMatrix();
    final startPoint = _buildStartPoint();
    final skewed = LineToCommand(
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
    final command = _buildRelativeLineToCommand();
    final skewX = _buildSkewXMatrix();
    final startPoint = _buildStartPoint();
    final skewed = LineToCommand(
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
    final command = _buildAbsoluteLineToCommand();
    final scale = _buildSkewYMatrix();
    final startPoint = _buildStartPoint();
    final skewed = LineToCommand(
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
    final command = _buildRelativeLineToCommand();
    final scale = _buildSkewYMatrix();
    final startPoint = _buildStartPoint();
    final skewed = LineToCommand(
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
    final command = _buildAbsoluteLineToCommand();
    final startPoint = _buildStartPoint();
    final lastPoint = CoordinatePair(
      x: 10.0,
      y: 20.0,
    );
    expect(command.getLastPoint(startPoint), equals(lastPoint));
  });

  test('Relative getLastPoint()', () {
    final command = _buildRelativeLineToCommand();
    final startPoint = _buildStartPoint();
    final lastPoint = CoordinatePair(
      x: 10.0,
      y: 20.0,
    );
    expect(command.getLastPoint(startPoint), equals(lastPoint));
  });

  test('hashCode', () {
    final object = _buildAbsoluteLineToCommand();
    final identicalObject = _buildAbsoluteLineToCommand();
    final differentObject = _buildRelativeLineToCommand();

    expect(object.hashCode, equals(identicalObject.hashCode));
    expect(object.hashCode, isNot(equals(differentObject.hashCode)));
  });

  test('== operator', () {
    final object = _buildAbsoluteLineToCommand();
    final identicalObject = _buildAbsoluteLineToCommand();
    final differentObject = _buildRelativeLineToCommand();

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

LineToCommand _buildAbsoluteLineToCommand() {
  return LineToCommand(
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

LineToCommand _buildRelativeLineToCommand() {
  return LineToCommand(
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
