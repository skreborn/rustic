import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:rustic/option.dart';
import 'package:rustic/result.dart';

final class _RusticBenchmark extends BenchmarkBase {
  const _RusticBenchmark() : super('Rustic');

  @override
  void run() {
    _multiply(const Some(2), const Some(3));
    _multiply(const None(), const Some(3));
    _multiply(const Some(2), const None());
    _multiply(const None(), const None());
  }

  @override
  void exercise() {
    for (var i = 0; i < 10000; ++i) {
      run();
    }
  }

  Result<int, String> _multiply(Option<int> a, Option<int> b) {
    return a.zip(b).map((pair) => pair.$1 * pair.$2).okOr('null');
  }
}

void main() => const _RusticBenchmark().report();
