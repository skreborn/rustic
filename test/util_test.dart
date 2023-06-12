import 'package:rustic/result.dart';
import 'package:checks/checks.dart';
import 'package:rustic/util.dart';
import 'package:test/test.dart';

sealed class _Ok {
  const _Ok();
}

final class _OkA extends _Ok {
  const _OkA();
}

final class _OkB extends _Ok {
  const _OkB();
}

sealed class _Err {
  const _Err();
}

final class _ErrA extends _Err {
  const _ErrA();
}

final class _ErrB extends _Err {
  const _ErrB();
}

void main() {
  group('utilities', () {
    test('upcast', () {
      const okA = Ok<_OkA, _ErrA>(_OkA());
      const okB = Ok<_OkB, _ErrB>(_OkB());

      const errA = Err<_OkA, _ErrA>(_ErrA());
      const errB = Err<_OkB, _ErrB>(_ErrB());

      final chain = okA.or(errA).mapErr<_Err>(upcast).and(okB).map<_Ok>(upcast).or(errB);

      check(chain).equals(const Ok(_OkB()));
    });
  });
}
