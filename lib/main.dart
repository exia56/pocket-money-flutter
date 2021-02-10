import 'package:flutter/material.dart';
import 'package:pocket_money/di-setup.dart';
import 'package:pocket_money/di.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:pocket_money/constant.dart';
import 'package:pocket_money/views/index.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final Database database = await openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'pocket_money.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        '''
        CREATE TABLE Costs(id TEXT PRIMARY KEY, amount INTEGER, dateStamp INTEGER, day INTEGER, month INTEGER, type INTEGER, year INTEGER, detail TEXT);
        ''',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  database.execute('DROP TABLE IF EXISTS Costs');
  database.execute(
      'CREATE TABLE Costs(id TEXT PRIMARY KEY, amount INTEGER, dateStamp INTEGER, day INTEGER, month INTEGER, type INTEGER, year INTEGER, detail TEXT);');
  DI.instance.register(DIKeys.database, () => database);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Money',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.pinkAccent,
      ),
      initialRoute: NamedRouter.splash.name,
      routes: {
        NamedRouter.signUp.name: (_) => SignUpView(),
        NamedRouter.signIn.name: (_) => SignInView(),
        NamedRouter.main.name: (_) => MainView(),
        NamedRouter.splash.name: (_) => SplashView(),
        NamedRouter.setting.name: (_) => SettingView(),
      },
    );
  }
}
