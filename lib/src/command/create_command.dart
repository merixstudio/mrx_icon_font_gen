import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mrx_icon_font_gen/src/config_generator/config_generator.dart';
import 'package:mrx_icon_font_gen/src/config_generator/model/generator_options.dart';
import 'package:mrx_icon_font_gen/src/config_generator/model/icon_file.dart';
import 'package:mrx_icon_font_gen/src/directory_scanner/directory_scanner.dart';
import 'package:mrx_icon_font_gen/src/flutter_icon_client/flutter_icon_client.dart';

class CreateCommand extends Command {
  @override
  String get description => 'Create a TTF font from a directory of SVGs';

  @override
  String get name => 'create';

  @override
  Future<void> run() async {
    final GeneratorOptions options =
        GeneratorOptions.fromArgResults(argResults!);
    final String directory = options.from;
    final DirectoryScanner scanner = DirectoryScanner(path: directory);
    final List<File> files = await scanner.scanPath();

    final List<IconFile> iconFiles = [];
    for (final File file in files) {
      final IconFile iconFile = IconFile(
        file: file,
      )..parse();
      if (iconFile.error != null) {
        stderr.writeln(iconFile.error);
        continue;
      }
      iconFiles.add(iconFile);
    }

    final ConfigGenerator configGenerator = ConfigGenerator(
      options: options,
      files: iconFiles,
    );
    configGenerator.generate();

    final FlutterIconClient flutterIconClient = FlutterIconClient(
      options: options,
    );
    await flutterIconClient.generateFont();
  }

  @override
  ArgParser get argParser => GeneratorOptions.argParser;
}
