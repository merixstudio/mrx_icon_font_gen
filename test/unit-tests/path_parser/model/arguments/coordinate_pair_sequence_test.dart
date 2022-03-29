import 'package:icon_font/icon_font.dart';
import 'package:test/test.dart';

void main() {
  test('Constructor', () {
    final object = _buildObject();

    expect(
      object.coordinatePairs,
      equals([
        CoordinatePair(
          x: 1.234,
          y: 2.345,
        ),
        CoordinatePair(
          x: 3.456,
          y: 4.567,
        ),
      ]),
    );
  });

  test('toString', () {
    final object = _buildObject();

    expect(object.toString(), equals('1.23 2.35 3.46 4.57'));
  });

  test('hashCode', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = CoordinatePairSequence(
      coordinatePairs: [
        CoordinatePair(
          x: 9.87,
          y: 8.76,
        ),
        CoordinatePair(
          x: 7.65,
          y: 6.54,
        ),
      ],
    );

    expect(object.hashCode, equals(identicalObject.hashCode));
    expect(object.hashCode, isNot(equals(differentObject.hashCode)));
  });

  test('== operator', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = CoordinatePairSequence(
      coordinatePairs: [
        CoordinatePair(
          x: 9.87,
          y: 8.76,
        ),
        CoordinatePair(
          x: 7.65,
          y: 6.54,
        ),
      ],
    );

    expect(object, equals(object));
    expect(object, equals(identicalObject));
    expect(object, isNot(equals(differentObject)));
  });
}

CoordinatePairSequence _buildObject() {
  return CoordinatePairSequence(
    coordinatePairs: [
      CoordinatePair(
        x: 1.234,
        y: 2.345,
      ),
      CoordinatePair(
        x: 3.456,
        y: 4.567,
      ),
    ],
  );
}
