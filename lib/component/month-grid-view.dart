import 'package:pocket_money/models/index.dart';
import 'package:pocket_money/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:pocket_money/views/index.dart';

import '../views/index.dart';

typedef OnCellPressedHandler = void Function(SingleDayArrguments);

Widget offMonthText(String str) {
  return Container(
    child: Text(
      str,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade700,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget normalText(String str) {
  return Container(
    child: Text(
      str,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget normalFee(String str) {
  return Container(
    child: Text(
      str,
      style: TextStyle(
        fontSize: 16,
      ),
    ),
  );
}

Widget weekendText(String str) {
  return Container(
    child: Text(
      str,
      style: TextStyle(
        fontSize: 14,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget todayText(String str) {
  return Container(
    child: Text(
      str,
      style: TextStyle(
        fontSize: 14,
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget weekdayCell(
  DayItem data,
  OnCellPressedHandler handler,
  int mainYearMonth,
) {
  final isWeekend = data.date.weekday == DateTime.sunday ||
      data.date.weekday == DateTime.saturday;
  final isToday = data.date.toDateStamp() == DateTime.now().toDateStamp();
  var amountStr = data.items.length == 0
      ? ''
      : data.amount > 1000
          ? '${(data.amount ~/ 1000)}k'
          : data.amount.toInt().toString();
  final child = Column(
    children: [
      Container(
        padding: EdgeInsets.all(3),
        child: Align(
          alignment: Alignment.topLeft,
          child: isToday
              ? todayText(data.date.day.toString())
              : isWeekend
                  ? weekendText(data.date.day.toString())
                  : mainYearMonth == data.date.toDateStamp() ~/ 100
                      ? normalText(data.date.day.toString())
                      : offMonthText(data.date.day.toString()),
        ),
      ),
      Align(alignment: Alignment.bottomRight, child: normalFee(amountStr)),
    ],
  );
  return InkWell(
    onTap: () => handler(SingleDayArrguments(data.date)),
    child: Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      padding: EdgeInsets.all(5),
      child: child,
    ),
  );
}

Row headerAggregate(List<String> weekStrs) {
  final commonPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  return Row(
    children: [
      Expanded(
        child: Padding(
          padding: commonPadding,
          child: Center(
            child: weekendText(weekStrs[0]),
          ),
        ),
      ),
      ...weekStrs
          .sublist(1, 6)
          .map(
            (e) => Expanded(
              child: Padding(
                padding: commonPadding,
                child: Center(
                  child: normalText(e),
                ),
              ),
            ),
          )
          .toList(),
      Expanded(
        child: Padding(
          padding: commonPadding,
          child: Center(
            child: weekendText(weekStrs[6]),
          ),
        ),
      ),
    ],
  );
}

Row weekCellAggregate(
  List<DayItem> datas,
  OnCellPressedHandler handler,
  int mainYearMonth,
) {
  return Row(
    children: [
      ...datas
          .map((e) => Expanded(
                  child: weekdayCell(
                e,
                handler,
                mainYearMonth,
              )))
          .toList(),
    ],
  );
}

class MonthGridView extends StatelessWidget {
  final List<String> header = ['日', '一', '二', '三', '四', '五', '六'];
  final List<DayItem> cellContent;
  final OnCellPressedHandler _onCellPressedHandler;
  MonthGridView(this.cellContent, this._onCellPressedHandler, {Key? key})
      : assert(cellContent.length == 42,
            'cellContent should be 42 length, get: ${cellContent.length}'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final gridRows = <Widget>[];
    final mainYearMonth = cellContent[21].date.toDateStamp() ~/ 100;
    for (int idx = 0; idx < 42; idx += 7) {
      gridRows.add(weekCellAggregate(
        cellContent.sublist(idx, idx + 7),
        _onCellPressedHandler,
        mainYearMonth,
      ));
    }

    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: headerAggregate(header),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1.5)),
            child: Column(
              children: [
                ...gridRows.toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
