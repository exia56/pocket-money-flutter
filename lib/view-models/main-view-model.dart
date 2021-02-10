import 'dart:async';
import 'package:pocket_money/services/index.dart';
import 'package:pocket_money/repos/index.dart';
import 'package:pocket_money/utils/index.dart';

class MainViewModel {
  final _logger = createLogger('MainViewModel');
  final CostService _costsService;

  final _dayItemsController = StreamController<List<DayItem>>.broadcast();
  Stream<List<DayItem>> get dayItems => _dayItemsController.stream;

  MainViewModel(this._costsService);

  void getDateFees(DateTime date) {
    _costsService
        .updateOrInsertCost(CostItem.fromMap({
          'amount': 123,
          'dateStamp': 123,
          'day': 123,
          'detail': '1234dfgh',
          'month': 123,
          'type': 1,
          'year': 123,
        }))
        .then((value) => _logger.i({'fn': 'updateOrInsertCost done'}));
    _costsService
        .getDailyCosts(date)
        .then((value) => _dayItemsController.add(value));
  }

  void dispose() {
    _dayItemsController.close();
  }
}
