import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pocket_money/exceptions.dart';
import 'package:pocket_money/utils/logger.dart';

class User {
  final String id;
  User({required this.id});
}

const UserIdKey = 'UserId';

class AuthRepo {
  static const diKey = 'AuthRepo';
  final _logger = createLogger(diKey);
  final FirebaseAuth _firebaseAuth;

  AuthRepo(FirebaseApp app)
      : _firebaseAuth = FirebaseAuth.instanceFor(app: app);

  Future<User?> isUserSignIn() async {
    if (_firebaseAuth.currentUser == null) return null;
    final user = _firebaseAuth.currentUser;
    _logger.i({
      'userid': user.uid,
      'msg': 'user is signed In',
      'isAnonymous': user.isAnonymous
    });
    return User(id: user.uid);
  }

  Future<User> signInUser(String email, String password) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return User(id: user.user.uid);
    } on FirebaseAuthException catch (err) {
      _logger.e({'email': email}, err, err.stackTrace);
      if (err.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (err.code == 'wrong-password') {
        throw WrongPasswordException();
      }
      throw UnknownException();
    } catch (err, stackTrace) {
      _logger.e(
        {'fn': 'signInUser-unknown error', 'email': email},
        err,
        stackTrace,
      );
      throw UnknownException();
    }
  }

  Future<User> signUpUser(String email, String password) async {
    try {
      final user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return User(id: user.user.uid);
    } on FirebaseAuthException catch (err) {
      _logger.e(
        {'fn': 'signUpUser error', 'email': email},
        err,
        err.stackTrace,
      );
      if (err.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (err.code == 'email-already-in-use') {
        throw EmailAlreadyUsedException();
      }
      throw UnknownException();
    } catch (err, stackTrace) {
      _logger.e(
        {'fn': 'signUpUser-unknown', 'email': email},
        err,
        stackTrace,
      );
      throw UnknownException();
    }
  }

  Future resetPassword(String email) async {
    try {
      final a = _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (err) {
      _logger.e({'fn': 'resetPassword', 'email': email}, err, err.stackTrace);
      throw UnknownException(message: err.code);
    } catch (err, stackTrace) {
      _logger
          .e({'fn': 'resetPassword-unknown', 'email': email}, err, stackTrace);
      throw UnknownException();
    }
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
  }
}
