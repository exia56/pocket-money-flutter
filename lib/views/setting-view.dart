import 'package:flutter/material.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/services/index.dart';

Widget settingRow(String str, Function onPress) {
  return FlatButton(
    onPressed: onPress,
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(str),
        ),
        Icon(Icons.chevron_right),
      ],
    ),
  );
}

class SettingView extends StatelessWidget {
  static const route = 'SettingView';

  final _userService = DI.instance.get<UserService>(UserService.diKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('設定'),
        ),
        body: Column(
          children: [
            settingRow('登入', () {
              // _userService.signOut().then((v) => Navigator.of(context)
              //     .pushNamedAndRemoveUntil(
              //         NamedRouter.splash.name, (route) => false));
            })
          ],
        ));
  }
}
