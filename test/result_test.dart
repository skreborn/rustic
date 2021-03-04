import 'package:rustic/option.dart';
import 'package:rustic/result.dart';
import 'package:rustic/tuple.dart';
import 'package:test/test.dart';

class _EmptyException implements Exception {
  const _EmptyException();
}

void main() {
  group('Result', () {
    group('factories', () {
      test('ok', () {
        expect(const Result<int, String>.ok(2), equals(const Ok<int, String>(2)));
      });

      test('err', () {
        expect(const Result<int, String>.err('2'), equals(const Err<int, String>('2')));
      });

      test('collect', () {
        final err = Result<int, int>.collect((check) {
          final first = check(const Ok<int, String>(2).mapErr(int.parse));
          final second = check(const Err<int, String>('3').mapErr(int.parse));

          return Ok(first + second);
        });

        expect(err, equals(const Err<int, int>(3)));

        final ok = Result<int, int>.collect((check) {
          final first = check(const Ok<int, String>(2).mapErr(int.parse));
          final second = check(const Ok<int, String>(3).mapErr(int.parse));

          return Ok(first + second);
        });

        expect(ok, equals(const Ok<int, int>(5)));
      });

      test('catchExceptions', () {
        Option<Err<int, String>> mapEx(Exception ex) {
          if (ex is FormatException) {
            return Some(Err('fail: ${ex.source}'));
          }

          return const None();
        }

        final err = Result<int, String>.catchException(() {
          return int.parse('II');
        }, mapEx);

        expect(err, equals(const Err<int, String>('fail: II')));

        final ok = Result<int, String>.catchException(() {
          return int.parse('2');
        }, mapEx);

        expect(ok, equals(const Ok<int, String>(2)));

        expect(
          () => Result<int, String>.catchException(() => throw const _EmptyException(), mapEx),
          throwsA(predicate<Object>((ex) => ex is _EmptyException)),
        );
      });
    });

    group('operators', () {
      test('==', () {
        expect(const Result<int, String>.ok(2) == const Result<int, String>.err('2'), isFalse);
        expect(const Result<int, String>.err('2') == const Result<int, String>.ok(2), isFalse);
      });
    });
  });

  group('Ok', () {
    group('properties', () {
      test('value', () => expect(const Ok<int, String>(2).value, equals(2)));
      test('iterable', () => expect(const Ok<int, String>(2).iterable.toList(), equals([2])));

      test('isOk', () => expect(const Ok<int, String>(2).isOk, isTrue));
      test('isErr', () => expect(const Ok<int, String>(2).isErr, isFalse));

      test('ok', () => expect(const Ok<int, String>(2).ok, equals(const Some(2))));
      test('err', () => expect(const Ok<int, String>(2).err, equals(const None<String>())));
    });

    group('operators', () {
      test('==', () {
        expect(const Ok<int, String>(2) == const Ok<int, String>(2), isTrue);
        expect(const Ok<int, String>(2) == const Ok<int, String>(3), isFalse);
      });
    });

    group('methods', () {
      test('contains', () {
        expect(const Ok<int, String>(2).contains(2), isTrue);
        expect(const Ok<int, String>(2).contains(3), isFalse);
      });

      test('containsErr', () => expect(const Ok<int, String>(2).containsErr('2'), isFalse));

      test('whenOk', () {
        var pair = const Tuple2<int?, String?>(null, null);

        const Ok<int, String>(2).whenOk((value) => pair = Tuple2(value, null));

        expect(pair, equals(const Tuple2<int?, String?>(2, null)));
      });

      test('whenErr', () {
        var pair = const Tuple2<int?, String?>(null, null);

        const Ok<int, String>(2).whenErr((err) => pair = Tuple2(null, err));

        expect(pair, equals(const Tuple2<int?, String?>(null, null)));
      });

      test('match', () {
        expect(
          const Ok<int, String>(2).match((value) => value.toString(), (error) => error),
          equals('2'),
        );
      });

      test('unwrap', () {
        expect(const Ok<int, String>(2).unwrap(), equals(2));
        expect(const Ok<int, String>(2).unwrap(msg: 'custom'), equals(2));
        expect(const Ok<int, String>(2).unwrap(ifErr: int.parse), equals(2));
      });

      test('unwrapErr', () {
        expect(
          () => const Ok<int, String>(2).unwrapErr(),
          throwsA(
            predicate<Object>((error) {
              return error is StateError &&
                  error.message == 'called `Result.unwrapErr()` on an `Ok`: 2';
            }),
          ),
        );

        expect(
          () => const Ok<int, String>(2).unwrapErr(msg: 'custom'),
          throwsA(
            predicate<Object>((error) => error is StateError && error.message == 'custom: 2'),
          ),
        );

        expect(const Ok<String, int>('2').unwrapErr(ifOk: int.parse), equals(2));
      });

      test('map', () {
        expect(const Ok<String, int>('2').map(int.parse), equals(const Ok<int, int>(2)));

        expect(
          const Ok<String, int>('2').map(int.parse, ifErr: (error) => error),
          equals(const Ok<int, int>(2)),
        );
      });

      test('and', () {
        expect(
          const Ok<int, String>(2).and((value) => Ok(value == 2)),
          equals(const Ok<bool, String>(true)),
        );

        expect(
          const Ok<int, String>(2).and<bool>((value) => Err(value.toString())),
          equals(const Err<bool, String>('2')),
        );
      });

      test('or', () {
        expect(
          const Ok<int, String>(2).or<String>((error) => Ok(int.parse(error))),
          equals(const Ok<int, String>(2)),
        );

        expect(
          const Ok<int, String>(2).or((error) => Err(error)),
          equals(const Ok<int, String>(2)),
        );
      });

      test('toString', () {
        expect(const Ok<int, String>(2).toString(), equals('Ok(2)'));
        expect(const Ok<int, String>(2).toString(true), equals('Ok<int, String>(2)'));
      });
    });
  });

  group('Err', () {
    group('properties', () {
      test('error', () => expect(const Err<int, String>('2').error, equals('2')));
      test('iterable', () => expect(const Err<int, String>('2').iterable, isEmpty));

      test('isOk', () => expect(const Err<int, String>('2').isOk, isFalse));
      test('isErr', () => expect(const Err<int, String>('2').isErr, isTrue));

      test('ok', () => expect(const Err<int, String>('2').ok, equals(const None<int>())));
      test('err', () => expect(const Err<int, String>('2').err, equals(const Some('2'))));
    });

    group('operators', () {
      test('==', () {
        expect(const Err<int, String>('2') == const Err<int, String>('2'), isTrue);
        expect(const Err<int, String>('2') == const Err<int, String>('3'), isFalse);
      });
    });

    group('methods', () {
      test('contains', () => expect(const Err<int, String>('2').contains(2), isFalse));

      test('containsErr', () {
        expect(const Err<int, String>('2').containsErr('2'), isTrue);
        expect(const Err<int, String>('3').containsErr('2'), isFalse);
      });

      test('whenOk', () {
        var pair = const Tuple2<int?, String?>(null, null);

        const Err<int, String>('2').whenOk((value) => pair = Tuple2(value, null));

        expect(pair, equals(const Tuple2<int?, String?>(null, null)));
      });

      test('whenErr', () {
        var pair = const Tuple2<int?, String?>(null, null);

        const Err<int, String>('2').whenErr((err) => pair = Tuple2(null, err));

        expect(pair, equals(const Tuple2<int?, String?>(null, '2')));
      });

      test('match', () {
        expect(
          const Err<int, String>('2').match((value) => value.toString(), (error) => error),
          equals('2'),
        );
      });

      test('unwrap', () {
        expect(
          () => const Err<int, String>('2').unwrap(),
          throwsA(
            predicate<Object>((error) {
              return error is StateError &&
                  error.message == 'called `Result.unwrap()` on an `Err`: 2';
            }),
          ),
        );

        expect(
          () => const Err<int, String>('2').unwrap(msg: 'custom'),
          throwsA(
            predicate<Object>((error) => error is StateError && error.message == 'custom: 2'),
          ),
        );

        expect(const Err<int, String>('3').unwrap(ifErr: int.parse), equals(3));
      });

      test('unwrapErr', () {
        expect(const Err<int, String>('2').unwrapErr(), equals('2'));
        expect(const Err<int, String>('2').unwrapErr(msg: 'custom'), equals('2'));
        expect(const Err<String, int>(3).unwrapErr(ifOk: int.parse), equals(3));
      });

      test('map', () {
        expect(const Err<String, int>(3).map(int.parse), equals(const Err<int, int>(3)));

        expect(
          const Err<String, int>(3).map(int.parse, ifErr: (error) => error),
          equals(const Ok<int, int>(3)),
        );
      });

      test('and', () {
        expect(
          const Err<int, String>('2').and((value) => Ok(value == 2)),
          equals(const Err<bool, String>('2')),
        );

        expect(
          const Err<int, String>('2').and<bool>((value) => Err(value.toString())),
          equals(const Err<bool, String>('2')),
        );
      });

      test('or', () {
        expect(
          const Err<int, String>('2').or<String>((error) => Ok(int.parse(error))),
          equals(const Ok<int, String>(2)),
        );

        expect(
          const Err<int, String>('2').or((error) => Err(error)),
          equals(const Err<int, String>('2')),
        );
      });

      test('toString', () {
        expect(const Err<int, String>('2').toString(), equals('Err(2)'));
        expect(const Err<int, String>('2').toString(true), equals('Err<int, String>(2)'));
      });
    });
  });

  group('OkResult', () {
    group('properties', () {
      test('value', () => expect(const Result<int, Never>.ok(2).value, equals(2)));
    });
  });

  group('ErrResult', () {
    group('properties', () {
      test('error', () => expect(const Result<Never, int>.err(2).error, equals(2)));
    });
  });

  group('ResultingOption', () {
    group('methods', () {
      test('transpose', () {
        expect(
          const Ok<Some<int>, String>(Some(2)).transpose(),
          equals(const Some(Result<int, String>.ok(2))),
        );

        expect(
          const Err<Some<int>, String>('error').transpose(),
          equals(const Some<Result<int, String>>(Err('error'))),
        );

        expect(
          const Ok<None<int>, String>(None()).transpose(),
          equals(const None<Result<int, String>>()),
        );
      });
    });
  });

  group('ResultingResult', () {
    group('methods', () {
      test('flatten', () {
        expect(
          const Ok<Ok<int, String>, String>(Ok(2)).flatten(),
          equals(const Ok<int, String>(2)),
        );

        expect(
          const Ok<Err<int, String>, String>(Err('2')).flatten(),
          equals(const Err<int, String>('2')),
        );

        expect(
          const Err<Ok<int, String>, String>('2').flatten(),
          equals(const Err<int, String>('2')),
        );

        expect(
          const Err<Err<int, String>, String>('2').flatten(),
          equals(const Err<int, String>('2')),
        );
      });
    });
  });
}
