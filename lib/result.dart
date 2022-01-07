import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'option.dart';

/// Short-circuits the enclosing [Result.collect()] if [result] is an [Err].
typedef Checker<E> = T Function<T>(Result<T, E> result);

/// Optionally maps an arbitrary exception [ex] to an [Err].
typedef ExceptionMapper<T, E> = Option<Err<T, E>> Function(Exception ex);

@immutable
class _CheckException<T, E> implements Exception {
  final Err<T, E> err;

  const _CheckException(this.err);
}

/// The result of an operation.
///
/// A [Result] is either successful ([Ok]) or erroneous ([Err]).
///
/// # Examples
///
/// The following function tries to parse an integer.
/// Upon success, the resulting value is wrapped in an [Ok].
/// If an error occurs during conversion, an [Err] is returned.
///
/// ```dart
/// Result<int, String> tryParse(String source) {
///   return Ok<int?, String>(int.tryParse(source)).and((value) {
///     return value == null ? Err('not a number: $source') : Ok(value);
///   });
/// }
/// ```
///
/// That function can now be used to try and parse an integer, and return with a
/// helpful error in case of failure.
///
/// ```dart
/// print(tryParse('2')); // "Ok(2)"
/// print(tryParse('two')); // "Err(not a number: two)"
/// ```
@sealed
@immutable
abstract class Result<T, E> extends Equatable {
  /// Creates an [Ok] with the given [value].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Result.ok(2)); // "Ok(2)"
  /// ```
  const factory Result.ok(T value) = Ok<T, E>;

  /// Creates an [Err] with the given [error].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Result.err(2)); // "Err(2)"
  /// ```
  const factory Result.err(E error) = Err<T, E>;

  /// Encloses any number of operations, optionally returning early on failure.
  ///
  /// [collector] provides a [Checker] that allows for an early return in case
  /// of a failure.
  ///
  /// # Examples
  ///
  /// ```dart
  /// final collected = Result.collect<int, String>((check) {
  ///   String mapErr(int error) => error.toString();
  ///
  ///   // This passes the check and `first` gets the value `2`
  ///   final first = check(Ok<int, int>(2).mapErr(mapErr));
  ///
  ///   // This fails the check and the error is returned from the collector
  ///   final second = check(Err<int, int>(3).mapErr(mapErr));
  ///
  ///   // This is never reached
  ///   return Ok(first + second);
  /// });
  ///
  /// print(collected); // "Err(3)"
  /// ```
  factory Result.collect(Result<T, E> Function(Checker<E> check) collector) {
    try {
      return collector(<U>(result) {
        return result.match(
          (value) => value,
          (error) => throw _CheckException<T, E>(Err(error)),
        );
      });
    } on _CheckException<T, E> catch (error) {
      return error.err;
    }
  }

  /// Executes [fn] that might throw an [Exception].
  ///
  /// [mapEx] optionally maps an [Exception] to an [Err]. Unhandled exceptions
  /// are rethrown unchanged.
  ///
  /// # Examples
  ///
  /// ```dart
  /// final caught = Result.catchException<int, String>(() {
  ///   return int.parse('II');
  /// }, (ex) {
  ///   if (ex is FormatException) {
  ///     return Some(Err('fail: ${ex.source}'));
  ///   }
  ///
  ///   return None();
  /// });
  ///
  /// print(caught); // "Err(fail: II)"
  /// ```
  factory Result.catchException(T Function() fn, ExceptionMapper<T, E> mapEx) {
    try {
      return Ok(fn());
    } on Exception catch (ex) {
      final result = mapEx(ex);

      if (result is Some<Err<T, E>>) {
        return result.value;
      }

      rethrow;
    }
  }

  const Result._();

  /// `true` if `this` is an [Ok].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(2).isOk); // "true"
  /// print(Err(2).isOk); // "false"
  /// ```
  bool get isOk => this is Ok;

  /// True if `this` is an [Err].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(2).isErr); // "false"
  /// print(Err(2).isErr); // "true"
  /// ```
  bool get isErr => this is Err;

  /// Returns an iterable over the possibly contained value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(2).iterable.length); // "1"
  /// print(Err(2).iterable.length); // "0"
  /// ```
  Iterable<T> get iterable;

  /// Returns `true` if `this` is an [Ok] with the given [value].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(2).contains(2)); // "true"
  /// print(Ok(2).contains(3)); // "false"
  /// print(Err(2).contains(2)); // "false"
  /// ```
  bool contains(T value) => this == Ok<T, E>(value);

  /// Returns `true` if `this` is an [Err] with the given [error].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Err(2).containsErr(2)); // "true"
  /// print(Err(2).containsErr(3)); // "false"
  /// print(Ok(2).containsErr(2)); // "false"
  /// ```
  bool containsErr(E error) => this == Err<T, E>(error);

  /// Executes [fn] if `this` is an [Ok].
  ///
  /// # Examples
  ///
  /// For an [Ok], [fn] is called with the contained value.
  ///
  /// ```dart
  /// Ok(2).whenOk((_) => print('ok')); // "ok"
  /// ```
  ///
  /// For an [Err], [fn] is never called.
  ///
  /// ```dart
  /// Err(2).whenOk((_) => print('ok')); // Outputs nothing
  /// ```
  void whenOk(void Function(T value) fn);

  /// Executes [fn] if `this` is an [Err].
  ///
  /// # Examples
  ///
  /// For an [Ok], [fn] is never called.
  ///
  /// ```dart
  /// Ok(2).whenErr((_) => print('err')); // Outputs nothing
  /// ```
  ///
  /// For an [Err], [fn] is called with the contained error.
  ///
  /// ```dart
  /// Err(2).whenErr((_) => print('err')); // "err"
  /// ```
  void whenErr(void Function(E error) fn);

  /// Applies mapping function [fOk] if `this` is an [Ok] and [fErr] otherwise.
  ///
  /// # Examples
  ///
  /// For an [Ok], [fOk] is called with the contained value.
  ///
  /// ```dart
  /// print(Ok(2).match((_) => 'ok', (_) => 'err')); // "ok"
  /// ```
  ///
  /// For an [Err], [fErr] is called with the contained error.
  ///
  /// ```dart
  /// print(Err(2).match((_) => 'ok', (_) => 'err')); // "err"
  /// ```
  U match<U>(U Function(T value) fOk, U Function(E error) fErr);

  /// The possibly contained value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(2).ok); // "Some(2)"
  /// print(Err(2).ok); // "None"
  /// ```
  Option<T> get ok;

  /// The possibly contained error.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(2).err); // "None"
  /// print(Err(2).err); // "Some(2)"
  /// ```
  Option<E> get err;

  /// Returns the contained value.
  ///
  /// If `this` is an [Err], [ifErr] is called to compute a fallback value.
  ///
  /// # Throws
  ///
  /// Throws a [StateError] (with custom message [msg] if provided) if `this` is
  /// an [Err] and [ifErr] is `null`.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(2).unwrap()); // "2"
  /// print(Err(2).unwrap()); // Throws a `StateError`
  /// ```
  T unwrap({String msg, T Function(E error) ifErr});

  /// Returns the contained error.
  ///
  /// If `this` is an [Ok], [ifOk] is called to compute a fallback value.
  ///
  /// # Throws
  ///
  /// Throws a [StateError] (with custom message [msg] if provided) if `this` is
  /// an [Ok] and [ifOk] is `null`.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(2).unwrapErr()); // Throws a `StateError`
  /// print(Err(2).unwrapErr()); // "2"
  /// ```
  E unwrapErr({String msg, E Function(T value) ifOk});

  /// Transforms the contained value, if any, by applying [map] to it.
  ///
  /// If `this` is an [Err], and [ifErr] is not `null`, it is called to compute
  /// a fallback value.
  ///
  /// # Examples
  ///
  /// For an [Ok], [map] is called with the contained value.
  ///
  /// ```dart
  /// print(Ok(2).map((_) => 'ok')); // "Ok(ok)"
  /// ```
  ///
  /// For an [Err], [map] is never called.
  ///
  /// ```dart
  /// print(Err(2).map((_) => 'ok')); // "Err(2)"
  /// ```
  Result<U, E> map<U>(U Function(T value) map, {U Function(E error) ifErr});

  /// Transforms the contained error, if any, by applying [map] to it.
  ///
  /// If `this` is an [Ok], and [ifOk] is not `null`, it is called to compute a
  /// fallback value.
  ///
  /// # Examples
  ///
  /// For an [Ok], [map] is never called.
  ///
  /// ```dart
  /// print(Ok(2).mapErr((_) => 'err')); // "Ok(2)"
  /// ```
  ///
  /// For an [Err], [map] is called with the contained error.
  ///
  /// ```dart
  /// print(Err(2).mapErr((_) => 'err')); // "Err('err')"
  /// ```
  Result<T, F> mapErr<F>(F Function(E error) map, {F Function(T value) ifOk});

  /// Returns the result of calling [other] if `this` is an [Ok], otherwise
  /// [Err].
  ///
  /// # Examples
  ///
  /// For an [Ok], [other] is called with the contained value.
  ///
  /// ```dart
  /// print(Ok(2).and((_) => Ok(3)); // "Ok(3)"
  /// ```
  ///
  /// For an [Err], [other] is never called.
  ///
  /// ```dart
  /// print(Err(2).and((_) => Ok(3)); // "Err(2)"
  /// ```
  Result<U, E> and<U>(Result<U, E> Function(T value) other);

  /// Returns [Ok] if `this` is an [Ok], otherwise the result of calling
  /// [other].
  ///
  /// # Examples
  ///
  /// For an [Ok], [other] is never called.
  ///
  /// ```dart
  /// print(Ok(2).or((_) => Ok(3)); // "Ok(2)"
  /// ```
  ///
  /// For an [Err], [other] is called with the contained error.
  ///
  /// ```dart
  /// print(Err(2).or((_) => Ok(3)); // "Ok(3)"
  /// ```
  Result<T, F> or<F>(Result<T, F> Function(E error) other);

  /// Returns the string representation of `this`.
  ///
  /// Type information is included if [typeInfo] is `true`.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok<int, String>(2).toString()); // "Ok(2)"
  /// print(Err<int, String>('2').toString(true)); // "Err<int, String>(2)"
  /// ```
  @override
  String toString([bool typeInfo]);
}

/// An extension on [Result] that is guaranteed to be an [Ok].
extension OkResult<T> on Result<T, Never> {
  /// Returns the contained value.
  ///
  /// Unlike [Result.unwrap()], this method is known to never throw because the
  /// error variant cannot possibly be instantiated.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(2).value); // "2"
  /// ```
  T get value => ok.unwrap();
}

/// An extension on [Result] that is guaranteed to be an [Err].
extension ErrResult<E> on Result<Never, E> {
  /// Returns the contained error.
  ///
  /// Unlike [Result.unwrapErr()], this method is known to never throw because
  /// the success variant cannot possibly be instantiated.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Err(2).error); // "2"
  /// ```
  E get error => err.unwrap();
}

/// An extension on [Result] containing an [Option].
extension ResultingOption<T, E> on Result<Option<T>, E> {
  /// Transposes a [Result] containing an [Option] into an [Option] containing a
  /// [Result].
  ///
  /// An [Ok] with a [None] value will be mapped to a [None], and an [Ok] with a
  /// [Some] value will be mapped to a [Some] with an [Ok] value. An [Err] will
  /// be mapped to a [Some] with an [Err] value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(Some(2)).transpose()); // "Some(Ok(2))"
  /// print(Err(2).transpose()); // "Some(Err(2))"
  /// ```
  Option<Result<T, E>> transpose() {
    return match(
      (value) => value.map((value) => Ok(value)),
      (error) => Some(Err(error)),
    );
  }
}

/// An extension on [Result] containing another [Result].
extension ResultingResult<T, E> on Result<Result<T, E>, E> {
  /// Flattens a [Result] containing another [Result].
  ///
  /// The flattening operation is only ever a single level deep.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(Ok(2)).flatten()); // "Ok(2)"
  /// print(Ok(Err(2)).flatten()); // "Err(2)"
  /// ```
  Result<T, E> flatten() => match((value) => value, (error) => Err(error));
}

/// A successful [Result].
@sealed
class Ok<T, E> extends Result<T, E> {
  /// The contained value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(2).value); // "2"
  /// ```
  final T value;

  /// Creates a successful [Result] with the given [value].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(2)); // "Ok(2)"
  /// ```
  const Ok(this.value) : super._();

  @override
  List<T> get props => [value];

  @override
  Iterable<T> get iterable => Iterable<T>.generate(1, (index) => value);

  @override
  void whenOk(void Function(T value) fn) => fn(value);

  @override
  void whenErr(void Function(E error) fn) {}

  @override
  U match<U>(U Function(T value) fOk, U Function(E error) fErr) => fOk(value);

  @override
  Some<T> get ok => Some(value);

  @override
  None<E> get err => None<E>();

  @override
  T unwrap({String? msg, T Function(E error)? ifErr}) => value;

  @override
  E unwrapErr({String? msg, E Function(T value)? ifOk}) {
    if (ifOk != null) {
      return ifOk(value);
    }

    throw StateError(
      '${msg ?? 'called `Result.unwrapErr()` on an `Ok`'}: $value',
    );
  }

  @override
  Result<U, E> map<U>(U Function(T value) map, {U Function(E error)? ifErr}) {
    return Ok(map(value));
  }

  @override
  Result<T, F> mapErr<F>(F Function(E error) map, {F Function(T value)? ifOk}) {
    return ifOk != null ? Err(ifOk(value)) : Ok(value);
  }

  @override
  Result<U, E> and<U>(Result<U, E> Function(T value) other) => other(value);

  @override
  Result<T, F> or<F>(Result<T, F> Function(E error) other) => Ok(value);

  @override
  String toString([bool typeInfo = false]) {
    return 'Ok${typeInfo ? '<$T, $E>' : ''}($value)';
  }
}

/// An erroneous [Result].
@sealed
class Err<T, E> extends Result<T, E> {
  /// The contained error.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Err(2).value); // "2"
  /// ```
  final E error;

  /// Creates an erroneous [Result] with the given [error].
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Err(2)); // "Err(2)"
  /// ```
  const Err(this.error) : super._();

  @override
  List<E> get props => [error];

  @override
  Iterable<T> get iterable => Iterable<T>.empty();

  @override
  void whenOk(void Function(T value) fn) {}

  @override
  void whenErr(void Function(E error) fn) => fn(error);

  @override
  U match<U>(U Function(T value) fOk, U Function(E error) fErr) => fErr(error);

  @override
  Option<T> get ok => None<T>();

  @override
  Option<E> get err => Some(error);

  @override
  T unwrap({String? msg, T Function(E error)? ifErr}) {
    if (ifErr != null) {
      return ifErr(error);
    }

    throw StateError(
      '${msg ?? 'called `Result.unwrap()` on an `Err`'}: $error',
    );
  }

  @override
  E unwrapErr({String? msg, E Function(T value)? ifOk}) => error;

  @override
  Result<U, E> map<U>(U Function(T value) map, {U Function(E error)? ifErr}) {
    return ifErr != null ? Ok(ifErr(error)) : Err(error);
  }

  @override
  Result<T, F> mapErr<F>(F Function(E error) map, {F Function(T value)? ifOk}) {
    return Err(map(error));
  }

  @override
  Result<U, E> and<U>(Result<U, E> Function(T value) other) => Err(error);

  @override
  Result<T, F> or<F>(Result<T, F> Function(E error) other) => other(error);

  @override
  String toString([bool typeInfo = false]) {
    return 'Err${typeInfo ? '<$T, $E>' : ''}($error)';
  }
}
