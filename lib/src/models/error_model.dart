class ErrorModel {
  final ErrorType type;
  final int? statusCode;
  final String message;

  ErrorModel({
    required this.type,
    this.statusCode,
    required this.message,
  });
}

enum ErrorType {
  dio,
  response,
  local,
}
