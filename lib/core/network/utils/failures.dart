abstract class Failure {
  final String message;
  final dynamic exception;

  Failure({required this.message, this.exception});

  @override
  String toString() {
    return "$runtimeType: $message ${exception != null ? '(${exception.runtimeType})' : ''}";
  }
}

class ApiFailure extends Failure {
  ApiFailure({required super.message, super.exception});
}

class GenericFailure extends Failure {
  GenericFailure({required super.message, super.exception});
}

class DatabaseFailure extends Failure {
  DatabaseFailure({required super.message, super.exception});
}
