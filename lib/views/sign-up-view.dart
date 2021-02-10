import 'package:flutter/material.dart';
import 'package:pocket_money/di-setup.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/constant.dart';
import 'package:pocket_money/view-models/index.dart';
import 'package:pocket_money/utils/logger.dart';

class SignUpView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignUpState();
}

Widget _rowCreation(String field, TextEditingController controller) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    child: Row(
      children: [
        Expanded(
          flex: 0,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(field),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: controller,
            ),
          ),
        ),
      ],
    ),
  );
}

class SignUpState extends State<SignUpView> {
  final _userViewModel = DI.instance.get<UserViewModel>(DIKeys.userViewModel);
  final _logger = createLogger('SignUpState');

  var _error = '';

  @override
  void initState() {
    super.initState();
    _userViewModel.error.listen((error) {
      setState(() {
        _error = error;
      });
    });
    _userViewModel.isUserSignIn.listen((signedIn) {
      if (signedIn) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(NamedRouter.main.name, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      _rowCreation('郵箱', _userViewModel.emailTextEditingController),
      _rowCreation('密碼', _userViewModel.passwordTextEditingController),
    ];
    if (_error.length != 0) {
      children.insert(
        children.length,
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            _error,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      );
    }
    children.insert(
      children.length,
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton(
              child: Text('去登入'),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    NamedRouter.signIn.name, (route) => false);
              },
            ),
            RaisedButton(
              child: Text('註冊'),
              onPressed: () {
                _userViewModel.signUp();
              },
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('註冊'),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _userViewModel.dispose();
  }
}
