import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:rustic/option.dart';

class _OptionBenchmark extends BenchmarkBase {
  const _OptionBenchmark() : super('Option');

  @override
  void run() {
    for (var i = 0; i < 10000; ++i) {
      _multiply('2', '3');
      _multiply('two', '3');
    }
  }

  Option<int> _multiply(String a, String b) {
    return int.tryParse(a).asOption().and((a) {
      return int.tryParse(b).asOption().map((b) => a * b);
    });
  }
}

void main() => const _OptionBenchmark().report();
