import 'package:rustic/tuple.dart';
import 'package:test/test.dart';

void main() {
  group('Tuple', () {
    group('statics', () {
      test('of2', () {
        expect(Tuple.of2(2, 'two'), equals(const Tuple2(2, 'two')));
      });

      test('of3', () {
        expect(Tuple.of3(2, 'two', true), equals(const Tuple3(2, 'two', true)));
      });
    });

    group('operators', () {
      test('==', () {
        expect(Tuple.of2(2, 'two') == Tuple.of3(2, 'two', true), isFalse);
        expect(Tuple.of3(2, 'two', true) == Tuple.of2(2, 'two'), isFalse);
      });
    });
  });

  group('Tuple2', () {
    group('properties', () {
      test('i0', () => expect(const Tuple2(2, 'two').i0, equals(2)));
      test('i1', () => expect(const Tuple2(2, 'two').i1, equals('two')));

      test('is2', () => expect(const Tuple2(2, 'two').is2, isTrue));
      test('is3', () => expect(const Tuple2(2, 'two').is3, isFalse));
    });

    group('operators', () {
      test('==', () {
        expect(const Tuple2(2, 'two') == const Tuple2(2, 'two'), isTrue);
        expect(const Tuple2(2, 'two') == const Tuple2(3, 'two'), isFalse);
        expect(const Tuple2(2, 'two') == const Tuple2(2, 'three'), isFalse);
      });
    });

    group('methods', () {
      test('toString', () => expect(const Tuple2(2, 'two').toString(), equals('(2, two)')));
    });
  });

  group('Tuple3', () {
    group('properties', () {
      test('i0', () => expect(const Tuple3(2, 'two', true).i0, equals(2)));
      test('i1', () => expect(const Tuple3(2, 'two', true).i1, equals('two')));
      test('i2', () => expect(const Tuple3(2, 'two', true).i2, equals(true)));

      test('is2', () => expect(const Tuple3(2, 'two', true).is2, isFalse));
      test('is3', () => expect(const Tuple3(2, 'two', true).is3, isTrue));
      test('is4', () => expect(const Tuple3(2, 'two', true).is4, isFalse));
    });

    group('operators', () {
      test('==', () {
        expect(const Tuple3(2, 'two', true) == const Tuple3(2, 'two', true), isTrue);
        expect(const Tuple3(2, 'two', true) == const Tuple3(3, 'two', true), isFalse);
        expect(const Tuple3(2, 'two', true) == const Tuple3(2, 'three', true), isFalse);
        expect(const Tuple3(2, 'two', true) == const Tuple3(2, 'two', false), isFalse);
      });
    });

    group('methods', () {
      test('toString', () {
        expect(const Tuple3(2, 'two', true).toString(), equals('(2, two, true)'));
      });
    });
  });
}
