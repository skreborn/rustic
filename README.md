# Rustic

Rustic defines various constructs inspired by the [Rust] programming
language.

Note that these are merely *inspired* by Rust, and do not necessarily map one-to-one to their
original counterparts. With that said, they do indeed share the majority of features and naming,
unless it is either againts Dart's conventions or simply impossible to implement.

## Release history

See the [changelog] for a detailed list of changes throughout the package's history.

## Performance

So how does this compare in performance to using Dart's built-in constructs? Rudamentary benchmarks
of simple tasks show about a 50% decrease in performance when using `Option` instead of a simple
nullable type. Then again, that's still pretty darn fast.

Should you use it in performance-critical code? Probably not. Should you use Dart as a whole in such
a context though? Again, probably not.

[Rust]: https://www.rust-lang.org/
[changelog]: https://github.com/skreborn/rustic/blob/master/CHANGELOG.md
