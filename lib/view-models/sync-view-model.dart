import 'dart:async';
import 'package:pocket_money/utils/index.dart';
import 'package:pocket_money/repos/index.dart';
import 'package:pocket_money/services/index.dart';

class SyncViewModel {
  static const diKey = 'SyncViewModel';
  final CostService _costService;

  final _logger = createLogger(SyncViewModel.diKey);

  final _errController = StreamController<String>.broadcast();
  Stream<String> get error => _errController.stream;

  final _loadingController = StreamController<bool>.broadcast();
  Stream<bool> get loading => _loadingController.stream;

  final _resultController = StreamController<bool>.broadcast();
  Stream<bool> get result => _resultController.stream;

  SyncViewModel(this._costService);

  Future<void> syncData(
    User user,
    DateTime startDate,
    DateTime endDate,
    bool toCloud,
  ) async {
    _loadingController.add(true);
    try {
      if (toCloud) {
        await _costService.syncToCloud(user.id, startDate, endDate);
      } else {
        await _costService.pullFromCloud(user.id, startDate, endDate);
      }
      _resultController.add(true);
    } catch (err, stackTrance) {
      _logger.e({
        'start': startDate.toYYYYMMDD(),
        'end': endDate.toYYYYMMDD(),
        'toCloud': toCloud,
        'user': user.id,
      }, err, stackTrance);
      _errController.add(err.toString());
    } finally {
      _loadingController.add(false);
    }
  }

  dispose() {
    _errController.close();
    _loadingController.close();
    _resultController.close();
  }
}
