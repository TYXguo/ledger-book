class AppException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  AppException({required this.message, this.code, this.statusCode});

  factory AppException.fromResponse(int statusCode, Map<String, dynamic> body) {
    return AppException(
      message: body['message'] ?? 'Unknown error',
      code: body['error'],
      statusCode: statusCode,
    );
  }

  @override
  String toString() => 'AppException($code): $message';
}
