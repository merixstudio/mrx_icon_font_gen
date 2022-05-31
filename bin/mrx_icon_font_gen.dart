import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mrx_icon_font_gen/src/command/create_command.dart';

Future<void> main(List<String> args) async {
  final runner = CommandRunner('mrx_icon_font_gen', 'Generate a TTF font from a directory of SVGs')
    ..addCommand(CreateCommand());
  try {
    await runner.run(['create', ...args]);
  } on UsageException catch (error) {
    stderr.writeln(error);
    exit(1);
  }
}
