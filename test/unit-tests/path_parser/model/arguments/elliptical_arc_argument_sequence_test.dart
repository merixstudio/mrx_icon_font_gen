import 'package:mrx_icon_font_gen/mrx_icon_font_gen.dart';
import 'package:test/test.dart';

void main() {
  test('Constructor', () {
    final EllipticalArcArgumentSequence object = _buildObject();

    expect(
      object.ellipticalArcArguments,
      equals([
        EllipticalArcArgument(
          rx: 1.234,
          ry: 2.345,
          xAxisRotation: 3.456,
          largeArcFlag: 0,
          sweepFlag: 1,
          x: 4.567,
          y: 5.678,
        ),
        EllipticalArcArgument(
          rx: 6.789,
          ry: 7.890,
          xAxisRotation: 8.901,
          largeArcFlag: 1,
          sweepFlag: 0,
          x: 9.012,
          y: 10.123,
        ),
      ]),
    );
  });

  test('toString', () {
    final object = _buildObject();

    expect(
      object.toString(),
      equals('1.23 2.35 3.46 0 1 4.57 5.68 6.79 7.89 8.90 1 0 9.01 10.12'),
    );
  });

  test('hashCode', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = EllipticalArcArgumentSequence(
      ellipticalArcArguments: [
        EllipticalArcArgument(
          rx: 9.876,
          ry: 8.765,
          xAxisRotation: 7.654,
          largeArcFlag: 0,
          sweepFlag: 0,
          x: 6.543,
          y: 5.432,
        ),
        EllipticalArcArgument(
          rx: 4.321,
          ry: 3.210,
          xAxisRotation: 2.109,
          largeArcFlag: 1,
          sweepFlag: 1,
          x: 1.098,
          y: 0.987,
        ),
      ],
    );

    expect(object.hashCode, equals(identicalObject.hashCode));
    expect(object.hashCode, isNot(equals(differentObject.hashCode)));
  });

  test('== operator', () {
    final object = _buildObject();
    final identicalObject = _buildObject();
    final differentObject = EllipticalArcArgumentSequence(
      ellipticalArcArguments: [
        EllipticalArcArgument(
          rx: 9.876,
          ry: 8.765,
          xAxisRotation: 7.654,
          largeArcFlag: 0,
          sweepFlag: 0,
          x: 6.543,
          y: 5.432,
        ),
        EllipticalArcArgument(
          rx: 4.321,
          ry: 3.210,
          xAxisRotation: 2.109,
          largeArcFlag: 1,
          sweepFlag: 1,
          x: 1.098,
          y: 0.987,
        ),
      ],
    );

    expect(object, equals(object));
    expect(object, equals(identicalObject));
    expect(object, isNot(equals(differentObject)));
  });
}

EllipticalArcArgumentSequence _buildObject() {
  return EllipticalArcArgumentSequence(
    ellipticalArcArguments: [
      EllipticalArcArgument(
        rx: 1.234,
        ry: 2.345,
        xAxisRotation: 3.456,
        largeArcFlag: 0,
        sweepFlag: 1,
        x: 4.567,
        y: 5.678,
      ),
      EllipticalArcArgument(
        rx: 6.789,
        ry: 7.890,
        xAxisRotation: 8.901,
        largeArcFlag: 1,
        sweepFlag: 0,
        x: 9.012,
        y: 10.123,
      ),
    ],
  );
}
