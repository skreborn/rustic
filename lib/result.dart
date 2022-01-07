import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'option.dart';

/// Short-circuits the enclosing [Result.collect()] or [Result.collectSync()] if
/// [result] is an [Err].
typedef Checker<E> = T Function<T>(Result<T, E> result);

/// Optionally maps an arbitrary exception [ex] to an [Err].
typedef ExceptionMapper<T, E> = FutureOr<Option<Err<T, E>>> Function(
  Exception ex,
);

/// Optionally maps an arbitrary exception [ex] to an [Err].
typedef ExceptionMapperSync<T, E> = Option<Err<T, E>> Function(Exception ex);

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
/// Future<Result<int, String>> tryParse(String source) {
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
/// print(await tryParse('2')); // "Ok(2)"
/// print(await tryParse('two')); // "Err(not a number: two)"
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
  /// See [collectSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// ```dart
  /// final collected = await Result.collect<int, String>((check) async {
  ///   String mapErr(int error) => error.toString();
  ///
  ///   // This passes the check and `first` gets the value `2`
  ///   final first = check(await Ok<int, int>(2).mapErr(mapErr));
  ///
  ///   // This fails the check and the error is returned from the collector
  ///   final second = check(await Err<int, int>(3).mapErr(mapErr));
  ///
  ///   // This is never reached
  ///   return Ok(first + second);
  /// });
  ///
  /// print(collected); // "Err(3)"
  /// ```
  static Future<Result<T, E>> collect<T, E>(
    FutureOr<Result<T, E>> Function(Checker<E> check) collector,
  ) async {
    try {
      return await collector(<U>(result) {
        return result.matchSync(
          (value) => value,
          (error) => throw _CheckException<T, E>(Err(error)),
        );
      });
    } on _CheckException<T, E> catch (error) {
      return error.err;
    }
  }

  /// Encloses any number of operations, optionally returning early on failure.
  ///
  /// [collector] provides a [Checker] that allows for an early return in case
  /// of a failure.
  ///
  /// See [collect] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// ```dart
  /// final collected = Result.collectSync<int, String>((check) {
  ///   String mapErr(int error) => error.toString();
  ///
  ///   // This passes the check and `first` gets the value `2`
  ///   final first = check(Ok<int, int>(2).mapErrSync(mapErr));
  ///
  ///   // This fails the check and the error is returned from the collector
  ///   final second = check(Err<int, int>(3).mapErrSync(mapErr));
  ///
  ///   // This is never reached
  ///   return Ok(first + second);
  /// });
  ///
  /// print(collected); // "Err(3)"
  /// ```
  static Result<T, E> collectSync<T, E>(
    Result<T, E> Function(Checker<E> check) collector,
  ) {
    try {
      return collector(<U>(result) {
        return result.matchSync(
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
  /// See [catchExceptionSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// ```dart
  /// final caught = await Result.catchException<int, String>(() {
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
  static Future<Result<T, E>> catchException<T, E>(
    FutureOr<T> Function() fn,
    ExceptionMapper<T, E> mapEx,
  ) async {
    try {
      return Ok(await fn());
    } on Exception catch (ex) {
      final result = await mapEx(ex);

      if (result is Some<Err<T, E>>) {
        return result.value;
      }

      rethrow;
    }
  }

  /// Executes [fn] that might throw an [Exception].
  ///
  /// [mapEx] optionally maps an [Exception] to an [Err]. Unhandled exceptions
  /// are rethrown unchanged.
  ///
  /// See [catchException] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// ```dart
  /// final caught = Result.catchExceptionSync<int, String>(() {
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
  static Result<T, E> catchExceptionSync<T, E>(
    T Function() fn,
    ExceptionMapperSync<T, E> mapEx,
  ) {
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
  /// See [whenOkSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For an [Ok], [fn] is called with the contained value.
  ///
  /// ```dart
  /// await Ok(2).whenOk((_) => print('ok')); // "ok"
  /// ```
  ///
  /// For an [Err], [fn] is never called.
  ///
  /// ```dart
  /// await Err(2).whenOk((_) => print('ok')); // Outputs nothing
  /// ```
  Future<void> whenOk(FutureOr<void> Function(T value) fn);

  /// Executes [fn] if `this` is an [Ok].
  ///
  /// See [whenOk] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For an [Ok], [fn] is called with the contained value.
  ///
  /// ```dart
  /// Ok(2).whenOkSync((_) => print('ok')); // "ok"
  /// ```
  ///
  /// For an [Err], [fn] is never called.
  ///
  /// ```dart
  /// Err(2).whenOkSync((_) => print('ok')); // Outputs nothing
  /// ```
  void whenOkSync(void Function(T value) fn);

  /// Executes [fn] if `this` is an [Err].
  ///
  /// See [whenErrSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For an [Ok], [fn] is never called.
  ///
  /// ```dart
  /// await Ok(2).whenErr((_) => print('err')); // Outputs nothing
  /// ```
  ///
  /// For an [Err], [fn] is called with the contained error.
  ///
  /// ```dart
  /// await Err(2).whenErr((_) => print('err')); // "err"
  /// ```
  Future<void> whenErr(FutureOr<void> Function(E error) fn);

  /// Executes [fn] if `this` is an [Err].
  ///
  /// See [whenErr] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For an [Ok], [fn] is never called.
  ///
  /// ```dart
  /// Ok(2).whenErrSync((_) => print('err')); // Outputs nothing
  /// ```
  ///
  /// For an [Err], [fn] is called with the contained error.
  ///
  /// ```dart
  /// Err(2).whenErrSync((_) => print('err')); // "err"
  /// ```
  void whenErrSync(void Function(E error) fn);

  /// Applies mapping function [fOk] if `this` is an [Ok] and [fErr] otherwise.
  ///
  /// See [matchSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For an [Ok], [fOk] is called with the contained value.
  ///
  /// ```dart
  /// print(await Ok(2).match((_) => 'ok', (_) => 'err')); // "ok"
  /// ```
  ///
  /// For an [Err], [fErr] is called with the contained error.
  ///
  /// ```dart
  /// print(await Err(2).match((_) => 'ok', (_) => 'err')); // "err"
  /// ```
  Future<U> match<U>(
    FutureOr<U> Function(T value) fOk,
    FutureOr<U> Function(E error) fErr,
  );

  /// Applies mapping function [fOk] if `this` is an [Ok] and [fErr] otherwise.
  ///
  /// See [match] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For an [Ok], [fOk] is called with the contained value.
  ///
  /// ```dart
  /// print(Ok(2).matchSync((_) => 'ok', (_) => 'err')); // "ok"
  /// ```
  ///
  /// For an [Err], [fErr] is called with the contained error.
  ///
  /// ```dart
  /// print(Err(2).matchSync((_) => 'ok', (_) => 'err')); // "err"
  /// ```
  U matchSync<U>(U Function(T value) fOk, U Function(E error) fErr);

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
  /// See [unwrapSync] for a synchronous version of this funcion.
  ///
  /// # Throws
  ///
  /// Throws a [StateError] (with custom message [msg] if provided) if `this` is
  /// an [Err] and [ifErr] is `null`.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(await Ok(2).unwrap()); // "2"
  /// print(await Err(2).unwrap()); // Throws a `StateError`
  /// ```
  Future<T> unwrap({String msg, FutureOr<T> Function(E error) ifErr});

  /// Returns the contained value.
  ///
  /// If `this` is an [Err], [ifErr] is called to compute a fallback value.
  ///
  /// See [unwrap] for an asynchronous version of this funcion.
  ///
  /// # Throws
  ///
  /// Throws a [StateError] (with custom message [msg] if provided) if `this` is
  /// an [Err] and [ifErr] is `null`.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(2).unwrapSync()); // "2"
  /// print(Err(2).unwrapSync()); // Throws a `StateError`
  /// ```
  T unwrapSync({String msg, T Function(E error) ifErr});

  /// Returns the contained error.
  ///
  /// If `this` is an [Ok], [ifOk] is called to compute a fallback value.
  ///
  /// See [unwrapErr] for a synchronous version of this funcion.
  ///
  /// # Throws
  ///
  /// Throws a [StateError] (with custom message [msg] if provided) if `this` is
  /// an [Ok] and [ifOk] is `null`.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(await Ok(2).unwrapErr()); // Throws a `StateError`
  /// print(await Err(2).unwrapErr()); // "2"
  /// ```
  Future<E> unwrapErr({String msg, FutureOr<E> Function(T value) ifOk});

  /// Returns the contained error.
  ///
  /// If `this` is an [Ok], [ifOk] is called to compute a fallback value.
  ///
  /// See [unwrapErr] for an asynchronous version of this funcion.
  ///
  /// # Throws
  ///
  /// Throws a [StateError] (with custom message [msg] if provided) if `this` is
  /// an [Ok] and [ifOk] is `null`.
  ///
  /// # Examples
  ///
  /// ```dart
  /// print(Ok(2).unwrapErrSync()); // Throws a `StateError`
  /// print(Err(2).unwrapErrSync()); // "2"
  /// ```
  E unwrapErrSync({String msg, E Function(T value) ifOk});

  /// Transforms the contained value, if any, by applying [map] to it.
  ///
  /// If `this` is an [Err], and [ifErr] is not `null`, it is called to compute
  /// a fallback value.
  ///
  /// See [mapSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For an [Ok], [map] is called with the contained value.
  ///
  /// ```dart
  /// print(await Ok(2).map((_) => 'ok')); // "Ok(ok)"
  /// ```
  ///
  /// For an [Err], [map] is never called.
  ///
  /// ```dart
  /// print(await Err(2).map((_) => 'ok')); // "Err(2)"
  /// ```
  Future<Result<U, E>> map<U>(
    FutureOr<U> Function(T value) map, {
    FutureOr<U> Function(E error) ifErr,
  });

  /// Transforms the contained value, if any, by applying [map] to it.
  ///
  /// If `this` is an [Err], and [ifErr] is not `null`, it is called to compute
  /// a fallback value.
  ///
  /// See [map] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For an [Ok], [map] is called with the contained value.
  ///
  /// ```dart
  /// print(Ok(2).mapSync((_) => 'ok')); // "Ok(ok)"
  /// ```
  ///
  /// For an [Err], [map] is never called.
  ///
  /// ```dart
  /// print(Err(2).mapSync((_) => 'ok')); // "Err(2)"
  /// ```
  Result<U, E> mapSync<U>(U Function(T value) map, {U Function(E error) ifErr});

  /// Transforms the contained error, if any, by applying [map] to it.
  ///
  /// If `this` is an [Ok], and [ifOk] is not `null`, it is called to compute a
  /// fallback value.
  ///
  /// See [mapErrSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For an [Ok], [map] is never called.
  ///
  /// ```dart
  /// print(await Ok(2).mapErr((_) => 'err')); // "Ok(2)"
  /// ```
  ///
  /// For an [Err], [map] is called with the contained error.
  ///
  /// ```dart
  /// print(await Err(2).mapErr((_) => 'err')); // "Err('err')"
  /// ```
  Future<Result<T, F>> mapErr<F>(
    FutureOr<F> Function(E error) map, {
    FutureOr<F> Function(T value) ifOk,
  });

  /// Transforms the contained error, if any, by applying [map] to it.
  ///
  /// If `this` is an [Ok], and [ifOk] is not `null`, it is called to compute a
  /// fallback value.
  ///
  /// See [mapErr] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For an [Ok], [map] is never called.
  ///
  /// ```dart
  /// print(Ok(2).mapErrSync((_) => 'err')); // "Ok(2)"
  /// ```
  ///
  /// For an [Err], [map] is called with the contained error.
  ///
  /// ```dart
  /// print(Err(2).mapErrSync((_) => 'err')); // "Err('err')"
  /// ```
  Result<T, F> mapErrSync<F>(
    F Function(E error) map, {
    F Function(T value) ifOk,
  });

  /// Returns the result of calling [other] if `this` is an [Ok], otherwise
  /// [Err].
  ///
  /// See [andSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For an [Ok], [other] is called with the contained value.
  ///
  /// ```dart
  /// print(await Ok(2).and((_) => Ok(3)); // "Ok(3)"
  /// ```
  ///
  /// For an [Err], [other] is never called.
  ///
  /// ```dart
  /// print(await Err(2).and((_) => Ok(3)); // "Err(2)"
  /// ```
  Future<Result<U, E>> and<U>(FutureOr<Result<U, E>> Function(T value) other);

  /// Returns the result of calling [other] if `this` is an [Ok], otherwise
  /// [Err].
  ///
  /// See [and] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For an [Ok], [other] is called with the contained value.
  ///
  /// ```dart
  /// print(Ok(2).andSync((_) => Ok(3)); // "Ok(3)"
  /// ```
  ///
  /// For an [Err], [other] is never called.
  ///
  /// ```dart
  /// print(Err(2).andSync((_) => Ok(3)); // "Err(2)"
  /// ```
  Result<U, E> andSync<U>(Result<U, E> Function(T value) other);

  /// Returns [Ok] if `this` is an [Ok], otherwise the result of calling
  /// [other].
  ///
  /// See [orSync] for a synchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For an [Ok], [other] is never called.
  ///
  /// ```dart
  /// print(await Ok(2).or((_) => Ok(3)); // "Ok(2)"
  /// ```
  ///
  /// For an [Err], [other] is called with the contained error.
  ///
  /// ```dart
  /// print(await Err(2).or((_) => Ok(3)); // "Ok(3)"
  /// ```
  Future<Result<T, F>> or<F>(FutureOr<Result<T, F>> Function(E error) other);

  /// Returns [Ok] if `this` is an [Ok], otherwise the result of calling
  /// [other].
  ///
  /// See [or] for an asynchronous version of this funcion.
  ///
  /// # Examples
  ///
  /// For an [Ok], [other] is never called.
  ///
  /// ```dart
  /// print(Ok(2).orSync((_) => Ok(3)); // "Ok(2)"
  /// ```
  ///
  /// For an [Err], [other] is called with the contained error.
  ///
  /// ```dart
  /// print(Err(2).orSync((_) => Ok(3)); // "Ok(3)"
  /// ```
  Result<T, F> orSync<F>(Result<T, F> Function(E error) other);

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
  T get value => ok.unwrapSync();
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
  E get error => err.unwrapSync();
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
    return matchSync(
      (value) => value.mapSync((value) => Ok(value)),
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
  Result<T, E> flatten() => matchSync((value) => value, (error) => Err(error));
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
  Future<void> whenOk(FutureOr<void> Function(T value) fn) async => fn(value);

  @override
  void whenOkSync(void Function(T value) fn) => fn(value);

  @override
  Future<void> whenErr(FutureOr<void> Function(E error) fn) async {}

  @override
  void whenErrSync(void Function(E error) fn) {}

  @override
  Future<U> match<U>(
    FutureOr<U> Function(T value) fOk,
    FutureOr<U> Function(E error) fErr,
  ) async {
    return fOk(value);
  }

  @override
  U matchSync<U>(U Function(T value) fOk, U Function(E error) fErr) {
    return fOk(value);
  }

  @override
  Some<T> get ok => Some(value);

  @override
  None<E> get err => None<E>();

  @override
  Future<T> unwrap({String? msg, FutureOr<T> Function(E error)? ifErr}) async {
    return value;
  }

  @override
  T unwrapSync({String? msg, T Function(E error)? ifErr}) => value;

  @override
  Future<E> unwrapErr({
    String? msg,
    FutureOr<E> Function(T value)? ifOk,
  }) async {
    if (ifOk != null) {
      return ifOk(value);
    }

    throw StateError(
      '${msg ?? 'tried to unwrap `Ok` as `Err`'}: $value',
    );
  }

  @override
  E unwrapErrSync({String? msg, E Function(T value)? ifOk}) {
    if (ifOk != null) {
      return ifOk(value);
    }

    throw StateError(
      '${msg ?? 'tried to unwrap `Ok` as `Err`'}: $value',
    );
  }

  @override
  Future<Result<U, E>> map<U>(
    FutureOr<U> Function(T value) map, {
    FutureOr<U> Function(E error)? ifErr,
  }) async {
    return Ok(await map(value));
  }

  @override
  Result<U, E> mapSync<U>(
    U Function(T value) map, {
    U Function(E error)? ifErr,
  }) {
    return Ok(map(value));
  }

  @override
  Future<Result<T, F>> mapErr<F>(
    FutureOr<F> Function(E error) map, {
    FutureOr<F> Function(T value)? ifOk,
  }) async {
    return ifOk != null ? Err(await ifOk(value)) : Ok(value);
  }

  @override
  Result<T, F> mapErrSync<F>(
    F Function(E error) map, {
    F Function(T value)? ifOk,
  }) {
    return ifOk != null ? Err(ifOk(value)) : Ok(value);
  }

  @override
  Future<Result<U, E>> and<U>(
    FutureOr<Result<U, E>> Function(T value) other,
  ) async {
    return other(value);
  }

  @override
  Result<U, E> andSync<U>(Result<U, E> Function(T value) other) => other(value);

  @override
  Future<Result<T, F>> or<F>(
    FutureOr<Result<T, F>> Function(E error) other,
  ) async {
    return Ok(value);
  }

  @override
  Result<T, F> orSync<F>(Result<T, F> Function(E error) other) => Ok(value);

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
  Future<void> whenOk(FutureOr<void> Function(T value) fn) async {}

  @override
  void whenOkSync(void Function(T value) fn) {}

  @override
  Future<void> whenErr(FutureOr<void> Function(E error) fn) async => fn(error);

  @override
  void whenErrSync(void Function(E error) fn) => fn(error);

  @override
  Future<U> match<U>(
    FutureOr<U> Function(T value) fOk,
    FutureOr<U> Function(E error) fErr,
  ) async {
    return fErr(error);
  }

  @override
  U matchSync<U>(U Function(T value) fOk, U Function(E error) fErr) {
    return fErr(error);
  }

  @override
  Option<T> get ok => None<T>();

  @override
  Option<E> get err => Some(error);

  @override
  Future<T> unwrap({String? msg, FutureOr<T> Function(E error)? ifErr}) async {
    if (ifErr != null) {
      return ifErr(error);
    }

    throw StateError(
      '${msg ?? 'tried to unwrap `Err` as `Ok`'}: $error',
    );
  }

  @override
  T unwrapSync({String? msg, T Function(E error)? ifErr}) {
    if (ifErr != null) {
      return ifErr(error);
    }

    throw StateError(
      '${msg ?? 'tried to unwrap `Err` as `Ok`'}: $error',
    );
  }

  @override
  Future<E> unwrapErr({
    String? msg,
    FutureOr<E> Function(T value)? ifOk,
  }) async {
    return error;
  }

  @override
  E unwrapErrSync({String? msg, E Function(T value)? ifOk}) => error;

  @override
  Future<Result<U, E>> map<U>(
    FutureOr<U> Function(T value) map, {
    FutureOr<U> Function(E error)? ifErr,
  }) async {
    return ifErr != null ? Ok(await ifErr(error)) : Err(error);
  }

  @override
  Result<U, E> mapSync<U>(
    U Function(T value) map, {
    U Function(E error)? ifErr,
  }) {
    return ifErr != null ? Ok(ifErr(error)) : Err(error);
  }

  @override
  Future<Result<T, F>> mapErr<F>(
    FutureOr<F> Function(E error) map, {
    FutureOr<F> Function(T value)? ifOk,
  }) async {
    return Err(await map(error));
  }

  @override
  Result<T, F> mapErrSync<F>(
    F Function(E error) map, {
    F Function(T value)? ifOk,
  }) {
    return Err(map(error));
  }

  @override
  Future<Result<U, E>> and<U>(
    FutureOr<Result<U, E>> Function(T value) other,
  ) async {
    return Err(error);
  }

  @override
  Result<U, E> andSync<U>(Result<U, E> Function(T value) other) => Err(error);

  @override
  Future<Result<T, F>> or<F>(
    FutureOr<Result<T, F>> Function(E error) other,
  ) async {
    return other(error);
  }

  @override
  Result<T, F> orSync<F>(Result<T, F> Function(E error) other) => other(error);

  @override
  String toString([bool typeInfo = false]) {
    return 'Err${typeInfo ? '<$T, $E>' : ''}($error)';
  }
}
