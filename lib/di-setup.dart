import 'package:firebase_core/firebase_core.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/repos/index.dart';
import 'package:pocket_money/services/index.dart';
import 'package:pocket_money/view-models/index.dart';
import 'package:pocket_money/view-models/user-view-model.dart';
import 'package:sqflite/sqflite.dart';

import 'repos/index.dart';

const databaseDIKey = 'db';

void diSetup(FirebaseApp firebaseApp, Database database) {
  DI.instance.register(databaseDIKey, () => database);
  DI.instance.register(AuthRepo.diKey, () => AuthRepo(firebaseApp));
  DI.instance.register(FirestoreRepo.diKey, () => FirestoreRepo(firebaseApp));
  DI.instance.register(
    CostsRepo.diKey,
    ({required Database db}) => CostsRepo(db),
    namedParameter: {'db': databaseDIKey},
  );

  DI.instance.register(
    UserService.diKey,
    ({required AuthRepo authRepo}) => UserService(authRepo),
    namedParameter: {'authRepo': AuthRepo.diKey},
  );
  DI.instance.register(
    CostService.diKey,
    ({required CostsRepo costsRepo, required FirestoreRepo firestoreRepo}) =>
        CostService(
      costsRepo,
      firestoreRepo,
    ),
    namedParameter: {
      'costsRepo': CostsRepo.diKey,
      'firestoreRepo': FirestoreRepo.diKey,
    },
  );

  DI.instance.register(
    UserViewModel.diKey,
    ({required UserService userService}) => UserViewModel(userService),
    namedParameter: {'userService': UserService.diKey},
    alwaysNew: true,
  );
  DI.instance.register(
    MainViewModel.diKey,
    ({required CostService costService}) => MainViewModel(costService),
    namedParameter: {'costService': CostService.diKey},
    alwaysNew: true,
  );
  DI.instance.register(
    CostViewModel.diKey,
    ({required CostService costService}) => CostViewModel(costService),
    namedParameter: {'costService': CostService.diKey},
    alwaysNew: true,
  );
  DI.instance.register(
    SyncViewModel.diKey,
    ({required CostService costService}) => SyncViewModel(costService),
    namedParameter: {'costService': CostService.diKey},
    alwaysNew: true,
  );
}
