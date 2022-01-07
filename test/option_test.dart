import 'package:rustic/option.dart';
import 'package:rustic/result.dart';
import 'package:rustic/tuple.dart';
import 'package:test/test.dart';

void main() {
  group('Option', () {
    group('factories', () {
      test('unnamed', () {
        expect(Option(2), equals(const Some(2)));
        expect(Option<int>(null), equals(const None<int>()));
      });

      test('some', () {
        expect(const Option.some(2), equals(const Some(2)));
      });

      test('none', () {
        expect(const Option<int>.none(), equals(const None<int>()));
      });
    });

    group('operators', () {
      test('==', () {
        expect(const Option.some(2) == const Option<int>.none(), isFalse);
        expect(const Option<int>.none() == const Option.some(2), isFalse);
      });
    });
  });

  group('Some', () {
    group('properties', () {
      test('value', () => expect(const Some(2).value, equals(2)));

      test('iterable', () {
        expect(const Some(2).iterable.toList(), equals([2]));
      });

      test('isSome', () => expect(const Some(2).isSome, isTrue));
      test('isNone', () => expect(const Some(2).isNone, isFalse));
    });

    group('operators', () {
      test('==', () {
        expect(const Some(2) == const Some(2), isTrue);
        expect(const Some(2) == const Some(3), isFalse);
      });
    });

    group('methods', () {
      test('asPlain', () => expect(const Some(2).asPlain(), equals(2)));

      test('contains', () {
        expect(const Some(2).contains(2), isTrue);
        expect(const Some(2).contains(3), isFalse);
      });

      test('whenSome', () async {
        var pair = const Tuple2<int?, bool>(null, false);

        await const Some(2).whenSome((value) => pair = Tuple2(value, false));

        expect(pair, equals(const Tuple2<int?, bool>(2, false)));
      });

      test('whenSomeSync', () {
        var pair = const Tuple2<int?, bool>(null, false);

        const Some(2).whenSomeSync((value) => pair = Tuple2(value, false));

        expect(pair, equals(const Tuple2<int?, bool>(2, false)));
      });

      test('whenNone', () async {
        var pair = const Tuple2<int?, bool>(null, false);

        await const Some(2).whenNone(() => pair = const Tuple2(null, true));

        expect(pair, equals(const Tuple2<int?, bool>(null, false)));
      });

      test('whenNoneSync', () {
        var pair = const Tuple2<int?, bool>(null, false);

        const Some(2).whenNoneSync(() => pair = const Tuple2(null, true));

        expect(pair, equals(const Tuple2<int?, bool>(null, false)));
      });

      test('match', () async {
        expect(
          await const Some(2).match((value) => 'some: $value', () => 'none'),
          equals('some: 2'),
        );
      });

      test('matchSync', () {
        expect(
          const Some(2).matchSync((value) => 'some: $value', () => 'none'),
          equals('some: 2'),
        );
      });

      test('unwrap', () async {
        expect(await const Some(2).unwrap(), equals(2));
        expect(await const Some(2).unwrap(msg: 'custom'), equals(2));
        expect(await const Some(2).unwrap(ifNone: () => 3), equals(2));
      });

      test('unwrapSync', () {
        expect(const Some(2).unwrapSync(), equals(2));
        expect(const Some(2).unwrapSync(msg: 'custom'), equals(2));
        expect(const Some(2).unwrapSync(ifNone: () => 3), equals(2));
      });

      test('unwrapNone', () {
        expect(
          () => const Some(2).unwrapNone(),
          throwsA(
            predicate<Object>((err) {
              return err is StateError &&
                  err.message == 'tried to unwrap `Some` as `None`: 2';
            }),
          ),
        );

        expect(
          () => const Some(2).unwrapNone(msg: 'custom'),
          throwsA(
            predicate<Object>((err) {
              return err is StateError && err.message == 'custom: 2';
            }),
          ),
        );
      });

      test('map', () async {
        expect(
          await const Some(2).map((value) => value.toString()),
          equals(const Some('2')),
        );

        expect(
          await const Some(2).map(
            (value) => value.toString(),
            ifNone: () => 'none',
          ),
          equals(const Some('2')),
        );
      });

      test('mapSync', () {
        expect(
          const Some(2).mapSync((value) => value.toString()),
          equals(const Some('2')),
        );

        expect(
          const Some(2).mapSync(
            (value) => value.toString(),
            ifNone: () => 'none',
          ),
          equals(const Some('2')),
        );
      });

      test('okOr', () async {
        expect(
          await const Some(2).okOr(() => 'none'),
          equals(const Ok<int, String>(2)),
        );
      });

      test('okOrSync', () {
        expect(
          const Some(2).okOrSync(() => 'none'),
          equals(const Ok<int, String>(2)),
        );
      });

      test('and', () async {
        expect(
          await const Some(2).and((value) => Some(value.toString())),
          equals(const Some('2')),
        );

        expect(
          await const Some(2).and((value) => const None<String>()),
          equals(const None<String>()),
        );
      });

      test('andSync', () {
        expect(
          const Some(2).andSync((value) => Some(value.toString())),
          equals(const Some('2')),
        );

        expect(
          const Some(2).andSync((value) => const None<String>()),
          equals(const None<String>()),
        );
      });

      test('or', () async {
        expect(
          await const Some(2).or(() => const Some(3)),
          equals(const Some(2)),
        );

        expect(
          await const Some(2).or(() => const None<int>()),
          equals(const Some(2)),
        );
      });

      test('orSync', () {
        expect(
          const Some(2).orSync(() => const Some(3)),
          equals(const Some(2)),
        );

        expect(
          const Some(2).orSync(() => const None<int>()),
          equals(const Some(2)),
        );
      });

      test('xor', () {
        expect(
          const Some(2).xor(const Some(3)),
          equals(const None<int>()),
        );

        expect(
          const Some(2).xor(const None<int>()),
          equals(const Some(2)),
        );
      });

      test('where', () async {
        expect(
          await const Some(2).where((value) => value == 2),
          equals(const Some(2)),
        );

        expect(
          await const Some(2).where((value) => value == 3),
          equals(const None<int>()),
        );
      });

      test('whereSync', () {
        expect(
          const Some(2).whereSync((value) => value == 2),
          equals(const Some(2)),
        );

        expect(
          const Some(2).whereSync((value) => value == 3),
          equals(const None<int>()),
        );
      });

      test('whereType', () {
        expect(const Some(2).whereType<int>(), equals(const Some(2)));
        expect(const Some(2).whereType<bool>(), equals(const None<bool>()));
      });

      test('zip', () async {
        expect(
          await const Some(2).zip((value) => Some('some: $value')),
          equals(const Some(Tuple2(2, 'some: 2'))),
        );

        expect(
          await const Some(2).zip((value) => const None<String>()),
          equals(const None<Tuple2<int, String>>()),
        );
      });

      test('zipSync', () {
        expect(
          const Some(2).zipSync((value) => Some('some: $value')),
          equals(const Some(Tuple2(2, 'some: 2'))),
        );

        expect(
          const Some(2).zipSync((value) => const None<String>()),
          equals(const None<Tuple2<int, String>>()),
        );
      });

      test('zipWith', () async {
        expect(
          await const Some(2).zipWith<bool, String>(
            (value) => Some(value == 2),
            (a, b) => '$a:$b',
          ),
          equals(const Some('2:true')),
        );

        expect(
          await const Some(2).zipWith<bool, String>(
            (value) => const None<bool>(),
            (a, b) => '$a:$b',
          ),
          equals(const None<String>()),
        );
      });

      test('zipWithSync', () {
        expect(
          const Some(2).zipWithSync<bool, String>(
            (value) => Some(value == 2),
            (a, b) => '$a:$b',
          ),
          equals(const Some('2:true')),
        );

        expect(
          const Some(2).zipWithSync<bool, String>(
            (value) => const None<bool>(),
            (a, b) => '$a:$b',
          ),
          equals(const None<String>()),
        );
      });

      test('toString', () {
        expect(const Some(2).toString(), equals('Some(2)'));
        expect(const Some(2).toString(true), equals('Some<int>(2)'));
      });
    });
  });

  group('None', () {
    group('properties', () {
      test('iterable', () => expect(const None<int>().iterable, isEmpty));

      test('isSome', () => expect(const None<int>().isSome, isFalse));
      test('isNone', () => expect(const None<int>().isNone, isTrue));
    });

    group('operators', () {
      test('==', () => expect(const None<int>() == const None<int>(), isTrue));
    });

    group('methods', () {
      test('asPlain', () => expect(const None<int>().asPlain(), isNull));
      test('contains', () => expect(const None<int>().contains(2), isFalse));

      test('whenSome', () async {
        var pair = const Tuple2<int?, bool>(null, false);

        await const None<int>().whenSome((value) {
          pair = Tuple2(value, false);
        });

        expect(pair, equals(const Tuple2<int?, bool>(null, false)));
      });

      test('whenSomeSync', () {
        var pair = const Tuple2<int?, bool>(null, false);

        const None<int>().whenSomeSync((value) {
          pair = Tuple2(value, false);
        });

        expect(pair, equals(const Tuple2<int?, bool>(null, false)));
      });

      test('whenNone', () async {
        var pair = const Tuple2<int?, bool>(null, false);

        await const None<int>().whenNone(() {
          pair = const Tuple2(null, true);
        });

        expect(pair, equals(const Tuple2<int?, bool>(null, true)));
      });

      test('whenNoneSync', () {
        var pair = const Tuple2<int?, bool>(null, false);

        const None<int>().whenNoneSync(() {
          pair = const Tuple2(null, true);
        });

        expect(pair, equals(const Tuple2<int?, bool>(null, true)));
      });

      test('match', () async {
        expect(
          await const None<int>().match(
            (value) => 'some: $value',
            () => 'none',
          ),
          equals('none'),
        );
      });

      test('matchSync', () {
        expect(
          const None<int>().matchSync(
            (value) => 'some: $value',
            () => 'none',
          ),
          equals('none'),
        );
      });

      test('unwrap', () async {
        expect(
          () async => const None<int>().unwrap(),
          throwsA(
            predicate<Object>((err) {
              return err is StateError &&
                  err.message == 'tried to unwrap `None` as `Some`';
            }),
          ),
        );

        expect(
          () async => const None<int>().unwrap(msg: 'custom'),
          throwsA(
            predicate<Object>((err) {
              return err is StateError && err.message == 'custom';
            }),
          ),
        );

        expect(await const None<int>().unwrap(ifNone: () => 3), equals(3));
      });

      test('unwrapSync', () {
        expect(
          () => const None<int>().unwrapSync(),
          throwsA(
            predicate<Object>((err) {
              return err is StateError &&
                  err.message == 'tried to unwrap `None` as `Some`';
            }),
          ),
        );

        expect(
          () => const None<int>().unwrapSync(msg: 'custom'),
          throwsA(
            predicate<Object>((err) {
              return err is StateError && err.message == 'custom';
            }),
          ),
        );

        expect(const None<int>().unwrapSync(ifNone: () => 3), equals(3));
      });

      test('unwrapNone', () {
        expect(
          () => const None<int>().unwrapNone(),
          isNot(throwsStateError),
        );

        expect(
          () => const None<int>().unwrapNone(msg: 'custom'),
          isNot(throwsStateError),
        );
      });

      test('map', () async {
        expect(
          await const None<int>().map((value) => value.toString()),
          equals(const None<String>()),
        );

        expect(
          await const None<int>().map(
            (value) => value.toString(),
            ifNone: () => 'none',
          ),
          equals(const Some('none')),
        );
      });

      test('mapSync', () {
        expect(
          const None<int>().mapSync((value) => value.toString()),
          equals(const None<String>()),
        );

        expect(
          const None<int>().mapSync(
            (value) => value.toString(),
            ifNone: () => 'none',
          ),
          equals(const Some('none')),
        );
      });

      test('okOr', () async {
        expect(
          await const None<int>().okOr(() => 'none'),
          equals(const Err<int, String>('none')),
        );
      });

      test('okOrSync', () {
        expect(
          const None<int>().okOrSync(() => 'none'),
          equals(const Err<int, String>('none')),
        );
      });

      test('and', () async {
        expect(
          await const None<int>().and((value) => Some(value.toString())),
          equals(const None<String>()),
        );

        expect(
          await const None<int>().and((value) => const None<String>()),
          equals(const None<String>()),
        );
      });

      test('andSync', () {
        expect(
          const None<int>().andSync((value) => Some(value.toString())),
          equals(const None<String>()),
        );

        expect(
          const None<int>().andSync((value) => const None<String>()),
          equals(const None<String>()),
        );
      });

      test('or', () async {
        expect(
          await const None<int>().or(() => const Some(3)),
          equals(const Some(3)),
        );

        expect(
          await const None<int>().or(() => const None<int>()),
          equals(const None<int>()),
        );
      });

      test('orSync', () {
        expect(
          const None<int>().orSync(() => const Some(3)),
          equals(const Some(3)),
        );

        expect(
          const None<int>().orSync(() => const None<int>()),
          equals(const None<int>()),
        );
      });

      test('xor', () {
        expect(
          const None<int>().xor(const Some(3)),
          equals(const Some(3)),
        );

        expect(
          const None<int>().xor(const None<int>()),
          equals(const None<int>()),
        );
      });

      test('where', () async {
        expect(
          await const None<int>().where((value) => value == 2),
          equals(const None<int>()),
        );

        expect(
          await const None<int>().where((value) => value == 3),
          equals(const None<int>()),
        );
      });

      test('whereSync', () {
        expect(
          const None<int>().whereSync((value) => value == 2),
          equals(const None<int>()),
        );

        expect(
          const None<int>().whereSync((value) => value == 3),
          equals(const None<int>()),
        );
      });

      test('whereType', () {
        expect(const None<int>().whereType<int>(), equals(const None<int>()));
        expect(const None<int>().whereType<bool>(), equals(const None<bool>()));
      });

      test('zip', () async {
        expect(
          await const None<int>().zip((value) => Some('some: $value')),
          equals(const None<Tuple2<int, String>>()),
        );

        expect(
          await const None<int>().zip((value) => const None<String>()),
          equals(const None<Tuple2<int, String>>()),
        );
      });

      test('zipSync', () {
        expect(
          const None<int>().zipSync((value) => Some('some: $value')),
          equals(const None<Tuple2<int, String>>()),
        );

        expect(
          const None<int>().zipSync((value) => const None<String>()),
          equals(const None<Tuple2<int, String>>()),
        );
      });

      test('zipWith', () async {
        expect(
          await const None<int>().zipWith<bool, String>(
            (value) => Some(value == 2),
            (a, b) => '$a:$b',
          ),
          equals(const None<String>()),
        );

        expect(
          await const None<int>().zipWith<bool, String>(
            (value) => const None<bool>(),
            (a, b) => '$a:$b',
          ),
          equals(const None<String>()),
        );
      });

      test('zipWithSync', () {
        expect(
          const None<int>().zipWithSync<bool, String>(
            (value) => Some(value == 2),
            (a, b) => '$a:$b',
          ),
          equals(const None<String>()),
        );

        expect(
          const None<int>().zipWithSync<bool, String>(
            (value) => const None<bool>(),
            (a, b) => '$a:$b',
          ),
          equals(const None<String>()),
        );
      });

      test('toString', () {
        expect(const None<int>().toString(), equals('None'));
        expect(const None<int>().toString(true), equals('None<int>'));
      });
    });
  });

  group('Optionable', () {
    group('methods', () {
      test('asOption', () {
        expect(2.asOption(), equals(const Some(2)));
        expect(Optionable<int>(null).asOption(), equals(const None<int>()));
      });
    });
  });

  group('OptionalResult', () {
    group('methods', () {
      test('transpose', () {
        expect(
          const Some<Ok<int, String>>(Ok<int, String>(2)).transpose(),
          equals(const Ok<Option<int>, String>(Some(2))),
        );

        expect(
          const Some<Err<int, String>>(Err('error')).transpose(),
          equals(const Err<Option<int>, String>('error')),
        );

        expect(
          const None<Ok<int, String>>().transpose(),
          equals(const Ok<Option<int>, String>(None())),
        );
      });
    });
  });

  group('OptionalOption', () {
    group('methods', () {
      test('flatten', () {
        expect(
          const Some(Some(2)).flatten(),
          equals(const Some(2)),
        );

        expect(
          const Some<None<int>>(None()).flatten(),
          equals(const None<int>()),
        );

        expect(const None<Some<int>>().flatten(), equals(const None<int>()));
        expect(const None<None<int>>().flatten(), equals(const None<int>()));
      });
    });
  });
}
