import 'package:rustic/option.dart';

Option<int> multiply(String a, String b) {
  return int.tryParse(a).asOption().and((a) {
    return int.tryParse(b).asOption().map((b) => a * b);
  });
}

void main() {
  print(multiply('2', '3')); // "Some(6)"
  print(multiply('two', '3')); // "None"
}
