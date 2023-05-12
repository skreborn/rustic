import 'package:rustic/option.dart';
import 'package:rustic/result.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

void main() {
  group('Option', () {
    group('factories', () {
      test('unnamed', () {
        check(Option(2)).equals(const Some(2));
        check(Option<int>(null)).equals(const None());
      });

      group('named', () {
        test('some', () => check(const Option.some(2)).equals(const Some(2)));
        test('none', () => check(const Option<int>.none()).equals(const None()));
      });
    });

    group('static methods', () {
      test('collect', () {
        final none = Option.collect<int>((check) {
          final first = check(const Some(2));
          final second = check(const None<int>());

          return Some(first + second);
        });

        check(none).equals(const None());

        final some = Option.collect<int>((check) {
          final first = check(const Some(2));
          final second = check(const Some(3));

          return Some(first + second);
        });

        check(some).equals(const Some(5));
      });

      test('collectAsync', () {
        final none = Option.collectAsync<int>((check) async {
          final first = check(await Future.value(const Some(2)));
          final second = check(await Future.value(const None<int>()));

          return Some(first + second);
        });

        check(none).completes(it()..equals(const None()));

        final some = Option.collectAsync<int>((check) async {
          final first = check(await Future.value(const Some(2)));
          final second = check(await Future.value(const Some(3)));

          return Some(first + second);
        });

        check(some).completes(it()..equals(const Some(5)));
      });
    });
  });

  group('Some', () {
    group('properties', () {
      test('value', () => check(const Some(2).value).equals(2));
      test('isSome', () => check(const Some(2).isSome).isTrue());
      test('isNone', () => check(const Some(2).isNone).isFalse());
      test('valueOrNull', () => check(const Some(2).valueOrNull).equals(2));
      test('iterable', () => check(const Some(2).iterable.toList()).deepEquals([2]));
    });

    group('methods', () {
      test('isSomeAnd', () {
        check(const Some(2).isSomeAnd((value) => value == 2)).isTrue();
        check(const Some(2).isSomeAnd((value) => value == 3)).isFalse();
      });

      test('contains', () {
        check(const Some(2).contains(2)).isTrue();
        check(const Some(2).contains(3)).isFalse();
      });

      test('unwrap', () {
        check(const Some(2).unwrap()).equals(2);
        check(const Some(2).unwrap(msg: 'custom')).equals(2);
      });

      test('unwrapOr', () => check(const Some(2).unwrapOr(3)).equals(2));
      test('unwrapOrElse', () => check(const Some(2).unwrapOrElse(() => 3)).equals(2));

      test('inspect', () {
        int? calledWith;

        check(const Some(2).inspect((value) => calledWith = value)).equals(const Some(2));

        check(calledWith).equals(2);
      });

      test('map', () {
        check(const Some(2).map((value) => value.toString())).equals(const Some('2'));
      });

      test('mapOr', () {
        check(const Some(2).mapOr((value) => value.toString(), 'none')).equals('2');
      });

      test('mapOrElse', () {
        check(const Some(2).mapOrElse((value) => value.toString(), () => 'none')).equals('2');
      });

      test('okOr', () => check(const Some(2).okOr('none')).equals(const Ok(2)));
      test('okOrElse', () => check(const Some(2).okOrElse(() => 'none')).equals(const Ok(2)));

      test('and', () {
        check(const Some(2).and(const Some('other'))).equals(const Some('other'));
        check(const Some(2).and(const None<String>())).equals(const None());
      });

      test('andThen', () {
        check(const Some(2).andThen((value) => Some(value.toString()))).equals(const Some('2'));
        check(const Some(2).andThen((value) => const None<String>())).equals(const None());
      });

      test('or', () {
        check(const Some(2).or(const Some(3))).equals(const Some(2));
        check(const Some(2).or(const None())).equals(const Some(2));
      });

      test('orElse', () {
        check(const Some(2).orElse(() => const Some(3))).equals(const Some(2));
        check(const Some(2).orElse(() => const None())).equals(const Some(2));
      });

      test('xor', () {
        check(const Some(2).xor(const Some(3))).equals(const None());
        check(const Some(2).xor(const None())).equals(const Some(2));
      });

      test('where', () {
        check(const Some(2).where((value) => value == 2)).equals(const Some(2));
        check(const Some(2).where((value) => value == 3)).equals(const None());
      });

      test('whereType', () {
        check(const Some(2).whereType<int>()).equals(const Some(2));
        check(const Some(2).whereType<bool>()).equals(const None());
      });

      test('zip', () {
        check(const Some(2).zip(const Some('other'))).equals(const Some((2, 'other')));
        check(const Some(2).zip(const None<String>())).equals(const None());
      });

      test('zipWith', () {
        check(const Some(2).zipWith(const Some(true), (a, b) => '$a:$b'))
            .equals(const Some('2:true'));

        check(const Some(2).zipWith(const None<bool>(), (a, b) => '$a:$b')).equals(const None());
      });

      test('toString', () => check(const Some(2).toString()).equals('Some(2)'));
    });
  });

  group('None', () {
    group('properties', () {
      test('isSome', () => check(const None<int>().isSome).isFalse());
      test('isNone', () => check(const None<int>().isNone).isTrue());
      test('valueOrNull', () => check(const None<int>().valueOrNull).isNull());
      test('iterable', () => check(const None<int>().iterable.toList()).isEmpty());
    });

    group('methods', () {
      test('isSomeAnd', () => check(const None<int>().isSomeAnd((value) => true)).isFalse());

      test('contains', () => check(const None<int>().contains(2)).isFalse());

      test('unwrap', () {
        check(() => const None<int>().unwrap())
            .throws<StateError>()
            .has((error) => error.message, 'message')
            .equals('tried to unwrap `None` as `Some`');

        check(() => const None<int>().unwrap(msg: 'custom'))
            .throws<StateError>()
            .has((error) => error.message, 'message')
            .equals('custom');
      });

      test('unwrapOr', () => check(const None<int>().unwrapOr(3)).equals(3));
      test('unwrapOrElse', () => check(const None<int>().unwrapOrElse(() => 3)).equals(3));

      test('inspect', () {
        int? calledWith;

        check(const None<int>().inspect((value) => calledWith = value)).equals(const None());

        check(calledWith).isNull();
      });

      test('map', () {
        check(const None<int>().map((value) => value.toString())).equals(const None());
      });

      test('mapOr', () {
        check(const None<int>().mapOr((value) => value.toString(), 'none')).equals('none');
      });

      test('mapOrElse', () {
        check(const None<int>().mapOrElse((value) => value.toString(), () => 'none'))
            .equals('none');
      });

      test('okOr', () => check(const None<int>().okOr('none')).equals(const Err('none')));

      test('okOrElse', () {
        check(const None<int>().okOrElse(() => 'none')).equals(const Err('none'));
      });

      test('and', () {
        check(const None<int>().and(const Some('other'))).equals(const None());
        check(const None<int>().and(const None<String>())).equals(const None());
      });

      test('andThen', () {
        check(const None<int>().andThen((value) => Some(value.toString()))).equals(const None());
        check(const None<int>().andThen((value) => const None<String>())).equals(const None());
      });

      test('or', () {
        check(const None<int>().or(const Some(3))).equals(const Some(3));
        check(const None<int>().or(const None())).equals(const None());
      });

      test('orElse', () {
        check(const None<int>().orElse(() => const Some(3))).equals(const Some(3));
        check(const None<int>().orElse(() => const None())).equals(const None());
      });

      test('xor', () {
        check(const None<int>().xor(const Some(3))).equals(const Some(3));
        check(const None<int>().xor(const None())).equals(const None());
      });

      test('where', () => check(const None<int>().where((value) => true)).equals(const None()));

      test('whereType', () {
        check(const None<int>().whereType<int>()).equals(const None());
        check(const None<int>().whereType<bool>()).equals(const None());
      });

      test('zip', () {
        check(const None<int>().zip(const Some('other'))).equals(const None());
        check(const None<int>().zip(const None<String>())).equals(const None());
      });

      test('zipWith', () {
        check(const None<int>().zipWith(const Some(true), (a, b) => '$a:$b')).equals(const None());

        check(const None<int>().zipWith(const None<bool>(), (a, b) => '$a:$b'))
            .equals(const None());
      });

      test('toString', () => check(const None<int>().toString()).equals('None'));
    });
  });

  group('Optional', () {
    group('properties', () {
      test('optional', () {
        check(2.optional).equals(const Some(2));
        check(Optional<int>(null).optional).equals(const None());
      });
    });
  });

  group('UnzippedOption', () {
    group('properties', () {
      test('unzipped', () {
        check(const Some((2, true)).unzipped).equals(const (Some(2), Some(true)));
        check(const None<(int, bool)>().unzipped).equals(const (None(), None()));
      });
    });
  });

  group('TransposedOption', () {
    group('properties', () {
      test('transposed', () {
        check(const Some(Ok<int, String>(2)).transposed).equals(const Ok(Some(2)));
        check(const Some(Err<int, String>('error')).transposed).equals(const Err('error'));
        check(const None<Result<int, String>>().transposed).equals(const Ok(None()));
      });
    });
  });

  group('FlattenedOption', () {
    group('properties', () {
      test('flattened', () {
        check(const Some(Some(2)).flattened).equals(const Some(2));
        check(const Some(None<int>()).flattened).equals(const None());
        check(const None<Option<int>>().flattened).equals(const None());
      });
    });
  });
}
