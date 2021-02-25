import 'package:pocket_money/repos/auth-repo.dart';
import 'package:pocket_money/utils/index.dart';

class UserService {
  static const diKey = 'UserService';
  final AuthRepo _authRepo;
  final _logger = createLogger(diKey);
  UserService(this._authRepo);

  Future<User?> isUserSignedIn() async {
    return await _authRepo.isUserSignIn();
  }

  Future<User> signIn(String email, String password) async {
    final user = await _authRepo.signInUser(email, password);
    return user;
  }

  Future<User> signUp(String email, String password) async {
    final user = await _authRepo.signUpUser(email, password);
    return user;
  }

  Future<void> signOut() {
    return _authRepo.signOut();
  }
}
