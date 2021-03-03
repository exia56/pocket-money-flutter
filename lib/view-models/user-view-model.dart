import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pocket_money/exceptions.dart';
import 'package:pocket_money/services/index.dart';
import 'package:pocket_money/repos/index.dart';

class UserViewModel {
  static const diKey = 'UserViewModel';
  final UserService _userService;

  final _errController = StreamController<String>.broadcast();
  Stream<String> get error => _errController.stream;

  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  final _userController = StreamController<User?>.broadcast();
  Stream<User?> get user => _userController.stream;

  final _loadingController = StreamController<bool>.broadcast();
  Stream<bool> get loading => _loadingController.stream;

  UserViewModel(this._userService);

  void isUserSignIn() async {
    _loadingController.add(true);
    final user = await _userService.isUserSignedIn();
    _userController.add(user);
    _loadingController.add(false);
  }

  void signIn() {
    _loadingController.add(true);
    final email = emailTextEditingController.text;
    final password = passwordTextEditingController.text;

    _userService.signIn(email, password).then((user) {
      _userController.add(user);
      _loadingController.add(false);
    }).catchError((err) {
      _userController.add(null);
      _loadingController.add(false);
      emailTextEditingController.clear();
      passwordTextEditingController.clear();
      if (err is CustomException) {
        _errController.add(err.toString());
      } else {
        _errController.add('Unknwon Error');
      }
    });
  }

  void signUp() {
    _loadingController.add(true);
    final email = emailTextEditingController.text;
    final password = passwordTextEditingController.text;

    _userService.signUp(email, password).then((user) {
      _userController.add(user);
      _loadingController.add(false);
    }).catchError((err) {
      _userController.add(null);
      _loadingController.add(false);
      emailTextEditingController.clear();
      passwordTextEditingController.clear();
      if (err is CustomException) {
        _errController.add(err.toString());
      } else {
        _errController.add('Unknwon Error');
      }
    });
  }

  void signOut() {
    _userService.signOut();
  }

  void dispose() {
    _errController.close();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
  }
}
