import 'package:intl/intl.dart';

final dateFormator = DateFormat('yyyy-MM-dd');

extension DateTimeEX on DateTime {
  static DateTime fromDateStamp(int dateStamp) {
    final year = dateStamp ~/ 10000;
    if (year <= 0) return DateTime.now();
    final month = dateStamp % 10000 ~/ 100;
    final day = dateStamp % 100;
    return DateTime(year, month, day);
  }

  static DateTime fromYYYYMMDD(String yyyyMMdd) {
    return dateFormator.parse(yyyyMMdd);
  }

  int toDateStamp() {
    return this.year * 10000 + this.month * 100 + this.day;
  }

  String toYYYYMMDD() {
    return dateFormator.format(this);
  }
}
