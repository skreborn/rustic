import 'package:rustic/option.dart';
import 'package:rustic/result.dart';
import 'package:rustic/tuple.dart';

Option<int> multiply(String a, String b) {
  return int.tryParse(a).asOption().and((a) {
    return int.tryParse(b).asOption().map((b) => a * b);
  });
}

Result<int, String> tryParse(String source) {
  return Ok<int, String>(int.tryParse(source)).and((value) {
    return value == null ? Err('not a number: $source') : Ok(value);
  });
}

Tuple2<int, int> sum2(Tuple2<int, int> a, Tuple2<int, int> b) {
  return Tuple2(a.i0 + b.i0, a.i1 + b.i1);
}

void main() {
  print(multiply('2', '3')); // "Some(6)"
  print(multiply('two', '3')); // "None"

  print(tryParse('2')); // "Ok(2)"
  print(tryParse('two')); // "Err(not a number: two)"

  print(sum2(const Tuple2(2, 3), const Tuple2(4, 5))); // "(6, 8)"
}
