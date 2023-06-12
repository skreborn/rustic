/// Constructs related to optional values.

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'result.dart';

@immutable
final class _CheckException implements Exception {
  const _CheckException();
}

/// Encloses any number of operations, optionally returning early on `null`.
///
/// See [collectNullableAsync] for an asynchronous version of this function.
///
/// # Examples
///
/// ```dart
/// int? filter(int n) => n.isOdd ? n : null;
///
/// final collected = collectNullable((check) {
///   // This passes the check and `first` gets the value `2`
///   final first = check(filter(1));
///
///   // This fails the check and `null` is returned from the collector
///   final second = check(filter(2));
///
///   // This is never reached
///   return first + second;
/// });
///
/// // prints "null"
/// print(collected);
/// ```
@useResult
T? collectNullable<T>(T? Function(U Function<U>(U? value) check) collector) {
  try {
    return collector(<U>(value) {
      if (value != null) {
        return value;
      }

      throw const _CheckException();
    });
  } on _CheckException {
    return null;
  }
}

/// Encloses any number of operations, optionally returning early on `null`.
///
/// See [collectNullable] for a synchronous version of this function.
///
/// # Examples
///
/// ```dart
/// int? filter(int n) => n.isOdd ? n : null;
///
/// final collected = await collectNullableAsync((check) async {
///   // This passes the check and `first` gets the value `2`
///   final first = check(await Future.value(filter(1)));
///
///   // This fails the check and `null` is returned from the collector
///   final second = check(await Future.value(filter(2)));
///
///   // This is never reached
///   return first + second;
/// });
///
/// // prints "null"
/// print(collected);
/// ```
@useResult
Future<T?> collectNullableAsync<T>(
  FutureOr<T?> Function(U Function<U>(U? value) check) collector,
) async {
  try {
    return await collector(<U>(value) {
      if (value != null) {
        return value;
      }

      throw const _CheckException();
    });
  } on _CheckException {
    return null;
  }
}

/// An optional value.
///
/// An [Option] either contains a value ([Some]) or it does not ([None]).
///
/// # Examples
///
/// The following function tries to multiply two integers after parsing them.
/// Upon success, the resulting value is wrapped in a [Some].
/// If an error occurs during conversion, [None] is returned.
///
/// ```dart
/// Option<int> multiply(String a, String b) {
///   return int
///     .tryParse(a)
///     .optional
///     .zip(int.tryParse(b).optional)
///     .map((ab) => ab.$1 * ab.$2);
/// }
/// ```
///
/// That function can now be used to try and multiply two integers encoded as strings and returning
/// [None] if that operation is not possible due to a conversion error.
///
/// ```dart
/// // prints "Some(6)"
/// print(multiply('2', '3'));
///
/// // prints "None"
/// print(multiply('two', '3'));
/// ```
@immutable
sealed class Option<T> {
  /// Encloses any number of operations, optionally returning early on [None].
  ///
  /// See [collectAsync] for an asynchronous version of this function.
  ///
  /// # Examples
  ///
  /// ```dart
  /// Option<int> filter(int n) => n.isOdd ? Some(n) : const None();
  ///
  /// final collected = Option.collect((check) {
  ///   // This passes the check and `first` gets the value `2`
  ///   final first = check(filter(1));
  ///
  ///   // This fails the check and `None` is returned from the collector
  ///   final second = check(filter(2));
  ///
  ///   // This is never reached
  ///   return Some(first + second);
  /// });
  ///
  /// // prints "None"
  /// print(collected);
  /// ```
  @useResult
  static Option<T> collect<T>(
    Option<T> Function(U Function<U>(Option<U> option) check) collector,
  ) {
    try {
      return collector(<U>(option) {
        return switch (option) {
          Some(:final value) => value,
          None() => throw const _CheckException()
        };
      });
    } on _CheckException {
      return None<T>();
    }
  }

  /// Encloses any number of operations, optionally returning early on [None].
  ///
  /// See [collect] for a synchronous version of this function.
  ///
  /// # Examples
  ///
  /// ```dart
  /// Option<int> filter(int n) => n.isOdd ? Some(n) : const None();
  ///
  /// final collected = await Option.collectAsync((check) async {
  ///   // This passes the check and `first` gets the value `2`
  ///   final first = check(await Future.value(filter(1)));
  ///
  ///   // This fails the check and `None` is returned from the collector
  ///   final second = check(await Future.value(filter(2)));
  ///
  ///   // This is never reached
  ///   return Some(first + second);
  /// });
  ///
  /// // prints "None"
  /// print(collected);
  /// ```
  @useResult
  static Future<Option<T>> collectAsync<T>(
    FutureOr<Option<T>> Function(U Function<U>(Option<U> option) check) collector,
  ) async {
    try {
      return await collector(<U>(option) {
        return switch (option) {
          Some(:final value) => value,
          None() => throw const _CheckException()
        };
      });
    } on _CheckException {
      return None<T>();
    }
  }

  /// Whether `this` is a [Some].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "true"
  /// print(const Some(2).isSome);
  ///
  /// // prints "false"
  /// print(const None<int>().isSome);
  /// ```
  @useResult
  bool get isSome;

  /// Whether `this` is [None].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "false"
  /// print(const Some(2).isNone);
  ///
  /// // prints "true"
  /// print(const None<int>().isNone);
  /// ```
  @useResult
  bool get isNone;

  /// The contained value if `this` is a [Some], or `null` otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(const Some(2).valueOrNull);
  ///
  /// // prints "null"
  /// print(const None<int>().valueOrNull);
  /// ```
  @useResult
  T? get valueOrNull;

  /// Returns an iterable over the possibly contained value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "[2]"
  /// print(const Some(2).iterable.toList());
  ///
  /// // prints "[]"
  /// print(const None<int>().iterable.toList());
  /// ```
  @useResult
  Iterable<T> get iterable;

  /// The hash code of `this`.
  @override
  @useResult
  @mustBeOverridden
  int get hashCode;

  const Option._();

  /// Creates a [Some] with the given [value], if it is not `null`, or [None] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(2)"
  /// print(Option(2));
  ///
  /// // prints "None"
  /// print(Option<int>(null));
  /// ```
  factory Option(T? value) => value != null ? Some(value) : None<T>();

  /// Creates a [Some] with the given [value].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(2)"
  /// print(const Option.some(2));
  /// ```
  @literal
  const factory Option.some(T value) = Some<T>;

  /// Creates a [None].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "None"
  /// print(const Option<int>.none());
  /// ```
  @literal
  const factory Option.none() = None<T>;

  /// Whether `this` equals [other].
  ///
  /// Two [Option] instances are considered equal if they are both either [Some] or [None] and their
  /// contained values are equal according to [DeepCollectionEquality.equals].
  @override
  @useResult
  @mustBeOverridden
  operator ==(covariant Option<T> other);

  /// Returns `true` if `this` is a [Some] with a contained value that satisfies [condition].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "true"
  /// print(const Some(2).isSomeAnd((value) => value == 2));
  ///
  /// // prints "false"
  /// print(const None<int>().isSomeAnd((value) => value == 2));
  /// ```
  @useResult
  bool isSomeAnd(bool Function(T value) condition);

  /// Returns `true` if `this` is a [Some] of the given [value].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "true"
  /// print(const Some(2).contains(2));
  ///
  /// // prints "false"
  /// print(const None<int>().contains(2));
  /// ```
  @useResult
  bool contains(T value);

  /// Returns the contained value.
  ///
  /// # Throws
  ///
  /// Throws a [StateError] (with custom message [msg] if provided) if `this` is [None].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(const Some(2).unwrap());
  ///
  /// // throws a `StateError`
  /// print(const None<int>().unwrap());
  /// ```
  @useResult
  T unwrap({String? msg});

  /// Returns the contained value, if any, or [defaultValue] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(const Some(2).unwrapOr(3));
  ///
  /// // prints "3"
  /// print(const None<int>().unwrapOr(3));
  /// ```
  @useResult
  T unwrapOr(T defaultValue);

  /// Returns the contained value, if any, or the result of [calculateDefaultValue] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(const Some(2).unwrapOrElse(() => 3));
  ///
  /// // prints "3"
  /// print(const None<int>().unwrapOrElse(() => 3));
  /// ```
  @useResult
  T unwrapOrElse(T Function() calculateDefaultValue);

  /// Calls [inspect] with the contained value if `this` is a [Some].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// const Some(2).inspect(print);
  ///
  /// // prints nothing
  /// const None<int>().inspect(print);
  /// ```
  @useResult
  Option<T> inspect(void Function(T value) inspect);

  /// Transforms the contained value, if any, by applying [map] to it.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(some: 2)"
  /// print(const Some(2).map((value) => 'some: $value'));
  ///
  /// // prints "None"
  /// print(const None<int>().map((value) => 'some: $value'));
  /// ```
  @useResult
  Option<U> map<U>(U Function(T value) map);

  /// Returns the contained value, if any, with [map] applied to it, or [defaultValue] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "some: 2"
  /// print(const Some(2).mapOr((value) => 'some: $value', 'none'));
  ///
  /// // prints "none"
  /// print(const None<int>().mapOr((value) => 'some: $value', 'none'));
  /// ```
  @useResult
  U mapOr<U>(U Function(T value) map, U defaultValue);

  /// Returns the contained value, if any, with [map] applied to it, or the result of
  /// [calculateDefaultValue] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "some: 2"
  /// print(const Some(2).mapOrElse((value) => 'some: $value', () => 'none'));
  ///
  /// // prints "none"
  /// print(const None<int>().mapOrElse((value) => 'some: $value', () => 'none'));
  /// ```
  @useResult
  U mapOrElse<U>(U Function(T value) map, U Function() calculateDefaultValue);

  /// Transforms an [Option] into a [Result], mapping [Some] to an [Ok] of the contained value and
  /// [None] to [Err] of [error].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(2)"
  /// print(const Some(2).okOr('none'));
  ///
  /// // prints "Err(none)"
  /// print(const None<int>().okOr('none'));
  /// ```
  @useResult
  Result<T, E> okOr<E>(E error);

  /// Transforms an [Option] into a [Result], mapping [Some] to an [Ok] of the contained value and
  /// [None] to [Err] of the result of [calculateError].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(2)"
  /// print(const Some(2).okOrElse(() => 'none'));
  ///
  /// // prints "Err(none)"
  /// print(const None<int>().okOrElse(() => 'none'));
  /// ```
  @useResult
  Result<T, E> okOrElse<E>(E Function() calculateError);

  /// Returns [other] if `this` is a [Some], or [None] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(3)"
  /// print(const Some(2).and(const Some(3)));
  ///
  /// // prints "None"
  /// print(const None<int>().and(const Some(3)));
  /// ```
  @useResult
  Option<U> and<U>(Option<U> other);

  /// Returns the result of [calculateOther] if `this` is a [Some], or [None] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(3)"
  /// print(const Some(2).andThen((value) => const Some(3)));
  ///
  /// // prints "None"
  /// print(const None<int>().andThen((value) => const Some(3)));
  /// ```
  @useResult
  Option<U> andThen<U>(Option<U> Function(T value) calculateOther);

  /// Returns a [Some] of the original value if `this` is a [Some], or [other] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(2)"
  /// print(const Some(2).or(const Some(3)));
  ///
  /// // prints "Some(3)"
  /// print(const None<int>().or(const Some(3)));
  /// ```
  @useResult
  Option<T> or(Option<T> other);

  /// Returns a [Some] of the original value if `this` is a [Some], or the result of
  /// [calculateOther] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(2)"
  /// print(const Some(2).orElse(() => const Some(3)));
  ///
  /// // prints "Some(3)"
  /// print(const None<int>().orElse(() => const Some(3)));
  /// ```
  @useResult
  Option<T> orElse(Option<T> Function() calculateOther);

  /// Returns a [Some] if either, but not both, of `this` and [other] is a [Some], or [None]
  /// otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "None"
  /// print(const Some(2).xor(const Some(3)));
  ///
  /// // prints "Some(2)";
  /// print(const Some(2).xor(const None()));
  /// ```
  @useResult
  Option<T> xor(Option<T> other);

  /// Returns a [Some] of the original value if `this` is a [Some] and its contained value satisfies
  /// [condition], or [None] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(2)"
  /// print(const Some(2).where((value) => true));
  ///
  /// // prints "None"
  /// print(const Some(2).where((value) => false));
  /// ```
  @useResult
  Option<T> where(bool Function(T value) condition);

  /// Returns a [Some] of the original value if `this` is a [Some] with a contained value of type
  /// [U], or [None] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(2)"
  /// print(const Some(2).whereType<int>());
  ///
  /// // prints "None"
  /// print(const Some(2).whereType<bool>());
  /// ```
  @useResult
  Option<U> whereType<U>();

  /// Returns a tuple of both `this` and [other] if both are [Some], or [None] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some((2, some))"
  /// print(const Some(2).zip(const Some('some')));
  ///
  /// // prints "None"
  /// print(const Some(2).zip(const None<String>()));
  /// ```
  @useResult
  Option<(T, U)> zip<U>(Option<U> other);

  /// Returns the result of [zip] called with both `this` and [other] if both are [Some], or [None]
  /// otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some((2, some))"
  /// print(const Some(2).zipWith(const Some('some'), (a, b) => (a, b)));
  ///
  /// // prints "None"
  /// print(const Some(2).zipWith(const None<String>(), (a, b) => (a, b)));
  /// ```
  @useResult
  Option<R> zipWith<U, R>(Option<U> other, R Function(T value, U otherValue) zip);

  /// Returns the `String` representation of `this`.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(2)"
  /// print(const Some(2));
  ///
  /// // prints "None"
  /// print(const None<int>());
  /// ```
  @override
  @useResult
  @mustBeOverridden
  String toString();
}

/// An extension on any nullable object.
extension Optional<T> on T? {
  /// Creates a [Some] with `this` as its value, if it is not `null`, or [None] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(2)"
  /// print(2.optional);
  ///
  /// // prints "None"
  /// print(null.optional);
  /// ```
  @useResult
  Option<T> get optional => Option(this);

  /// Returns an iterable over `this`.
  ///
  /// If `this` is `null`, the resulting iterable is empty, otherwise it has a single element.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "[2]"
  /// print(2.iterable.toList());
  ///
  /// // prints "[]"
  /// print(null.iterable.toList());
  /// ```
  @useResult
  Iterable<T> get iterable {
    if (this case T value) {
      return Iterable.generate(1, (_) => value);
    }

    return const Iterable.empty();
  }

  /// Returns `true` if `this` is not `null` and it satisfies [condition].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "true"
  /// print(2.isNotNullAnd((value) => value == 2));
  ///
  /// // prints "false"
  /// print(null.isNotNullAnd((value) => value == 2));
  /// ```
  @useResult
  bool isNotNullAnd(bool Function(T value) condition) {
    if (this case T value) {
      return condition(value);
    }

    return false;
  }

  /// Calls [inspect] with `this`, if it is not `null`.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// 2.inspect(print);
  ///
  /// // prints nothing
  /// null.inspect(print);
  /// ```
  @useResult
  T? inspect(void Function(T value) inspect) {
    if (this case T value) {
      inspect(value);
    }

    return this;
  }

  /// Transforms `this`, if it is not `null`, by applying [map] to it.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "value: 2"
  /// print(2.map((value) => 'value: $value'));
  ///
  /// // prints "null"
  /// print(null.map((value) => 'value: $value'));
  /// ```
  @useResult
  U? map<U>(U Function(T value) map) {
    if (this case T value) {
      return map(value);
    }

    return null;
  }

  /// Returns `this`, if it is not `null`, with [map] applied to it, or [defaultValue] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "value: 2"
  /// print(2.mapOr((value) => 'value: $value', 'null'));
  ///
  /// // prints "null"
  /// print(null.mapOr((value) => 'value: $value', 'null'));
  /// ```
  @useResult
  U mapOr<U>(U Function(T value) map, U defaultValue) {
    if (this case T value) {
      return map(value);
    }

    return defaultValue;
  }

  /// Returns `this`, if it is not `null`, with [map] applied to it, or the result of
  /// [calculateDefaultValue] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "value: 2"
  /// print(2.mapOrElse((value) => 'value: $value', () => 'null'));
  ///
  /// // prints "null"
  /// print(null.mapOrElse((value) => 'value: $value', () => 'null'));
  /// ```
  @useResult
  U mapOrElse<U>(U Function(T value) map, U Function() calculateDefaultValue) {
    if (this case T value) {
      return map(value);
    }

    return calculateDefaultValue();
  }

  /// Transforms `this` into a [Result], mapping a non-`null` value to an [Ok] of it and a `null`
  /// value to [Err] of [error].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(2)"
  /// print(2.okOr('null'));
  ///
  /// // prints "Err(null)"
  /// print(null.okOr('null'));
  /// ```
  @useResult
  Result<T, E> okOr<E>(E error) {
    if (this case T value) {
      return Ok(value);
    }

    return Err(error);
  }

  /// Transforms `this` into a [Result], mapping a non-`null` value to an [Ok] of it and a `null`
  /// value to [Err] of the result of [calculateError].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(2)"
  /// print(2.okOrElse(() => 'null'));
  ///
  /// // prints "Err(null)"
  /// print(null.okOrElse(() => 'null'));
  /// ```
  @useResult
  Result<T, E> okOrElse<E>(E Function() calculateError) {
    if (this case T value) {
      return Ok(value);
    }

    return Err(calculateError());
  }

  /// Returns [other] if `this` is not `null`, or `null` otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "3"
  /// print(2.and(3));
  ///
  /// // prints "null"
  /// print(null.and(3));
  /// ```
  @useResult
  U? and<U>(U? other) => this != null ? other : null;

  /// Returns the result of [calculateOther] if `this` is not `null`, or `null` otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "3"
  /// print(2.andThen((value) => 3));
  ///
  /// // prints "null"
  /// print(null.andThen((value) => 3));
  /// ```
  @useResult
  U? andThen<U>(U? Function(T value) calculateOther) {
    if (this case T value) {
      return calculateOther(value);
    }

    return null;
  }

  /// Returns `this`, if it is not `null`, or [other] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(2.or(3));
  ///
  /// // prints "3"
  /// print(null.or(3));
  /// ```
  @useResult
  T? or(T? other) => this ?? other;

  /// Returns `this`, if it is not `null`, or the result of [calculateOther] otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(2.orElse(() => 3));
  ///
  /// // prints "3"
  /// print(null.orElse(() => 3));
  /// ```
  @useResult
  T? orElse(T? Function() calculateOther) => this ?? calculateOther();

  /// Returns a non-`null` value if either, but not both, of `this` and [other] is non-`null`, or
  /// `null` otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "null"
  /// print(2.xor(3));
  ///
  /// // prints "2";
  /// print(2.xor(null));
  /// ```
  @useResult
  T? xor(T? other) {
    return switch ((this, other)) {
      (final T value, null) || (null, final T value) => value,
      _ => null,
    };
  }

  /// Returns `this`, if it is not `null` and it satisfies [condition], or `null` otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(2.where((value) => true));
  ///
  /// // prints "null"
  /// print(2.where((value) => false));
  /// ```
  @useResult
  T? where(bool Function(T value) condition) {
    if (this case T value when condition(value)) {
      return value;
    }

    return null;
  }

  /// Returns `this`, if it is not `null` and it is of type [U], or `null` otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(2.whereType<int>());
  ///
  /// // prints "null"
  /// print(2.whereType<bool>());
  /// ```
  @useResult
  U? whereType<U>() {
    if (this case final U value) {
      return value;
    }

    return null;
  }

  /// Returns a tuple of both `this` and [other] if both are non-`null`, or `null` otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "(2, value)"
  /// print(2.zip('value'));
  ///
  /// // prints "null"
  /// print(2.zip(null));
  /// ```
  @useResult
  (T, U)? zip<U>(U? other) {
    if ((this, other) case final (T, U) pair) {
      return pair;
    }

    return null;
  }

  /// Returns the result of [zip] called with both `this` and [other] if both are non-`null`, or
  /// `null` otherwise.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "(2, value)"
  /// print(2.zipWith('value', (a, b) => (a, b)));
  ///
  /// // prints "null"
  /// print(2.zipWith(null, (a, b) => (a, b)));
  /// ```
  @useResult
  R? zipWith<U, R>(U? other, R Function(T value, U otherValue) zip) {
    if ((this, other) case (final T value, final U otherValue)) {
      return zip(value, otherValue);
    }

    return null;
  }
}

/// An extension on an [Option] containing a [Result].
extension UnzippedOption<T, U> on Option<(T, U)> {
  /// An [Option] containing a tuple transformed into a tuple of two [Option]s.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "(Some(2), Some(true))"
  /// print(const Some((2, true)).unzipped);
  ///
  /// // prints "(None, None)"
  /// print(const None<(int, bool)>().unzipped);
  /// ```
  @useResult
  (Option<T>, Option<U>) get unzipped {
    return switch (this) {
      Some(:final value) => (Some(value.$1), Some(value.$2)),
      None() => (None<T>(), None<U>()),
    };
  }
}

/// An extension on an [Option] containing a [Result].
extension TransposedOption<T, E> on Option<Result<T, E>> {
  /// An [Option] containing a [Result] transposed into a [Result] containing an [Option].
  ///
  /// [None] will be mapped to an [Ok] with a [None] value. A [Some] with an [Ok] value will be
  /// mapped to an [Ok] with a [Some] value, and a [Some] with an [Err] value will be mapped to an
  /// [Err].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Ok(Some(2))"
  /// print(const Some(Ok<int, String>(2)).transposed);
  ///
  /// // prints "Err(error)"
  /// print(const Some(Err<int, String>('error')).transposed);
  /// ```
  @useResult
  Result<Option<T>, E> get transposed {
    return switch (this) {
      // ignore: unused_result
      Some(:final value) => value.map((value) => Some(value)),
      None() => Ok(None<T>()),
    };
  }
}

/// An extension on an [Option] containing another [Option].
extension FlattenedOption<T> on Option<Option<T>> {
  /// An [Option] containing another [Option] flattened into a single [Option].
  ///
  /// The flattening operation is only ever a single level deep.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(2)"
  /// print(const Some(Some(2)).flattened);
  ///
  /// // prints "None"
  /// print(const Some(None<int>()).flattened);
  /// ```
  @useResult
  Option<T> get flattened {
    return switch (this) {
      Some(:final value) => value,
      None() => None<T>(),
    };
  }
}

/// An extension on an [Iterable] of [Option] items.
extension IterableOptions<T> on Iterable<Option<T>> {
  /// Collects an [Iterable] of [Option] items into a single [Option] containing a [List].
  ///
  /// # Examples
  ///
  /// ```dart
  /// Option<int> filter(int n) => n.isOdd ? Some(n) : const None();
  ///
  /// // prints "Some([1, 3, 5, 5])"
  /// print(const [1, 3, 5, 5].map(filter).collectToList());
  ///
  /// // prints "None"
  /// print(const [1, 2, 3, 4, 5, 5].map(filter).collectToList());
  /// ```
  @useResult
  Option<List<T>> collectToList() => Option.collect((check) => Some(map<T>(check).toList()));

  /// Collects an [Iterable] of [Option] items into a single [Option] containing a [Set].
  ///
  /// # Examples
  ///
  /// ```dart
  /// Option<int> filter(int n) => n.isOdd ? Some(n) : const None();
  ///
  /// // prints "Some({1, 3, 5})"
  /// print(const [1, 3, 5, 5].map(filter).collectToSet());
  ///
  /// // prints "None"
  /// print(const [1, 2, 3, 4, 5, 5].map(filter).collectToSet());
  /// ```
  @useResult
  Option<Set<T>> collectToSet() => Option.collect((check) => Some(map<T>(check).toSet()));
}

/// An extension on an [Iterable] of nullable items.
extension IterableNullables<T> on Iterable<T?> {
  /// Collects an [Iterable] of nullable items into a single nullable [List].
  ///
  /// # Examples
  ///
  /// ```dart
  /// int? filter(int n) => n.isOdd ? n : null;
  ///
  /// // prints "[1, 3, 5, 5]"
  /// print(const [1, 3, 5, 5].map(filter).collectToList());
  ///
  /// // prints "null"
  /// print(const [1, 2, 3, 4, 5, 5].map(filter).collectToList());
  /// ```
  @useResult
  List<T>? collectToList() => collectNullable((check) => map<T>(check).toList());

  /// Collects an [Iterable] of nullable items into a single nullable [Set].
  ///
  /// # Examples
  ///
  /// ```dart
  /// int? filter(int n) => n.isOdd ? n : null;
  ///
  /// // prints "{1, 3, 5}"
  /// print(const [1, 3, 5, 5].map(filter).collectToSet());
  ///
  /// // prints "null"
  /// print(const [1, 2, 3, 4, 5, 5].map(filter).collectToSet());
  /// ```
  @useResult
  Set<T>? collectToSet() => collectNullable((check) => map<T>(check).toSet());
}

/// An [Option] with a value.
final class Some<T> extends Option<T> {
  /// The contained value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "2"
  /// print(const Some(2).value);
  /// ```
  final T value;

  @override
  @useResult
  bool get isSome => true;

  @override
  @useResult
  bool get isNone => false;

  @override
  @useResult
  T get valueOrNull => value;

  @override
  @useResult
  Iterable<T> get iterable => Iterable.generate(1, (_) => value);

  @override
  @useResult
  int get hashCode => const DeepCollectionEquality().hash(value);

  /// Creates an [Option] with the given [value].
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "Some(2)"
  /// print(const Some(2));
  /// ```
  @literal
  const Some(this.value) : super._();

  @override
  @useResult
  operator ==(covariant Option<T> other) {
    return switch (other) {
      Some(:final value) => const DeepCollectionEquality().equals(this.value, value),
      None() => false,
    };
  }

  @override
  @useResult
  bool isSomeAnd(bool Function(T value) condition) => condition(value);

  @override
  @useResult
  bool contains(T value) => value == this.value;

  @override
  @useResult
  T unwrap({String? msg}) => value;

  @override
  @useResult
  T unwrapOr(T defaultValue) => value;

  @override
  @useResult
  T unwrapOrElse(T Function() calculateDefaultValue) => value;

  @override
  @useResult
  Some<T> inspect(void Function(T value) inspect) {
    inspect(value);

    return this;
  }

  @override
  @useResult
  Some<U> map<U>(U Function(T value) map) => Some(map(value));

  @override
  @useResult
  U mapOr<U>(U Function(T value) map, U defaultValue) => map(value);

  @override
  @useResult
  U mapOrElse<U>(U Function(T value) map, U Function() calculateDefaultValue) => map(value);

  @override
  @useResult
  Ok<T, E> okOr<E>(E error) => Ok(value);

  @override
  @useResult
  Ok<T, E> okOrElse<E>(E Function() calculateError) => Ok(value);

  @override
  @useResult
  Option<U> and<U>(Option<U> other) => other;

  @override
  @useResult
  Option<U> andThen<U>(Option<U> Function(T value) calculateOther) => calculateOther(value);

  @override
  @useResult
  Some<T> or(Option<T> other) => this;

  @override
  @useResult
  Some<T> orElse(Option<T> Function() calculateOther) => this;

  @override
  @useResult
  Option<T> xor(Option<T> other) => other is None ? this : None<T>();

  @override
  @useResult
  Option<T> where(bool Function(T value) condition) => condition(value) ? this : None<T>();

  @override
  @useResult
  Option<U> whereType<U>() {
    final value = this.value;

    return value is U ? Some(value) : None<U>();
  }

  @override
  @useResult
  Option<(T, U)> zip<U>(Option<U> other) {
    return switch (other) {
      Some(value: final otherValue) => Some((value, otherValue)),
      // ignore: non_const_call_to_literal_constructor
      None() => None<(T, U)>(),
    };
  }

  @override
  @useResult
  Option<R> zipWith<U, R>(Option<U> other, R Function(T value, U otherValue) zip) {
    return switch (other) {
      Some(value: final otherValue) => Some(zip(value, otherValue)),
      None() => None<R>(),
    };
  }

  @override
  @useResult
  String toString() => 'Some($value)';
}

/// An [Option] with no value.
final class None<T> extends Option<T> {
  @override
  @useResult
  bool get isSome => false;

  @override
  @useResult
  bool get isNone => true;

  @override
  @useResult
  Null get valueOrNull => null;

  @override
  @useResult
  Iterable<T> get iterable => const Iterable.empty();

  @override
  @useResult
  int get hashCode => 0;

  /// Creates an [Option] with no value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// // prints "None"
  /// print(const None<int>());
  /// ```
  @literal
  const None() : super._();

  @override
  @useResult
  operator ==(covariant Option<T> other) => other is None;

  @override
  @useResult
  bool isSomeAnd(bool Function(T value) condition) => false;

  @override
  @useResult
  bool contains(T value) => false;

  @override
  @useResult
  Never unwrap({String? msg}) => throw StateError(msg ?? 'tried to unwrap `None` as `Some`');

  @override
  @useResult
  T unwrapOr(T defaultValue) => defaultValue;

  @override
  @useResult
  T unwrapOrElse(T Function() calculateDefaultValue) => calculateDefaultValue();

  @override
  @useResult
  None<T> inspect(void Function(T value) inspect) => this;

  @override
  @useResult
  None<U> map<U>(U Function(T value) map) => None<U>();

  @override
  @useResult
  U mapOr<U>(U Function(T value) map, U defaultValue) => defaultValue;

  @override
  @useResult
  U mapOrElse<U>(U Function(T value) map, U Function() calculateDefaultValue) {
    return calculateDefaultValue();
  }

  @override
  @useResult
  Err<T, E> okOr<E>(E error) => Err(error);

  @override
  @useResult
  Err<T, E> okOrElse<E>(E Function() calculateError) => Err(calculateError());

  @override
  @useResult
  None<U> and<U>(Option<U> other) => None<U>();

  @override
  @useResult
  None<U> andThen<U>(Option<U> Function(T value) calculateOther) => None<U>();

  @override
  @useResult
  Option<T> or(Option<T> other) => other;

  @override
  @useResult
  Option<T> orElse(Option<T> Function() calculateOther) => calculateOther();

  @override
  @useResult
  Option<T> xor(Option<T> other) => other is Some ? other : this;

  @override
  @useResult
  None<T> where(bool Function(T value) condition) => this;

  @override
  @useResult
  None<U> whereType<U>() => None<U>();

  @override
  @useResult
  // ignore: non_const_call_to_literal_constructor
  None<(T, U)> zip<U>(Option<U> other) => None<(T, U)>();

  @override
  @useResult
  None<R> zipWith<U, R>(Option<U> other, R Function(T value, U otherValue) zip) => None<R>();

  @override
  @useResult
  String toString() => 'None';
}
