import 'package:pocket_money/constant.dart';
import 'package:pocket_money/utils/index.dart';

class CostItem {
  String id;
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

  CostItem.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    amount = tryCastToInt(map['amount']);
    dateStamp = tryCastToInt(map['dateStamp']);
    day = tryCastToInt(map['day']);
    detail = map['detail'];
    month = tryCastToInt(map['month']);
    type = map['type'] is CostType
        ? map['type']
        : costTypeFrom(tryCastToInt(map['type']));
    year = tryCastToInt(map['year']);
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
