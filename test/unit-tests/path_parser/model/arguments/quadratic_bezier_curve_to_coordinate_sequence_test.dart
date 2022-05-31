import 'package:mrx_icon_font_gen/mrx_icon_font_gen.dart';
import 'package:test/test.dart';

void main() {
  test('Constructor', () {
    final QuadraticBezierCurveToCoordinateSequence object = _buildObject();

    expect(
      object.coordinatePairDoubles,
      equals([
        CoordinatePairDouble(
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
        ),
        CoordinatePairDouble(
          coordinatePairs: [
            CoordinatePair(
              x: 5.678,
              y: 6.789,
            ),
            CoordinatePair(
              x: 7.890,
              y: 8.901,
            ),
          ],
        ),
      ]),
    );
  });

  test('toString', () {
    final object = _buildObject();

    expect(
      object.toString(),
      equals('1.23 2.35 3.46 4.57 5.68 6.79 7.89 8.90'),
    );
  });

  test('hashCode', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = QuadraticBezierCurveToCoordinateSequence(
      coordinatePairDoubles: [
        CoordinatePairDouble(
          coordinatePairs: [
            CoordinatePair(
              x: 9.876,
              y: 8.765,
            ),
            CoordinatePair(
              x: 7.654,
              y: 6.543,
            ),
          ],
        ),
        CoordinatePairDouble(
          coordinatePairs: [
            CoordinatePair(
              x: 5.432,
              y: 4.321,
            ),
            CoordinatePair(
              x: 3.210,
              y: 2.109,
            ),
          ],
        ),
      ],
    );

    expect(object.hashCode, equals(identicalObject.hashCode));
    expect(object.hashCode, isNot(equals(differentObject.hashCode)));
  });

  test('== operator', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = QuadraticBezierCurveToCoordinateSequence(
      coordinatePairDoubles: [
        CoordinatePairDouble(
          coordinatePairs: [
            CoordinatePair(
              x: 9.876,
              y: 8.765,
            ),
            CoordinatePair(
              x: 7.654,
              y: 6.543,
            ),
          ],
        ),
        CoordinatePairDouble(
          coordinatePairs: [
            CoordinatePair(
              x: 5.432,
              y: 4.321,
            ),
            CoordinatePair(
              x: 3.210,
              y: 2.109,
            ),
          ],
        ),
      ],
    );

    expect(object, equals(object));
    expect(object, equals(identicalObject));
    expect(object, isNot(equals(differentObject)));
  });
}

QuadraticBezierCurveToCoordinateSequence _buildObject() {
  return QuadraticBezierCurveToCoordinateSequence(
    coordinatePairDoubles: [
      CoordinatePairDouble(
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
      ),
      CoordinatePairDouble(
        coordinatePairs: [
          CoordinatePair(
            x: 5.678,
            y: 6.789,
          ),
          CoordinatePair(
            x: 7.890,
            y: 8.901,
          ),
        ],
      ),
    ],
  );
}
