import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pocket_money/di-setup.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/models/index.dart';
import 'package:pocket_money/views/insert-cost-view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:pocket_money/views/index.dart';

import 'views/index.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final futureResults = await Future.wait<dynamic>([
    openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join((await getDatabasesPath())!, 'pocket_money.db'),
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
    ),
    Firebase.initializeApp()
  ]);
  // await futureResults[0].execute('DROP TABLE IF EXISTS Costs');
  // await futureResults[0].execute(
  //     'CREATE TABLE Costs(id TEXT PRIMARY KEY, amount INTEGER, dateStamp INTEGER, day INTEGER, month INTEGER, type INTEGER, year INTEGER, detail TEXT);');
  diSetup(futureResults[1], futureResults[0]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
      title: 'Pocket Money',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.pinkAccent,
          backgroundColor: Colors.white,
        ),
        textTheme: theme.textTheme.copyWith(
          bodyText1: (theme.textTheme.bodyText1 ?? TextStyle()).copyWith(
            fontSize: 20,
          ),
          bodyText2: (theme.textTheme.bodyText2 ?? TextStyle()).copyWith(
            fontSize: 20,
          ),
        ),
      ),
      initialRoute: MainView.route,
      routes: {
        SignUpView.route: (_) => SignUpView(),
        SignInView.route: (_) => SignInView(),
        MainView.route: (_) => MainView(),
        SettingView.route: (_) => SettingView(),
        SingleDayView.route: (context) {
          if (ModalRoute.of(context)?.settings.arguments == null) {
            throw NullThrownError();
          }
          final SingleDayArrguments? args = ModalRoute.of(context)!
              .settings
              .arguments! as SingleDayArrguments;
          return SingleDayView(args: args!);
        },
        InsertCostView.route: (context) {
          if (ModalRoute.of(context)?.settings.arguments == null) {
            throw NullThrownError();
          }
          final CostItem args =
              ModalRoute.of(context)!.settings.arguments! as CostItem;
          return InsertCostView(args);
        },
        SyncDataView.route: (context) {
          if (ModalRoute.of(context)?.settings.arguments == null) {
            throw NullThrownError();
          }
          final SyncViewParam args =
              ModalRoute.of(context)!.settings.arguments! as SyncViewParam;
          return SyncDataView(args);
        }
      },
    );
  }
}
