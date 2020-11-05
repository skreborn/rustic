// GENERATED CONTENT - DO NOT EDIT MANUALLY!

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
  /// Creates a [Tuple2] with the given values.
  ///
  /// ```
  /// final tuple = Tuple2(0, 1);
  ///
  /// print(tuple); // "(0, 1)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of2<I0, I1>(
    I0 i0,
    I1 i1,
  ) =>
      Tuple2(i0, i1);

  /// Creates a [Tuple3] with the given values.
  ///
  /// ```
  /// final tuple = Tuple3(0, 1, 2);
  ///
  /// print(tuple); // "(0, 1, 2)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of3<I0, I1, I2>(
    I0 i0,
    I1 i1,
    I2 i2,
  ) =>
      Tuple3(i0, i1, i2);

  /// Creates a [Tuple4] with the given values.
  ///
  /// ```
  /// final tuple = Tuple4(0, 1, 2, 3);
  ///
  /// print(tuple); // "(0, 1, 2, 3)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of4<I0, I1, I2, I3>(
    I0 i0,
    I1 i1,
    I2 i2,
    I3 i3,
  ) =>
      Tuple4(i0, i1, i2, i3);

  /// Creates a [Tuple5] with the given values.
  ///
  /// ```
  /// final tuple = Tuple5(0, 1, 2, 3, 4);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of5<I0, I1, I2, I3, I4>(
    I0 i0,
    I1 i1,
    I2 i2,
    I3 i3,
    I4 i4,
  ) =>
      Tuple5(i0, i1, i2, i3, i4);

  /// Creates a [Tuple6] with the given values.
  ///
  /// ```
  /// final tuple = Tuple6(0, 1, 2, 3, 4, 5);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of6<I0, I1, I2, I3, I4, I5>(
    I0 i0,
    I1 i1,
    I2 i2,
    I3 i3,
    I4 i4,
    I5 i5,
  ) =>
      Tuple6(i0, i1, i2, i3, i4, i5);

  /// Creates a [Tuple7] with the given values.
  ///
  /// ```
  /// final tuple = Tuple7(0, 1, 2, 3, 4, 5, 6);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of7<I0, I1, I2, I3, I4, I5, I6>(
    I0 i0,
    I1 i1,
    I2 i2,
    I3 i3,
    I4 i4,
    I5 i5,
    I6 i6,
  ) =>
      Tuple7(i0, i1, i2, i3, i4, i5, i6);

  /// Creates a [Tuple8] with the given values.
  ///
  /// ```
  /// final tuple = Tuple8(0, 1, 2, 3, 4, 5, 6, 7);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of8<I0, I1, I2, I3, I4, I5, I6, I7>(
    I0 i0,
    I1 i1,
    I2 i2,
    I3 i3,
    I4 i4,
    I5 i5,
    I6 i6,
    I7 i7,
  ) =>
      Tuple8(i0, i1, i2, i3, i4, i5, i6, i7);

  /// Creates a [Tuple9] with the given values.
  ///
  /// ```
  /// final tuple = Tuple9(0, 1, 2, 3, 4, 5, 6, 7, 8);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of9<I0, I1, I2, I3, I4, I5, I6, I7, I8>(
    I0 i0,
    I1 i1,
    I2 i2,
    I3 i3,
    I4 i4,
    I5 i5,
    I6 i6,
    I7 i7,
    I8 i8,
  ) =>
      Tuple9(i0, i1, i2, i3, i4, i5, i6, i7, i8);

  /// Creates a [Tuple10] with the given values.
  ///
  /// ```
  /// final tuple = Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of10<I0, I1, I2, I3, I4, I5, I6, I7, I8, I9>(
    I0 i0,
    I1 i1,
    I2 i2,
    I3 i3,
    I4 i4,
    I5 i5,
    I6 i6,
    I7 i7,
    I8 i8,
    I9 i9,
  ) =>
      Tuple10(i0, i1, i2, i3, i4, i5, i6, i7, i8, i9);

  /// Creates a [Tuple11] with the given values.
  ///
  /// ```
  /// final tuple = Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of11<I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10>(
    I0 i0,
    I1 i1,
    I2 i2,
    I3 i3,
    I4 i4,
    I5 i5,
    I6 i6,
    I7 i7,
    I8 i8,
    I9 i9,
    I10 i10,
  ) =>
      Tuple11(i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10);

  /// Creates a [Tuple12] with the given values.
  ///
  /// ```
  /// final tuple = Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of12<I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11>(
    I0 i0,
    I1 i1,
    I2 i2,
    I3 i3,
    I4 i4,
    I5 i5,
    I6 i6,
    I7 i7,
    I8 i8,
    I9 i9,
    I10 i10,
    I11 i11,
  ) =>
      Tuple12(i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11);

  /// Creates a [Tuple13] with the given values.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of13<I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12>(
    I0 i0,
    I1 i1,
    I2 i2,
    I3 i3,
    I4 i4,
    I5 i5,
    I6 i6,
    I7 i7,
    I8 i8,
    I9 i9,
    I10 i10,
    I11 i11,
    I12 i12,
  ) =>
      Tuple13(i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12);

  /// Creates a [Tuple14] with the given values.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of14<I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13>(
    I0 i0,
    I1 i1,
    I2 i2,
    I3 i3,
    I4 i4,
    I5 i5,
    I6 i6,
    I7 i7,
    I8 i8,
    I9 i9,
    I10 i10,
    I11 i11,
    I12 i12,
    I13 i13,
  ) =>
      Tuple14(i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13);

  /// Creates a [Tuple15] with the given values.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of15<I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14>(
    I0 i0,
    I1 i1,
    I2 i2,
    I3 i3,
    I4 i4,
    I5 i5,
    I6 i6,
    I7 i7,
    I8 i8,
    I9 i9,
    I10 i10,
    I11 i11,
    I12 i12,
    I13 i13,
    I14 i14,
  ) =>
      Tuple15(i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14);

  /// Creates a [Tuple16] with the given values.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)"
  /// ```
  @pragma('vm:prefer-inline')
  static Tuple of16<I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15>(
    I0 i0,
    I1 i1,
    I2 i2,
    I3 i3,
    I4 i4,
    I5 i5,
    I6 i6,
    I7 i7,
    I8 i8,
    I9 i9,
    I10 i10,
    I11 i11,
    I12 i12,
    I13 i13,
    I14 i14,
    I15 i15,
  ) =>
      Tuple16(i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15);

  /// `true` if `this` is a [Tuple2].
  ///
  /// ```
  /// print(Tuple2(0, 1).is2); // "true"
  /// print(Tuple3(0, 1, 2).is2); // "false"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is2 => this is Tuple2;

  /// `true` if `this` is a [Tuple3].
  ///
  /// ```
  /// print(Tuple2(0, 1).is3); // "false"
  /// print(Tuple3(0, 1, 2).is3); // "true"
  /// print(Tuple4(0, 1, 2, 3).is3); // "false"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is3 => this is Tuple3;

  /// `true` if `this` is a [Tuple4].
  ///
  /// ```
  /// print(Tuple3(0, 1, 2).is4); // "false"
  /// print(Tuple4(0, 1, 2, 3).is4); // "true"
  /// print(Tuple5(0, 1, 2, 3, 4).is4); // "false"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is4 => this is Tuple4;

  /// `true` if `this` is a [Tuple5].
  ///
  /// ```
  /// print(Tuple4(0, 1, 2, 3).is5); // "false"
  /// print(Tuple5(0, 1, 2, 3, 4).is5); // "true"
  /// print(Tuple6(0, 1, 2, 3, 4, 5).is5); // "false"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is5 => this is Tuple5;

  /// `true` if `this` is a [Tuple6].
  ///
  /// ```
  /// print(Tuple5(0, 1, 2, 3, 4).is6); // "false"
  /// print(Tuple6(0, 1, 2, 3, 4, 5).is6); // "true"
  /// print(Tuple7(0, 1, 2, 3, 4, 5, 6).is6); // "false"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is6 => this is Tuple6;

  /// `true` if `this` is a [Tuple7].
  ///
  /// ```
  /// print(Tuple6(0, 1, 2, 3, 4, 5).is7); // "false"
  /// print(Tuple7(0, 1, 2, 3, 4, 5, 6).is7); // "true"
  /// print(Tuple8(0, 1, 2, 3, 4, 5, 6, 7).is7); // "false"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is7 => this is Tuple7;

  /// `true` if `this` is a [Tuple8].
  ///
  /// ```
  /// print(Tuple7(0, 1, 2, 3, 4, 5, 6).is8); // "false"
  /// print(Tuple8(0, 1, 2, 3, 4, 5, 6, 7).is8); // "true"
  /// print(Tuple9(0, 1, 2, 3, 4, 5, 6, 7, 8).is8); // "false"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is8 => this is Tuple8;

  /// `true` if `this` is a [Tuple9].
  ///
  /// ```
  /// print(Tuple8(0, 1, 2, 3, 4, 5, 6, 7).is9); // "false"
  /// print(Tuple9(0, 1, 2, 3, 4, 5, 6, 7, 8).is9); // "true"
  /// print(Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9).is9); // "false"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is9 => this is Tuple9;

  /// `true` if `this` is a [Tuple10].
  ///
  /// ```
  /// print(Tuple9(0, 1, 2, 3, 4, 5, 6, 7, 8).is10); // "false"
  /// print(Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9).is10); // "true"
  /// print(Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10).is10); // "false"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is10 => this is Tuple10;

  /// `true` if `this` is a [Tuple11].
  ///
  /// ```
  /// print(Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9).is11); // "false"
  /// print(Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10).is11); // "true"
  /// print(Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11).is11); // "false"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is11 => this is Tuple11;

  /// `true` if `this` is a [Tuple12].
  ///
  /// ```
  /// print(Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10).is12); // "false"
  /// print(Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11).is12); // "true"
  /// print(Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12).is12); // "false"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is12 => this is Tuple12;

  /// `true` if `this` is a [Tuple13].
  ///
  /// ```
  /// print(Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11).is13); // "false"
  /// print(Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12).is13); // "true"
  /// print(Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13).is13); // "false"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is13 => this is Tuple13;

  /// `true` if `this` is a [Tuple14].
  ///
  /// ```
  /// print(Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12).is14); // "false"
  /// print(Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13).is14); // "true"
  /// print(Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14).is14); // "false"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is14 => this is Tuple14;

  /// `true` if `this` is a [Tuple15].
  ///
  /// ```
  /// print(Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13).is15); // "false"
  /// print(Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14).is15); // "true"
  /// print(Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15).is15); // "false"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is15 => this is Tuple15;

  /// `true` if `this` is a [Tuple16].
  ///
  /// ```
  /// print(Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14).is16); // "false"
  /// print(Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15).is16); // "true"
  /// ```
  @pragma('vm:prefer-inline')
  bool get is16 => this is Tuple16;

  @pragma('vm:prefer-inline')
  const Tuple._();

  @override
  String toString() => '(${props.join(', ')})';
}

/// A [Tuple] of 2 items.
@sealed
class Tuple2<I0, I1> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple2(0, 1);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple2(0, 1);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  @override
  List<Object> get props => [i0, i1];

  /// Creates a [Tuple] of 2 items.
  ///
  /// ```
  /// final tuple = Tuple2(0, 1);
  ///
  /// print(tuple); // "(0, 1)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple2(
    this.i0,
    this.i1,
  ) : super._();
}

/// A [Tuple] of 3 items.
@sealed
class Tuple3<I0, I1, I2> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple3(0, 1, 2);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple3(0, 1, 2);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  /// Item 2.
  ///
  /// ```
  /// final tuple = Tuple3(0, 1, 2);
  ///
  /// print(tuple.2); // "2"
  /// ```
  final I2 i2;

  @override
  List<Object> get props => [i0, i1, i2];

  /// Creates a [Tuple] of 3 items.
  ///
  /// ```
  /// final tuple = Tuple3(0, 1, 2);
  ///
  /// print(tuple); // "(0, 1, 2)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple3(
    this.i0,
    this.i1,
    this.i2,
  ) : super._();
}

/// A [Tuple] of 4 items.
@sealed
class Tuple4<I0, I1, I2, I3> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple4(0, 1, 2, 3);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple4(0, 1, 2, 3);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  /// Item 2.
  ///
  /// ```
  /// final tuple = Tuple4(0, 1, 2, 3);
  ///
  /// print(tuple.2); // "2"
  /// ```
  final I2 i2;

  /// Item 3.
  ///
  /// ```
  /// final tuple = Tuple4(0, 1, 2, 3);
  ///
  /// print(tuple.3); // "3"
  /// ```
  final I3 i3;

  @override
  List<Object> get props => [i0, i1, i2, i3];

  /// Creates a [Tuple] of 4 items.
  ///
  /// ```
  /// final tuple = Tuple4(0, 1, 2, 3);
  ///
  /// print(tuple); // "(0, 1, 2, 3)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple4(
    this.i0,
    this.i1,
    this.i2,
    this.i3,
  ) : super._();
}

/// A [Tuple] of 5 items.
@sealed
class Tuple5<I0, I1, I2, I3, I4> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple5(0, 1, 2, 3, 4);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple5(0, 1, 2, 3, 4);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  /// Item 2.
  ///
  /// ```
  /// final tuple = Tuple5(0, 1, 2, 3, 4);
  ///
  /// print(tuple.2); // "2"
  /// ```
  final I2 i2;

  /// Item 3.
  ///
  /// ```
  /// final tuple = Tuple5(0, 1, 2, 3, 4);
  ///
  /// print(tuple.3); // "3"
  /// ```
  final I3 i3;

  /// Item 4.
  ///
  /// ```
  /// final tuple = Tuple5(0, 1, 2, 3, 4);
  ///
  /// print(tuple.4); // "4"
  /// ```
  final I4 i4;

  @override
  List<Object> get props => [i0, i1, i2, i3, i4];

  /// Creates a [Tuple] of 5 items.
  ///
  /// ```
  /// final tuple = Tuple5(0, 1, 2, 3, 4);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple5(
    this.i0,
    this.i1,
    this.i2,
    this.i3,
    this.i4,
  ) : super._();
}

/// A [Tuple] of 6 items.
@sealed
class Tuple6<I0, I1, I2, I3, I4, I5> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple6(0, 1, 2, 3, 4, 5);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple6(0, 1, 2, 3, 4, 5);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  /// Item 2.
  ///
  /// ```
  /// final tuple = Tuple6(0, 1, 2, 3, 4, 5);
  ///
  /// print(tuple.2); // "2"
  /// ```
  final I2 i2;

  /// Item 3.
  ///
  /// ```
  /// final tuple = Tuple6(0, 1, 2, 3, 4, 5);
  ///
  /// print(tuple.3); // "3"
  /// ```
  final I3 i3;

  /// Item 4.
  ///
  /// ```
  /// final tuple = Tuple6(0, 1, 2, 3, 4, 5);
  ///
  /// print(tuple.4); // "4"
  /// ```
  final I4 i4;

  /// Item 5.
  ///
  /// ```
  /// final tuple = Tuple6(0, 1, 2, 3, 4, 5);
  ///
  /// print(tuple.5); // "5"
  /// ```
  final I5 i5;

  @override
  List<Object> get props => [i0, i1, i2, i3, i4, i5];

  /// Creates a [Tuple] of 6 items.
  ///
  /// ```
  /// final tuple = Tuple6(0, 1, 2, 3, 4, 5);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple6(
    this.i0,
    this.i1,
    this.i2,
    this.i3,
    this.i4,
    this.i5,
  ) : super._();
}

/// A [Tuple] of 7 items.
@sealed
class Tuple7<I0, I1, I2, I3, I4, I5, I6> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple7(0, 1, 2, 3, 4, 5, 6);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple7(0, 1, 2, 3, 4, 5, 6);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  /// Item 2.
  ///
  /// ```
  /// final tuple = Tuple7(0, 1, 2, 3, 4, 5, 6);
  ///
  /// print(tuple.2); // "2"
  /// ```
  final I2 i2;

  /// Item 3.
  ///
  /// ```
  /// final tuple = Tuple7(0, 1, 2, 3, 4, 5, 6);
  ///
  /// print(tuple.3); // "3"
  /// ```
  final I3 i3;

  /// Item 4.
  ///
  /// ```
  /// final tuple = Tuple7(0, 1, 2, 3, 4, 5, 6);
  ///
  /// print(tuple.4); // "4"
  /// ```
  final I4 i4;

  /// Item 5.
  ///
  /// ```
  /// final tuple = Tuple7(0, 1, 2, 3, 4, 5, 6);
  ///
  /// print(tuple.5); // "5"
  /// ```
  final I5 i5;

  /// Item 6.
  ///
  /// ```
  /// final tuple = Tuple7(0, 1, 2, 3, 4, 5, 6);
  ///
  /// print(tuple.6); // "6"
  /// ```
  final I6 i6;

  @override
  List<Object> get props => [i0, i1, i2, i3, i4, i5, i6];

  /// Creates a [Tuple] of 7 items.
  ///
  /// ```
  /// final tuple = Tuple7(0, 1, 2, 3, 4, 5, 6);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple7(
    this.i0,
    this.i1,
    this.i2,
    this.i3,
    this.i4,
    this.i5,
    this.i6,
  ) : super._();
}

/// A [Tuple] of 8 items.
@sealed
class Tuple8<I0, I1, I2, I3, I4, I5, I6, I7> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple8(0, 1, 2, 3, 4, 5, 6, 7);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple8(0, 1, 2, 3, 4, 5, 6, 7);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  /// Item 2.
  ///
  /// ```
  /// final tuple = Tuple8(0, 1, 2, 3, 4, 5, 6, 7);
  ///
  /// print(tuple.2); // "2"
  /// ```
  final I2 i2;

  /// Item 3.
  ///
  /// ```
  /// final tuple = Tuple8(0, 1, 2, 3, 4, 5, 6, 7);
  ///
  /// print(tuple.3); // "3"
  /// ```
  final I3 i3;

  /// Item 4.
  ///
  /// ```
  /// final tuple = Tuple8(0, 1, 2, 3, 4, 5, 6, 7);
  ///
  /// print(tuple.4); // "4"
  /// ```
  final I4 i4;

  /// Item 5.
  ///
  /// ```
  /// final tuple = Tuple8(0, 1, 2, 3, 4, 5, 6, 7);
  ///
  /// print(tuple.5); // "5"
  /// ```
  final I5 i5;

  /// Item 6.
  ///
  /// ```
  /// final tuple = Tuple8(0, 1, 2, 3, 4, 5, 6, 7);
  ///
  /// print(tuple.6); // "6"
  /// ```
  final I6 i6;

  /// Item 7.
  ///
  /// ```
  /// final tuple = Tuple8(0, 1, 2, 3, 4, 5, 6, 7);
  ///
  /// print(tuple.7); // "7"
  /// ```
  final I7 i7;

  @override
  List<Object> get props => [i0, i1, i2, i3, i4, i5, i6, i7];

  /// Creates a [Tuple] of 8 items.
  ///
  /// ```
  /// final tuple = Tuple8(0, 1, 2, 3, 4, 5, 6, 7);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple8(
    this.i0,
    this.i1,
    this.i2,
    this.i3,
    this.i4,
    this.i5,
    this.i6,
    this.i7,
  ) : super._();
}

/// A [Tuple] of 9 items.
@sealed
class Tuple9<I0, I1, I2, I3, I4, I5, I6, I7, I8> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple9(0, 1, 2, 3, 4, 5, 6, 7, 8);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple9(0, 1, 2, 3, 4, 5, 6, 7, 8);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  /// Item 2.
  ///
  /// ```
  /// final tuple = Tuple9(0, 1, 2, 3, 4, 5, 6, 7, 8);
  ///
  /// print(tuple.2); // "2"
  /// ```
  final I2 i2;

  /// Item 3.
  ///
  /// ```
  /// final tuple = Tuple9(0, 1, 2, 3, 4, 5, 6, 7, 8);
  ///
  /// print(tuple.3); // "3"
  /// ```
  final I3 i3;

  /// Item 4.
  ///
  /// ```
  /// final tuple = Tuple9(0, 1, 2, 3, 4, 5, 6, 7, 8);
  ///
  /// print(tuple.4); // "4"
  /// ```
  final I4 i4;

  /// Item 5.
  ///
  /// ```
  /// final tuple = Tuple9(0, 1, 2, 3, 4, 5, 6, 7, 8);
  ///
  /// print(tuple.5); // "5"
  /// ```
  final I5 i5;

  /// Item 6.
  ///
  /// ```
  /// final tuple = Tuple9(0, 1, 2, 3, 4, 5, 6, 7, 8);
  ///
  /// print(tuple.6); // "6"
  /// ```
  final I6 i6;

  /// Item 7.
  ///
  /// ```
  /// final tuple = Tuple9(0, 1, 2, 3, 4, 5, 6, 7, 8);
  ///
  /// print(tuple.7); // "7"
  /// ```
  final I7 i7;

  /// Item 8.
  ///
  /// ```
  /// final tuple = Tuple9(0, 1, 2, 3, 4, 5, 6, 7, 8);
  ///
  /// print(tuple.8); // "8"
  /// ```
  final I8 i8;

  @override
  List<Object> get props => [i0, i1, i2, i3, i4, i5, i6, i7, i8];

  /// Creates a [Tuple] of 9 items.
  ///
  /// ```
  /// final tuple = Tuple9(0, 1, 2, 3, 4, 5, 6, 7, 8);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple9(
    this.i0,
    this.i1,
    this.i2,
    this.i3,
    this.i4,
    this.i5,
    this.i6,
    this.i7,
    this.i8,
  ) : super._();
}

/// A [Tuple] of 10 items.
@sealed
class Tuple10<I0, I1, I2, I3, I4, I5, I6, I7, I8, I9> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  /// Item 2.
  ///
  /// ```
  /// final tuple = Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  ///
  /// print(tuple.2); // "2"
  /// ```
  final I2 i2;

  /// Item 3.
  ///
  /// ```
  /// final tuple = Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  ///
  /// print(tuple.3); // "3"
  /// ```
  final I3 i3;

  /// Item 4.
  ///
  /// ```
  /// final tuple = Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  ///
  /// print(tuple.4); // "4"
  /// ```
  final I4 i4;

  /// Item 5.
  ///
  /// ```
  /// final tuple = Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  ///
  /// print(tuple.5); // "5"
  /// ```
  final I5 i5;

  /// Item 6.
  ///
  /// ```
  /// final tuple = Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  ///
  /// print(tuple.6); // "6"
  /// ```
  final I6 i6;

  /// Item 7.
  ///
  /// ```
  /// final tuple = Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  ///
  /// print(tuple.7); // "7"
  /// ```
  final I7 i7;

  /// Item 8.
  ///
  /// ```
  /// final tuple = Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  ///
  /// print(tuple.8); // "8"
  /// ```
  final I8 i8;

  /// Item 9.
  ///
  /// ```
  /// final tuple = Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  ///
  /// print(tuple.9); // "9"
  /// ```
  final I9 i9;

  @override
  List<Object> get props => [i0, i1, i2, i3, i4, i5, i6, i7, i8, i9];

  /// Creates a [Tuple] of 10 items.
  ///
  /// ```
  /// final tuple = Tuple10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple10(
    this.i0,
    this.i1,
    this.i2,
    this.i3,
    this.i4,
    this.i5,
    this.i6,
    this.i7,
    this.i8,
    this.i9,
  ) : super._();
}

/// A [Tuple] of 11 items.
@sealed
class Tuple11<I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  /// Item 2.
  ///
  /// ```
  /// final tuple = Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  ///
  /// print(tuple.2); // "2"
  /// ```
  final I2 i2;

  /// Item 3.
  ///
  /// ```
  /// final tuple = Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  ///
  /// print(tuple.3); // "3"
  /// ```
  final I3 i3;

  /// Item 4.
  ///
  /// ```
  /// final tuple = Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  ///
  /// print(tuple.4); // "4"
  /// ```
  final I4 i4;

  /// Item 5.
  ///
  /// ```
  /// final tuple = Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  ///
  /// print(tuple.5); // "5"
  /// ```
  final I5 i5;

  /// Item 6.
  ///
  /// ```
  /// final tuple = Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  ///
  /// print(tuple.6); // "6"
  /// ```
  final I6 i6;

  /// Item 7.
  ///
  /// ```
  /// final tuple = Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  ///
  /// print(tuple.7); // "7"
  /// ```
  final I7 i7;

  /// Item 8.
  ///
  /// ```
  /// final tuple = Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  ///
  /// print(tuple.8); // "8"
  /// ```
  final I8 i8;

  /// Item 9.
  ///
  /// ```
  /// final tuple = Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  ///
  /// print(tuple.9); // "9"
  /// ```
  final I9 i9;

  /// Item 10.
  ///
  /// ```
  /// final tuple = Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  ///
  /// print(tuple.10); // "10"
  /// ```
  final I10 i10;

  @override
  List<Object> get props => [i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10];

  /// Creates a [Tuple] of 11 items.
  ///
  /// ```
  /// final tuple = Tuple11(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple11(
    this.i0,
    this.i1,
    this.i2,
    this.i3,
    this.i4,
    this.i5,
    this.i6,
    this.i7,
    this.i8,
    this.i9,
    this.i10,
  ) : super._();
}

/// A [Tuple] of 12 items.
@sealed
class Tuple12<I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  /// Item 2.
  ///
  /// ```
  /// final tuple = Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
  ///
  /// print(tuple.2); // "2"
  /// ```
  final I2 i2;

  /// Item 3.
  ///
  /// ```
  /// final tuple = Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
  ///
  /// print(tuple.3); // "3"
  /// ```
  final I3 i3;

  /// Item 4.
  ///
  /// ```
  /// final tuple = Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
  ///
  /// print(tuple.4); // "4"
  /// ```
  final I4 i4;

  /// Item 5.
  ///
  /// ```
  /// final tuple = Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
  ///
  /// print(tuple.5); // "5"
  /// ```
  final I5 i5;

  /// Item 6.
  ///
  /// ```
  /// final tuple = Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
  ///
  /// print(tuple.6); // "6"
  /// ```
  final I6 i6;

  /// Item 7.
  ///
  /// ```
  /// final tuple = Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
  ///
  /// print(tuple.7); // "7"
  /// ```
  final I7 i7;

  /// Item 8.
  ///
  /// ```
  /// final tuple = Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
  ///
  /// print(tuple.8); // "8"
  /// ```
  final I8 i8;

  /// Item 9.
  ///
  /// ```
  /// final tuple = Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
  ///
  /// print(tuple.9); // "9"
  /// ```
  final I9 i9;

  /// Item 10.
  ///
  /// ```
  /// final tuple = Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
  ///
  /// print(tuple.10); // "10"
  /// ```
  final I10 i10;

  /// Item 11.
  ///
  /// ```
  /// final tuple = Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
  ///
  /// print(tuple.11); // "11"
  /// ```
  final I11 i11;

  @override
  List<Object> get props => [i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11];

  /// Creates a [Tuple] of 12 items.
  ///
  /// ```
  /// final tuple = Tuple12(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple12(
    this.i0,
    this.i1,
    this.i2,
    this.i3,
    this.i4,
    this.i5,
    this.i6,
    this.i7,
    this.i8,
    this.i9,
    this.i10,
    this.i11,
  ) : super._();
}

/// A [Tuple] of 13 items.
@sealed
class Tuple13<I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  /// Item 2.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple.2); // "2"
  /// ```
  final I2 i2;

  /// Item 3.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple.3); // "3"
  /// ```
  final I3 i3;

  /// Item 4.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple.4); // "4"
  /// ```
  final I4 i4;

  /// Item 5.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple.5); // "5"
  /// ```
  final I5 i5;

  /// Item 6.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple.6); // "6"
  /// ```
  final I6 i6;

  /// Item 7.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple.7); // "7"
  /// ```
  final I7 i7;

  /// Item 8.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple.8); // "8"
  /// ```
  final I8 i8;

  /// Item 9.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple.9); // "9"
  /// ```
  final I9 i9;

  /// Item 10.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple.10); // "10"
  /// ```
  final I10 i10;

  /// Item 11.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple.11); // "11"
  /// ```
  final I11 i11;

  /// Item 12.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple.12); // "12"
  /// ```
  final I12 i12;

  @override
  List<Object> get props => [i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12];

  /// Creates a [Tuple] of 13 items.
  ///
  /// ```
  /// final tuple = Tuple13(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple13(
    this.i0,
    this.i1,
    this.i2,
    this.i3,
    this.i4,
    this.i5,
    this.i6,
    this.i7,
    this.i8,
    this.i9,
    this.i10,
    this.i11,
    this.i12,
  ) : super._();
}

/// A [Tuple] of 14 items.
@sealed
class Tuple14<I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  /// Item 2.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple.2); // "2"
  /// ```
  final I2 i2;

  /// Item 3.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple.3); // "3"
  /// ```
  final I3 i3;

  /// Item 4.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple.4); // "4"
  /// ```
  final I4 i4;

  /// Item 5.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple.5); // "5"
  /// ```
  final I5 i5;

  /// Item 6.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple.6); // "6"
  /// ```
  final I6 i6;

  /// Item 7.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple.7); // "7"
  /// ```
  final I7 i7;

  /// Item 8.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple.8); // "8"
  /// ```
  final I8 i8;

  /// Item 9.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple.9); // "9"
  /// ```
  final I9 i9;

  /// Item 10.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple.10); // "10"
  /// ```
  final I10 i10;

  /// Item 11.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple.11); // "11"
  /// ```
  final I11 i11;

  /// Item 12.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple.12); // "12"
  /// ```
  final I12 i12;

  /// Item 13.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple.13); // "13"
  /// ```
  final I13 i13;

  @override
  List<Object> get props => [i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13];

  /// Creates a [Tuple] of 14 items.
  ///
  /// ```
  /// final tuple = Tuple14(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple14(
    this.i0,
    this.i1,
    this.i2,
    this.i3,
    this.i4,
    this.i5,
    this.i6,
    this.i7,
    this.i8,
    this.i9,
    this.i10,
    this.i11,
    this.i12,
    this.i13,
  ) : super._();
}

/// A [Tuple] of 15 items.
@sealed
class Tuple15<I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  /// Item 2.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.2); // "2"
  /// ```
  final I2 i2;

  /// Item 3.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.3); // "3"
  /// ```
  final I3 i3;

  /// Item 4.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.4); // "4"
  /// ```
  final I4 i4;

  /// Item 5.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.5); // "5"
  /// ```
  final I5 i5;

  /// Item 6.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.6); // "6"
  /// ```
  final I6 i6;

  /// Item 7.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.7); // "7"
  /// ```
  final I7 i7;

  /// Item 8.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.8); // "8"
  /// ```
  final I8 i8;

  /// Item 9.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.9); // "9"
  /// ```
  final I9 i9;

  /// Item 10.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.10); // "10"
  /// ```
  final I10 i10;

  /// Item 11.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.11); // "11"
  /// ```
  final I11 i11;

  /// Item 12.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.12); // "12"
  /// ```
  final I12 i12;

  /// Item 13.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.13); // "13"
  /// ```
  final I13 i13;

  /// Item 14.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple.14); // "14"
  /// ```
  final I14 i14;

  @override
  List<Object> get props => [i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14];

  /// Creates a [Tuple] of 15 items.
  ///
  /// ```
  /// final tuple = Tuple15(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple15(
    this.i0,
    this.i1,
    this.i2,
    this.i3,
    this.i4,
    this.i5,
    this.i6,
    this.i7,
    this.i8,
    this.i9,
    this.i10,
    this.i11,
    this.i12,
    this.i13,
    this.i14,
  ) : super._();
}

/// A [Tuple] of 16 items.
@sealed
class Tuple16<I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15> extends Tuple {
  /// Item 0.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.0); // "0"
  /// ```
  final I0 i0;

  /// Item 1.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.1); // "1"
  /// ```
  final I1 i1;

  /// Item 2.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.2); // "2"
  /// ```
  final I2 i2;

  /// Item 3.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.3); // "3"
  /// ```
  final I3 i3;

  /// Item 4.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.4); // "4"
  /// ```
  final I4 i4;

  /// Item 5.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.5); // "5"
  /// ```
  final I5 i5;

  /// Item 6.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.6); // "6"
  /// ```
  final I6 i6;

  /// Item 7.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.7); // "7"
  /// ```
  final I7 i7;

  /// Item 8.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.8); // "8"
  /// ```
  final I8 i8;

  /// Item 9.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.9); // "9"
  /// ```
  final I9 i9;

  /// Item 10.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.10); // "10"
  /// ```
  final I10 i10;

  /// Item 11.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.11); // "11"
  /// ```
  final I11 i11;

  /// Item 12.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.12); // "12"
  /// ```
  final I12 i12;

  /// Item 13.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.13); // "13"
  /// ```
  final I13 i13;

  /// Item 14.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.14); // "14"
  /// ```
  final I14 i14;

  /// Item 15.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple.15); // "15"
  /// ```
  final I15 i15;

  @override
  List<Object> get props => [i0, i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12, i13, i14, i15];

  /// Creates a [Tuple] of 16 items.
  ///
  /// ```
  /// final tuple = Tuple16(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
  ///
  /// print(tuple); // "(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)"
  /// ```
  @pragma('vm:prefer-inline')
  const Tuple16(
    this.i0,
    this.i1,
    this.i2,
    this.i3,
    this.i4,
    this.i5,
    this.i6,
    this.i7,
    this.i8,
    this.i9,
    this.i10,
    this.i11,
    this.i12,
    this.i13,
    this.i14,
    this.i15,
  ) : super._();
}
