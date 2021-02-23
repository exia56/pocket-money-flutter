import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pocket_money/exceptions.dart';
import 'package:pocket_money/services/index.dart';

class SyncViewModel {
  static const diKey = 'SyncViewModel';
  final UserService _userService;

  final _errController = StreamController<String>.broadcast();
  Stream<String> get error => _errController.stream;

  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  SyncViewModel(this._userService);

  signIn() {
    final email = emailTextEditingController.text;
    final password = passwordTextEditingController.text;

    _userService.signIn(email, password).catchError((err) {
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

    _userService.signUp(email, password).catchError((err) {
      emailTextEditingController.clear();
      passwordTextEditingController.clear();
      if (err is CustomException) {
        _errController.add(err.toString());
      } else {
        _errController.add('Unknwon Error');
      }
    });
  }

  signOut() {
    _userService.signOut();
  }

  dispose() {
    _errController.close();
  }
}
