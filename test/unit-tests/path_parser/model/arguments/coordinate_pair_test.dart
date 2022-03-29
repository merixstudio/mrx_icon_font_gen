import 'package:icon_font/icon_font.dart';
import 'package:test/test.dart';

void main() {
  test('Constructor', () {
    final object = _buildObject();

    expect(object.x, closeTo(1.23, 0.001));
    expect(object.y, closeTo(2.35, 0.001));
  });

  test('toString', () {
    final object = _buildObject();

    expect(object.toString(), equals('1.23 2.35'));
  });

  test('hashCode', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = CoordinatePair(
      x: 9.87,
      y: 8.76,
    );

    expect(object.hashCode, equals(identicalObject.hashCode));
    expect(object.hashCode, isNot(equals(differentObject.hashCode)));
  });

  test('== operator', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = CoordinatePair(
      x: 9.87,
      y: 8.76,
    );

    expect(object, equals(object));
    expect(object, equals(identicalObject));
    expect(object, isNot(equals(differentObject)));
  });
}

CoordinatePair _buildObject() {
  return CoordinatePair(
    x: 1.234,
    y: 2.345,
  );
}
