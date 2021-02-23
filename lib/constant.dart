import 'package:flutter/material.dart';
import 'package:pocket_money/exceptions.dart';

const primaryColor = Colors.blue;
const accentColor = Colors.pinkAccent;

enum CostType {
  Vacation,
  Breakfast,
  Lunch,
  Dinner,
  Groceries,
  Motor,
  Out,
  Supper,
  Other,
}

extension CostTypeEX on CostType {
  String get name {
    return this.toString().replaceAll(RegExp(r'CostType\.'), '');
  }
}

CostType costTypeFrom(int type) {
  if (type >= CostType.values.length) {
    throw WrongCostTypeException(type);
  }
  return CostType.values[type];
}
