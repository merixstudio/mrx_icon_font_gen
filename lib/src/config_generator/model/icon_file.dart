import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_pair.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/arguments/coordinate_pair_sequence.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/command.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/commands/close_path_command.dart';
import 'package:mrx_icon_font_gen/src/parser/path/model/commands/move_to_command.dart';
import 'package:mrx_icon_font_gen/src/parser/path/path_grammar_definition.dart';
import 'package:mrx_icon_font_gen/src/parser/transform/model/transform.dart';
import 'package:mrx_icon_font_gen/src/parser/transform/transform_grammar_definition.dart';
import 'package:mrx_icon_font_gen/src/util/list_util.dart';
import 'package:petitparser/core.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:xml/xml.dart';

class IconFile {
  static Parser? _pathParser;
  static Parser? _transformParser;

  List<Command>? _svgPath;
  final File file;
  String? _error;
  double? _height;
  double? _width;
  String? _uid;

  IconFile({
    required this.file,
  });

  String? get error => _error;

  double get height {
    if (_height == null) {
      throw StateError(
        'Use parse() method before using this method and make sure the error field is NULL',
      );
    }
    return _height!;
  }

  List<Command> get svgPath {
    if (_svgPath == null) {
      throw StateError(
        'Use parse() method before using this method and make sure the error field is NULL',
      );
    }
    return _svgPath!;
  }

  double get width {
    if (_width == null) {
      throw StateError(
        'Use parse() method before using this method and make sure the error field is NULL',
      );
    }
    return _width!;
  }

  String get uid {
    if (_uid == null) {
      throw StateError(
        'Use parse() method before using this method and make sure the error field is NULL',
      );
    }
    return _uid!;
  }

  void parse() {
    if (_pathParser == null) {
      _initParser();
    }
    final String fileContent = file.readAsStringSync();
    _uid = md5.convert(utf8.encode(fileContent)).toString();
    final XmlDocument document = XmlDocument.parse(fileContent);
    final XmlElement? path = _extractPath(document);
    if (path == null) {
      _error = 'No <path> element found in file';
      return;
    }
    Matrix3 elementTransformation = _getElementTransformMatrix(path);
    final List<double> viewBoxArgs = _getViewBox(document);
    final Matrix3 sizeNormalization = _getSizeNormalizationMatrix(viewBoxArgs);
    _width = viewBoxArgs[2] * sizeNormalization.getColumn(0).x;
    _height = viewBoxArgs[3] * sizeNormalization.getColumn(1).y;
    elementTransformation = sizeNormalization.multiplied(elementTransformation);

    final result = _pathParser!.parse(
      path.attributes.firstWhere((a) => a.name.toString() == 'd').value.trim(),
    );
    if (result.isFailure) {
      _error =
          '${result.message}\n At: ${result.buffer.substring(result.position)}';
      return;
    }
    CoordinatePair startPoint = CoordinatePair(x: 0, y: 0);
    CoordinatePair previousPoint = CoordinatePair(x: 0, y: 0);
    final List<Command> transformedCommands = [];
    for (final Command command in result.value as List<Command>) {
      final newTransformedCommands =
          command.applyTransformation(elementTransformation, previousPoint);
      transformedCommands.addAll(newTransformedCommands);

      if (command is MoveToCommand) {
        final CoordinatePair coordinates =
            (command.commandArguments! as CoordinatePairSequence)
                .coordinatePairs
                .first;
        if (command.isAbsolute) {
          startPoint = coordinates;
        } else {
          startPoint = CoordinatePair(
            x: previousPoint.x + coordinates.x,
            y: previousPoint.y + coordinates.y,
          );
        }
      }

      if (command is ClosePathCommand) {
        previousPoint = startPoint;
      } else {
        previousPoint = command.getLastPoint(previousPoint);
      }
    }
    _svgPath = transformedCommands;
  }

  XmlElement? _extractPath(XmlDocument document) {
    final Iterable<XmlElement> paths = document.findAllElements('path');
    if (paths.isEmpty) {
      return null;
    }
    return paths.first;
  }

  Matrix3 _getElementTransformMatrix(XmlElement element) {
    Matrix3 elementTransformation = Matrix3.identity();
    XmlElement currentElement = element;
    while (true) {
      final String? transform = currentElement.getAttribute('transform');
      if (transform != null) {
        final Matrix3 currentTransformation = Matrix3.identity();
        final List<Transform> transforms =
            (_transformParser!.parse(transform).value as List<dynamic>)
                .flatten()
                .whereType<Transform>()
                .toList();
        for (final trans in transforms) {
          currentTransformation.multiply(trans.transformMatrix);
        }
        elementTransformation = currentTransformation
          ..multiply(elementTransformation);
      }
      if (currentElement.parent == null ||
          currentElement.parent is! XmlElement) {
        break;
      }
      currentElement = currentElement.parent! as XmlElement;
    }

    return elementTransformation;
  }

  Matrix3 _getSizeNormalizationMatrix(List<double> viewBoxArgs) {
    return Matrix3(
      1000.0 / viewBoxArgs[3],
      0.0,
      0.0,
      0.0,
      1000.0 / viewBoxArgs[3],
      0.0,
      -viewBoxArgs[0],
      -viewBoxArgs[1],
      1.0,
    );
  }

  List<double> _getViewBox(XmlDocument document) {
    final List<double> viewBoxArgs = [];
    final XmlNode root = document.rootElement;
    if (root is XmlElement && root.getAttribute('viewBox') != null) {
      final String viewBox = root.getAttribute('viewBox') ?? '';
      viewBoxArgs.addAll(
        viewBox
            .split(RegExp(r'\s+'))
            .map<double>((e) => double.parse(e))
            .toList(),
      );
    }
    final List<double> viewBoxDefaults = [0.0, 0.0, 1000.0, 1000.0];
    viewBoxArgs.addAll(viewBoxDefaults.sublist(viewBoxArgs.length));
    return viewBoxArgs;
  }

  void _initParser() {
    _pathParser = PathGrammarDefinition().build();
    _transformParser = TransformGrammarDefinition().build();
  }
}
