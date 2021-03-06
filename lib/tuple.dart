import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'src/tuple_variants.dart';

/// A fixed-length container where each item has its own type.
///
/// ```
/// Tuple2<int, int> sum2(Tuple2<int, int> a, Tuple2<int, int> b) {
///   return Tuple2(a.i0 + b.i0, a.i1 + b.i1);
/// }
/// ```
///
/// ```
/// print(sum2(Tuple2(2, 3), Tuple2(4, 5))); // "(6, 8)"
/// ```
@sealed
@immutable
abstract class Tuple extends Equatable {
  const Tuple._();

  @override
  String toString() => '(${props.join(', ')})';
}

/// An empty [Tuple].
///
/// Also known as a unit type.
@sealed
class Unit extends Tuple {
  @override
  List<Object> get props => const [];

  /// Creates an empty [Tuple].
  ///
  /// ```
  /// print(Unit()); // "()"
  /// ```
  const Unit() : super._();
}
