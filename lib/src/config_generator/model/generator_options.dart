import 'package:args/args.dart';

class GeneratorOptions {
  static const String fromOption = 'from';
  static const String outConfigOption = 'out-config';
  static const String outFontOption = 'out-font';
  static const String outFlutterOption = 'out-flutter';
  static const String classNameOption = 'class-name';

  late final String from;
  late final String outConfig;
  late final String outFont;
  late final String outFlutter;
  late final String className;

  static final ArgParser argParser = ArgParser()
    ..addOption(
      fromOption,
      abbr: 's',
      help: 'Directory that will be recursively scanned for SVG files',
      valueHelp: 'DIR',
      defaultsTo: '.',
    )
    ..addOption(
      outConfigOption,
      abbr: 'c',
      help:
          'Output JSON configuration file for FlutterIcon',
      valueHelp: 'FILE-PATH',
      defaultsTo: 'assets/fonts/config/',
    )
    ..addOption(
      outFontOption,
      abbr: 'd',
      help: 'Output icon font path',
      valueHelp: 'FILE-PATH',
      defaultsTo: 'assets/fonts/',
    )
    ..addOption(
      outFlutterOption,
      help:
          'Output icon class file containing icon definitions',
      valueHelp: 'FILE-PATH',
      defaultsTo: 'lib/config/font/',
    )
    ..addOption(
      classNameOption,
      help: 'Name of the class containing icon definitions',
      valueHelp: 'CLASSNAME',
      defaultsTo: 'AppIcons',
    );

  GeneratorOptions({
    required this.from,
    required this.outConfig,
    required this.outFont,
    required this.outFlutter,
    required this.className,
  });

  GeneratorOptions.fromArgResults(ArgResults argResults) {
    from = argResults[fromOption];
    outConfig = argResults[outConfigOption];
    outFont = argResults[outFontOption];
    outFlutter = argResults[outFlutterOption];
    className = argResults[classNameOption];
  }
}
