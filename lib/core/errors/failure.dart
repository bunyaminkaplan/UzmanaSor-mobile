import 'package:dio/dio.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  factory ServerFailure.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure('Connection timeout with API server');
      case DioExceptionType.sendTimeout:
        return const ServerFailure('Send timeout with API server');
      case DioExceptionType.receiveTimeout:
        return const ServerFailure('Receive timeout with API server');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          error.response?.statusCode,
          error.response?.data,
        );
      case DioExceptionType.cancel:
        return const ServerFailure('Request to API server was cancelled');
      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          return const ServerFailure('No Internet Connection');
        }
        return const ServerFailure('Unexpected error occurred');
      default:
        return const ServerFailure('Something went wrong');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      // Handle Django error format: { "detail": "..." } or { "field": ["error"] }
      if (response is Map<String, dynamic>) {
        if (response.containsKey('detail')) {
          return ServerFailure(response['detail']);
        }
        // Iterate generic keys
        if (response.keys.isNotEmpty) {
          final key = response.keys.first;
          final value = response[key];
          if (value is List) return ServerFailure("$key: ${value.first}");
          return ServerFailure("$key: $value");
        }
      }
      return const ServerFailure('Invalid Request');
    } else if (statusCode == 404) {
      return const ServerFailure('Request not found');
    } else if (statusCode == 500) {
      return const ServerFailure('Internal Server Error');
    } else {
      return const ServerFailure('Oops something went wrong');
    }
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
