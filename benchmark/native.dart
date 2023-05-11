import 'package:benchmark_harness/benchmark_harness.dart';

final class _NativeBenchmark extends BenchmarkBase {
  const _NativeBenchmark() : super('Native');

  @override
  void run() {
    _multiply(2, 3);
    _multiply(null, 3);
    _multiply(2, null);
    _multiply(null, null);
  }

  @override
  void exercise() {
    for (var i = 0; i < 10000; ++i) {
      run();
    }
  }

  (int?, String?) _multiply(int? a, int? b) {
    return a != null && b != null ? (a * b, null) : (null, 'null');
  }
}

void main() => const _NativeBenchmark().report();
