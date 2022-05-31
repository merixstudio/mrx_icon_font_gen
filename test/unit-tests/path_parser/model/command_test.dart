import 'package:mrx_icon_font_gen/mrx_icon_font_gen.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Constructor', () {
    test('Construct without arguments', () {
      expect(() => _MockCommand(), throwsA(isA<ArgumentError>()));
    });

    test('Construct with {command: "MOCK"}', () {
      const commandName = 'MOCK';
      final command = _MockCommand(
        command: commandName,
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "mock"}', () {
      const commandName = 'mock';
      final command = _MockCommand(
        command: commandName,
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {isRelative: false}', () {
      const commandName = 'MOCK';
      const isRelative = false;
      final command = _MockCommand(
        isRelative: isRelative,
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {isRelative: true}', () {
      const commandName = 'mock';
      const isRelative = true;
      final command = _MockCommand(
        isRelative: isRelative,
      );
      expect(command.command, equals(commandName));
    });
  });

  group('isRelative getter', () {
    test('isRelative: true', () {
      const isRelative = true;
      final command = _MockCommand(
        isRelative: isRelative,
      );
      expect(command.isRelative, equals(isRelative));
    });

    test('isRelative: false', () {
      const isRelative = false;
      final command = _MockCommand(
        isRelative: isRelative,
      );
      expect(command.isRelative, equals(isRelative));
    });
  });

  group('isAbsolute getter', () {
    test('isRelative: true', () {
      const isRelative = true;
      final command = _MockCommand(
        isRelative: isRelative,
      );
      expect(command.isAbsolute, equals(!isRelative));
    });

    test('isRelative: false', () {
      const isRelative = false;
      final command = _MockCommand(
        isRelative: isRelative,
      );
      expect(command.isAbsolute, equals(!isRelative));
    });
  });
}

class _MockCommand extends Command {
  _MockCommand({
    String? command,
    bool? isRelative,
    CommandArguments? commandArguments,
  }) : super(
          name: command,
          isRelative: isRelative,
          commandArguments: commandArguments,
        );

  @override
  String get absoluteCommandName => 'MOCK';

  @override
  String get relativeCommandName => 'mock';

  @override
  List<Command> applyTransformation(
    Matrix3 transform,
    CoordinatePair startPoint,
  ) {
    throw UnimplementedError();
  }

  @override
  CoordinatePair getLastPoint(
    CoordinatePair previousPoint, {
    CoordinatePair? startPoint,
  }) {
    throw UnimplementedError();
  }
}
