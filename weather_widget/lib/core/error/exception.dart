abstract class CustomException implements Exception {
  final String _errorMessage;

  const CustomException({
    required String errorMessage,
  }) : _errorMessage = errorMessage;

  String errorMessage() {
    return '$runtimeType Exception: $_errorMessage';
  }
}

class ServerException extends CustomException {
  ServerException({required super.errorMessage});
}

class CacheException extends CustomException {
  CacheException({required super.errorMessage});
}

class TimeOutException extends CustomException {
  TimeOutException({required super.errorMessage});
}

class EnvironmentalConditionsException extends CustomException {
  EnvironmentalConditionsException({required super.errorMessage});
}

class UDPClientSenderReceiverException extends CustomException {
  UDPClientSenderReceiverException({required super.errorMessage});
}
