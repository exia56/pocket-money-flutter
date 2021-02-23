import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/utils/index.dart';
import 'package:pocket_money/services/index.dart';
import 'package:pocket_money/views/index.dart';

class SplashView extends StatelessWidget {
  static const route = 'SplashView';

  final _logger = createLogger('SplashView');
  Future changeView(BuildContext context) async {
    final user =
        await DI.instance.get<UserService>(UserService.diKey).isUserSignedIn();
    if (user == null) {
      _logger.i('not user exists');
      Navigator.of(context)
          .pushNamedAndRemoveUntil(SignInView.route, (route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(MainView.route, (route) => false);
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
