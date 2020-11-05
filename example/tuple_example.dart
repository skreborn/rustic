import 'package:rustic/tuple.dart';

Tuple2<int, int> sum2(Tuple2<int, int> a, Tuple2<int, int> b) {
  return Tuple2(a.i0 + b.i0, a.i1 + b.i1);
}

void main() {
  print(sum2(Tuple2(2, 3), Tuple2(4, 5))); // "(6, 8)"
}
