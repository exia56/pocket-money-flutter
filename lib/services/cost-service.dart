import 'package:pocket_money/repos/index.dart';
import 'package:pocket_money/utils/index.dart';

class DayItem {
  final DateTime date;
  final List<CostItem> items;

  DayItem(this.date, this.items);
  double get amount {
    double f = 0;
    items?.forEach((item) {
      f += item.amount;
    });
    return f;
  }
}

int _dateToDateStamp(DateTime date) {
  return date.year * 10000 + date.month * 100 + date.day;
}

class CostService {
  final FirestoreRepo _firestoreRepo;
  final CostsRepo _costsRepo;
  final AuthRepo _authRepo;
  final _logger = createLogger('CostService');

  CostService(this._authRepo, this._firestoreRepo, this._costsRepo);

  Future<List<DayItem>> getDailyCosts(DateTime date) async {
    var weekdayCellDatas = List<DayItem>(42);
    var monthEndAt = DateTime(date.year, date.month + 1, 0);
    var startWeekday = monthEndAt.weekday;
    var endWeekdayOffset = DateTime.sunday - startWeekday;

    var gridViewEndDate = monthEndAt.add(Duration(days: endWeekdayOffset));
    var gridViewStartDate = gridViewEndDate.add(Duration(days: -41));

    final result = await _costsRepo.queryBetween(
        _dateToDateStamp(gridViewStartDate), _dateToDateStamp(gridViewEndDate));

    _logger.i(
        'start: ${gridViewStartDate.toString()}, end: ${gridViewEndDate.toString()}, length: ${result.length}');

    final dateStampMap = <int, List<CostItem>>{};
    result.forEach((cost) {
      var list = dateStampMap[cost.dateStamp];
      if (list == null) {
        dateStampMap[cost.dateStamp] = List<CostItem>();
        list = dateStampMap[cost.dateStamp];
      }
      list.add(cost);
    });

    for (int offset = 0; offset < 42; offset++) {
      final thisDay = gridViewEndDate.add(Duration(days: offset - 41));
      final serializeDatestamp = _dateToDateStamp(thisDay);
      final costItemsOfthisDay = dateStampMap[serializeDatestamp] ?? [];

      weekdayCellDatas[offset] = DayItem(thisDay, costItemsOfthisDay);
    }

    return weekdayCellDatas;
  }

  Future<List<CostItem>> getSingleDayCost(DateTime date) async {
    final dateStamp = _dateToDateStamp(date);
    final results = await _costsRepo.queryBetween(dateStamp, dateStamp);
    return results;
  }

  Future<void> pullFromCloudBetween(DateTime from, DateTime to) async {
    final fromDateStamp = _dateToDateStamp(from);
    final toDateStamp = _dateToDateStamp(to);

    final user = _authRepo.getUser();

    final costs = await _firestoreRepo.getCostsBetween(
      user.id,
      fromDateStamp,
      toDateStamp,
    );

    await _costsRepo.updateOrInsertMany(costs);
  }

  Future<void> pushToCloudBetween(DateTime from, DateTime to) async {
    final fromDateStamp = _dateToDateStamp(from);
    final toDateStamp = _dateToDateStamp(to);

    final user = _authRepo.getUser();

    final costs = await _costsRepo.queryBetween(
      fromDateStamp,
      toDateStamp,
    );

    await _firestoreRepo.updateOrInsertMany(user.id, costs);
  }

  Future<void> updateOrInsertCost(CostItem item) async {
    final user = _authRepo.getUser();
    if (item.id == null) {
      item.id = randomString(20);
    }
    await _firestoreRepo.updateOrInsert(user.id, item).catchError(
          (err) => _logger.i(
            item,
            err,
            StackTrace.current,
          ),
        );
    await _costsRepo.updateOrInsert(item).catchError(
          (err) => _logger.i(
            item,
            err,
            StackTrace.current,
          ),
        );
  }
}
