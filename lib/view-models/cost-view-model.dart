import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pocket_money/exceptions.dart';
import 'package:pocket_money/models/index.dart';
import 'package:pocket_money/services/index.dart';
import 'package:pocket_money/utils/index.dart';

class CostViewModel {
  static const diKey = 'CostViewModel';
  final _logger = createLogger(diKey);
  final CostService _costService;

  final _errController = StreamController<String>.broadcast();
  Stream<String> get error => _errController.stream;

  final _costItemsController = StreamController<List<CostItem>>.broadcast();
  Stream<List<CostItem>> get costItems => _costItemsController.stream;

  final _updatedController = StreamController<bool>.broadcast();
  Stream<bool> get updated => _updatedController.stream;

  CostViewModel(this._costService);

  void querySingleDayCost(DateTime date) {
    _costService.getSingleDayCost(date).then((costItems) {
      _costItemsController.add(costItems);
    }).catchError((err) {
      _errController.add(err.toString());
    });
  }

  void updateOrInsertCost(CostItem item) {
    _costService.updateOrInsertCost(item).then((res) {
      _updatedController.add(true);
    }).catchError((err) {
      _errController.add(err.toString());
    });
  }

  void deleteCost(String id) {
    _costService.deleteCost(id).then((res) {
      _updatedController.add(true);
    }).catchError((err) {
      _errController.add(err.toString());
    });
  }

  void dispose() {
    _errController.close();
    _costItemsController.close();
    _updatedController.close();
  }
}
