import 'package:flutter/material.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/view-models/index.dart';
import 'package:pocket_money/utils/logger.dart';
import 'package:pocket_money/views/index.dart';

class SyncDataView extends StatefulWidget {
  static const route = 'SyncDataView';

  @override
  State<StatefulWidget> createState() => SyncDataState();
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

class SyncDataState extends State<SyncDataView> {
  final _userViewModel = DI.instance.get<UserViewModel>(UserViewModel.diKey);
  final _logger = createLogger('SyncDataState');

  var _error = '';

  @override
  void initState() {
    super.initState();
    _userViewModel.error.listen((error) {
      _logger.i('error: $error');
      setState(() {
        _error = error;
      });
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
              child: Text('去註冊'),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    SignUpView.route, (route) => false);
              },
            ),
            RaisedButton(
              child: Text('登入'),
              onPressed: () {
                _userViewModel.signIn();
              },
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('登入'),
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
    _userViewModel.signOut();
    _userViewModel.dispose();
  }
}
