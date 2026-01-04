/// Base class for domain failures.
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'An unexpected error occurred']);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure([super.message = 'No internet connection']);
}
