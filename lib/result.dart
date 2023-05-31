/// Constructs related to results of operations.

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'option.dart';

@immutable
final class _CheckException<T, E> implements Exception {
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
///   final parsed = int.tryParse(source);
///
///   if (parsed != null) {
///     return Ok(parsed);
///   }
///
///   return Err('not a number: $source');
/// }
/// ```
///
/// That function can now be used to try and parse an integer, and return with a helpful error in
/// case of failure.
///
/// ```dart
/// // prints "Ok(2)"
/// print(tryParse('2'));
///
/// // prints "Err(not a number: two)"
/// print(tryParse('two'));
/// ```
@immutable
sealed class Result<T, E> {
  /// Encloses any number of operations, optionally returning early on [Err].
  ///
  /// See [collectAsync] for an asynchronous version of this function.
  ///
  /// # Examples
  ///
  /// ```dart
  /// Result<int, String> validate(int n) => n % 2 != 0 ? Ok(n) : Err('even: $n');
  ///
  /// final collected = Result.collect<int, String>((check) {
  ///   // This passes the check and `first` gets the value `2`
  ///   final first = check(validate(1));
  ///
  ///   // This fails the check and the error is returned from the collector
  ///   final second = check(validate(2));
  ///
  ///   // This is never reached
  ///   return Ok(first + second);
  /// });
  ///
  /// // prints "Err(even: 2)"
  /// print(collected);
  /// ```
  @useResult
  @factory
  // ignore: invalid_factory_method_impl
  static Result<T, E> collect<T, E>(
    Result<T, E> Function(U Function<U>(Result<U, E> result) check) collector,
  ) {
    try {
      return collector(<U>(result) {
        return switch (result) {
          Ok(:final value) => value,
          Err(:final error) => throw _CheckException<T, E>(Err(error))
        };
      });
    } on _CheckException<T, E> catch (ex) {
      return ex.err;
    }
  }

  /// Encloses any number of operations, optionally returning early on [Err].
  ///
  /// See [collect] for a synchronous version of this function.
  ///
  /// # Examples
  ///
  /// ```dart
  /// Result<int, String> validate(int n) => n % 2 != 0 ? Ok(n) : Err('even: $n');
  ///
  /// final collected = await Result.collectAsync<int, String>((check) async {
  ///   // This passes the check and `first` gets the value `2`
  ///   final first = check(await Future.value(validate(1)));
  ///
  ///   // This fails the check and the error is returned from the collector
  ///   final second = check(await Future.value(validate(2)));
  ///
  ///   // This is never reached
  ///   return Ok(first + second);
  /// });
  ///
  /// // prints "Err(even: 2)"
  /// print(collected);
  /// ```
  @useResult
  @factory
  // ignore: invalid_factory_method_impl
  static Future<Result<T, E>> collectAsync<T, E>(
    FutureOr<Result<T, E>> Function(U Function<U>(Result<U, E> result) check) collector,
  ) async {
    try {
      return await collector(<U>(result) {
        return switch (result) {
          Ok(:final value) => value,
          Err(:final error) => throw _CheckException<T, E>(Err(error))
        };
      });
    } on _CheckException<T, E> catch (error) {
      return error.err;
    }
  }

  /// Whether `this` is an [Ok].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "true"
  /// print(const Ok<int, String>(2).isOk);
  ///
  /// // prints "false"
  /// print(const Err<int, String>('error').isOk);
  /// ```
  @useResult
  bool get isOk;

  /// Whether `this` is an [Err].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "false"
  /// print(const Ok<int, String>(2).isErr);
  ///
  /// // prints "true"
  /// print(const Err<int, String>('error').isErr);
  /// ```
  @useResult
  bool get isErr;

  /// The possibly contained value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(2)"
  /// print(const Ok<int, String>(2).ok);
  ///
  /// // prints "None"
  /// print(const Err<int, String>('error').ok);
  /// ```
  @useResult
  Option<T> get ok;

  /// The possibly contained error.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "None"
  /// print(const Ok<int, String>(2).err);
  ///
  /// // prints "Some(error)"
  /// print(const Err<int, String>('error').err);
  /// ```
  @useResult
  Option<E> get err;

  /// The contained value if `this` is an [Ok], or `null` otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(const Ok<int, String>(2).valueOrNull);
  ///
  /// // prints "null"
  /// print(const Err<int, String>('error').valueOrNull);
  /// ```
  @useResult
  T? get valueOrNull;

  /// The contained error if `this` is an [Err], or `null` otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "null"
  /// print(const Ok<int, String>(2).errorOrNull);
  ///
  /// // prints "error"
  /// print(const Err<int, String>('error').errorOrNull);
  /// ```
  @useResult
  E? get errorOrNull;

  /// Returns an iterable over the possibly contained value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "[2]"
  /// print(const Ok<int, String>(2).iterable.toList());
  ///
  /// // prints "[]"
  /// print(const Err<int, String>('error').iterable.toList());
  /// ```
  @useResult
  Iterable<T> get iterable;

  /// The hash code of `this`.
  @override
  @useResult
  int get hashCode;

  const Result._();

  /// Creates an [Ok] with the given [value].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(2)"
  /// print(Result<int, String>.ok(2));
  /// ```
  const factory Result.ok(T value) = Ok<T, E>;

  /// Creates an [Err] with the given [error].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Err(error)"
  /// print(Result<int, String>.err('error'));
  /// ```
  const factory Result.err(E error) = Err<T, E>;

  /// Whether `this` equals [other].
  ///
  /// Two [Result] instances are considered equal if they are both either [Ok] or [Err] and their
  /// contained values/errors are equal according to [DeepCollectionEquality.equals].
  @override
  @useResult
  operator ==(covariant Result<T, E> other);

  /// Returns `true` if `this` is an [Ok] with a contained value that satisfies [condition].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "true"
  /// print(const Ok<int, String>(2).isOkAnd((value) => value == 2));
  ///
  /// // prints "false"
  /// print(const Err<int, String>('error').isOkAnd((value) => value == 2));
  /// ```
  @useResult
  bool isOkAnd(bool Function(T value) condition);

  /// Returns `true` if `this` is an [Err] with a contained error that satisfies [condition].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "false"
  /// print(const Ok<int, String>(2).isErrAnd((value) => value == 'error'));
  ///
  /// // prints "true"
  /// print(const Err<int, String>('error').isErrAnd((value) => value == 'error'));
  /// ```
  @useResult
  bool isErrAnd(bool Function(E error) condition);

  /// Returns `true` if `this` is an [Ok] with the given [value].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "true"
  /// print(const Ok<int, String>(2).contains(2));
  ///
  /// // prints "false"
  /// print(const Err<int, String>('error').contains(2));
  /// ```
  @useResult
  bool contains(T value);

  /// Returns `true` if `this` is an [Err] with the given [error].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "false"
  /// print(const Ok<int, String>(2).containsErr('error'));
  ///
  /// // prints "true"
  /// print(const Err<int, String>('error').containsErr('error'));
  /// ```
  @useResult
  bool containsErr(E error);

  /// Returns the contained value.
  ///
  /// # Throws
  ///
  /// Throws a [StateError] (with custom message [msg] if provided) if `this` is an [Err].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(const Ok<int, String>(2).unwrap());
  ///
  /// // throws a `StateError`
  /// print(const Err<int, String>('error').unwrap());
  /// ```
  @useResult
  T unwrap({String? msg});

  /// Returns the contained value, if any, or [defaultValue] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(const Ok<int, String>(2).unwrapOr(3));
  ///
  /// // prints "3"
  /// print(const Err<int, String>('error').unwrapOr(3));
  /// ```
  @useResult
  T unwrapOr(T defaultValue);

  /// Returns the contained value, if any, or the result of [calculateDefaultValue] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(const Ok<int, String>(2).unwrapOrElse((_) => 3));
  ///
  /// // prints "3"
  /// print(const Err<int, String>('error').unwrapOrElse((_) => 3));
  /// ```
  @useResult
  T unwrapOrElse(T Function(E error) calculateDefaultValue);

  /// Returns the contained error.
  ///
  /// # Throws
  ///
  /// Throws a [StateError] (with custom message [msg] if provided) if `this` is an [Err].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // throws a `StateError`
  /// print(const Ok<int, String>(2).unwrapErr());
  ///
  /// // prints "error"
  /// print(const Err<int, String>('error').unwrapErr());
  /// ```
  @useResult
  E unwrapErr({String? msg});

  /// Returns the contained error, if any, or [defaultError] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "other"
  /// print(const Ok<int, String>(2).unwrapErrOr('other'));
  ///
  /// // prints "error"
  /// print(const Err<int, String>('error').unwrapErrOr('other'));
  /// ```
  @useResult
  E unwrapErrOr(E defaultError);

  /// Returns the contained error, if any, or the result of [calculateDefaultError] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "other"
  /// print(const Ok<int, String>(2).unwrapErrOrElse((_) => 'other'));
  ///
  /// // prints "error"
  /// print(const Err<int, String>('error').unwrapErrOrElse((_) => 'other'));
  /// ```
  @useResult
  E unwrapErrOrElse(E Function(T value) calculateDefaultError);

  /// Calls [inspect] with the contained value if `this` is an [Ok].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// const Ok<int, String>(2).inspect(print);
  ///
  /// // prints nothing
  /// const Err<int, String>('error').inspect(print);
  /// ```
  @useResult
  Result<T, E> inspect(void Function(T value) inspect);

  /// Calls [inspect] with the contained error if `this` is an [Err].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints nothing
  /// const Ok<int, String>(2).inspectErr(print);
  ///
  /// // prints "error"
  /// const Err<int, String>('error').inspectErr(print);
  /// ```
  @useResult
  Result<T, E> inspectErr(void Function(E error) inspect);

  /// Transforms the contained value, if any, by applying [map] to it.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(4)"
  /// print(const Ok<int, String>(2).map((value) => value * 2));
  ///
  /// // prints "Err(error)"
  /// print(const Err<int, String>('error').map((value) => value * 2));
  /// ```
  @useResult
  Result<U, E> map<U>(U Function(T value) map);

  /// Returns the contained value, if any, with [map] applied to it, or [defaultValue] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "4"
  /// print(const Ok<int, String>(2).mapOr((value) => value * 2, 0));
  ///
  /// // prints "0"
  /// print(const Err<int, String>('error').mapOr((value) => value * 2, 0));
  /// ```
  @useResult
  U mapOr<U>(U Function(T value) map, U defaultValue);

  /// Returns the contained value, if any, with [map] applied to it, or the result of
  /// [calculateDefaultValue] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "4"
  /// print(const Ok<int, String>(2).mapOrElse((value) => value * 2, (_) => 0));
  ///
  /// // prints "0"
  /// print(const Err<int, String>('error').mapOrElse((value) => value * 2, (_) => 0));
  /// ```
  @useResult
  U mapOrElse<U>(U Function(T value) map, U Function(E error) calculateDefaultValue);

  /// Transforms the contained error, if any, by applying [map] to it.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(2)"
  /// print(const Ok<int, String>(2).mapErr((error) => '$error!'));
  ///
  /// // prints "Err(error!)"
  /// print(const Err<int, String>('error').mapErr((error) => '$error!'));
  /// ```
  @useResult
  Result<T, F> mapErr<F>(F Function(E error) map);

  /// Returns the contained error, if any, with [map] applied to it, or [defaultError] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "4"
  /// print(const Ok<int, String>(2).mapErrOr((error) => '$error!', 'other'));
  ///
  /// // prints "0"
  /// print(const Err<int, String>('error').mapErrOr((error) => '$error!', 'other'));
  /// ```
  @useResult
  F mapErrOr<F>(F Function(E error) map, F defaultError);

  /// Returns the contained error, if any, with [map] applied to it, or the result of
  /// [calculateDefaultError] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "4"
  /// print(const Ok<int, String>(2).mapErrOrElse((error) => '$error!', (_) => 'other'));
  ///
  /// // prints "0"
  /// print(const Err<int, String>('error').mapErrOrElse((error) => '$error!', (_) => 'other'));
  /// ```
  @useResult
  F mapErrOrElse<F>(F Function(E error) map, F Function(T value) calculateDefaultError);

  /// Returns [other] if `this` is an [Ok], or an [Err] of the original error otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(3)"
  /// print(const Ok<int, String>(2).and(const Ok(3)));
  ///
  /// // prints "Err(error)"
  /// print(const Err<int, String>('error').and(const Ok(3)));
  /// ```
  @useResult
  Result<U, E> and<U>(Result<U, E> other);

  /// Returns the result of [calculateOther] if `this` is an [Ok], or an [Err] of the original error
  /// otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(3)"
  /// print(const Ok<int, String>(2).andThen((value) => const Ok(3)));
  ///
  /// // prints "Err(error)"
  /// print(const Err<int, String>('error').andThen((value) => const Ok(3)));
  /// ```
  @useResult
  Result<U, E> andThen<U>(Result<U, E> Function(T value) calculateOther);

  /// Returns an [Ok] of the original value if `this` is an [Ok], or [other] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(2)"
  /// print(const Ok<int, String>(2).or(const Ok<int, String>(3)));
  ///
  /// // prints "Ok(3)"
  /// print(const Err<int, String>('error').or(const Ok<int, String>(3)));
  /// ```
  @useResult
  Result<T, F> or<F>(Result<T, F> other);

  /// Returns an [Ok] of the original value if `this` is an [Ok], or the result of [calculateOther]
  /// otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(2)"
  /// print(const Ok<int, String>(2).orElse((_) => const Ok<int, String>(3)));
  ///
  /// // prints "Ok(3)"
  /// print(const Err<int, String>('error').orElse((_) => const Ok<int, String>(3)));
  /// ```
  @useResult
  Result<T, F> orElse<F>(Result<T, F> Function(E error) calculateOther);

  /// Returns the `String` representation of `this`.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(2)"
  /// print(const Ok<int, String>(2));
  ///
  /// // prints "Err(error)"
  /// print(const Err<int, String>('error'));
  /// ```
  @override
  @useResult
  String toString();
}

/// An extension on a [Result] that is guaranteed to be an [Ok].
extension SuccessfulResult<T> on Result<T, Never> {
  /// Returns the contained value.
  ///
  /// Unlike [Result.unwrap], this method is known to never throw because the error variant cannot
  /// possibly be instantiated.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(const Ok<int, String>(2).value);
  /// ```
  @useResult
  T get value => ok.unwrap();
}

/// An extension on a [Result] that is guaranteed to be an [Err].
extension ErroneousResult<E> on Result<Never, E> {
  /// Returns the contained error.
  ///
  /// Unlike [Result.unwrapErr], this method is known to never throw because the success variant
  /// cannot possibly be instantiated.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "error"
  /// print(const Err<int, String>('error').error);
  /// ```
  @useResult
  E get error => err.unwrap();
}

/// An extension on a [Result] containing an [Option].
extension TransposedResult<T, E> on Result<Option<T>, E> {
  /// A [Result] containing an [Option] transposed into an [Option] containing a [Result].
  ///
  /// An [Ok] with a [None] value will be mapped to a [None], and an [Ok] with a [Some] value will
  /// be mapped to a [Some] with an [Ok] value. An [Err] will be mapped to a [Some] with an [Err]
  /// value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(Ok(2))"
  /// print(const Ok<Option<int>, String>(Some(2)).transposed);
  ///
  /// // prints "Some(Err('error'))"
  /// print(const Err<Option<int>, String>('error').transposed);
  /// ```
  @useResult
  Option<Result<T, E>> get transposed {
    return switch (this) {
      // ignore: unused_result
      Ok(:final value) => value.map<Result<T, E>>((value) => Ok<T, E>(value)),
      Err(:final error) => Some(Err(error)),
    };
  }
}

/// An extension on a [Result] containing another [Result].
extension FlattenedResult<T, E> on Result<Result<T, E>, E> {
  /// Flattens a [Result] containing another [Result].
  ///
  /// The flattening operation is only ever a single level deep.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(2)"
  /// print(const Ok<Result<int, String>, String>(Ok(2)).flattened);
  ///
  /// // prints "Err(error)"
  /// print(const Ok<Result<int, String>, String>(Err('error')).flattened);
  /// ```
  @useResult
  Result<T, E> get flattened {
    return switch (this) {
      Ok(:final value) => value,
      Err(:final error) => Err(error),
    };
  }
}

/// An extension on an [Iterable] of [Result] items.
extension IterableResults<T, E> on Iterable<Result<T, E>> {
  /// Collects an [Iterable] of [Result] items into a single [Result] containing a [List].
  ///
  /// # Examples
  ///
  /// ```dart
  /// Result<int, String> validate(int n) => n % 2 != 0 ? Ok(n) : Err('even: $n');
  ///
  /// // prints "Ok([1, 3, 5, 5])"
  /// print(const [1, 3, 5, 5].map(validate).collectToList());
  ///
  /// // prints "Err(even: 2)"
  /// print(const [1, 2, 3, 4, 5, 5].map(validate).collectToList());
  /// ```
  @useResult
  Result<List<T>, E> collectToList() => Result.collect((check) => Ok(map<T>(check).toList()));

  /// Collects an [Iterable] of [Result] items into a single [Result] containing a [Set].
  ///
  /// # Examples
  ///
  /// ```dart
  /// Result<int, String> validate(int n) => n % 2 != 0 ? Ok(n) : Err('even: $n');
  ///
  /// // prints "Ok({1, 3, 5})"
  /// print(const [1, 3, 5, 5].map(validate).collectToSet());
  ///
  /// // prints "Err(even: 2)"
  /// print(const [1, 2, 3, 4, 5, 5].map(validate).collectToSet());
  /// ```
  @useResult
  Result<Set<T>, E> collectToSet() => Result.collect((check) => Ok(map<T>(check).toSet()));
}

/// A successful [Result].
final class Ok<T, E> extends Result<T, E> {
  /// The contained value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(const Ok<int, String>(2).value);
  /// ```
  final T value;

  @override
  @useResult
  bool get isOk => true;

  @override
  @useResult
  bool get isErr => false;

  @override
  @useResult
  Some<T> get ok => Some(value);

  @override
  @useResult
  None<E> get err => None<E>();

  @override
  @useResult
  T get valueOrNull => value;

  @override
  @useResult
  Null get errorOrNull => null;

  @override
  @useResult
  Iterable<T> get iterable => Iterable.generate(1, (_) => value);

  @override
  @useResult
  int get hashCode => const DeepCollectionEquality().hash(value);

  /// Creates a successful [Result] with the given [value].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(2)"
  /// print(const Ok<int, String>(2));
  /// ```
  @literal
  const Ok(this.value) : super._();

  @override
  @useResult
  operator ==(covariant Result<T, E> other) {
    return switch (other) {
      Ok(:final value) => const DeepCollectionEquality().equals(this.value, value),
      Err() => false,
    };
  }

  @override
  @useResult
  bool isOkAnd(bool Function(T value) condition) => condition(value);

  @override
  @useResult
  bool isErrAnd(bool Function(E error) condition) => false;

  @override
  @useResult
  bool contains(T value) => value == this.value;

  @override
  @useResult
  bool containsErr(E error) => false;

  @override
  @useResult
  T unwrap({String? msg}) => value;

  @override
  @useResult
  T unwrapOr(T defaultValue) => value;

  @override
  @useResult
  T unwrapOrElse(T Function(E error) calculateDefaultValue) => value;

  @override
  @useResult
  Never unwrapErr({String? msg}) {
    throw StateError('${msg ?? 'tried to unwrap `Ok` as `Err`'}: $value');
  }

  @override
  @useResult
  E unwrapErrOr(E defaultError) => defaultError;

  @override
  @useResult
  E unwrapErrOrElse(E Function(T value) calculateDefaultError) => calculateDefaultError(value);

  @override
  @useResult
  Ok<T, E> inspect(void Function(T value) inspect) {
    inspect(value);

    return this;
  }

  @override
  @useResult
  Ok<T, E> inspectErr(void Function(E error) inspect) => this;

  @override
  @useResult
  Ok<U, E> map<U>(U Function(T value) map) => Ok(map(value));

  @override
  @useResult
  U mapOr<U>(U Function(T value) map, U defaultValue) => map(value);

  @override
  @useResult
  U mapOrElse<U>(U Function(T value) map, U Function(E error) calculateDefaultValue) => map(value);

  @override
  @useResult
  Ok<T, F> mapErr<F>(F Function(E error) map) => Ok(value);

  @override
  @useResult
  F mapErrOr<F>(F Function(E error) map, F defaultError) => defaultError;

  @override
  @useResult
  F mapErrOrElse<F>(F Function(E error) map, F Function(T value) calculateDefaultError) {
    return calculateDefaultError(value);
  }

  @override
  @useResult
  Result<U, E> and<U>(Result<U, E> other) => other;

  @override
  @useResult
  Result<U, E> andThen<U>(Result<U, E> Function(T value) calculateOther) => calculateOther(value);

  @override
  @useResult
  Ok<T, F> or<F>(Result<T, F> other) => Ok(value);

  @override
  @useResult
  Ok<T, F> orElse<F>(Result<T, F> Function(E error) calculateOther) => Ok(value);

  @override
  @useResult
  String toString() => 'Ok($value)';
}

/// An erroneous [Result].
final class Err<T, E> extends Result<T, E> {
  /// The contained error.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "error"
  /// print(const Err<int, String>('error').error);
  /// ```
  final E error;

  @override
  @useResult
  bool get isOk => false;

  @override
  @useResult
  bool get isErr => true;

  @override
  @useResult
  None<T> get ok => None<T>();

  @override
  @useResult
  Some<E> get err => Some(error);

  @override
  @useResult
  Null get valueOrNull => null;

  @override
  @useResult
  E get errorOrNull => error;

  @override
  @useResult
  Iterable<T> get iterable => const Iterable.empty();

  @override
  @useResult
  int get hashCode => const DeepCollectionEquality().hash(error);

  /// Creates an erroneous [Result] with the given [error].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Err(error)"
  /// print(const Err<int, String>('error'));
  /// ```
  @literal
  const Err(this.error) : super._();

  @override
  @useResult
  operator ==(covariant Result<T, E> other) {
    return switch (other) {
      Ok() => false,
      Err(:final error) => const DeepCollectionEquality().equals(this.error, error),
    };
  }

  @override
  @useResult
  bool isOkAnd(bool Function(T value) condition) => false;

  @override
  @useResult
  bool isErrAnd(bool Function(E error) condition) => condition(error);

  @override
  @useResult
  bool contains(T value) => false;

  @override
  @useResult
  bool containsErr(E error) => error == this.error;

  @override
  @useResult
  Never unwrap({String? msg}) {
    throw StateError('${msg ?? 'tried to unwrap `Err` as `Ok`'}: $error');
  }

  @override
  @useResult
  T unwrapOr(T defaultValue) => defaultValue;

  @override
  @useResult
  T unwrapOrElse(T Function(E error) calculateDefaultValue) => calculateDefaultValue(error);

  @override
  @useResult
  E unwrapErr({String? msg}) => error;

  @override
  @useResult
  E unwrapErrOr(E defaultError) => error;

  @override
  @useResult
  E unwrapErrOrElse(E Function(T value) calculateDefaultError) => error;

  @override
  @useResult
  Err<T, E> inspect(void Function(T value) inspect) => this;

  @override
  @useResult
  Err<T, E> inspectErr(void Function(E error) inspect) {
    inspect(error);

    return this;
  }

  @override
  @useResult
  Err<U, E> map<U>(U Function(T value) map) => Err(error);

  @override
  @useResult
  U mapOr<U>(U Function(T value) map, U defaultValue) => defaultValue;

  @override
  @useResult
  U mapOrElse<U>(U Function(T value) map, U Function(E error) calculateDefaultValue) {
    return calculateDefaultValue(error);
  }

  @override
  @useResult
  Err<T, F> mapErr<F>(F Function(E error) map) => Err(map(error));

  @override
  @useResult
  F mapErrOr<F>(F Function(E error) map, F defaultError) => map(error);

  @override
  @useResult
  F mapErrOrElse<F>(F Function(E error) map, F Function(T value) calculateDefaultError) {
    return map(error);
  }

  @override
  @useResult
  Err<U, E> and<U>(Result<U, E> other) => Err(error);

  @override
  @useResult
  Err<U, E> andThen<U>(Result<U, E> Function(T value) calculateOther) => Err(error);

  @override
  @useResult
  Result<T, F> or<F>(Result<T, F> other) => other;

  @override
  @useResult
  Result<T, F> orElse<F>(Result<T, F> Function(E error) calculateOther) => calculateOther(error);

  @override
  @useResult
  String toString() => 'Err($error)';
}
