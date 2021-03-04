import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'result.dart';
import 'tuple.dart';

/// An optional value.
///
/// An [Option] either contains a value ([Some]) or it does not ([None]).
///
/// ```
/// Option<int> multiply(String a, String b) {
///   return int.tryParse(a).asOption().and((a) {
///     return int.tryParse(b).asOption().map((b) => a * b);
///   });
/// }
/// ```
///
/// ```
/// print(multiply('2', '3')); // "Some(6)"
/// print(multiply('two', '3')); // "None"
/// ```
@sealed
@immutable
abstract class Option<T> extends Equatable {
  /// Creates a [Some] with the given [value], if it is not `null`, or a [None] otherwise.
  ///
  /// ```
  /// print(Option(2)); // "Some(2)"
  /// print(Option(null)); // "None"
  /// ```
  factory Option(T? value) => value != null ? Some(value) : None<T>();

  /// Creates a [Some] with the given [value].
  ///
  /// ```
  /// print(Option.some(2)); // "Some(2)"
  /// ```
  const factory Option.some(T value) = Some<T>;

  /// Creates a [None].
  ///
  /// ```
  /// print(Option.none()); // "None"
  /// ```
  const factory Option.none() = None<T>;

  const Option._();

  /// `true` if `this` is a [Some].
  ///
  /// ```
  /// print(Some(2).isSome); // "true"
  /// print(None().isSome); // "false"
  /// ```
  bool get isSome => this is Some;

  /// `true` if `this` is a [None].
  ///
  /// ```
  /// print(Some(2).isNone); // "false"
  /// print(None().isNone); // "true"
  /// ```
  bool get isNone => this is None;

  /// Returns an iterable over the possibly contained value.
  ///
  /// ```
  /// print(Some(2).iterable.length); // "1"
  /// print(None().iterable.length); // "0"
  /// ```
  Iterable<T> get iterable;

  /// Returns the contained value if `this` is a [Some], otherwise `null`.
  ///
  /// ```
  /// print(Some(2).asPlain()); // "2"
  /// print(None().asPlain()); // "null"
  /// ```
  T? asPlain();

  /// Returns `true` if `this` is a [Some] with the given [value].
  ///
  /// ```
  /// print(Some(2).contains(2)); // "true"
  /// print(Some(2).contains(3)); // "false"
  /// print(None().contains(2)); // "false"
  /// ```
  bool contains(T value) => this == Some(value);

  /// Executes [fn] if `this` is a [Some].
  ///
  /// ```
  /// Some(2).whenSome((_) => print('some')); // "some"
  /// None(2).whenSome((_) => print('some')); // Outputs nothing
  /// ```
  void whenSome(void Function(T value) fn);

  /// Executes [fn] if `this` is a [None].
  ///
  /// ```
  /// Some(2).whenNone((_) => print('none')); // Outputs nothing
  /// None(2).whenNone((_) => print('none')); // "none"
  /// ```
  void whenNone(void Function() fn);

  /// Applies mapping function [fSome] if `this` is a [Some] and [fNone] otherwise.
  ///
  /// ```
  /// print(Some(2).match((_) => 'some', () => 'none')); // "some"
  /// print(None().match((_) => 'some', () => 'none')); // "none"
  /// ```
  U match<U>(U Function(T value) fSome, U Function() fNone);

  /// Returns the contained value.
  ///
  /// If `this` is a [None], [ifNone] is called to compute a fallback value.
  ///
  /// Throws a [StateError] (with custom message [msg] if provided) if `this` is a [None] and
  /// [ifNone] is `null`.
  ///
  /// ```
  /// print(Some(2).unwrap()); // "2"
  /// print(None().unwrap()); // Throws a `StateError`
  /// ```
  T unwrap({String msg, T Function() ifNone});

  /// Expects `this` to be [None] and returns nothing.
  ///
  /// Throws a [StateError] (with custom message [msg] if provided) if `this` is a [Some].
  ///
  /// ```
  /// Some(2).unwrapNone(); // Throws a `StateError`
  /// None().unwrapNone(); // Does not throw
  /// ```
  void unwrapNone({String msg});

  /// Transforms the contained value, if any, by applying [map] to it.
  ///
  /// If `this` is a [None], and [ifNone] is not `null`, it is called to compute a fallback value.
  ///
  /// ```
  /// print(Some(2).map((_) => 'some')); // "Some(some)"
  /// print(None().map((_) => 'some')); // "None"
  /// ```
  Option<U> map<U>(U Function(T value) map, {U Function() ifNone});

  /// Transforms an [Option] into a [Result], mapping [Some] to [Ok] and [None] to [Err] using
  /// [ifNone].
  ///
  /// ```
  /// print(Some(2).okOr(() => 'none'); // "Ok(2)"
  /// print(None().okOr(() => 'none'); // "Err(none)"
  /// ```
  Result<T, E> okOr<E>(E Function() ifNone);

  /// Returns the result of calling [other] if `this` is a [Some], otherwise [None].
  ///
  /// ```
  /// print(Some(2).and((_) => Some(3)); // "Some(3)"
  /// print(None().and((_) => Some(3)); // "None"
  /// ```
  Option<U> and<U>(Option<U> Function(T value) other);

  /// Returns `this` unchanged if `this` is a [Some], otherwise the result of calling [other].
  ///
  /// ```
  /// print(Some(2).or((_) => Some(3)); // "Some(2)"
  /// print(None().or((_) => Some(3)); // "Some(3)"
  /// ```
  Option<T> or(Option<T> Function() other);

  /// Returns `this` unchanged if either, but not both, of `this` and [other] is a [Some], otherwise
  /// [None].
  ///
  /// ```
  /// print(Some(2).xor(Some(3)); // "None"
  /// print(Some(2).xor(None()); // "Some(2)"
  /// ```
  Option<T> xor(Option<T> other);

  /// Returns `this` unchanged if `this` is a [Some] and satisfies [condition], otherwise [None].
  ///
  /// ```
  /// print(Some(2).where((_) => true); // "Some(2)"
  /// print(Some(2).where((_) => false); // "None"
  /// ```
  Option<T> where(bool Function(T value) condition);

  /// Returns [Some] if `this` is a [Some] with a value of type [U], otherwise [None].
  ///
  /// ```
  /// print(Some(2).whereType<int>()); // "Some(2)"
  /// print(Some(2).whereType<bool>()); // "None"
  /// ```
  Option<U> whereType<U>();

  /// Returns [Some] with a [Tuple2] value if both `this` and the result of calling [other] are
  /// [Some], otherwise [None].
  ///
  /// ```
  /// print(Some(2).zip(Some('some')); // "Some(Tuple2(2, some))"
  /// print(Some(2).zip(None()); // "None"
  /// ```
  Option<Tuple2<T, U>> zip<U>(Option<U> Function(T value) other);

  /// Returns [Some] with the result of calling [zipper] if both `this` and the result of calling
  /// [other] are [Some], otherwise [None].
  ///
  /// ```
  /// print(Some(2).zipWith(Some(3), (a, b) => a + b); // "Some(5)"
  /// print(Some(2).zipWith(None(), (a, b) => a + b); // "None"
  /// ```
  Option<R> zipWith<U, R>(Option<U> Function(T value) other, R Function(T first, U second) zipper);

  /// Returns the string representation of `this`.
  ///
  /// Type information is included if [typeInfo] is `true`.
  ///
  /// ```
  /// print(Some<int>(2).toString()); // "Some(2)"
  /// print(None<int>().toString(true)); // "None<int>"
  /// ```
  @override
  String toString([bool typeInfo]);
}

/// An extension on any nullable object.
extension Optionable<T> on T? {
  /// Creates a [Some] with `this` as its value, if it is not `null`, or a [None] otherwise.
  ///
  /// ```
  /// print(2.asOption()); // "Some(2)"
  /// print(null.asOption()); // "None"
  /// ```
  Option<T> asOption() => Option(this);
}

/// An extension on [Option] containing a [Result].
extension OptionalResult<T, E> on Option<Result<T, E>> {
  /// Transposes an [Option] containing a [Result] into a [Result] containing an [Option].
  ///
  /// A [None] will be mapped to an [Ok] with a [None] value. A [Some] with an [Ok] value will be
  /// mapped to an [Ok] with a [Some] value, and a [Some] with an [Err] value will be mapped to an
  /// [Err].
  ///
  /// ```
  /// print(Some(Ok(2)).transpose()); // "Ok(Some(2))"
  /// print(Some(Err(2)).transpose()); // "Err(2)"
  /// ```
  Result<Option<T>, E> transpose() {
    return match(
      (value) => value.map((value) => Some(value)),
      () => Ok(None<T>()),
    );
  }
}

/// An extension on [Option] containing another [Option].
extension OptionalOption<T> on Option<Option<T>> {
  /// Flattens an [Option] containing another [Option].
  ///
  /// The flattening operation is only ever a single level deep.
  ///
  /// ```
  /// print(Some(Some(2)).flatten()); // "Some(2)"
  /// print(Some(None()).flatten()); // "None"
  /// ```
  Option<T> flatten() => match((value) => value, () => None<T>());
}

/// An [Option] with a value.
@sealed
class Some<T> extends Option<T> {
  /// The contained value.
  ///
  /// ```
  /// print(Some(2).value); // "2"
  /// ```
  final T value;

  /// Creates an [Option] with the given [value].
  ///
  /// ```
  /// print(Some(2)); // "Some(2)"
  /// ```
  const Some(this.value) : super._();

  @override
  List<T> get props => [value];

  @override
  Iterable<T> get iterable => Iterable<T>.generate(1, (index) => value);

  @override
  T asPlain() => value;

  @override
  void whenSome(void Function(T value) fn) => fn(value);

  @override
  void whenNone(void Function() fn) {}

  @override
  U match<U>(U Function(T value) fSome, U Function() fNone) => fSome(value);

  @override
  T unwrap({String? msg, T Function()? ifNone}) => value;

  @override
  void unwrapNone({String? msg}) {
    throw StateError('${msg ?? 'called `Option.unwrapNone()` on a `Some`'}: $value');
  }

  @override
  Some<U> map<U>(U Function(T value) map, {U Function()? ifNone}) => Some(map(value));

  @override
  Result<T, E> okOr<E>(E Function() ifNone) => Ok(value);

  @override
  Option<U> and<U>(Option<U> Function(T value) other) => other(value);

  @override
  Some<T> or(Option<T> Function() other) => this;

  @override
  Option<T> xor(Option<T> other) => other is None ? this : None<T>();

  @override
  Option<T> where(bool Function(T value) condition) => condition(value) ? this : None<T>();

  @override
  Option<U> whereType<U>() => value is U ? Some(value as U) : None<U>();

  @override
  Option<Tuple2<T, U>> zip<U>(Option<U> Function(T value) other) {
    return other(value).match(
      (otherValue) => Some(Tuple2(value, otherValue)),
      () => None<Tuple2<T, U>>(),
    );
  }

  @override
  Option<R> zipWith<U, R>(Option<U> Function(T value) other, R Function(T first, U second) zipper) {
    return other(value).match(
      (otherValue) => Some(zipper(value, otherValue)),
      () => None<R>(),
    );
  }

  @override
  String toString([bool typeInfo = false]) => 'Some${typeInfo ? '<$T>' : ''}($value)';
}

/// An [Option] with no value.
@sealed
class None<T> extends Option<T> {
  /// Creates an [Option] with no value.
  ///
  /// ```
  /// print(None()); // "None"
  /// ```
  const None() : super._();

  @override
  List<Never> get props => [];

  @override
  Iterable<T> get iterable => Iterable<T>.empty();

  @override
  Null asPlain() => null;

  @override
  void whenSome(void Function(T value) fn) {}

  @override
  void whenNone(void Function() fn) => fn();

  @override
  U match<U>(U Function(T value) fSome, U Function() fNone) => fNone();

  @override
  T unwrap({String? msg, T Function()? ifNone}) {
    if (ifNone != null) {
      return ifNone();
    }

    throw StateError(msg ?? 'called `Option.unwrap()` on a `None`');
  }

  @override
  void unwrapNone({String? msg}) {}

  @override
  Option<U> map<U>(U Function(T value) map, {U Function()? ifNone}) {
    return ifNone != null ? Some(ifNone()) : None<U>();
  }

  @override
  Result<T, E> okOr<E>(E Function() ifNone) => Err(ifNone());

  @override
  None<U> and<U>(Option<U> Function(T value) other) => None<U>();

  @override
  Option<T> or(Option<T> Function() other) => other();

  @override
  Option<T> xor(Option<T> other) => other is Some ? other : this;

  @override
  None<T> where(bool Function(T value) condition) => this;

  @override
  None<U> whereType<U>() => None<U>();

  @override
  None<Tuple2<T, U>> zip<U>(Option<U> Function(T value) other) => None<Tuple2<T, U>>();

  @override
  None<R> zipWith<U, R>(Option<U> Function(T value) other, R Function(T first, U second) zipper) {
    return None<R>();
  }

  @override
  String toString([bool typeInfo = false]) => 'None${typeInfo ? '<$T>' : ''}';
}
