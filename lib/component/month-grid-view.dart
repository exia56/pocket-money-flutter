import 'package:pocket_money/models/index.dart';
import 'package:pocket_money/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:pocket_money/views/index.dart';

import '../views/index.dart';

typedef OnCellPressedHandler = void Function(SingleDayArrguments);

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

Widget todayText(String str) {
  return Container(
    child: Text(
      str,
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget weekdayCell(
  DayItem data,
  OnCellPressedHandler handler,
  String heroTag,
) {
  final isWeekend = data.date.weekday == DateTime.sunday ||
      data.date.weekday == DateTime.saturday;
  final isToday = data.date.toDateStamp() == DateTime.now().toDateStamp();
  var amountStr = data.amount > 1000
      ? '${(data.amount ~/ 1000)}k'
      : data.amount.toInt().toString();
  final child = Container(
    padding: EdgeInsets.all(5),
    child: Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: isToday
                ? todayText(data.date.day.toString())
                : isWeekend
                    ? weekendText(data.date.day.toString())
                    : normalText(data.date.day.toString())),
        Align(alignment: Alignment.bottomRight, child: normalFee(amountStr)),
      ],
    ),
  );
  return Container(
    decoration: BoxDecoration(border: Border.all(width: 1)),
    child: InkWell(
      onTap: () => handler(SingleDayArrguments(data.date, heroTag)),
      child: Hero(
        tag: heroTag,
        child: child,
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

Row weekCellAggregate(
  List<DayItem> datas,
  OnCellPressedHandler handler,
  int idx,
) {
  return Row(
    children: [
      ...datas
          .map((e) => Expanded(
              child: weekdayCell(
                  e, handler, 'row_${idx.toString()}_${e.date.toYYYYMMDD()}')))
          .toList(),
    ],
  );
}

class MonthGridView extends StatelessWidget {
  final List<String> header = ['一', '二', '三', '四', '五', '六', '日'];
  final List<DayItem> cellContent;
  final OnCellPressedHandler _onCellPressedHandler;
  MonthGridView(this.cellContent, this._onCellPressedHandler, {Key? key})
      : assert(cellContent.length == 42,
            'cellContent should be 42 length, get: ${cellContent.length}'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final gridRows = <Widget>[];
    for (int idx = 0; idx < 42; idx += 7) {
      gridRows.add(weekCellAggregate(
        cellContent.sublist(idx, idx + 7),
        _onCellPressedHandler,
        idx,
      ));
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
