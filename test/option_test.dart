import 'package:rustic/option.dart';
import 'package:rustic/result.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

typedef _Option = Option<int>;
typedef _None = None<int>;

void main() {
  _Option filter(int n) => n % 2 != 0 ? Some(n) : const None();

  String concat(Object a, Object b) => '$a:$b';
  String stringify(int n) => n.toString();

  group('Option', () {
    group('static methods', () {
      test('collect', () {
        final none = Option.collect((check) {
          final first = check(filter(1));
          final second = check(filter(2));

          return Some(first + second);
        });

        check(none).equals(const None());

        final some = Option.collect((check) {
          final first = check(filter(1));
          final second = check(filter(3));

          return Some(first + second);
        });

        check(some).equals(const Some(4));
      });

      test('collectAsync', () {
        final none = Option.collectAsync((check) async {
          final first = check(await Future.value(filter(1)));
          final second = check(await Future.value(filter(2)));

          return Some(first + second);
        });

        check(none).completes(it()..equals(const None()));

        final some = Option.collectAsync((check) async {
          final first = check(await Future.value(filter(1)));
          final second = check(await Future.value(filter(3)));

          return Some(first + second);
        });

        check(some).completes(it()..equals(const Some(4)));
      });
    });

    group('factories', () {
      test('unnamed', () {
        check(_Option(2)).equals(const Some(2));
        check(_Option(null)).equals(const None());
      });

      group('named', () {
        test('some', () => check(const _Option.some(2)).equals(const Some(2)));
        test('none', () => check(const _Option.none()).equals(const None()));
      });
    });
  });

  group('Some', () {
    const subject = Some(2);

    group('properties', () {
      test('value', () => check(subject.value).equals(2));
      test('isSome', () => check(subject.isSome).isTrue());
      test('isNone', () => check(subject.isNone).isFalse());
      test('valueOrNull', () => check(subject.valueOrNull).equals(2));
      test('iterable', () => check(subject.iterable.toList()).deepEquals([2]));
    });

    group('operators', () {
      test('==', () {
        check(const Some(2)).equals(const Some(2));
        check(const Some(<int>[])).equals(const Some([]));
        check(const Some([1, 2, 3])).equals(const Some([1, 2, 3]));
        check(const Some({1, 2, 3})).equals(const Some({1, 2, 3}));
        check(const Some({1, 2, 3})).equals(const Some({3, 2, 1}));
        check(const Some(2)).not(it()..equals(const Some(3)));
        check(const Some([1, 2, 3])).not(it()..equals(const Some([3, 2, 1])));
        check(const _Option.some(2)).not(it()..equals(const None()));
      });
    });

    group('methods', () {
      test('isSomeAnd', () {
        check(subject.isSomeAnd((value) => value == 2)).isTrue();
        check(subject.isSomeAnd((value) => value == 3)).isFalse();
      });

      test('contains', () {
        check(subject.contains(2)).isTrue();
        check(subject.contains(3)).isFalse();
      });

      test('unwrap', () {
        check(subject.unwrap()).equals(2);
        check(subject.unwrap(msg: 'custom')).equals(2);
      });

      test('unwrapOr', () => check(subject.unwrapOr(3)).equals(2));
      test('unwrapOrElse', () => check(subject.unwrapOrElse(() => 3)).equals(2));

      test('inspect', () {
        int? calledWith;

        check(subject.inspect((value) => calledWith = value)).equals(const Some(2));

        check(calledWith).equals(2);
      });

      test('map', () => check(subject.map(stringify)).equals(const Some('2')));
      test('mapOr', () => check(subject.mapOr(stringify, 'none')).equals('2'));
      test('mapOrElse', () => check(subject.mapOrElse(stringify, () => 'none')).equals('2'));
      test('okOr', () => check(subject.okOr('none')).equals(const Ok(2)));
      test('okOrElse', () => check(subject.okOrElse(() => 'none')).equals(const Ok(2)));

      test('and', () {
        check(subject.and(const Some('other'))).equals(const Some('other'));
        check(subject.and(const _None())).equals(const None());
      });

      test('andThen', () {
        check(subject.andThen((value) => Some(value.toString()))).equals(const Some('2'));
        check(subject.andThen((value) => const _None())).equals(const None());
      });

      test('or', () {
        check(subject.or(const Some(3))).equals(const Some(2));
        check(subject.or(const None())).equals(const Some(2));
      });

      test('orElse', () {
        check(subject.orElse(() => const Some(3))).equals(const Some(2));
        check(subject.orElse(() => const None())).equals(const Some(2));
      });

      test('xor', () {
        check(subject.xor(const Some(3))).equals(const None());
        check(subject.xor(const None())).equals(const Some(2));
      });

      test('where', () {
        check(subject.where((value) => value == 2)).equals(const Some(2));
        check(subject.where((value) => value == 3)).equals(const None());
      });

      test('whereType', () {
        check(subject.whereType<int>()).equals(const Some(2));
        check(subject.whereType<bool>()).equals(const None());
      });

      test('zip', () {
        check(subject.zip(const Some('other'))).equals(const Some((2, 'other')));
        check(subject.zip(const _None())).equals(const None());
      });

      test('zipWith', () {
        check(subject.zipWith(const Some(true), concat)).equals(const Some('2:true'));
        check(subject.zipWith(const _None(), concat)).equals(const None());
      });

      test('toString', () => check(subject.toString()).equals('Some(2)'));
    });
  });

  group('None', () {
    const subject = _None();

    group('properties', () {
      test('isSome', () => check(subject.isSome).isFalse());
      test('isNone', () => check(subject.isNone).isTrue());
      test('valueOrNull', () => check(subject.valueOrNull).isNull());
      test('iterable', () => check(subject.iterable.toList()).isEmpty());
    });

    group('operators', () {
      test('==', () {
        check(const _None()).equals(const None());
        check(const _Option.none()).not(it()..equals(const Some(2)));
      });
    });

    group('methods', () {
      test('isSomeAnd', () => check(subject.isSomeAnd((value) => true)).isFalse());
      test('contains', () => check(subject.contains(2)).isFalse());

      test('unwrap', () {
        check(() => subject.unwrap())
            .throws<StateError>()
            .has((error) => error.message, 'message')
            .equals('tried to unwrap `None` as `Some`');

        check(() => subject.unwrap(msg: 'custom'))
            .throws<StateError>()
            .has((error) => error.message, 'message')
            .equals('custom');
      });

      test('unwrapOr', () => check(subject.unwrapOr(3)).equals(3));
      test('unwrapOrElse', () => check(subject.unwrapOrElse(() => 3)).equals(3));

      test('inspect', () {
        int? calledWith;

        check(subject.inspect((value) => calledWith = value)).equals(const None());

        check(calledWith).isNull();
      });

      test('map', () => check(subject.map(stringify)).equals(const None()));
      test('mapOr', () => check(subject.mapOr(stringify, 'none')).equals('none'));
      test('mapOrElse', () => check(subject.mapOrElse(stringify, () => 'none')).equals('none'));
      test('okOr', () => check(subject.okOr('none')).equals(const Err('none')));
      test('okOrElse', () => check(subject.okOrElse(() => 'none')).equals(const Err('none')));

      test('and', () {
        check(subject.and(const Some('other'))).equals(const None());
        check(subject.and(const _None())).equals(const None());
      });

      test('andThen', () {
        check(subject.andThen((value) => Some(value.toString()))).equals(const None());
        check(subject.andThen((value) => const _None())).equals(const None());
      });

      test('or', () {
        check(subject.or(const Some(3))).equals(const Some(3));
        check(subject.or(const None())).equals(const None());
      });

      test('orElse', () {
        check(subject.orElse(() => const Some(3))).equals(const Some(3));
        check(subject.orElse(() => const None())).equals(const None());
      });

      test('xor', () {
        check(subject.xor(const Some(3))).equals(const Some(3));
        check(subject.xor(const None())).equals(const None());
      });

      test('where', () => check(subject.where((value) => true)).equals(const None()));

      test('whereType', () {
        check(subject.whereType<int>()).equals(const None());
        check(subject.whereType<bool>()).equals(const None());
      });

      test('zip', () {
        check(subject.zip(const Some('other'))).equals(const None());
        check(subject.zip(const _None())).equals(const None());
      });

      test('zipWith', () {
        check(subject.zipWith(const Some(true), concat)).equals(const None());
        check(subject.zipWith(const _None(), concat)).equals(const None());
      });

      test('toString', () => check(subject.toString()).equals('None'));
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
        check(const Some(_None()).flattened).equals(const None());
        check(const None<_Option>().flattened).equals(const None());
      });
    });
  });
}
