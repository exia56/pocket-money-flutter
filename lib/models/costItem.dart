import 'package:pocket_money/constant.dart';
import 'package:pocket_money/utils/index.dart';

class CostItem {
  String? id;
  int amount;
  int dateStamp;
  int day;
  String detail;
  int month;
  CostType type;
  int year;

  CostItem(
    this.id,
    this.amount,
    this.dateStamp,
    this.day,
    this.detail,
    this.month,
    this.type,
    this.year,
  );

  factory CostItem.fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final amount = tryCastToInt(map['amount']);
    final dateStamp = tryCastToInt(map['dateStamp']);
    final day = tryCastToInt(map['day']);
    final detail = map['detail'];
    final month = tryCastToInt(map['month']);
    final type = map['type'] is CostType
        ? map['type']
        : costTypeFrom(tryCastToInt(map['type']));
    final year = tryCastToInt(map['year']);
    return CostItem(id, amount, dateStamp, day, detail, month, type, year);
  }

  @override
  String toString() {
    return 'id=$id, amount=$amount, detail=$detail, dateStamp=$dateStamp, type=${type.name}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'dateStamp': dateStamp,
      'day': day,
      'detail': detail,
      'month': month,
      'type': type.index,
      'year': year,
    };
  }
}
