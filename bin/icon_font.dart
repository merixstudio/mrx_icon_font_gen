import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:icon_font/src/command/create_command.dart';

void main(List<String> args) async {
  final runner = CommandRunner('icon_font', 'Generate a TTF font from a directory of SVGs')
    ..addCommand(CreateCommand());
  try {
    await runner.run(['create', ...args]);
  } on UsageException catch (error) {
    print(error);
    exit(1);
  }
}
