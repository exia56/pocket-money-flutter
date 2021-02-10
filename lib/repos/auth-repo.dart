import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pocket_money/exceptions.dart';
import 'package:pocket_money/utils/logger.dart';

class User {
  final String id;
  User({this.id});
}

const UserIdKey = 'UserId';

class AuthRepo {
  final _logger = createLogger('FirebaseAuthRepo');
  final FirebaseAuth _firebaseAuth;

  User cacheUser;

  AuthRepo(FirebaseApp app)
      : _firebaseAuth = FirebaseAuth.instanceFor(app: app);

  User getUser() {
    if (cacheUser == null) {
      throw new UserNotFoundException();
    }
    return cacheUser;
  }

  Future<User> isUserSignIn() async {
    if (_firebaseAuth.currentUser == null) return null;
    final user = _firebaseAuth.currentUser;
    _logger.i({'userid': user.uid, 'msg': 'user is signed In'});
    cacheUser = User(id: user.uid);
    return cacheUser;
  }

  Future<User> signInUser(String email, String password) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      cacheUser = User(id: user.user.uid);
      return cacheUser;
    } on FirebaseAuthException catch (err) {
      _logger.e({'email': email}, err, err.stackTrace);
      if (err.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (err.code == 'wrong-password') {
        throw WrongPasswordException();
      }
      throw UnknownException();
    } catch (err) {
      _logger.e({'fn': 'signInUser-unknown error', 'email': email}, err,
          err.stackTrace);
      throw UnknownException();
    }
  }

  Future<User> signUpUser(String email, String password) async {
    try {
      final user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      cacheUser = User(id: user.user.uid);
      return cacheUser;
    } on FirebaseAuthException catch (err) {
      _logger.e(err);
      if (err.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (err.code == 'email-already-in-use') {
        throw EmailAlreadyUsedException();
      }
      throw UnknownException();
    } catch (err) {
      _logger.e(err);
      throw UnknownException();
    }
  }

  Future signOut() async {
    _logger.i('signOut');
    cacheUser = null;
    await _firebaseAuth.signOut();
    _logger.i('signOut done');
  }
}
