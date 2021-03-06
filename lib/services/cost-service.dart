import 'package:pocket_money/models/index.dart';
import 'package:pocket_money/repos/index.dart';
import 'package:pocket_money/utils/index.dart';

class CostService {
  static const diKey = 'CostService';
  final CostsRepo _costsRepo;
  final FirestoreRepo _firestoreRepo;
  final _logger = createLogger(diKey);

  CostService(this._costsRepo, this._firestoreRepo);

  Future<List<DayItem>> getDailyCosts(DateTime date) async {
    var monthEndAt = DateTime(date.year, date.month + 1, 0);
    var endAtWeekday = monthEndAt.weekday % 7;
    var endWeekdayOffset = DateTime.saturday - endAtWeekday;

    var gridViewEndDate = monthEndAt.add(Duration(days: endWeekdayOffset));
    var gridViewStartDate = gridViewEndDate.add(Duration(days: -41));

    final result = await _costsRepo.queryBetween(
        gridViewStartDate.toDateStamp(), gridViewEndDate.toDateStamp());

    _logger.d({
      'start': gridViewStartDate.toDateStamp(),
      'end': gridViewEndDate.toDateStamp()
    });

    final dateStampMap = <int, List<CostItem>>{};
    result.forEach((cost) {
      var list = dateStampMap[cost.dateStamp];
      if (list == null) {
        dateStampMap[cost.dateStamp] = <CostItem>[];
        list = dateStampMap[cost.dateStamp];
      }
      list!.add(cost);
    });

    var weekdayCellDatas = List<DayItem>.generate(42, (offset) {
      final thisDay = gridViewEndDate.add(Duration(days: offset - 41));
      final serializeDatestamp = thisDay.toDateStamp();
      final costItemsOfthisDay = dateStampMap[serializeDatestamp] ?? [];

      return DayItem(thisDay, costItemsOfthisDay);
    });

    return weekdayCellDatas;
  }

  Future<List<CostItem>> getSingleDayCost(DateTime date) async {
    final dateStamp = date.toDateStamp();
    final results = await _costsRepo.queryBetween(dateStamp, dateStamp);
    return results;
  }

  Future<void> updateOrInsertCost(CostItem item) async {
    if (item.id == null) {
      item.id = randomString(20);
    }
    await _costsRepo.updateOrInsert(item).catchError(
          (err) => _logger.i(
            item,
            err,
            StackTrace.current,
          ),
        );
  }

  Future<void> deleteCost(String id) async {
    await _costsRepo.delete(id);
  }

  Future<void> syncToCloud(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final costs = await _costsRepo.queryBetween(
      startDate.toDateStamp(),
      endDate.toDateStamp(),
    );
    await _firestoreRepo.updateOrInsertMany(userId, costs);
  }

  Future<void> pullFromCloud(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final firestoreCosts = await _firestoreRepo.getCostsBetween(
      userId,
      startDate.toDateStamp(),
      endDate.toDateStamp(),
    );
    await _costsRepo.updateOrInsertMany(firestoreCosts);
  }
}
