import 'package:flutter/material.dart';
import 'package:pocket_money/utils/index.dart';

typedef OnDatePicked = void Function(DateTime);

class DateTimePicker extends StatelessWidget {
  final DateTime _currentDate;
  final DateTime _firstDate;
  final DateTime _lastDate;
  final OnDatePicked _onDatePicked;
  DateTimePicker({
    DateTime? currentDate,
    DateTime? firstDate,
    DateTime? lastDate,
    required OnDatePicked onDatePicked,
  })   : _currentDate = currentDate ?? DateTime.now(),
        _firstDate = firstDate ?? DateTime.now().add(Duration(days: -365)),
        _lastDate = lastDate ?? DateTime.now().add(Duration(days: 365)),
        _onDatePicked = onDatePicked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final newDate = await showDatePicker(
          context: context,
          initialDate: _currentDate,
          firstDate: _firstDate,
          lastDate: _lastDate,
        );
        if (newDate != null) {
          _onDatePicked(newDate);
        }
      },
      child: Text(
        _currentDate.toYYYYMMDD(),
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
