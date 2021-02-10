import 'package:firebase_core/firebase_core.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/repos/index.dart';
import 'package:pocket_money/services/index.dart';
import 'package:pocket_money/view-models/index.dart';
import 'package:pocket_money/view-models/user-view-model.dart';
import 'package:sqflite/sqflite.dart';

class DIKeys {
  static const database = 'db';

  static const authRepo = 'authRepo';
  static const firestoreRepo = 'firestoreRepo';
  static const costsRepo = 'costsRepo';

  static const dateService = 'dateService';
  static const userService = 'userService';

  static const mainViewModel = 'mainViewModel';
  static const userViewModel = 'userViewModel';

  DIKeys._();
}

void diSetup(FirebaseApp firebaseApp) {
  DI.instance.register(DIKeys.authRepo, () => AuthRepo(firebaseApp));
  DI.instance.register(DIKeys.firestoreRepo, () => FirestoreRepo(firebaseApp));
  DI.instance.register(
    DIKeys.costsRepo,
    ({Database db}) => CostsRepo(db),
    namedParameter: {'db': DIKeys.database},
  );

  DI.instance.register(
    DIKeys.userService,
    ({AuthRepo authRepo}) => UserService(authRepo),
    namedParameter: {'authRepo': DIKeys.authRepo},
  );
  DI.instance.register(
    DIKeys.dateService,
    ({FirestoreRepo firestoreRepo, AuthRepo authRepo, CostsRepo costsRepo}) =>
        CostService(authRepo, firestoreRepo, costsRepo),
    namedParameter: {
      'firestoreRepo': DIKeys.firestoreRepo,
      'authRepo': DIKeys.authRepo,
      'costsRepo': DIKeys.costsRepo,
    },
  );

  DI.instance.register(
    DIKeys.userViewModel,
    ({UserService userService}) => UserViewModel(userService),
    namedParameter: {'userService': DIKeys.userService},
    alwaysNew: true,
  );
  DI.instance.register(
    DIKeys.mainViewModel,
    ({CostService costService}) => MainViewModel(costService),
    namedParameter: {'costService': DIKeys.dateService},
    alwaysNew: true,
  );
}
