import 'src/generate.dart';

const _minItems = 2;
const _maxItems = 16;

void main() async {
  List<String> minMax(List<String> Function(int n) generate) {
    return [for (var n = _minItems; n <= _maxItems; ++n) ...generate(n)];
  }

  generate('src/tuple_variants', [
    "part of '../tuple.dart';",
    null,
    ...minMax((n) => [if (n > _minItems) null, _variant(n)]),
  ]);
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
