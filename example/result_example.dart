import 'package:rustic/result.dart';

Result<int, String> tryParse(String source) {
  return Ok<int, String>(int.tryParse(source)).and((value) {
    return value == null ? Err('not a number: $source') : Ok(value);
  });
}

void main() {
  print(tryParse('2')); // "Ok(2)"
  print(tryParse('two')); // "Err(not a number: two)"
}
