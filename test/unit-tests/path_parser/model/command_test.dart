import 'package:icon_font/icon_font.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Constructor', () {
    test('Construct without arguments', () {
      expect(() => _MockCommand(), throwsA(isA<ArgumentError>()));
    });

    test('Construct with {command: "MOCK"}', () {
      final commandName = 'MOCK';
      final command = _MockCommand(
        command: commandName,
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {command: "mock"}', () {
      final commandName = 'mock';
      final command = _MockCommand(
        command: commandName,
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {isRelative: false}', () {
      final commandName = 'MOCK';
      final isRelative = false;
      final command = _MockCommand(
        isRelative: isRelative,
      );
      expect(command.command, equals(commandName));
    });

    test('Construct with {isRelative: true}', () {
      final commandName = 'mock';
      final isRelative = true;
      final command = _MockCommand(
        isRelative: isRelative,
      );
      expect(command.command, equals(commandName));
    });
  });

  group('isRelative getter', () {
    test('isRelative: true', () {
      final isRelative = true;
      final command = _MockCommand(
        isRelative: isRelative,
      );
      expect(command.isRelative, equals(isRelative));
    });

    test('isRelative: false', () {
      final isRelative = false;
      final command = _MockCommand(
        isRelative: isRelative,
      );
      expect(command.isRelative, equals(isRelative));
    });
  });

  group('isAbsolute getter', () {
    test('isRelative: true', () {
      final isRelative = true;
      final command = _MockCommand(
        isRelative: isRelative,
      );
      expect(command.isAbsolute, equals(!isRelative));
    });

    test('isRelative: false', () {
      final isRelative = false;
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
