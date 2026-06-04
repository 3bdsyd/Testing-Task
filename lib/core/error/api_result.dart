import 'failure.dart';

/// Result type returned by use cases and repositories (CLAUDE.md §B5).
///
/// Implemented as a Dart 3 sealed class so callers can exhaustively pattern
/// match without Freezed:
///
/// ```dart
/// switch (result) {
///   Success(:final data) => ...,
///   ResultFailure(:final failure) => ...,
/// }
/// ```
sealed class ApiResult<T> {
  const ApiResult();

  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(Failure failure) = ResultFailure<T>;

  /// Fold both branches into a single value.
  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final data) => onSuccess(data),
      ResultFailure<T>(:final failure) => onFailure(failure),
    };
  }
}

final class Success<T> extends ApiResult<T> {
  const Success(this.data);
  final T data;
}

final class ResultFailure<T> extends ApiResult<T> {
  const ResultFailure(this.failure);
  final Failure failure;
}
