import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pocket_money/di-setup.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/utils/index.dart';
import 'package:pocket_money/constant.dart';
import 'package:pocket_money/services/index.dart';

class SplashView extends StatelessWidget {
  final _logger = createLogger('SplashView');
  final _initialization = Firebase.initializeApp();

  Future changeView(BuildContext context) async {
    final firebaseApp = await _initialization;
    diSetup(firebaseApp);
    final user =
        await DI.instance.get<UserService>(DIKeys.userService).isUserSignedIn();
    if (user == null) {
      _logger.i('not user exists');
      Navigator.of(context)
          .pushNamedAndRemoveUntil(NamedRouter.signIn.name, (route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(NamedRouter.main.name, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    changeView(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('檢查使用者。。。'),
      ),
      body: Center(
        child: Text('檢查使用者。。。'),
      ),
    );
  }
}
