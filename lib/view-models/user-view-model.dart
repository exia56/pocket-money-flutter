import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pocket_money/exceptions.dart';
import 'package:pocket_money/services/index.dart';

class UserViewModel {
  final UserService _userService;
  final _isUserSignInController = StreamController<bool>.broadcast();
  Stream<bool> get isUserSignIn => _isUserSignInController.stream;

  final _errController = StreamController<String>.broadcast();
  Stream<String> get error => _errController.stream;

  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  UserViewModel(this._userService) {
    _isUserSignInController.add(false);
  }

  signIn() {
    final email = emailTextEditingController.text;
    final password = passwordTextEditingController.text;

    _userService.signIn(email, password).then((user) {
      _isUserSignInController.add(true);
    }).catchError((err) {
      emailTextEditingController.clear();
      passwordTextEditingController.clear();
      if (err is CustomException) {
        _errController.add(err.toString());
      } else {
        _errController.add('Unknwon Error');
      }
    });
  }

  signUp() {
    final email = emailTextEditingController.text;
    final password = passwordTextEditingController.text;

    _userService.signUp(email, password).then((user) {
      _isUserSignInController.add(true);
    }).catchError((err) {
      emailTextEditingController.clear();
      passwordTextEditingController.clear();
      if (err is CustomException) {
        _errController.add(err.toString());
      } else {
        _errController.add('Unknwon Error');
      }
    });
  }

  dispose() {
    _isUserSignInController.close();
    _errController.close();
  }
}
