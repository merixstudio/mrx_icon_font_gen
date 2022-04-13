import 'dart:convert';
import 'dart:io';

import 'package:icon_font/src/config_generator/model/generator_options.dart';
import 'package:icon_font/src/config_generator/model/icon_file.dart';
import 'package:path/path.dart' as p;

class ConfigGenerator {
  final GeneratorOptions options;
  final List<IconFile> files;

  ConfigGenerator({
    required this.options,
    required this.files,
  });

  void generate() {
    final File configFile = File(p.join(options.outConfig, 'config.json'));
    if (!configFile.existsSync()) {
      configFile.createSync(
        recursive: true,
      );
    }
    configFile.writeAsStringSync(
      _buildJson(),
      flush: true,
    );
  }

  String _buildJson() {
    int code = 0xE800;
    final Map<String, dynamic> glyphs = {};
    final int prefixLength = p.canonicalize(options.from).length + 1;
    for (IconFile file in files) {
      String name = _convertToDartName(
        file.file.absolute.path.substring(prefixLength),
      );
      if (glyphs.containsKey(name)) {
        int i = 2;
        while (glyphs.containsKey('$name$i')) {
          i++;
        }
        name += i.toString();
      }
      final Map<String, dynamic> glyph = <String, dynamic>{
        'uid': file.uid,
        'css': name,
        'code': code++,
        'src': 'custom_icons',
        'selected': true,
        'svg': {
          'path': file.svgPath.join(),
          'width': file.width.round(),
        },
        'search': [
          name,
        ],
      };
      glyphs[name] = glyph;
    }
    Map<String, dynamic> config = {
      'name': options.className,
      'css_prefix_text': '',
      'css_use_suffix': false,
      'hinting': true,
      'units_per_em': 1000,
      'ascent': 850,
      'glyphs': glyphs.values.toList(),
    };

    return jsonEncode(config);
  }

  String _convertToDartName(String fileName) {
    List<String> reservedKeywords = [
      'assert',
      'break',
      'case',
      'catch',
      'class',
      'const',
      'continue',
      'default',
      'do',
      'else',
      'enum',
      'extends',
      'false',
      'final',
      'finally',
      'for',
      'if',
      'in',
      'is',
      'new',
      'null',
      'rethrow',
      'return',
      'super',
      'switch',
      'this',
      'throw',
      'true',
      'try',
      'var',
      'void',
      'while',
      'with',
    ];

    String dartName = p
        .split(p.withoutExtension(fileName))
        .where((s) => s != '.')
        .join('_')
        .replaceAll(RegExp(r'[^\w]+'), '_')
        .replaceAll(RegExp('[_]+'), '_');
    // Add a letter 'i' in front if the name if it is a reserved keyword, or it
    // starts with a digit or an underscore.
    if (dartName.startsWith(RegExp(r'\d')) ||
        reservedKeywords.contains(dartName)) {
      dartName = 'i$dartName';
    }
    if (dartName.startsWith('_') || reservedKeywords.contains(dartName)) {
      dartName = 'i$dartName';
    }
    // Use "icon" as a name if all original characters are invalid and the final
    // converted name is an empty string.
    if (dartName.isEmpty) {
      dartName = 'icon';
    }
    return dartName;
  }
}
