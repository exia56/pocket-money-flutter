import 'package:intl/intl.dart';

final dateFormator = DateFormat('yyyy-MM-dd');

extension DateTimeEX on DateTime {
  static DateTime fromDateStamp(int dateStamp) {
    final year = dateStamp ~/ 10000;
    final month = dateStamp % 10000 ~/ 100;
    final day = dateStamp % 100;
    return DateTime(year, month, day);
  }

  int toDateStamp() {
    return this.year * 10000 + this.month * 100 + this.day;
  }

  String toYYYYMMDD() {
    return dateFormator.format(this);
  }
}
