import 'package:firebase_core/firebase_core.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/repos/index.dart';
import 'package:pocket_money/services/index.dart';
import 'package:pocket_money/view-models/index.dart';
import 'package:pocket_money/view-models/user-view-model.dart';
import 'package:sqflite/sqflite.dart';

const databaseDIKey = 'db';

void diSetup(FirebaseApp firebaseApp, Database database) {
  DI.instance.register(databaseDIKey, () => database);
  DI.instance.register(AuthRepo.diKey, () => AuthRepo(firebaseApp));
  DI.instance.register(FirestoreRepo.diKey, () => FirestoreRepo(firebaseApp));
  DI.instance.register(
    CostsRepo.diKey,
    ({Database db}) => CostsRepo(db),
    namedParameter: {'db': databaseDIKey},
  );

  DI.instance.register(
    UserService.diKey,
    ({AuthRepo authRepo}) => UserService(authRepo),
    namedParameter: {'authRepo': AuthRepo.diKey},
  );
  DI.instance.register(
    CostService.diKey,
    ({CostsRepo costsRepo}) => CostService(costsRepo),
    namedParameter: {'costsRepo': CostsRepo.diKey},
  );

  DI.instance.register(
    UserViewModel.diKey,
    ({UserService userService}) => UserViewModel(userService),
    namedParameter: {'userService': UserService.diKey},
    alwaysNew: true,
  );
  DI.instance.register(
    MainViewModel.diKey,
    ({CostService costService}) => MainViewModel(costService),
    namedParameter: {'costService': CostService.diKey},
    alwaysNew: true,
  );
  DI.instance.register(
    CostViewModel.diKey,
    ({CostService costService}) => CostViewModel(costService),
    namedParameter: {'costService': CostService.diKey},
    alwaysNew: true,
  );
}
