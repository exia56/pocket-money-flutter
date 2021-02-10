class CustomException implements Exception {
  String message;

  @override
  String toString() {
    return '$message\n${super.toString()}';
  }
}

class UnknownException extends CustomException {
  final message = 'Error: Unknown Error';
}

class UserNotFoundException extends CustomException {
  final message = 'Error: User Not Found';
}

class EmailAlreadyUsedException extends CustomException {
  final message = 'Error: Email Already Used';
}

class WrongPasswordException extends CustomException {
  final message = 'Error: Wrong Password';
}

class WeakPasswordException extends CustomException {
  final message = 'Error: Weak Password';
}
