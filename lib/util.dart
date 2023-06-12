import 'package:rustic/result.dart';

/// Casts [value] to a supertype.
///
/// # Examples
///
/// When chaining [Result] instances with varying subtypes of values and errors, you might run into
/// type errors. To resolve these issues, [upcast] provides you with an identity function that,
/// while not changing the contained value, returns it cast to the desired supertype.
///
/// ```dart
/// sealed class Kind {
///   const Kind();
/// }
///
/// final class KindA extends Kind {
///   const KindA();
/// }
///
/// final class KindB extends Kind {
///   const KindB();
/// }
///
/// Result<Kind, ()> kinds() {
///   const a = Err<KindA, ()>(());
///   const b = Err<KindB, ()>(());
///
///   // simply using `a.or(b)` would result in a type error
///
///   return a.map<Kind>(upcast).or(b);
/// }
/// ```
U upcast<T extends U, U>(T value) => value;
