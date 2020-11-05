import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:rustic/result.dart';

class _ResultBenchmark extends BenchmarkBase {
  const _ResultBenchmark() : super('Result');

  @override
  void run() {
    for (var i = 0; i < 10000; ++i) {
      _tryParse('2');
      _tryParse('two');
    }
  }

  Result<int, String> _tryParse(String source) {
    return Ok<int, String>(int.tryParse(source)).and((value) {
      return value == null ? Err('not a number: $source') : Ok(value);
    });
  }
}

void main() => const _ResultBenchmark().report();
