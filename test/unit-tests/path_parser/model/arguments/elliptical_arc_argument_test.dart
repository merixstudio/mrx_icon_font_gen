import 'package:mrx_icon_font_gen/mrx_icon_font_gen.dart';
import 'package:test/test.dart';

void main() {
  test('Constructor', () {
    final EllipticalArcArgument object = _buildObject();

    expect(object.rx, closeTo(1.23, 0.001));
    expect(object.ry, closeTo(2.35, 0.001));
    expect(object.xAxisRotation, closeTo(3.46, 0.001));
    expect(object.largeArcFlag, equals(1));
    expect(object.sweepFlag, equals(1));
    expect(object.x, closeTo(4.57, 0.001));
    expect(object.y, closeTo(5.68, 0.001));
  });

  test('toString', () {
    final object = _buildObject();

    expect(object.toString(), equals('1.23 2.35 3.46 1 1 4.57 5.68'));
  });

  test('hashCode', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = EllipticalArcArgument(
      rx: 9.876,
      ry: 8.765,
      xAxisRotation: 7.654,
      largeArcFlag: 0,
      sweepFlag: 0,
      x: 6.543,
      y: 5.432,
    );

    expect(object.hashCode, equals(identicalObject.hashCode));
    expect(object.hashCode, isNot(equals(differentObject.hashCode)));
  });

  test('== operator', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = EllipticalArcArgument(
      rx: 9.876,
      ry: 8.765,
      xAxisRotation: 7.654,
      largeArcFlag: 0,
      sweepFlag: 0,
      x: 6.543,
      y: 5.432,
    );

    expect(object, equals(object));
    expect(object, equals(identicalObject));
    expect(object, isNot(equals(differentObject)));
  });
}

EllipticalArcArgument _buildObject() {
  return EllipticalArcArgument(
    rx: 1.234,
    ry: 2.345,
    xAxisRotation: 3.456,
    largeArcFlag: 1,
    sweepFlag: 1,
    x: 4.567,
    y: 5.678,
  );
}
