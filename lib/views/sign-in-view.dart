import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_money/component/modal.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/repos/index.dart';
import 'package:pocket_money/view-models/index.dart';
import 'package:pocket_money/utils/logger.dart';
import 'package:pocket_money/views/index.dart';

class SignInView extends StatefulWidget {
  static const route = 'SignInView';

  @override
  State<StatefulWidget> createState() => SignInState();
}

class SignInState extends StateWithOverlay<SignInView> {
  final _userViewModel = DI.instance.get<UserViewModel>(UserViewModel.diKey);
  final _logger = createLogger(SingleDayView.route);

  var _error = '';
  User? user;

  OverlayEntry? _overly;

  @override
  void initState() {
    super.initState();
    _userViewModel.error.listen((error) {
      _logger.i('error: $error');
      setState(() {
        _error = error;
      });
    });
    _userViewModel.user.listen((user) async {
      if (user != null) {
        Navigator.of(context).pop(user);
      }
    });
    _userViewModel.loading.listen((loading) {
      if (loading) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });
    _userViewModel.isUserSignIn();
  }

  @override
  Widget childBuilder() {
    return Center(
      child: CircularProgressIndicator(),
    );
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
            // TextButton(
            //   child: Text('去註冊'),
            //   onPressed: () async {
            //     final a = await Navigator.of(context)
            //         .pushReplacementNamed(SignUpView.route);
            //     _logger.i(a.toString());
            //   },
            // ),
            ElevatedButton(
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
    _userViewModel.dispose();
  }
}
