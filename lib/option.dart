import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'result.dart';
import 'tuple.dart';

/// An optional value.
///
/// An [Option] either contains a value ([Some]) or it does not ([None]).
///
/// # Examples
///
/// The following function tries to multiply two integers after parsing them.
/// Upon success, the resulting value is wrapped in a [Some].
/// If an error occurs during conversion, a [None] is returned.
///
/// ```dart
/// Future<Option<int>> multiply(String a, String b) {
///   return int.tryParse(a).asOption().and((a) {
///     return int.tryParse(b).asOption().map((b) => a * b);
///   });
/// }
/// ```
///
/// That function can now be used to try and multiply two integers encoded as strings and returning
/// [None] if that operation is not possible due to a conversion error.
///
/// ```dart
/// print(await multiply('2', '3')); // "Some(6)"
/// print(await multiply('two', '3')); // "None"
/// ```
@sealed
@immutable
abstract class Option<T> extends Equatable {
  /// Creates a [Some] with the given [value], if it is not `null`, or a [None] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Option(2)); // "Some(2)"
  /// print(Option(null)); // "None"
  /// ```
  factory Option(T? value) => value != null ? Some(value) : None<T>();

  /// Creates a [Some] with the given [value].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Option.some(2)); // "Some(2)"
  /// ```
  const factory Option.some(T value) = Some<T>;

  /// Creates a [None].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Option.none()); // "None"
  /// ```
  const factory Option.none() = None<T>;

  const Option._();

  /// `true` if `this` is a [Some].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Some(2).isSome); // "true"
  /// print(None().isSome); // "false"
  /// ```
  bool get isSome => this is Some;

  /// `true` if `this` is a [None].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Some(2).isNone); // "false"
  /// print(None().isNone); // "true"
  /// ```
  bool get isNone => this is None;

  /// Returns an iterable over the possibly contained value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Some(2).iterable.length); // "1"
  /// print(None().iterable.length); // "0"
  /// ```
  Iterable<T> get iterable;

  /// Returns the contained value if `this` is a [Some], otherwise `null`.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Some(2).asPlain()); // "2"
  /// print(None().asPlain()); // "null"
  /// ```
  T? asPlain();

  /// Returns `true` if `this` is a [Some] with the given [value].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Some(2).contains(2)); // "true"
  /// print(Some(2).contains(3)); // "false"
  /// print(None().contains(2)); // "false"
  /// ```
  bool contains(T value) => this == Some(value);

  /// Executes [fn] if `this` is a [Some].
  ///
  /// See [whenSomeSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For a [Some], [fn] is called with the contained value.
  ///
  /// ```dart
  /// await Some(2).whenSome((_) => print('some')); // "some"
  /// ```
  ///
  /// For a [None], [fn] is never called.
  ///
  /// ```dart
  /// await None(2).whenSome((_) => print('some')); // Outputs nothing
  /// ```
  Future<void> whenSome(FutureOr<void> Function(T value) fn);

  /// Executes [fn] if `this` is a [Some].
  ///
  /// See [whenSome] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For a [Some], [fn] is called with the contained value.
  ///
  /// ```dart
  /// Some(2).whenSomeSync((_) => print('some')); // "some"
  /// ```
  ///
  /// For a [None], [fn] is never called.
  ///
  /// ```dart
  /// None(2).whenSomeSync((_) => print('some')); // Outputs nothing
  /// ```
  void whenSomeSync(void Function(T value) fn);

  /// Executes [fn] if `this` is a [None].
  ///
  /// See [whenNoneSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For a [Some], [fn] is never called.
  ///
  /// ```dart
  /// await Some(2).whenNone(() => print('none')); // Outputs nothing
  /// ```
  ///
  /// For a [None], [fn] is called.
  ///
  /// ```dart
  /// await None(2).whenNone(() => print('none')); // "none"
  /// ```
  Future<void> whenNone(FutureOr<void> Function() fn);

  /// Executes [fn] if `this` is a [None].
  ///
  /// See [whenNone] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For a [Some], [fn] is never called.
  ///
  /// ```dart
  /// Some(2).whenNoneSync(() => print('none')); // Outputs nothing
  /// ```
  ///
  /// For a [None], [fn] is called.
  ///
  /// ```dart
  /// None(2).whenNoneSync(() => print('none')); // "none"
  /// ```
  void whenNoneSync(void Function() fn);

  /// Applies mapping function [fSome] if `this` is a [Some] and [fNone] otherwise.
  ///
  /// See [matchSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For a [Some], [fSome] is called with the contained value.
  ///
  /// ```dart
  /// print(await Some(2).match((_) => 'some', () => 'none')); // "some"
  /// ```
  ///
  /// For a [None], [fNone] is called.
  ///
  /// ```dart
  /// print(await None().match((_) => 'some', () => 'none')); // "none"
  /// ```
  Future<U> match<U>(FutureOr<U> Function(T value) fSome, FutureOr<U> Function() fNone);

  /// Applies mapping function [fSome] if `this` is a [Some] and [fNone] otherwise.
  ///
  /// See [match] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For a [Some], [fSome] is called with the contained value.
  ///
  /// ```dart
  /// print(Some(2).matchSync((_) => 'some', () => 'none')); // "some"
  /// ```
  ///
  /// For a [None], [fNone] is called.
  ///
  /// ```dart
  /// print(None().matchSync((_) => 'some', () => 'none')); // "none"
  /// ```
  U matchSync<U>(U Function(T value) fSome, U Function() fNone);

  /// Returns the contained value.
  ///
  /// See [unwrapSync] for a synchronous version of this funcion.
  ///
  /// If `this` is a [None], [ifNone] is called to compute a fallback value.
  ///
  /// # Throws
  ///
  /// Throws a [StateError] (with custom message [msg] if provided) if `this` is a [None] and
  /// [ifNone] is `null`.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(await Some(2).unwrap()); // "2"
  /// print(await None().unwrap()); // Throws a `StateError`
  /// ```
  Future<T> unwrap({String msg, FutureOr<T> Function() ifNone});

  /// Returns the contained value.
  ///
  /// See [unwrap] for an asynchronous version of this funcion.
  ///
  /// If `this` is a [None], [ifNone] is called to compute a fallback value.
  ///
  /// # Throws
  ///
  /// Throws a [StateError] (with custom message [msg] if provided) if `this` is a [None] and
  /// [ifNone] is `null`.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Some(2).unwrapSync()); // "2"
  /// print(None().unwrapSync()); // Throws a `StateError`
  /// ```
  T unwrapSync({String msg, T Function() ifNone});

  /// Expects `this` to be [None] and returns nothing.
  ///
  /// # Throws
  ///
  /// Throws a [StateError] (with custom message [msg] if provided) if `this` is a [Some].
  ///
  /// # Examples
  ///
  /// ```dart
  /// Some(2).unwrapNone(); // Throws a `StateError`
  /// None().unwrapNone(); // Does not throw
  /// ```
  void unwrapNone({String msg});

  /// Transforms the contained value, if any, by applying [map] to it.
  ///
  /// If `this` is a [None], and [ifNone] is not `null`, it is called to compute a fallback value.
  ///
  /// See [mapSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For a [Some], [map] is called with the contained value.
  ///
  /// ```dart
  /// print(await Some(2).map((_) => 'some')); // "Some(some)"
  /// ```
  ///
  /// For a [None], [map] is never called.
  ///
  /// ```dart
  /// print(await None().map((_) => 'some')); // "None"
  /// ```
  Future<Option<U>> map<U>(
    FutureOr<U> Function(T value) map, {
    FutureOr<U> Function() ifNone,
  });

  /// Transforms the contained value, if any, by applying [map] to it.
  ///
  /// If `this` is a [None], and [ifNone] is not `null`, it is called to compute a fallback value.
  ///
  /// See [map] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For a [Some], [map] is called with the contained value.
  ///
  /// ```dart
  /// print(Some(2).mapSync((_) => 'some')); // "Some(some)"
  /// ```
  ///
  /// For a [None], [map] is never called.
  ///
  /// ```dart
  /// print(None().mapSync((_) => 'some')); // "None"
  /// ```
  Option<U> mapSync<U>(U Function(T value) map, {U Function() ifNone});

  /// Transforms an [Option] into a [Result], mapping [Some] to [Ok] and [None] to [Err] using
  /// [ifNone].
  ///
  /// See [okOrSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(await Some(2).okOr(() => 'none'); // "Ok(2)"
  /// print(await None().okOr(() => 'none'); // "Err(none)"
  /// ```
  Future<Result<T, E>> okOr<E>(FutureOr<E> Function() ifNone);

  /// Transforms an [Option] into a [Result], mapping [Some] to [Ok] and [None] to [Err] using
  /// [ifNone].
  ///
  /// See [okOr] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Some(2).okOrSync(() => 'none'); // "Ok(2)"
  /// print(None().okOrSync(() => 'none'); // "Err(none)"
  /// ```
  Result<T, E> okOrSync<E>(E Function() ifNone);

  /// Returns the result of calling [other] if `this` is a [Some], otherwise [None].
  ///
  /// See [andSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For a [Some], [other] is called with the contained value.
  ///
  /// ```dart
  /// print(await Some(2).and((_) => Some(3)); // "Some(3)"
  /// ```
  ///
  /// For a [None], [other] is never called.
  ///
  /// ```dart
  /// print(await None().and((_) => Some(3)); // "None"
  /// ```
  Future<Option<U>> and<U>(FutureOr<Option<U>> Function(T value) other);

  /// Returns the result of calling [other] if `this` is a [Some], otherwise [None].
  ///
  /// See [and] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For a [Some], [other] is called with the contained value.
  ///
  /// ```dart
  /// print(Some(2).andSync((_) => Some(3)); // "Some(3)"
  /// ```
  ///
  /// For a [None], [other] is never called.
  ///
  /// ```dart
  /// print(None().andSync((_) => Some(3)); // "None"
  /// ```
  Option<U> andSync<U>(Option<U> Function(T value) other);

  /// Returns `this` unchanged if `this` is a [Some], otherwise the result of calling [other].
  ///
  /// See [orSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For a [Some], [other] is never called.
  ///
  /// ```dart
  /// print(await Some(2).or((_) => Some(3)); // "Some(2)"
  /// ```
  ///
  /// For a [None], [other] is called.
  ///
  /// ```dart
  /// print(await None().or((_) => Some(3)); // "Some(3)"
  /// ```
  Future<Option<T>> or(FutureOr<Option<T>> Function() other);

  /// Returns `this` unchanged if `this` is a [Some], otherwise the result of calling [other].
  ///
  /// See [or] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For a [Some], [other] is never called.
  ///
  /// ```dart
  /// print(Some(2).orSync((_) => Some(3)); // "Some(2)"
  /// ```
  ///
  /// For a [None], [other] is called.
  ///
  /// ```dart
  /// print(None().orSync((_) => Some(3)); // "Some(3)"
  /// ```
  Option<T> orSync(Option<T> Function() other);

  /// Returns `this` unchanged if either, but not both, of `this` and [other] is a [Some], otherwise
  /// [None].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Some(2).xor(Some(3)); // "None"
  /// print(Some(2).xor(None()); // "Some(2)"
  /// ```
  Option<T> xor(Option<T> other);

  /// Returns `this` unchanged if `this` is a [Some] and satisfies [condition], otherwise [None].
  ///
  /// See [whereSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(await Some(2).where((_) => true); // "Some(2)"
  /// print(await Some(2).where((_) => false); // "None"
  /// ```
  Future<Option<T>> where(FutureOr<bool> Function(T value) condition);

  /// Returns `this` unchanged if `this` is a [Some] and satisfies [condition], otherwise [None].
  ///
  /// See [where] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Some(2).whereSync((_) => true); // "Some(2)"
  /// print(Some(2).whereSync((_) => false); // "None"
  /// ```
  Option<T> whereSync(bool Function(T value) condition);

  /// Returns [Some] if `this` is a [Some] with a value of type [U], otherwise [None].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Some(2).whereType<int>()); // "Some(2)"
  /// print(Some(2).whereType<bool>()); // "None"
  /// ```
  Option<U> whereType<U>();

  /// Returns [Some] with a [Tuple2] value if both `this` and the result of calling [other] are
  /// [Some], otherwise [None].
  ///
  /// See [zipSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(await Some(2).zip(Some('some')); // "Some(Tuple2(2, some))"
  /// print(await Some(2).zip(None()); // "None"
  /// ```
  Future<Option<Tuple2<T, U>>> zip<U>(FutureOr<Option<U>> Function(T value) other);

  /// Returns [Some] with a [Tuple2] value if both `this` and the result of calling [other] are
  /// [Some], otherwise [None].
  ///
  /// See [zip] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Some(2).zipSync(Some('some')); // "Some(Tuple2(2, some))"
  /// print(Some(2).zipSync(None()); // "None"
  /// ```
  Option<Tuple2<T, U>> zipSync<U>(Option<U> Function(T value) other);

  /// Returns [Some] with the result of calling [zipper] if both `this` and the result of calling
  /// [other] are [Some], otherwise [None].
  ///
  /// See [zipWithSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(await Some(2).zipWith(Some(3), (a, b) => a + b); // "Some(5)"
  /// print(await Some(2).zipWith(None(), (a, b) => a + b); // "None"
  /// ```
  Future<Option<R>> zipWith<U, R>(
    FutureOr<Option<U>> Function(T value) other,
    FutureOr<R> Function(T first, U second) zipper,
  );

  /// Returns [Some] with the result of calling [zipper] if both `this` and the result of calling
  /// [other] are [Some], otherwise [None].
  ///
  /// See [zipWith] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Some(2).zipWithSync(Some(3), (a, b) => a + b); // "Some(5)"
  /// print(Some(2).zipWithSync(None(), (a, b) => a + b); // "None"
  /// ```
  Option<R> zipWithSync<U, R>(
    Option<U> Function(T value) other,
    R Function(T first, U second) zipper,
  );

  /// Returns the string representation of `this`.
  ///
  /// Type information is included if [typeInfo] is `true`.
  ///
  /// # Examples
  ///
  /// ```dart
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
  /// # Examples
  ///
  /// ```dart
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
  /// # Examples
  ///
  /// ```dart
  /// print(await Some(Ok(2)).transpose()); // "Ok(Some(2))"
  /// print(await Some(Err(2)).transpose()); // "Err(2)"
  /// ```
  Result<Option<T>, E> transpose() {
    return matchSync(
      (value) => value.mapSync((value) => Some(value)),
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
  /// # Examples
  ///
  /// ```dart
  /// print(Some(Some(2)).flatten()); // "Some(2)"
  /// print(Some(None()).flatten()); // "None"
  /// ```
  Option<T> flatten() => matchSync((value) => value, () => None<T>());
}

/// An [Option] with a value.
@sealed
class Some<T> extends Option<T> {
  /// The contained value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Some(2).value); // "2"
  /// ```
  final T value;

  /// Creates an [Option] with the given [value].
  ///
  /// # Examples
  ///
  /// ```dart
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
  Future<void> whenSome(FutureOr<void> Function(T value) fn) async => fn(value);

  @override
  void whenSomeSync(void Function(T value) fn) => fn(value);

  @override
  Future<void> whenNone(FutureOr<void> Function() fn) async {}

  @override
  void whenNoneSync(void Function() fn) {}

  @override
  Future<U> match<U>(FutureOr<U> Function(T value) fSome, FutureOr<U> Function() fNone) async {
    return fSome(value);
  }

  @override
  U matchSync<U>(U Function(T value) fSome, U Function() fNone) => fSome(value);

  @override
  Future<T> unwrap({
    String? msg,
    FutureOr<T> Function()? ifNone,
  }) async =>
      value;

  @override
  T unwrapSync({String? msg, T Function()? ifNone}) => value;

  @override
  void unwrapNone({String? msg}) {
    throw StateError(
      '${msg ?? 'tried to unwrap `Some` as `None`'}: $value',
    );
  }

  @override
  Future<Some<U>> map<U>(
    FutureOr<U> Function(T value) map, {
    FutureOr<U> Function()? ifNone,
  }) async {
    return Some(await map(value));
  }

  @override
  Some<U> mapSync<U>(U Function(T value) map, {U Function()? ifNone}) {
    return Some(map(value));
  }

  @override
  Future<Result<T, E>> okOr<E>(FutureOr<E> Function() ifNone) async {
    return Ok(value);
  }

  @override
  Result<T, E> okOrSync<E>(E Function() ifNone) => Ok(value);

  @override
  Future<Option<U>> and<U>(FutureOr<Option<U>> Function(T value) other) async {
    return other(value);
  }

  @override
  Option<U> andSync<U>(Option<U> Function(T value) other) => other(value);

  @override
  Future<Some<T>> or(FutureOr<Option<T>> Function() other) async => this;

  @override
  Some<T> orSync(Option<T> Function() other) => this;

  @override
  Option<T> xor(Option<T> other) => other is None ? this : None<T>();

  @override
  Future<Option<T>> where(FutureOr<bool> Function(T value) condition) async {
    return await condition(value) ? this : None<T>();
  }

  @override
  Option<T> whereSync(bool Function(T value) condition) {
    return condition(value) ? this : None<T>();
  }

  @override
  Option<U> whereType<U>() => value is U ? Some(value as U) : None<U>();

  @override
  Future<Option<Tuple2<T, U>>> zip<U>(FutureOr<Option<U>> Function(T value) other) async {
    return (await other(value)).match(
      (otherValue) => Some(Tuple2(value, otherValue)),
      () => None<Tuple2<T, U>>(),
    );
  }

  @override
  Option<Tuple2<T, U>> zipSync<U>(Option<U> Function(T value) other) {
    return other(value).matchSync(
      (otherValue) => Some(Tuple2(value, otherValue)),
      () => None<Tuple2<T, U>>(),
    );
  }

  @override
  Future<Option<R>> zipWith<U, R>(
    FutureOr<Option<U>> Function(T value) other,
    FutureOr<R> Function(T first, U second) zipper,
  ) async {
    return (await other(value)).match(
      (otherValue) async => Some(await zipper(value, otherValue)),
      () => None<R>(),
    );
  }

  @override
  Option<R> zipWithSync<U, R>(
    Option<U> Function(T value) other,
    R Function(T first, U second) zipper,
  ) {
    return other(value).matchSync(
      (otherValue) => Some(zipper(value, otherValue)),
      () => None<R>(),
    );
  }

  @override
  String toString([bool typeInfo = false]) {
    return 'Some${typeInfo ? '<$T>' : ''}($value)';
  }
}

/// An [Option] with no value.
@sealed
class None<T> extends Option<T> {
  /// Creates an [Option] with no value.
  ///
  /// # Examples
  ///
  /// ```dart
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
  Future<void> whenSome(FutureOr<void> Function(T value) fn) async {}

  @override
  void whenSomeSync(void Function(T value) fn) {}

  @override
  Future<void> whenNone(FutureOr<void> Function() fn) async => fn();

  @override
  void whenNoneSync(void Function() fn) => fn();

  @override
  Future<U> match<U>(FutureOr<U> Function(T value) fSome, FutureOr<U> Function() fNone) async {
    return fNone();
  }

  @override
  U matchSync<U>(U Function(T value) fSome, U Function() fNone) => fNone();

  @override
  Future<T> unwrap({String? msg, FutureOr<T> Function()? ifNone}) async {
    if (ifNone != null) {
      return ifNone();
    }

    throw StateError(msg ?? 'tried to unwrap `None` as `Some`');
  }

  @override
  T unwrapSync({String? msg, T Function()? ifNone}) {
    if (ifNone != null) {
      return ifNone();
    }

    throw StateError(msg ?? 'tried to unwrap `None` as `Some`');
  }

  @override
  void unwrapNone({String? msg}) {}

  @override
  Future<Option<U>> map<U>(
    FutureOr<U> Function(T value) map, {
    FutureOr<U> Function()? ifNone,
  }) async {
    return ifNone != null ? Some(await ifNone()) : None<U>();
  }

  @override
  Option<U> mapSync<U>(U Function(T value) map, {U Function()? ifNone}) {
    return ifNone != null ? Some(ifNone()) : None<U>();
  }

  @override
  Future<Result<T, E>> okOr<E>(FutureOr<E> Function() ifNone) async {
    return Err(await ifNone());
  }

  @override
  Result<T, E> okOrSync<E>(E Function() ifNone) => Err(ifNone());

  @override
  Future<None<U>> and<U>(FutureOr<Option<U>> Function(T value) other) async {
    return None<U>();
  }

  @override
  None<U> andSync<U>(Option<U> Function(T value) other) => None<U>();

  @override
  Future<Option<T>> or(FutureOr<Option<T>> Function() other) async => other();

  @override
  Option<T> orSync(Option<T> Function() other) => other();

  @override
  Option<T> xor(Option<T> other) => other is Some ? other : this;

  @override
  Future<None<T>> where(FutureOr<bool> Function(T value) condition) async {
    return this;
  }

  @override
  None<T> whereSync(bool Function(T value) condition) => this;

  @override
  None<U> whereType<U>() => None<U>();

  @override
  Future<None<Tuple2<T, U>>> zip<U>(FutureOr<Option<U>> Function(T value) other) async {
    return None<Tuple2<T, U>>();
  }

  @override
  None<Tuple2<T, U>> zipSync<U>(Option<U> Function(T value) other) {
    return None<Tuple2<T, U>>();
  }

  @override
  Future<None<R>> zipWith<U, R>(
    FutureOr<Option<U>> Function(T value) other,
    FutureOr<R> Function(T first, U second) zipper,
  ) async {
    return None<R>();
  }

  @override
  None<R> zipWithSync<U, R>(
    Option<U> Function(T value) other,
    R Function(T first, U second) zipper,
  ) {
    return None<R>();
  }

  @override
  String toString([bool typeInfo = false]) => 'None${typeInfo ? '<$T>' : ''}';
}
