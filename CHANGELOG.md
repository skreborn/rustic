## 0.5.2

Another hotfix that corrects a compilation error.

- Fix `Option.zip` unable to compile due to a type error that the analyzer missed.

## 0.5.1

This is a hotfix release to restore the flexibility of the collect functions that was accidentally
dropped in the previous version.

- Make collect functions generic over the value type.

## 0.5.0

This is the largest release since the initial one, adding, removing, or otherwise changing countless
items. The main driver for this is the arrival of Dart 3, which this package will require as a
minimum going forward.

The `Tuple` types (including `Unit`) have been stripped, as Dart 3 comes with tuples built into the
language in the form of records. With this change, the complete `tuple` library goes away.

The asynchronous versions of all instance methods have also been removed, as it has become
straightforward to provide their functionality in user code with the new language constructs,
should there be a need. Instead of `rustic` including an asnychronous version of all methods, one
can, for the most part, simply turn to the new `switch` expression, if they really must execute
asynchronous code when manipulating or otherwise working with `rustic`. This change might make
migration to the new version more difficult in certain cases, but reduces confusion and maintenance
in the long run. Real-world usage indicated that the asynchronous versions are seldom used, anyway.

- **\[BREAKING\]** Require Dart 3.
- Add the `Optional` extension.
  This replaces the `Optionable` extension.
- Add the `FlattenedOption` extension.
  This replaces the `OptionalOption` extension.
- Add the `UnzippedOption` extension.
- Add the `TransposedOption` extension.
  This replaces the `OptionalResult` extension.
- Add the `Option.collect` method.
- Add the `Option.collectAsync` method.
- Add the `Option.inspect` method.
- Add the `Option.isSomeAnd` method.
- Add the `Option.mapOr` method.
- Add the `Option.mapOrElse` method.
- Add the `Option.unwrapOr` method.
- Add the `Option.unwrapOrElse` method.
- Add the `Option.valueOrNull` getter.
- Add the `FlattenedResult` extension.
  This replaces the `ResultingResult` extension.
- Add the `TransposedResult` extension.
  This replaces the `ResultingOption` extension.
- Add the `Result.collectAsync` method.
- Add the `Result.errorOrNull` getter.
- Add the `Result.inspect` method.
- Add the `Result.inspectErr` method.
- Add the `Result.isErrAnd` method.
- Add the `Result.isOkAnd` method.
- Add the `Result.mapErrOr` method.
- Add the `Result.mapErrOrElse` method.
- Add the `Result.mapOr` method.
- Add the `Result.mapOrElse` method.
- Add the `Result.unwrapErrOr` method.
- Add the `Result.unwrapErrOrElse` method.
- Add the `Result.unwrapOr` method.
- Add the `Result.unwrapOrElse` method.
- Add the `Result.valueOrNull` getter.
- **\[BREAKING\]** Rename the `Option.andSync` method to `andThen`.
- **\[BREAKING\]** Remove the `Option.asPlain` method.
  Use the `valueOrNull` getter instead.
- **\[BREAKING\]** Rename the `Option.mapSync` method to `map`.
  This new method no longer accepts a callback to calculate a fallback value.
  If a fallback value is desired, use `mapOr` or `mapOrElse` instead.
- **\[BREAKING\]** Remove the `Option.match` method.
- **\[BREAKING\]** Remove the `Option.matchSync` method.
- **\[BREAKING\]** Rename the `Option.okOrSync` method to `okOrElse`.
- **\[BREAKING\]** Rename the `Option.orSync` method to `orElse`.
- **\[BREAKING\]** Remove the `Option.unwrapNone` method.
- **\[BREAKING\]** Rename the `Option.unwrapSync` method to `unwrap`.
  This new method no longer accepts a callback to calculate a fallback value.
  If a fallback value is desired, use `unwrapOr` or `unwrapOrElse` instead.
- **\[BREAKING\]** Remove the `Option.whenNone` method.
- **\[BREAKING\]** Remove the `Option.whenNoneSync` method.
- **\[BREAKING\]** Remove the `Option.whenSome` method.
- **\[BREAKING\]** Remove the `Option.whenSomeSync` method.
- **\[BREAKING\]** Rename the `Option.whereSync` method to `where`.
- **\[BREAKING\]** Rename the `Option.zipSync` method to `zip`.
  This new method no longer accepts a callback to generate the other value.
- **\[BREAKING\]** Rename the `Option.zipWithSync` method to `zipWith`.
  This new method no longer accepts a callback to generate the other value.
- **\[BREAKING\]** Remove the `Optionable` extension.
  Use the `Optionial` extension instead.
  Instead of an `asOption` method, this new extension has an `optional` getter.
- **\[BREAKING\]** Remove the `OptionalOption` extension.
  Use the `FlattenedOption` extension instead.
  Instead of a `flatten` method, this new extension has a `flattened` getter.
- **\[BREAKING\]** Remove the `OptionalResult` extension.
  Use the `TransposedOption` extension instead.
  Instead of a `transpose` method, this new extension has a `transposed` getter.
- **\[BREAKING\]** Remove the `Checker` type.
- **\[BREAKING\]** Remove the `ExceptionMapper` type.
- **\[BREAKING\]** Remove the `ExceptionMapperSync` type.
- **\[BREAKING\]** Rename the `OkResult` extension to `SuccessfulResult`.
- **\[BREAKING\]** Rename the `ErrResult` extension to `ErroneousResult`.
- **\[BREAKING\]** Rename the `Result.andSync` method to `andThen`.
- **\[BREAKING\]** Remove the `Result.catchException` method.
- **\[BREAKING\]** Remove the `Result.catchExceptionSync` method.
- **\[BREAKING\]** Rename the `Result.collectSync` method to `collect`.
- **\[BREAKING\]** Rename the `Result.mapErrSync` method to `mapErr`.
  This new method no longer accepts a callback to calculate a fallback error.
  If a fallback error is desired, use `mapErrOr` or `mapErrOrElse` instead.
- **\[BREAKING\]** Rename the `Result.mapSync` method to `map`.
  This new method no longer accepts a callback to calculate a fallback value.
  If a fallback value is desired, use `mapOr` or `mapOrElse` instead.
- **\[BREAKING\]** Remove the `Result.match` method.
- **\[BREAKING\]** Remove the `Result.matchSync` method.
- **\[BREAKING\]** Rename the `Result.orSync` method to `orElse`.
- **\[BREAKING\]** Rename the `Result.unwrapErrSync` method to `unwrapErr`.
  This new method no longer accepts a callback to calculate a fallback error.
  If a fallback error is desired, use `unwrapErrOr` or `unwrapErrOrElse` instead.
- **\[BREAKING\]** Rename the `Result.unwrapSync` method to `unwrap`.
  This new method no longer accepts a callback to calculate a fallback value.
  If a fallback value is desired, use `unwrapOr` or `unwrapOrElse` instead.
- **\[BREAKING\]** Remove the `Result.whenErr` method.
- **\[BREAKING\]** Remove the `Result.whenErrSync` method.
- **\[BREAKING\]** Remove the `Result.whenOk` method.
- **\[BREAKING\]** Remove the `Result.whenOkSync` method.
- **\[BREAKING\]** Remove the `ResultingResult` extension.
  Use the `FlattenedResult` extension instead.
  Instead of a `flatten` method, this new extension has a `flattened` getter.
- **\[BREAKING\]** Remove the `ResultingOption` extension.
  Use the `TransposedResult` extension instead.
  Instead of a `transpose` method, this new extension has a `transposed` getter.
- **\[BREAKING\]** Remove the `tuple` library.
  Dart comes with tuples built into the language now.

## 0.4.0 (2022-01-07)

- Introduce asynchronous variants of functions where applicable.
- **\[BREAKING\]** Numerous functions that were previously synchronous in nature are now
  asynchronous by default. Following Dart conventions, the synchronous variants have the suffix
  `Sync`. **Take extra care when upgrading so you don't end up with asynchronous functions that are
  never awaited.**

## 0.3.0

- **\[BREAKING\]** Reduce maximum tuple item count to 8.

## 0.2.0

- **\[BREAKING\]** Migrate to null-safety. **Requires Dart 2.12.**

## 0.1.1

- Implement unit type.

## 0.1.0

- Implement tuples (up to 16 items).
- Implement optional values.
- Implement operation results.
