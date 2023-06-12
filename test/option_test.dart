import 'package:rustic/option.dart';
import 'package:rustic/result.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

typedef _Option = Option<int>;
typedef _None = None<int>;

void main() {
  _Option filterOption(int n) => n.isOdd ? Some(n) : const None();
  int? filterNullable(int n) => n.isOdd ? n : null;

  String concat(Object a, Object b) => '$a:$b';
  String stringify(int n) => n.toString();

  group('methods', () {
    test('collectNullable', () {
      final none = collectNullable((check) {
        final first = check(filterNullable(1));
        final second = check(filterNullable(2));

        return first + second;
      });

      check(none).isNull();

      final some = collectNullable((check) {
        final first = check(filterNullable(1));
        final second = check(filterNullable(3));

        return first + second;
      });

      check(some).equals(4);
    });

    test('collectNullableAsync', () {
      final none = collectNullableAsync((check) async {
        final first = check(await Future.value(filterNullable(1)));
        final second = check(await Future.value(filterNullable(2)));

        return first + second;
      });

      check(none).completes(it()..isNull());

      final some = collectNullableAsync((check) async {
        final first = check(await Future.value(filterNullable(1)));
        final second = check(await Future.value(filterNullable(3)));

        return first + second;
      });

      check(some).completes(it()..equals(4));
    });
  });

  group('Option', () {
    group('static methods', () {
      test('collect', () {
        final none = Option.collect((check) {
          final first = check(filterOption(1));
          final second = check(filterOption(2));

          return Some(first + second);
        });

        check(none).equals(const None());

        final some = Option.collect((check) {
          final first = check(filterOption(1));
          final second = check(filterOption(3));

          return Some(first + second);
        });

        check(some).equals(const Some(4));
      });

      test('collectAsync', () {
        final none = Option.collectAsync((check) async {
          final first = check(await Future.value(filterOption(1)));
          final second = check(await Future.value(filterOption(2)));

          return Some(first + second);
        });

        check(none).completes(it()..equals(const None()));

        final some = Option.collectAsync((check) async {
          final first = check(await Future.value(filterOption(1)));
          final second = check(await Future.value(filterOption(3)));

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
    const int? n = null;

    group('properties', () {
      test('optional', () {
        check(2.optional).equals(const Some(2));
        check(n.optional).equals(const None());
      });
    });

    group('methods', () {
      group('isNotNullAnd', () {
        test('non-null', () {
          check(2.isNotNullAnd((value) => value == 2)).isTrue();
          check(2.isNotNullAnd((value) => value == 3)).isFalse();
        });

        test('null', () {
          check(n.isNotNullAnd((value) => value == 2)).isFalse();
        });
      });

      group('inspect', () {
        test('non-null', () {
          int? calledWith;

          check(2.inspect((value) => calledWith = value)).equals(2);

          check(calledWith).equals(2);
        });

        test('null', () {
          int? calledWith;

          check(n.inspect((value) => calledWith = value)).isNull();

          check(calledWith).isNull();
        });
      });

      group('map', () {
        test('non-null', () => check(2.map(stringify)).equals('2'));
        test('null', () => check(n.map(stringify)).isNull());
      });

      group('mapOr', () {
        test('non-null', () => check(2.mapOr(stringify, 'null')).equals('2'));
        test('null', () => check(n.mapOr(stringify, 'null')).equals('null'));
      });

      group('mapOrElse', () {
        test('non-null', () => check(2.mapOrElse(stringify, () => 'null')).equals('2'));
        test('null', () => check(n.mapOrElse(stringify, () => 'null')).equals('null'));
      });

      group('okOr', () {
        test('non-null', () => check(2.okOr('null')).equals(const Ok(2)));
        test('null', () => check(n.okOr('null')).equals(const Err('null')));
      });

      group('okOrElse', () {
        test('non-null', () => check(2.okOrElse(() => 'null')).equals(const Ok(2)));
        test('null', () => check(n.okOrElse(() => 'null')).equals(const Err('null')));
      });

      group('and', () {
        test('non-null', () {
          check(2.and('other')).equals('other');
          check(2.and(n)).isNull();
        });

        test('null', () {
          check(n.and(const Some('other'))).isNull();
          check(n.and(n)).isNull();
        });
      });

      group('andThen', () {
        test('non-null', () {
          check(2.andThen((value) => value.toString())).equals('2');
          check(2.andThen((value) => n)).isNull();
        });

        test('null', () {
          check(n.andThen((value) => Some(value.toString()))).isNull();
          check(n.andThen((value) => n)).isNull();
        });
      });

      group('or', () {
        test('non-null', () {
          check(2.or(3)).equals(2);
          check(2.or(n)).equals(2);
        });

        test('null', () {
          check(n.or(3)).equals(3);
          check(n.or(null)).isNull();
        });
      });

      group('orElse', () {
        test('non-null', () {
          check(2.orElse(() => 3)).equals(2);
          check(2.orElse(() => n)).equals(2);
        });

        test('null', () {
          check(n.orElse(() => 3)).equals(3);
          check(n.orElse(() => null)).isNull();
        });
      });

      group('xor', () {
        test('non-null', () {
          check(2.xor(3)).isNull();
          check(2.xor(n)).equals(2);
        });

        test('null', () {
          check(n.xor(3)).equals(3);
          check(n.xor(null)).isNull();
        });
      });

      group('where', () {
        test('non-null', () {
          check(2.where((value) => value == 2)).equals(2);
          check(2.where((value) => value == 3)).isNull();
        });

        test('null', () => check(n.where((value) => true)).isNull());
      });

      group('whereType', () {
        test('non-null', () {
          check(2.whereType<int>()).equals(2);
          check(2.whereType<bool>()).isNull();
        });

        test('null', () {
          check(n.whereType<int>()).isNull();
          check(n.whereType<bool>()).isNull();
        });
      });

      group('zip', () {
        test('non-null', () {
          check(2.zip('other')).equals(((2, 'other')));
          check(2.zip(n)).isNull();
        });

        test('null', () {
          check(n.zip(const Some('other'))).isNull();
          check(n.zip(n)).isNull();
        });
      });

      group('zipWith', () {
        test('non-null', () {
          check(2.zipWith(true, concat)).equals(('2:true'));
          check(2.zipWith(n, concat)).isNull();
        });

        test('null', () {
          check(n.zipWith(const Some(true), concat)).isNull();
          check(n.zipWith(n, concat)).isNull();
        });
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

  group('IterableOptions', () {
    group('methods', () {
      const odd = [1, 3, 5, 5];
      const mixed = [1, 2, 3, 4, 5, 5];

      test('collectToList', () {
        check(odd.map(filterOption).collectToList()).equals(const Some([1, 3, 5, 5]));
        check(mixed.map(filterOption).collectToList()).equals(const None());
      });

      test('collectToSet', () {
        check(odd.map(filterOption).collectToSet()).equals(const Some({1, 3, 5}));
        check(mixed.map(filterOption).collectToSet()).equals(const None());
      });
    });
  });

  group('IterableNullables', () {
    group('methods', () {
      const odd = [1, 3, 5, 5];
      const mixed = [1, 2, 3, 4, 5, 5];

      test('collectToList', () {
        check(odd.map(filterNullable).collectToList()).isNotNull().deepEquals([1, 3, 5, 5]);
        check(mixed.map(filterNullable).collectToList()).isNull();
      });

      test('collectToSet', () {
        check(odd.map(filterNullable).collectToSet()).isNotNull().deepEquals({1, 3, 5});
        check(mixed.map(filterNullable).collectToSet()).isNull();
      });
    });
  });
}
