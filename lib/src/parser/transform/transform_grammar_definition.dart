import 'package:mrx_icon_font_gen/src/parser/transform/model/transforms/matrix_transform.dart';
import 'package:mrx_icon_font_gen/src/parser/transform/model/transforms/rotate_transform.dart';
import 'package:mrx_icon_font_gen/src/parser/transform/model/transforms/scale_transform.dart';
import 'package:mrx_icon_font_gen/src/parser/transform/model/transforms/skew_x_transform.dart';
import 'package:mrx_icon_font_gen/src/parser/transform/model/transforms/skew_y_transform.dart';
import 'package:mrx_icon_font_gen/src/parser/transform/model/transforms/translate_transform.dart';
import 'package:petitparser/petitparser.dart';

/// SVG transform grammar definition.
///
/// A `petitparser` grammar constructed according to
/// ["Syntax of the SVG `transform` attribute"](https://www.w3.org/TR/css-transforms-1/#svg-syntax)
/// from W3C SVG documentation.
class TransformGrammarDefinition extends GrammarDefinition {
  @override
  Parser start() => (ref0(wsp).star() & ref0(transforms).optional() & ref0(wsp).star()).end();

  Parser transforms() => ref0(transform) & ref0(commaWsp) & ref0(transforms) | ref0(transform);

  Parser transform() =>
      ref0(matrix) | ref0(translate) | ref0(scale) | ref0(rotate) | ref0(skewX) | ref0(skewY);

  Parser translate() => (string('translate') &
              ref0(wsp).star() &
              char('(') &
              ref0(wsp).star() &
              ref0(number) &
              (ref0(commaWsp).optional() & ref0(number)).optional() &
              ref0(wsp).star() &
              char(')'))
          .map((value) {
        return TranslateTransform(
          tx: value[4] as double,
          ty: value[5] is Iterable
              ? (value[5] as Iterable).elementAt(1) as double
              : value[4] as double,
        );
      });

  Parser scale() => (string('scale') &
              ref0(wsp).star() &
              char('(') &
              ref0(wsp).star() &
              ref0(number) &
              (ref0(commaWsp).optional() & ref0(number)).optional() &
              ref0(wsp).star() &
              char(')'))
          .map((value) {
        return ScaleTransform(
          sx: value[4] as double,
          sy: value[5] is Iterable
              ? (value[5] as Iterable).elementAt(1) as double
              : value[4] as double,
        );
      });

  Parser rotate() => (string('rotate') &
              ref0(wsp).star() &
              char('(') &
              ref0(wsp).star() &
              ref0(number) &
              (ref0(commaWsp).optional() & ref0(number) & ref0(commaWsp).optional() & ref0(number))
                  .optional() &
              ref0(wsp).star() &
              char(')'))
          .map((value) {
        return RotateTransform(
          a: value[4] as double,
          cx: value[5] is Iterable ? (value[5] as Iterable).elementAt(1) as double : 0.0,
          cy: value[5] is Iterable ? (value[5] as Iterable).elementAt(3) as double : 0.0,
        );
      });

  Parser skewX() => (string('skewX') &
              ref0(wsp).star() &
              char('(') &
              ref0(wsp).star() &
              ref0(number) &
              ref0(wsp).star() &
              char(')'))
          .map((value) {
        return SkewXTransform(
          a: value[4] as double,
        );
      });

  Parser skewY() => (string('skewY') &
              ref0(wsp).star() &
              char('(') &
              ref0(wsp).star() &
              ref0(number) &
              ref0(wsp).star() &
              char(')'))
          .map((value) {
        return SkewYTransform(
          a: value[4] as double,
        );
      });

  Parser matrix() => (string('matrix') &
              ref0(wsp).star() &
              char('(') &
              ref0(wsp).star() &
              ref0(number) &
              ref0(commaWsp).optional() &
              ref0(number) &
              ref0(commaWsp).optional() &
              ref0(number) &
              ref0(commaWsp).optional() &
              ref0(number) &
              ref0(commaWsp).optional() &
              ref0(number) &
              ref0(commaWsp).optional() &
              ref0(number) &
              ref0(wsp).star() &
              char(')'))
          .map((value) {
        return MatrixTransform(
          a: value[4] as double,
          b: value[6] as double,
          c: value[8] as double,
          d: value[10] as double,
          e: value[12] as double,
          f: value[14] as double,
        );
      });

  Parser number() => (ref0(sign).optional() &
          ((char('.') & digit().plus()) |
              (digit().plus() & char('.') & digit().star()) |
              digit().plus()) &
          ((char('E') | char('e')) & ref0(sign).optional() & digit().plus()).optional())
      .flatten()
      .map(double.parse);

  Parser sign() => char('+') | char('-');

  Parser commaWsp() => ((ref0(wsp).plus() & char(',').optional() & ref0(wsp).star()) |
          (char(',') & ref0(wsp).star()))
      .map((_) => null);

  Parser wsp() => (char(String.fromCharCode(0x9)) |
          char(String.fromCharCode(0x20)) |
          char(String.fromCharCode(0xA)) |
          char(String.fromCharCode(0xC)) |
          char(String.fromCharCode(0xD)))
      .map((_) => null);
}
