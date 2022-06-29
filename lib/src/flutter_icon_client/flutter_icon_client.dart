import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:http/http.dart';
import 'package:mrx_icon_font_gen/src/config_generator/model/generator_options.dart';
import 'package:path/path.dart' as p;

class FlutterIconClient {
  static String flutterIconHost = 'https://www.fluttericon.com';

  final GeneratorOptions options;

  FlutterIconClient({
    required this.options,
  });

  Future<void> generateFont() async {
    final String configFilePath = p.join(options.outConfig, 'config.json');
    final MultipartRequest uploadConfigRequest =
        MultipartRequest('POST', Uri.parse(flutterIconHost));
    final File configFile = File(configFilePath);
    uploadConfigRequest.files.add(
      MultipartFile(
        'config',
        configFile.readAsBytes().asStream(),
        configFile.lengthSync(),
        filename: configFilePath.split("/").last,
      ),
    );
    final StreamedResponse uploadConfigResponse =
        await uploadConfigRequest.send();
    if (uploadConfigResponse.statusCode >= 400) {
      stderr.writeln(uploadConfigResponse.reasonPhrase);
      return;
    }
    final String code =
        await uploadConfigResponse.stream.transform(utf8.decoder).join();
    final Request downloadFontRequest =
        Request('GET', Uri.parse('$flutterIconHost/$code/get'));
    final StreamedResponse downloadFontResponse =
        await downloadFontRequest.send();
    final Archive archive =
        ZipDecoder().decodeBytes(await downloadFontResponse.stream.toBytes());
    // The archive should contain three files:
    // - a config file (config.json)
    // - a font file (*.ttf)
    // - a Dart class with font definitions (*.dart)
    _scanArchive(archive.files);
  }

  void _scanArchive(List<ArchiveFile> archiveFiles) {
    for (final ArchiveFile file in archiveFiles) {
      final fileName = file.name;
      if (file.isFile) {
        final String? path = _getFilePath(fileName);
        if (path == null) {
          continue;
        }
        final data = file.content as List<int>;
        File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
        stdout.writeln('Saved file "$path"');
      }
    }
  }

  String? _getFilePath(String fileName) {
    final String extension = fileName.split('.').last;
    switch (extension) {
      case 'dart':
        return p.join(
          options.outFlutter,
          '${_toSnakeCase(options.className)}.dart',
        );
      case 'json':
        return p.join(options.outConfig, 'config.json');
      case 'ttf':
        return p.join(options.outFont, '${options.className}.ttf');
    }
    return null;
  }

  String _toSnakeCase(String name) {
    final RegExp exp = RegExp('(?<=[a-z])[A-Z]');
    return name
        .replaceAllMapped(exp, (Match m) => '_${m.group(0) ?? ''}')
        .toLowerCase();
  }
}
