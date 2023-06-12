import 'package:rustic/option.dart';
import 'package:rustic/result.dart';
import 'package:checks/checks.dart';
import 'package:rustic/util.dart';
import 'package:test/test.dart';

sealed class _Kind {
  const _Kind();
}

final class _KindA extends _Kind {
  const _KindA();
}

final class _KindB extends _Kind {
  const _KindB();
}

void main() {
  group('utilities', () {
    group('upcast', () {
      test('Result', () {
        const okA = Ok<_KindA, _KindA>(_KindA());
        const okB = Ok<_KindB, _KindB>(_KindB());

        const errA = Err<_KindA, _KindA>(_KindA());
        const errB = Err<_KindB, _KindB>(_KindB());

        check(okA.mapErr<_Kind>(upcast).and(okB)).equals(const Ok(_KindB()));
        check(errA.map<_Kind>(upcast).or(errB)).equals(const Err(_KindB()));
      });

      test('Option', () {
        const someA = Some<_KindA>(_KindA());
        const someB = Some<_KindB>(_KindB());

        const noneA = None<_KindA>();
        const noneB = None<_KindB>();

        check(someA.map<_Kind>(upcast).or(someB)).equals(const Some(_KindA()));
        check(noneA.map<_Kind>(upcast).or(noneB)).equals(const None<_KindB>());
      });
    });
  });
}
