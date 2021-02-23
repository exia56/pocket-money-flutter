import 'costItem.dart';
import 'package:pocket_money/utils/index.dart';

class DayItem {
  final DateTime date;
  final List<CostItem> items;

  DayItem(this.date, this.items);
  int get amount {
    int f = 0;
    items?.forEach((item) {
      f += item.amount;
    });
    return f;
  }

  @override
  String toString() {
    return 'date: ${date.toYYYYMMDD()} -- ${items.length}';
  }
}
