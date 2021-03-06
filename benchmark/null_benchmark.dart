import 'package:benchmark_harness/benchmark_harness.dart';

class _NullBenchmark extends BenchmarkBase {
  const _NullBenchmark() : super('Null');

  @override
  void run() {
    for (var i = 0; i < 10000; ++i) {
      _multiply('2', '3');
      _multiply('two', '3');
    }
  }

  int? _multiply(String a, String b) {
    final aParsed = int.tryParse(a);

    if (aParsed != null) {
      final bParsed = int.tryParse(b);

      if (bParsed != null) {
        return aParsed * bParsed;
      }
    }

    return null;
  }
}

void main() => const _NullBenchmark().report();
