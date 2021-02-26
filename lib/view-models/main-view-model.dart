import 'dart:async';
import 'package:pocket_money/services/index.dart';
import 'package:intl/intl.dart';
import 'package:pocket_money/models/index.dart';
import 'package:pocket_money/utils/index.dart';

class MainViewModel {
  static const diKey = 'MainViewModel';
  final _logger = createLogger('MainViewModel');
  final CostService _costsService;

  final _dayItemsController = StreamController<List<DayItem>>.broadcast();
  Stream<List<DayItem>> get dayItems => _dayItemsController.stream;

  MainViewModel(this._costsService) {
    _dayItemsController.add([]);
  }

  void getDateFees(DateTime date) {
    final futureGroup = [Future(() => null)];
    // final futureGroup = List<Future<void>>.generate(30, (index) {
    //   final date = DateTime.now().subtract(new Duration(days: index));
    //   return _costsService.updateOrInsertCost(CostItem.fromMap({
    //     'amount': randomInt(200),
    //     'dateStamp': date.toDateStamp(),
    //     'day': date.day,
    //     'detail': date.toYYYYMMDD() + '測試1\n你測試2',
    //     'month': date.month - 1,
    //     'type': 1,
    //     'year': date.year,
    //   }));
    // });
    Future.wait(futureGroup).then((value) => _costsService
        .getDailyCosts(date)
        .then((value) => _dayItemsController.add(value)));
  }

  void dispose() {
    _dayItemsController.close();
  }
}
