import 'package:rustic/option.dart';
import 'package:rustic/result.dart';

Result<int, String> _multiply(Option<int> a, Option<int> b) {
  return a.zip(b).map((pair) => pair.$1 * pair.$2).okOr('null');
}

void main() {
  print(_multiply(const Some(2), const Some(3))); // prints "Ok(Some(6))"
  print(_multiply(const Some(2), const None())); // prints "Err(null)"
}
