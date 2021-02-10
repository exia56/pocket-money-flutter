import 'dart:collection';
import 'package:pocket_money/services/index.dart';
import 'package:flutter/material.dart';

Widget normalText(String str) {
  return Container(
    child: Text(
      str,
      style: TextStyle(
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
        fontSize: 18,
      ),
    ),
  );
}

Widget weekendText(String str) {
  return Container(
    child: Text(
      str,
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget weekdayCell(DayItem data) {
  final isWeekend = data.date.weekday == DateTime.sunday ||
      data.date.weekday == DateTime.saturday;
  var amountStr = data.amount > 1000
      ? '${(data.amount / 1000)}k'
      : data.amount.toInt().toString();
  return Container(
    decoration: BoxDecoration(border: Border.all(width: 1)),
    child: Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: isWeekend
                  ? weekendText(data.date.day.toString())
                  : normalText(data.date.day.toString())),
          Align(alignment: Alignment.bottomRight, child: normalFee(amountStr)),
        ],
      ),
    ),
  );
}

Row headerAggregate(List<String> weekStrs) {
  return Row(
    children: [
      ...weekStrs
          .sublist(0, 5)
          .map((e) => Expanded(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(child: normalText(e)))))
          .toList(),
      Expanded(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Center(child: weekendText(weekStrs[5])))),
      Expanded(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Center(child: weekendText(weekStrs[6])))),
    ],
  );
}

Row weekCellAggregate(List<DayItem> datas) {
  return Row(
    children: [
      ...datas.map((e) => Expanded(child: weekdayCell(e))).toList(),
    ],
  );
}

class MonthGridView extends StatelessWidget {
  final List<String> header = ['一', '二', '三', '四', '五', '六', '日'];
  final List<DayItem> cellContent;
  MonthGridView({@required this.cellContent, Key key})
      : assert(cellContent.length == 42,
            'cellContent should be 42 length, get: ${cellContent.length}'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var gridRows = Queue<Widget>();

    for (int idx = 0; idx < 42; idx += 7) {
      gridRows.add(weekCellAggregate(cellContent.sublist(idx, idx + 7)));
    }
    return Container(
      child: Column(
        children: [
          headerAggregate(header),
          ...gridRows.toList(),
        ],
      ),
    );
  }
}
