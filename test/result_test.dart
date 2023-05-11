import 'package:rustic/option.dart';
import 'package:rustic/result.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    group('factories', () {
      group('named', () {
        test('some', () {
          check(const Result<int, String>.ok(2)).equals(const Ok(2));
        });

        test('none', () {
          check(const Result<int, String>.err('error')).equals(const Err('error'));
        });
      });
    });

    group('static methods', () {
      test('collect', () {
        final err = Result.collect<int, String>((check) {
          final first = check(const Ok(2));
          final second = check(const Err('error'));

          return Ok(first + second);
        });

        check(err).equals(const Err('error'));

        final ok = Result.collect<int, String>((check) {
          final first = check(const Ok(2));
          final second = check(const Ok(3));

          return Ok(first + second);
        });

        check(ok).equals(const Ok(5));
      });

      test('collectAsync', () {
        final err = Result.collectAsync<int, String>((check) async {
          final first = check(await Future.value(const Ok(2)));
          final second = check(await Future.value(const Err('error')));

          return Ok(first + second);
        });

        check(err).completes(it()..equals(const Err('error')));

        final ok = Result.collectAsync<int, String>((check) async {
          final first = check(await Future.value(const Ok(2)));
          final second = check(await Future.value(const Ok(3)));

          return Ok(first + second);
        });

        check(ok).completes(it()..equals(const Ok(5)));
      });
    });
  });

  group('Ok', () {
    group('properties', () {
      test('value', () => check(const Ok<int, String>(2).value).equals(2));
      test('isOk', () => check(const Ok<int, String>(2).isOk).isTrue());
      test('isErr', () => check(const Ok<int, String>(2).isErr).isFalse());
      test('ok', () => check(const Ok<int, String>(2).ok).equals(const Some(2)));
      test('err', () => check(const Ok<int, String>(2).err).equals(const None()));
      test('valueOrNull', () => check(const Ok<int, String>(2).valueOrNull).equals(2));
      test('errorOrNull', () => check(const Ok<int, String>(2).errorOrNull).equals(null));
      test('iterable', () => check(const Ok<int, String>(2).iterable.toList()).deepEquals([2]));
    });

    group('methods', () {
      test('isOkAnd', () {
        check(const Ok<int, String>(2).isOkAnd((value) => value == 2)).isTrue();
        check(const Ok<int, String>(2).isOkAnd((value) => value == 3)).isFalse();
      });

      test('isErrAnd', () => check(const Ok<int, String>(2).isErrAnd((error) => true)).isFalse());

      test('contains', () {
        check(const Ok<int, String>(2).contains(2)).isTrue();
        check(const Ok<int, String>(2).contains(3)).isFalse();
      });

      test('containsErr', () => check(const Ok<int, String>(2).containsErr('error')).isFalse());

      test('unwrap', () {
        check(const Ok<int, String>(2).unwrap()).equals(2);
        check(const Ok<int, String>(2).unwrap(msg: 'custom')).equals(2);
      });

      test('unwrapOr', () => check(const Ok<int, String>(2).unwrapOr(3)).equals(2));

      test('unwrapOrElse', () {
        check(const Ok<int, String>(2).unwrapOrElse((error) => error.length)).equals(2);
      });

      test('unwrapErr', () {
        check(() => const Ok<int, String>(2).unwrapErr())
            .throws<StateError>()
            .has((error) => error.message, 'message')
            .equals('tried to unwrap `Ok` as `Err`: 2');

        check(() => const Ok<int, String>(2).unwrapErr(msg: 'custom'))
            .throws<StateError>()
            .has((error) => error.message, 'message')
            .equals('custom: 2');
      });

      test('unwrapErrOr', () {
        check(const Ok<int, String>(2).unwrapErrOr('other')).equals('other');
      });

      test('unwrapErrOrElse', () {
        check(const Ok<int, String>(2).unwrapErrOrElse((value) => '$value!')).equals('2!');
      });

      test('inspect', () {
        int? calledWith;

        check(const Ok<int, String>(2).inspect((value) => calledWith = value)).equals(const Ok(2));

        check(calledWith).equals(2);
      });

      test('inspectErr', () {
        String? calledWith;

        check(const Ok<int, String>(2).inspectErr((error) => calledWith = error))
            .equals(const Ok(2));

        check(calledWith).isNull();
      });

      test('map', () {
        check(const Ok<int, String>(2).map((value) => value * 2)).equals(const Ok(4));
      });

      test('mapOr', () {
        check(const Ok<int, String>(2).mapOr((value) => value * 2, 0)).equals(4);
      });

      test('mapOrElse', () {
        check(const Ok<int, String>(2).mapOrElse((value) => value * 2, (error) => error.length))
            .equals(4);
      });

      test('mapErr', () {
        check(const Ok<int, String>(2).mapErr((error) => '$error!')).equals(const Ok(2));
      });

      test('mapErrOr', () {
        check(const Ok<int, String>(2).mapErrOr((error) => '$error!', 'other')).equals('other');
      });

      test('mapErrOrElse', () {
        check(const Ok<int, String>(2).mapErrOrElse((error) => '$error!', (value) => '$value!'))
            .equals('2!');
      });

      test('and', () {
        check(const Ok<int, String>(2).and(const Ok('other'))).equals(const Ok('other'));

        check(const Ok<int, String>(2).and(const Err<String, String>('error')))
            .equals(const Err('error'));
      });

      test('andThen', () {
        check(const Ok<int, String>(2).andThen((value) => Ok('$value!'))).equals(const Ok('2!'));

        check(const Ok<int, String>(2).andThen((value) => Err<String, String>('$value!')))
            .equals(const Err('2!'));
      });

      test('or', () {
        check(const Ok<int, String>(2).or(const Ok<int, String>(3))).equals(const Ok(2));
        check(const Ok<int, String>(2).or(const Err('error'))).equals(const Ok(2));
      });

      test('orElse', () {
        check(const Ok<int, String>(2).orElse((error) => Ok<int, String>(error.length)))
            .equals(const Ok(2));

        check(const Ok<int, String>(2).orElse((error) => Err('$error!'))).equals(const Ok(2));
      });

      test('toString', () => check(const Ok<int, String>(2).toString()).equals('Ok(2)'));
    });
  });

  group('Err', () {
    group('properties', () {
      test('error', () => check(const Err<int, String>('error').error).equals('error'));
      test('isOk', () => check(const Err<int, String>('error').isOk).isFalse());
      test('isErr', () => check(const Err<int, String>('error').isErr).isTrue());
      test('ok', () => check(const Err<int, String>('error').ok).equals(const None()));
      test('err', () => check(const Err<int, String>('error').err).equals(const Some('error')));
      test('valueOrNull', () => check(const Err<int, String>('error').valueOrNull).equals(null));
      test('errorOrNull', () => check(const Err<int, String>('error').errorOrNull).equals('error'));
      test('iterable', () => check(const Err<int, String>('error').iterable.toList()).isEmpty());
    });

    group('methods', () {
      test('isOkAnd', () {
        check(const Err<int, String>('error').isOkAnd((value) => true)).isFalse();
      });

      test('isErrAnd', () {
        check(const Err<int, String>('error').isErrAnd((error) => error == 'error')).isTrue();
        check(const Err<int, String>('error').isErrAnd((error) => error == 'other')).isFalse();
      });

      test('contains', () => check(const Err<int, String>('error').contains(2)).isFalse());

      test('containsErr', () {
        check(const Err<int, String>('error').containsErr('error')).isTrue();
        check(const Err<int, String>('error').containsErr('other')).isFalse();
      });

      test('unwrap', () {
        check(() => const Err<int, String>('error').unwrap())
            .throws<StateError>()
            .has((error) => error.message, 'message')
            .equals('tried to unwrap `Err` as `Ok`: error');

        check(() => const Err<int, String>('error').unwrap(msg: 'custom'))
            .throws<StateError>()
            .has((error) => error.message, 'message')
            .equals('custom: error');
      });

      test('unwrapOr', () => check(const Err<int, String>('error').unwrapOr(2)).equals(2));

      test('unwrapOrElse', () {
        check(const Err<int, String>('error').unwrapOrElse((value) => value.length)).equals(5);
      });

      test('unwrapErr', () {
        check(const Err<int, String>('error').unwrapErr()).equals('error');
        check(const Err<int, String>('error').unwrapErr(msg: 'custom')).equals('error');
      });

      test('unwrapErrOr', () {
        check(const Err<int, String>('error').unwrapErrOr('other')).equals('error');
      });

      test('unwrapErrOrElse', () {
        check(const Err<int, String>('error').unwrapErrOrElse((value) => '$value!'))
            .equals('error');
      });

      test('inspect', () {
        int? calledWith;

        check(const Err<int, String>('error').inspect((value) => calledWith = value))
            .equals(const Err('error'));

        check(calledWith).isNull();
      });

      test('inspectErr', () {
        String? calledWith;

        check(const Err<int, String>('error').inspectErr((error) => calledWith = error))
            .equals(const Err('error'));

        check(calledWith).equals('error');
      });

      test('map', () {
        check(const Err<int, String>('error').map((value) => value * 2)).equals(const Err('error'));
      });

      test('mapOr', () {
        check(const Err<int, String>('error').mapOr((value) => value * 2, 0)).equals(0);
      });

      test('mapOrElse', () {
        check(const Err<int, String>('error')
            .mapOrElse((value) => value * 2, (error) => error.length)).equals(5);
      });

      test('mapErr', () {
        check(const Err<int, String>('error').mapErr((error) => '$error!'))
            .equals(const Err('error!'));
      });

      test('mapErrOr', () {
        check(const Err<int, String>('error').mapErrOr((error) => '$error!', 'other'))
            .equals('error!');
      });

      test('mapErrOrElse', () {
        check(const Err<int, String>('error').mapErrOrElse(
          (error) => '$error!',
          (value) => '$value!',
        )).equals('error!');
      });

      test('and', () {
        check(const Err<int, String>('error').and(const Ok(2))).equals(const Err('error'));

        check(const Err<int, String>('error').and(const Err<String, String>('other')))
            .equals(const Err('error'));
      });

      test('andThen', () {
        check(const Err<int, String>('error').andThen((value) => Ok('$value!')))
            .equals(const Err('error'));

        check(const Err<int, String>('error').andThen((value) => Err<String, String>('$value!')))
            .equals(const Err('error'));
      });

      test('or', () {
        check(const Err<int, String>('error').or(const Ok<int, String>(3))).equals(const Ok(3));
        check(const Err<int, String>('error').or(const Err('other'))).equals(const Err('other'));
      });

      test('orElse', () {
        check(const Err<int, String>('error').orElse((error) => Ok<int, String>(error.length)))
            .equals(const Ok(5));

        check(const Err<int, String>('error').orElse((error) => Err('$error!')))
            .equals(const Err('error!'));
      });

      test('toString', () {
        check(const Err<int, String>('error').toString()).equals('Err(error)');
      });
    });
  });

  group('SuccessfulResult', () {
    group('properties', () {
      test('value', () => check(const Result<int, Never>.ok(2).value).equals(2));
    });
  });

  group('ErroneousResult', () {
    group('properties', () {
      test('error', () => check(const Result<Never, String>.err('error').error).equals('error'));
    });
  });

  group('TransposedResult', () {
    group('properties', () {
      test('transposed', () {
        check(const Ok<Some<int>, String>(Some(2)).transposed).equals(const Some(Ok(2)));
        check(const Err<Some<int>, String>('error').transposed).equals(const Some(Err('error')));
        check(const Ok<None<int>, String>(None()).transposed).equals(const None());
      });
    });
  });

  group('FlattenedResult', () {
    group('properties', () {
      test('flattened', () {
        check(const Ok<Result<int, String>, String>(Ok(2)).flattened).equals(const Ok(2));

        check(const Ok<Result<int, String>, String>(Err('error')).flattened)
            .equals(const Err('error'));

        check(const Err<Result<int, String>, String>('error').flattened).equals(const Err('error'));
      });
    });
  });
}
