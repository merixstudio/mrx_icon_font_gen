import 'package:icon_font/icon_font.dart';
import 'package:test/test.dart';

void main() {
  test('Constructor', () {
    final object = _buildObject();

    expect(
      object.coordinates,
      equals([
        1.234,
        2.345,
      ]),
    );
  });

  test('toString', () {
    final object = _buildObject();

    expect(object.toString(), equals('1.23 2.35'));
  });

  test('hashCode', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = CoordinateSequence(
      coordinates: [
        9.87,
        8.76,
      ],
    );

    expect(object.hashCode, equals(identicalObject.hashCode));
    expect(object.hashCode, isNot(equals(differentObject.hashCode)));
  });

  test('== operator', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = CoordinateSequence(
      coordinates: [
        9.87,
        8.76,
      ],
    );

    expect(object, equals(object));
    expect(object, equals(identicalObject));
    expect(object, isNot(equals(differentObject)));
  });
}

CoordinateSequence _buildObject() {
  return CoordinateSequence(
    coordinates: [
      1.234,
      2.345,
    ],
  );
}
