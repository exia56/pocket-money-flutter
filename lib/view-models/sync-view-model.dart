import 'dart:async';
import 'package:pocket_money/utils/index.dart';
import 'package:pocket_money/repos/index.dart';
import 'package:pocket_money/services/index.dart';

class SyncParam {
  final DateTime start;
  final DateTime end;
  final bool toCloud;

  SyncParam({
    required this.start,
    required this.end,
    required this.toCloud,
  });

  SyncParam clone({
    DateTime? start,
    DateTime? end,
    bool? toCloud,
  }) {
    return SyncParam(
      start: start ?? this.start,
      end: end ?? this.end,
      toCloud: toCloud ?? this.toCloud,
    );
  }
}

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

  final _syncParamController = StreamController<SyncParam>.broadcast();
  Stream<SyncParam> get syncParamSteam => _syncParamController.stream;
  Sink<SyncParam> get syncParamSink => _syncParamController.sink;

  SyncViewModel(this._costService);

  Future<void> syncData(User user) async {
    _loadingController.add(true);
    SyncParam? data;
    try {
      _logger.d({
        'user':user.id
      });
      data = await syncParamSteam.last;
      _logger.d({
        'start': data.start,
        'end': data.end,
        'toCloud': data.toCloud,
        'user': user.id,
      });
    } catch (err, stackTrance) {
      _logger.e({'data': data}, err, stackTrance);
      _syncParamController.addError(err);
      _errController.add(err.toString());
    } finally {
      _loadingController.add(false);
    }
  }

  dispose() {
    _errController.close();
    _syncParamController.close();
  }
}
