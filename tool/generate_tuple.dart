import 'src/generate.dart';

const _minItems = 2;
const _maxItems = 16;

void main() async {
  List<String> minMax(List<String> Function(int n) generate) {
    return [for (var n = _minItems; n <= _maxItems; ++n) ...generate(n)];
  }

  generate('tuple', [
    '''
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
    ''',
    ...minMax((n) {
      return [
        if (n > _minItems) null,
        _of(n),
      ];
    }),
    null,
    ...minMax((n) {
      final examples = [n - 1, n, n + 1].where((m) => m >= _minItems && m <= _maxItems).map((m) {
        final values = Iterable.generate(m, (i) => i).join(', ');

        return '/// print(Tuple$m($values).is$n); // "${n == m}"';
      }).join('\n');

      return [
        '''
          /// `true` if `this` is a [Tuple$n].
          ///
          /// ```
          $examples
          /// ```
          bool get is$n => this is Tuple$n;
        ''',
      ];
    }),
    null,
    r'''
      const Tuple._();

      @override
      String toString() => '(${props.join(', ')})';
    ''',
    '}',
    null,
    ...minMax((n) {
      return [
        if (n > _minItems) null,
        _variant(n),
      ];
    }),
  ]);
}

String _of(int n) {
  final names = Iterable.generate(n, (i) => 'i$i');

  final values = Iterable.generate(n, (i) => i).join(', ');
  final types = names.join(', ').toUpperCase();
  final typedParams = names.map((name) => '${name.toUpperCase()} $name').join(', ');
  final params = names.join(', ');

  return '''
    /// Creates a [Tuple$n] with the given values.
    ///
    /// ```
    /// final tuple = Tuple$n($values);
    ///
    /// print(tuple); // "($values)"
    /// ```
    static Tuple of$n<$types>($typedParams,) => Tuple$n($params);
  ''';
}

String _variant(int n) {
  final names = Iterable.generate(n, (i) => 'i$i');

  final types = names.join(', ').toUpperCase();
  final values = Iterable.generate(n, (i) => i).join(', ');
  final props = names.join(', ');
  final params = names.map((name) => 'this.$name').join(', ');

  final fields = Iterable.generate(n, (i) {
    return '''
      /// Item $i.
      ///
      /// ```
      /// final tuple = Tuple$n($values);
      ///
      /// print(tuple.$i); // "$i"
      /// ```
      final ${names.elementAt(i).toUpperCase()} ${names.elementAt(i)};
    ''';
  }).join('\n');

  return '''
    /// A [Tuple] of $n items.
    @sealed
    class Tuple$n<$types> extends Tuple {
      $fields

      @override
      List<Object> get props => [$props];

      /// Creates a [Tuple] of $n items.
      ///
      /// ```
      /// final tuple = Tuple$n($values);
      ///
      /// print(tuple); // "($values)"
      /// ```
      const Tuple$n($params,) : super._();
    }
  ''';
}
