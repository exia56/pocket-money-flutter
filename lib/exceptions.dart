class CustomException implements Exception {
  String _message;

  @override
  String toString() {
    return '$_message\n${super.toString()}';
  }
}

class UnknownException extends CustomException {
  var _message = 'Error: Unknown Error';

  UnknownException({String message = 'Error: Unknown Error'}) {
    this._message = message;
  }
}

class UserNotFoundException extends CustomException {
  final _message = 'Error: User Not Found';
}

class EmailAlreadyUsedException extends CustomException {
  final _message = 'Error: Email Already Used';
}

class WrongPasswordException extends CustomException {
  final _message = 'Error: Wrong Password';
}

class WeakPasswordException extends CustomException {
  final _message = 'Error: Weak Password';
}

class NotSignInException extends CustomException {
  final _message = 'Error: Not Sign In';
}

class WrongCostTypeException extends CustomException {
  final int _type;
  String _message;
  WrongCostTypeException(this._type) {
    _message = 'Error: Wrong Cost Type ${_type.toString()}';
  }
}
