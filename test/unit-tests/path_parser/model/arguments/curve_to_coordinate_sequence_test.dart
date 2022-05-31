import 'package:mrx_icon_font_gen/mrx_icon_font_gen.dart';
import 'package:test/test.dart';

void main() {
  test('Constructor', () {
    final CurveToCoordinateSequence object = _buildObject();

    expect(
      object.coordinatePairTriplets,
      equals([
        CoordinatePairTriplet(
          coordinatePairs: [
            CoordinatePair(
              x: 1.234,
              y: 2.345,
            ),
            CoordinatePair(
              x: 3.456,
              y: 4.567,
            ),
            CoordinatePair(
              x: 5.678,
              y: 6.789,
            ),
          ],
        ),
        CoordinatePairTriplet(
          coordinatePairs: [
            CoordinatePair(
              x: 7.890,
              y: 8.901,
            ),
            CoordinatePair(
              x: 9.012,
              y: 10.123,
            ),
            CoordinatePair(
              x: 11.234,
              y: 12.345,
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
      equals('1.23 2.35 3.46 4.57 5.68 6.79 7.89 8.90 9.01 10.12 11.23 12.35'),
    );
  });

  test('hashCode', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = CurveToCoordinateSequence(
      coordinatePairTriplets: [
        CoordinatePairTriplet(
          coordinatePairs: [
            CoordinatePair(
              x: 9.876,
              y: 8.765,
            ),
            CoordinatePair(
              x: 7.654,
              y: 6.543,
            ),
            CoordinatePair(
              x: 5.432,
              y: 4.321,
            ),
          ],
        ),
        CoordinatePairTriplet(
          coordinatePairs: [
            CoordinatePair(
              x: 3.210,
              y: 2.109,
            ),
            CoordinatePair(
              x: 1.098,
              y: 0.987,
            ),
            CoordinatePair(
              x: -1.876,
              y: -2.765,
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
    final differentObject = CurveToCoordinateSequence(
      coordinatePairTriplets: [
        CoordinatePairTriplet(
          coordinatePairs: [
            CoordinatePair(
              x: 9.876,
              y: 8.765,
            ),
            CoordinatePair(
              x: 7.654,
              y: 6.543,
            ),
            CoordinatePair(
              x: 5.432,
              y: 4.321,
            ),
          ],
        ),
        CoordinatePairTriplet(
          coordinatePairs: [
            CoordinatePair(
              x: 3.210,
              y: 2.109,
            ),
            CoordinatePair(
              x: 1.098,
              y: 0.987,
            ),
            CoordinatePair(
              x: -1.876,
              y: -2.765,
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

CurveToCoordinateSequence _buildObject() {
  return CurveToCoordinateSequence(
    coordinatePairTriplets: [
      CoordinatePairTriplet(
        coordinatePairs: [
          CoordinatePair(
            x: 1.234,
            y: 2.345,
          ),
          CoordinatePair(
            x: 3.456,
            y: 4.567,
          ),
          CoordinatePair(
            x: 5.678,
            y: 6.789,
          ),
        ],
      ),
      CoordinatePairTriplet(
        coordinatePairs: [
          CoordinatePair(
            x: 7.890,
            y: 8.901,
          ),
          CoordinatePair(
            x: 9.012,
            y: 10.123,
          ),
          CoordinatePair(
            x: 11.234,
            y: 12.345,
          ),
        ],
      ),
    ],
  );
}
