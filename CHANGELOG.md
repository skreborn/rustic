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
- Add the `option/Optional` extension.
  This replaces the `Optionable` extension.
- Add the `option/FlattenedOption` extension.
  This replaces the `OptionalOption` extension.
- Add the `option/UnzippedOption` extension.
- Add the `option/TransposedOption` extension.
  This replaces the `OptionalResult` extension.
- Add the `option/Option.collect` method.
- Add the `option/Option.collectAsync` method.
- Add the `option/Option.inspect` method.
- Add the `option/Option.isSomeAnd` method.
- Add the `option/Option.mapOr` method.
- Add the `option/Option.mapOrElse` method.
- Add the `option/Option.unwrapOr` method.
- Add the `option/Option.unwrapOrElse` method.
- Add the `option/Option.valueOrNull` getter.
- Add the `result/FlattenedResult` extension.
  This replaces the `ResultingResult` extension.
- Add the `result/TransposedResult` extension.
  This replaces the `ResultingOption` extension.
- Add the `result/Result.collectAsync` method.
- Add the `result/Result.errorOrNull` getter.
- Add the `result/Result.inspect` method.
- Add the `result/Result.inspectErr` method.
- Add the `result/Result.isErrAnd` method.
- Add the `result/Result.isOkAnd` method.
- Add the `result/Result.mapErrOr` method.
- Add the `result/Result.mapErrOrElse` method.
- Add the `result/Result.mapOr` method.
- Add the `result/Result.mapOrElse` method.
- Add the `result/Result.unwrapErrOr` method.
- Add the `result/Result.unwrapErrOrElse` method.
- Add the `result/Result.unwrapOr` method.
- Add the `result/Result.unwrapOrElse` method.
- Add the `result/Result.valueOrNull` getter.
- **\[BREAKING\]** Rename the `option/Option.andSync` method to `andThen`.
- **\[BREAKING\]** Remove the `option/Option.asPlain` method.
  Use the `valueOrNull` getter instead.
- **\[BREAKING\]** Rename the `option/Option.mapSync` method to `map`.
  This new method no longer accepts a callback to calculate a fallback value.
  If a fallback value is desired, use `mapOr` or `mapOrElse` instead.
- **\[BREAKING\]** Remove the `option/Option.match` method.
- **\[BREAKING\]** Remove the `option/Option.matchSync` method.
- **\[BREAKING\]** Rename the `option/Option.okOrSync` method to `okOrElse`.
- **\[BREAKING\]** Rename the `option/Option.orSync` method to `orElse`.
- **\[BREAKING\]** Remove the `option/Option.unwrapNone` method.
- **\[BREAKING\]** Rename the `option/Option.unwrapSync` method to `unwrap`.
  This new method no longer accepts a callback to calculate a fallback value.
  If a fallback value is desired, use `unwrapOr` or `unwrapOrElse` instead.
- **\[BREAKING\]** Remove the `option/Option.whenNone` method.
- **\[BREAKING\]** Remove the `option/Option.whenNoneSync` method.
- **\[BREAKING\]** Remove the `option/Option.whenSome` method.
- **\[BREAKING\]** Remove the `option/Option.whenSomeSync` method.
- **\[BREAKING\]** Rename the `option/Option.whereSync` method to `where`.
- **\[BREAKING\]** Rename the `option/Option.zipSync` method to `zip`.
  This new method no longer accepts a callback to generate the other value.
- **\[BREAKING\]** Rename the `option/Option.zipWithSync` method to `zipWith`.
  This new method no longer accepts a callback to generate the other value.
- **\[BREAKING\]** Remove the `option/Optionable` extension.
  Use the `Optionial` extension instead.
  Instead of an `asOption` method, this new extension has an `optional` getter.
- **\[BREAKING\]** Remove the `option/OptionalOption` extension.
  Use the `FlattenedOption` extension instead.
  Instead of a `flatten` method, this new extension has a `flattened` getter.
- **\[BREAKING\]** Remove the `option/OptionalResult` extension.
  Use the `TransposedOption` extension instead.
  Instead of a `transpose` method, this new extension has a `transposed` getter.
- **\[BREAKING\]** Remove the `result/Checker` type.
- **\[BREAKING\]** Remove the `result/ExceptionMapper` type.
- **\[BREAKING\]** Remove the `result/ExceptionMapperSync` type.
- **\[BREAKING\]** Rename the `result/OkResult` extension to `SuccessfulResult`.
- **\[BREAKING\]** Rename the `result/ErrResult` extension to `ErroneousResult`.
- **\[BREAKING\]** Rename the `result/Result.andSync` method to `andThen`.
- **\[BREAKING\]** Remove the `result/Result.catchException` method.
- **\[BREAKING\]** Remove the `result/Result.catchExceptionSync` method.
- **\[BREAKING\]** Rename the `result/Result.collectSync` method to `collect`.
- **\[BREAKING\]** Rename the `result/Result.mapErrSync` method to `mapErr`.
  This new method no longer accepts a callback to calculate a fallback error.
  If a fallback error is desired, use `mapErrOr` or `mapErrOrElse` instead.
- **\[BREAKING\]** Rename the `result/Result.mapSync` method to `map`.
  This new method no longer accepts a callback to calculate a fallback value.
  If a fallback value is desired, use `mapOr` or `mapOrElse` instead.
- **\[BREAKING\]** Remove the `result/Result.match` method.
- **\[BREAKING\]** Remove the `result/Result.matchSync` method.
- **\[BREAKING\]** Rename the `result/Result.orSync` method to `orElse`.
- **\[BREAKING\]** Rename the `result/Result.unwrapErrSync` method to `unwrapErr`.
  This new method no longer accepts a callback to calculate a fallback error.
  If a fallback error is desired, use `unwrapErrOr` or `unwrapErrOrElse` instead.
- **\[BREAKING\]** Rename the `result/Result.unwrapSync` method to `unwrap`.
  This new method no longer accepts a callback to calculate a fallback value.
  If a fallback value is desired, use `unwrapOr` or `unwrapOrElse` instead.
- **\[BREAKING\]** Remove the `result/Result.whenErr` method.
- **\[BREAKING\]** Remove the `result/Result.whenErrSync` method.
- **\[BREAKING\]** Remove the `result/Result.whenOk` method.
- **\[BREAKING\]** Remove the `result/Result.whenOkSync` method.
- **\[BREAKING\]** Remove the `result/ResultingResult` extension.
  Use the `FlattenedResult` extension instead.
  Instead of a `flatten` method, this new extension has a `flattened` getter.
- **\[BREAKING\]** Remove the `result/ResultingOption` extension.
  Use the `TransposedResult` extension instead.
  Instead of a `transpose` method, this new extension has a `transposed` getter.
- **\[BREAKING\]** Remove the `tuple` library.
  Dart comes with tuples built into the language now.

## 0.4.0

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
