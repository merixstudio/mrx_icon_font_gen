import 'package:mrx_icon_font_gen/mrx_icon_font_gen.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Constructor', () {
    test('Construct without "command" and "isRelative" arguments', () {
      expect(() => ClosePathCommand(), throwsA(isA<ArgumentError>()));
    });

    test('Construct with {command: "Z"}', () {
      const commandName = 'Z';
      final command = ClosePathCommand(
        command: commandName,
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "z"}', () {
      const commandName = 'z';
      final command = ClosePathCommand(
        command: commandName,
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "foo"}', () {
      expect(
        () => ClosePathCommand(
          command: 'foo',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Construct with {isRelative: false}', () {
      const commandName = 'Z';
      const isRelative = false;
      final command = ClosePathCommand(
        isRelative: isRelative,
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {isRelative: true}', () {
      const commandName = 'z';
      const isRelative = true;
      final command = ClosePathCommand(
        isRelative: isRelative,
      );
      expect(command.command, equals(commandName));
    });
  });

  test('Absolute toString()', () {
    const commandName = 'Z';
    final command = ClosePathCommand(
      command: commandName,
    );
    expect(command.toString(), equals(commandName));
  });

  test('Relative toString()', () {
    const commandName = 'z';
    final command = ClosePathCommand(
      command: commandName,
    );
    expect(command.toString(), equals(commandName));
  });

  test('Absolute applyTransformation()', () {
    const commandName = 'Z';
    final command = ClosePathCommand(
      command: commandName,
    );
    final transform = Matrix3.identity();
    final startPoint = CoordinatePair(
      x: 10.0,
      y: 10.0,
    );
    expect(
      command.applyTransformation(transform, startPoint),
      equals([command]),
    );
  });

  test('Relative applyTransformation()', () {
    const commandName = 'z';
    final command = ClosePathCommand(
      command: commandName,
    );
    final transform = Matrix3.identity();
    final startPoint = CoordinatePair(
      x: 10.0,
      y: 10.0,
    );
    expect(
      command.applyTransformation(transform, startPoint),
      equals([command]),
    );
  });

  test('Absolute getLastPoint()', () {
    final command = ClosePathCommand(
      isRelative: false,
    );
    final startPoint = CoordinatePair(
      x: 10.0,
      y: 10.0,
    );
    expect(command.getLastPoint(startPoint), equals(startPoint));
  });

  test('Relative getLastPoint()', () {
    final command = ClosePathCommand(
      isRelative: true,
    );
    final startPoint = CoordinatePair(
      x: 10.0,
      y: 10.0,
    );
    expect(command.getLastPoint(startPoint), equals(startPoint));
  });

  test('hashCode', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = _buildDifferentObject();

    expect(object.hashCode, equals(identicalObject.hashCode));
    expect(object.hashCode, isNot(equals(differentObject.hashCode)));
  });

  test('== operator', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = _buildDifferentObject();

    expect(object, equals(object));
    expect(object, equals(identicalObject));
    expect(object, isNot(equals(differentObject)));
  });
}

ClosePathCommand _buildObject() {
  return ClosePathCommand(
    isRelative: true,
  );
}

ClosePathCommand _buildDifferentObject() {
  return ClosePathCommand(
    isRelative: false,
  );
}
