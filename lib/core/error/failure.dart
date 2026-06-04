import 'package:equatable/equatable.dart';

/// Typed failures used across layers. The data layer catches exceptions and
/// maps them to a [Failure]; the presentation layer maps a [Failure] to a
/// user-friendly message (CLAUDE.md §B5).
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Remote/server side problem (non-2xx, malformed payload, etc.).
final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}

/// Local cache / storage problem.
final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}

/// No connectivity.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error']);
}

/// Anything not otherwise classified.
final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong']);
}
