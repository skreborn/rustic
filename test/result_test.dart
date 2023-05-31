import 'package:rustic/option.dart';
import 'package:rustic/result.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

typedef _Result = Result<int, String>;
typedef _Ok<T> = Ok<T, String>;
typedef _Err<E> = Err<int, E>;

void main() {
  _Result validate(int n) => n % 2 != 0 ? Ok(n) : Err('even: $n');

  int triple(int n) => n * 3;
  int length(String s) => s.length;
  String exclaim(Object value) => '$value!';

  group('Result', () {
    group('static methods', () {
      test('collect', () {
        final err = Result.collect<int, String>((check) {
          final first = check(validate(1));
          final second = check(validate(2));

          return Ok(first + second);
        });

        check(err).equals(const Err('even: 2'));

        final ok = Result.collect<int, String>((check) {
          final first = check(validate(1));
          final second = check(validate(3));

          return Ok(first + second);
        });

        check(ok).equals(const Ok(4));
      });

      test('collectAsync', () {
        final err = Result.collectAsync<int, String>((check) async {
          final first = check(await Future.value(validate(1)));
          final second = check(await Future.value(validate(2)));

          return Ok(first + second);
        });

        check(err).completes(it()..equals(const Err('even: 2')));

        final ok = Result.collectAsync<int, String>((check) async {
          final first = check(await Future.value(validate(1)));
          final second = check(await Future.value(validate(3)));

          return Ok(first + second);
        });

        check(ok).completes(it()..equals(const Ok(4)));
      });
    });

    group('factories', () {
      group('named', () {
        test('ok', () => check(const _Result.ok(2)).equals(const Ok(2)));
        test('err', () => check(const _Result.err('oops')).equals(const Err('oops')));
      });
    });
  });

  group('Ok', () {
    const subject = _Ok(2);

    group('properties', () {
      test('value', () => check(subject.value).equals(2));
      test('isOk', () => check(subject.isOk).isTrue());
      test('isErr', () => check(subject.isErr).isFalse());
      test('ok', () => check(subject.ok).equals(const Some(2)));
      test('err', () => check(subject.err).equals(const None()));
      test('valueOrNull', () => check(subject.valueOrNull).equals(2));
      test('errorOrNull', () => check(subject.errorOrNull).equals(null));
      test('iterable', () => check(subject.iterable.toList()).deepEquals([2]));
    });

    group('operators', () {
      test('==', () {
        check(const _Ok(2)).equals(const Ok(2));
        check(const _Ok(<int>[])).equals(const Ok([]));
        check(const _Ok([1, 2, 3])).equals(const Ok([1, 2, 3]));
        check(const _Ok({1, 2, 3})).equals(const Ok({1, 2, 3}));
        check(const _Ok({1, 2, 3})).equals(const Ok({3, 2, 1}));
        check(const _Ok(2)).not(it()..equals(const Ok(3)));
        check(const _Ok([1, 2, 3])).not(it()..equals(const Ok([3, 2, 1])));
        check(const _Result.ok(2)).not(it()..equals(const Err('oops')));
      });
    });

    group('methods', () {
      test('isOkAnd', () {
        check(subject.isOkAnd((value) => value == 2)).isTrue();
        check(subject.isOkAnd((value) => value == 3)).isFalse();
      });

      test('isErrAnd', () => check(subject.isErrAnd((error) => true)).isFalse());

      test('contains', () {
        check(subject.contains(2)).isTrue();
        check(subject.contains(3)).isFalse();
      });

      test('containsErr', () => check(subject.containsErr('oops')).isFalse());

      test('unwrap', () {
        check(subject.unwrap()).equals(2);
        check(subject.unwrap(msg: 'custom')).equals(2);
      });

      test('unwrapOr', () => check(subject.unwrapOr(3)).equals(2));
      test('unwrapOrElse', () => check(subject.unwrapOrElse(length)).equals(2));

      test('unwrapErr', () {
        check(() => subject.unwrapErr())
            .throws<StateError>()
            .has((error) => error.message, 'message')
            .equals('tried to unwrap `Ok` as `Err`: 2');

        check(() => subject.unwrapErr(msg: 'custom'))
            .throws<StateError>()
            .has((error) => error.message, 'message')
            .equals('custom: 2');
      });

      test('unwrapErrOr', () => check(subject.unwrapErrOr('daisy')).equals('daisy'));
      test('unwrapErrOrElse', () => check(subject.unwrapErrOrElse(exclaim)).equals('2!'));

      test('inspect', () {
        int? calledWith;

        check(subject.inspect((value) => calledWith = value)).equals(const Ok(2));

        check(calledWith).equals(2);
      });

      test('inspectErr', () {
        String? calledWith;

        check(subject.inspectErr((error) => calledWith = error)).equals(const Ok(2));

        check(calledWith).isNull();
      });

      test('map', () => check(subject.map(triple)).equals(const Ok(6)));
      test('mapOr', () => check(subject.mapOr(triple, 0)).equals(6));
      test('mapOrElse', () => check(subject.mapOrElse(triple, length)).equals(6));
      test('mapErr', () => check(subject.mapErr(exclaim)).equals(const Ok(2)));
      test('mapErrOr', () => check(subject.mapErrOr(exclaim, 'daisy')).equals('daisy'));
      test('mapErrOrElse', () => check(subject.mapErrOrElse(exclaim, exclaim)).equals('2!'));

      test('and', () {
        check(subject.and(const _Ok('daisy'))).equals(const Ok('daisy'));
        check(subject.and(const _Err('oops'))).equals(const Err('oops'));
      });

      test('andThen', () {
        check(subject.andThen((value) => _Ok('$value!'))).equals(const Ok('2!'));
        check(subject.andThen((value) => _Err('$value!'))).equals(const Err('2!'));
      });

      test('or', () {
        check(subject.or(const _Ok(3))).equals(const Ok(2));
        check(subject.or(const _Err('oops'))).equals(const Ok(2));
      });

      test('orElse', () {
        check(subject.orElse((error) => _Ok(error.length))).equals(const Ok(2));
        check(subject.orElse((error) => _Err('$error!'))).equals(const Ok(2));
      });

      test('toString', () => check(subject.toString()).equals('Ok(2)'));
    });
  });

  group('Err', () {
    const subject = _Err('oops');

    group('properties', () {
      test('oops', () => check(subject.error).equals('oops'));
      test('isOk', () => check(subject.isOk).isFalse());
      test('isErr', () => check(subject.isErr).isTrue());
      test('ok', () => check(subject.ok).equals(const None()));
      test('err', () => check(subject.err).equals(const Some('oops')));
      test('valueOrNull', () => check(subject.valueOrNull).equals(null));
      test('errorOrNull', () => check(subject.errorOrNull).equals('oops'));
      test('iterable', () => check(subject.iterable.toList()).isEmpty());
    });

    group('operators', () {
      test('==', () {
        check(const _Err('oops')).equals(const Err('oops'));
        check(const _Err(<String>[])).equals(const Err([]));
        check(const _Err(['oops', 'daisy'])).equals(const Err(['oops', 'daisy']));
        check(const _Err({'oops', 'daisy'})).equals(const Err({'oops', 'daisy'}));
        check(const _Err({'oops', 'daisy'})).equals(const Err({'daisy', 'oops'}));
        check(const _Err(2)).not(it()..equals(const Err(3)));
        check(const _Err(['oops', 'daisy'])).not(it()..equals(const Err(['daisy', 'oops'])));
        check(const _Result.err('oops')).not(it()..equals(const Ok(2)));
      });
    });

    group('methods', () {
      test('isOkAnd', () => check(subject.isOkAnd((value) => true)).isFalse());

      test('isErrAnd', () {
        check(subject.isErrAnd((error) => error == 'oops')).isTrue();
        check(subject.isErrAnd((error) => error == 'daisy')).isFalse();
      });

      test('contains', () => check(subject.contains(2)).isFalse());

      test('containsErr', () {
        check(subject.containsErr('oops')).isTrue();
        check(subject.containsErr('daisy')).isFalse();
      });

      test('unwrap', () {
        check(() => subject.unwrap())
            .throws<StateError>()
            .has((error) => error.message, 'message')
            .equals('tried to unwrap `Err` as `Ok`: oops');

        check(() => subject.unwrap(msg: 'custom'))
            .throws<StateError>()
            .has((error) => error.message, 'message')
            .equals('custom: oops');
      });

      test('unwrapOr', () => check(subject.unwrapOr(2)).equals(2));
      test('unwrapOrElse', () => check(subject.unwrapOrElse(length)).equals(4));

      test('unwrapErr', () {
        check(subject.unwrapErr()).equals('oops');
        check(subject.unwrapErr(msg: 'custom')).equals('oops');
      });

      test('unwrapErrOr', () => check(subject.unwrapErrOr('daisy')).equals('oops'));
      test('unwrapErrOrElse', () => check(subject.unwrapErrOrElse(exclaim)).equals('oops'));

      test('inspect', () {
        int? calledWith;

        check(subject.inspect((value) => calledWith = value)).equals(const Err('oops'));

        check(calledWith).isNull();
      });

      test('inspectErr', () {
        String? calledWith;

        check(subject.inspectErr((error) => calledWith = error)).equals(const Err('oops'));

        check(calledWith).equals('oops');
      });

      test('map', () => check(subject.map(triple)).equals(const Err('oops')));
      test('mapOr', () => check(subject.mapOr(triple, 0)).equals(0));
      test('mapOrElse', () => check(subject.mapOrElse(triple, length)).equals(4));
      test('mapErr', () => check(subject.mapErr(exclaim)).equals(const Err('oops!')));
      test('mapErrOr', () => check(subject.mapErrOr(exclaim, 'daisy')).equals('oops!'));
      test('mapErrOrElse', () => check(subject.mapErrOrElse(exclaim, exclaim)).equals('oops!'));

      test('and', () {
        check(subject.and(const _Ok(2))).equals(const Err('oops'));
        check(subject.and(const _Err('daisy'))).equals(const Err('oops'));
      });

      test('andThen', () {
        check(subject.andThen((value) => _Ok('$value!'))).equals(const Err('oops'));
        check(subject.andThen((value) => _Err('$value!'))).equals(const Err('oops'));
      });

      test('or', () {
        check(subject.or(const _Ok(3))).equals(const Ok(3));
        check(subject.or(const _Err('daisy'))).equals(const Err('daisy'));
      });

      test('orElse', () {
        check(subject.orElse((error) => _Ok(error.length))).equals(const Ok(4));
        check(subject.orElse((error) => _Err('$error!'))).equals(const Err('oops!'));
      });

      test('toString', () => check(subject.toString()).equals('Err(oops)'));
    });
  });

  group('SuccessfulResult', () {
    group('properties', () {
      test('value', () => check(const Result<int, Never>.ok(2).value).equals(2));
    });
  });

  group('ErroneousResult', () {
    group('properties', () {
      test('oops', () => check(const Result<Never, String>.err('oops').error).equals('oops'));
    });
  });

  group('TransposedResult', () {
    group('properties', () {
      test('transposed', () {
        check(const _Ok<Some<int>>(Some(2)).transposed).equals(const Some(Ok(2)));
        check(const Err<Some<int>, String>('oops').transposed).equals(const Some(Err('oops')));
        check(const _Ok<None<int>>(None()).transposed).equals(const None());
      });
    });
  });

  group('FlattenedResult', () {
    group('properties', () {
      test('flattened', () {
        check(const _Ok<_Result>(Ok(2)).flattened).equals(const Ok(2));
        check(const _Ok<_Result>(Err('oops')).flattened).equals(const Err('oops'));
        check(const Err<_Result, String>('oops').flattened).equals(const Err('oops'));
      });
    });
  });

  group('IterableResults', () {
    group('methods', () {
      test('collectToList', () {
        check(const [1, 3, 5, 5].map(validate).collectToList()).equals(const Ok([1, 3, 5, 5]));
        check(const [1, 2, 3, 4, 5, 5].map(validate).collectToList()).equals(const Err('even: 2'));
      });

      test('collectToSet', () {
        check(const [1, 3, 5, 5].map(validate).collectToSet()).equals(const Ok({1, 3, 5}));
        check(const [1, 2, 3, 4, 5, 5].map(validate).collectToSet()).equals(const Err('even: 2'));
      });
    });
  });
}
