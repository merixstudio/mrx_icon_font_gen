import 'dart:math';

import 'package:mrx_icon_font_gen/mrx_icon_font_gen.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Constructor', () {
    test('Construct without "command" and "isRelative" arguments', () {
      expect(
        () => HorizontalLineToCommand(
          commandArguments: CoordinateSequence(
            coordinates: [],
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {command: "H"}', () {
      const commandName = 'H';
      final command = HorizontalLineToCommand(
        command: commandName,
        commandArguments: CoordinateSequence(
          coordinates: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "h"}', () {
      const commandName = 'h';
      final command = HorizontalLineToCommand(
        command: commandName,
        commandArguments: CoordinateSequence(
          coordinates: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "foo"}', () {
      expect(
        () => HorizontalLineToCommand(
          command: 'foo',
          commandArguments: CoordinateSequence(
            coordinates: [],
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {isRelative: false}', () {
      const commandName = 'H';
      const isRelative = false;
      final command = HorizontalLineToCommand(
        isRelative: isRelative,
        commandArguments: CoordinateSequence(
          coordinates: [],
        ),
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {isRelative: true}', () {
      const commandName = 'h';
      const isRelative = true;
      final command = HorizontalLineToCommand(
        isRelative: isRelative,
        commandArguments: CoordinateSequence(
          coordinates: [],
        ),
      );
      expect(command.command, equals(commandName));
    });
  });

  test('Absolute toString()', () {
    final command = _buildAbsoluteHorizontalLineToCommand();
    const toString = 'H20.00 15.00';
    expect(command.toString(), equals(toString));
  });

  test('Relative toString()', () {
    final command = _buildRelativeHorizontalLineToCommand();
    const toString = 'h10.00 -5.00';
    expect(command.toString(), equals(toString));
  });

  test('Absolute applyTransformation() - identity', () {
    final HorizontalLineToCommand command = _buildAbsoluteHorizontalLineToCommand();
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
            x: 15.0,
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

  test('Relative applyTransformation() - identity', () {
    final command = _buildRelativeHorizontalLineToCommand();
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
            x: -5.0,
            y: 0.0,
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
    final command = _buildAbsoluteHorizontalLineToCommand();
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
            x: 25.0,
            y: 30.0,
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
    final command = _buildRelativeHorizontalLineToCommand();
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
            x: -5.0,
            y: 0.0,
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
    final command = _buildAbsoluteHorizontalLineToCommand();
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
            x: 30.0,
            y: 30.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([scaled]));
  });

  test('Relative applyTransformation() - scale x by 2, y by 3', () {
    final command = _buildRelativeHorizontalLineToCommand();
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
            x: -10.0,
            y: 0.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([scaled]));
  });

  test('Absolute applyTransformation() - rotate by 45deg around point <20,30>',
      () {
    final command = _buildAbsoluteHorizontalLineToCommand();
    final rotate = _buildRotationMatrix();
    final startPoint = _buildStartPoint();
    final rotated = LineToCommand(
      isRelative: false,
      commandArguments: CoordinatePairSequence(
        coordinatePairs: [
          CoordinatePair(
            x: 18.54,
            y: 13.54,
          ),
          CoordinatePair(
            x: 15.0,
            y: 10.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(rotate, startPoint), equals([rotated]));
  });

  test('Relative applyTransformation() - rotate by 45deg around point <20,30>',
      () {
    final command = _buildRelativeHorizontalLineToCommand();
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
            x: -3.54,
            y: -3.54,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(rotate, startPoint), equals([rotated]));
  });

  test('Absolute applyTransformation() - skew by 45deg along x axis', () {
    final command = _buildAbsoluteHorizontalLineToCommand();
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
            x: 25.0,
            y: 10.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(skewX, startPoint), equals([skewed]));
  });

  test('Relative applyTransformation() - skew by 45deg along x axis', () {
    final command = _buildRelativeHorizontalLineToCommand();
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
            x: -5.0,
            y: 0.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(skewX, startPoint), equals([skewed]));
  });

  test('Absolute applyTransformation() - skew by 45deg along y axis', () {
    final command = _buildAbsoluteHorizontalLineToCommand();
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
            x: 15.0,
            y: 25.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([skewed]));
  });

  test('Relative applyTransformation() - skew by 45deg along y axis', () {
    final command = _buildRelativeHorizontalLineToCommand();
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
            x: -5.0,
            y: -5.0,
          ),
        ],
      ),
    );
    expect(command.applyTransformation(scale, startPoint), equals([skewed]));
  });

  test('Absolute getLastPoint()', () {
    final command = _buildAbsoluteHorizontalLineToCommand();
    final startPoint = _buildStartPoint();
    final lastPoint = CoordinatePair(
      x: 15.0,
      y: 10.0,
    );
    expect(command.getLastPoint(startPoint), equals(lastPoint));
  });

  test('Relative getLastPoint()', () {
    final command = _buildRelativeHorizontalLineToCommand();
    final startPoint = _buildStartPoint();
    final lastPoint = CoordinatePair(
      x: 15.0,
      y: 10.0,
    );
    expect(command.getLastPoint(startPoint), equals(lastPoint));
  });

  test('hashCode', () {
    final object = _buildAbsoluteHorizontalLineToCommand();
    final identicalObject = _buildAbsoluteHorizontalLineToCommand();
    final differentObject = _buildRelativeHorizontalLineToCommand();

    expect(object.hashCode, equals(identicalObject.hashCode));
    expect(object.hashCode, isNot(equals(differentObject.hashCode)));
  });

  test('== operator', () {
    final object = _buildAbsoluteHorizontalLineToCommand();
    final identicalObject = _buildAbsoluteHorizontalLineToCommand();
    final differentObject = _buildRelativeHorizontalLineToCommand();

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

HorizontalLineToCommand _buildAbsoluteHorizontalLineToCommand() {
  return HorizontalLineToCommand(
    isRelative: false,
    commandArguments: CoordinateSequence(
      coordinates: [
        20.0,
        15.0,
      ],
    ),
  );
}

HorizontalLineToCommand _buildRelativeHorizontalLineToCommand() {
  return HorizontalLineToCommand(
    isRelative: true,
    commandArguments: CoordinateSequence(
      coordinates: [
        10.0,
        -5.0,
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
      Vector3((15.0), (10.0), 1.0),
    )
    ..multiply(Matrix3.identity()..setRotationZ(2.0 * pi * 45.0 / 360.0))
    ..multiply(
      Matrix3.identity()
        ..setColumn(
          2,
          Vector3(-15.0, -10.0, 1),
        ),
    );
}

Matrix3 _buildSkewXMatrix() {
  return Matrix3.identity()..setColumn(1, Vector3(1.0, 1.0, 0.0));
}

Matrix3 _buildSkewYMatrix() {
  return Matrix3.identity()..setColumn(0, Vector3(1.0, 1.0, 0.0));
}
