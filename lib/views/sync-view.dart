import 'package:flutter/material.dart';
import 'package:pocket_money/component/datetime-picker.dart';
import 'package:pocket_money/component/modal.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/repos/index.dart';
import 'package:pocket_money/view-models/index.dart';
import 'package:pocket_money/utils/index.dart';

class SyncViewParam {
  final User user;

  SyncViewParam(this.user);
}

class SyncDataView extends StatefulWidget {
  static const route = 'SyncDataView';

  final User user;

  SyncDataView(SyncViewParam param) : user = param.user;

  @override
  State<StatefulWidget> createState() => SyncDataState();
}

class SyncDataState extends StateWithOverlay<SyncDataView> {
  final _syncViewModel = DI.instance.get<SyncViewModel>(SyncViewModel.diKey);
  final _logger = createLogger(SyncDataView.route);

  var _startDate = DateTime.now().subtract(Duration(days: 30));
  var _endDate = DateTime.now();
  var _toCloud = true;
  var _error = '';

  @override
  void initState() {
    super.initState();
    _syncViewModel.error.listen((error) {
      _logger.i('error: $error');
      setState(() {
        _error = error;
      });
    });
    _syncViewModel.loading.listen((loading) {
      if (loading) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });
    _syncViewModel.result.listen((result) {
      if (result) {
        Navigator.of(context).pop();
      }
    });
  }

  Widget _rowCreation(Widget title, Widget value) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: title,
          ),
          Expanded(
            flex: 3,
            child: value,
          ),
        ],
      ),
    );
  }

  @override
  Widget childBuilder() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('備份'),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _rowCreation(
              Text(
                'start: ',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: DateTimePicker(
                  currentDate: _startDate,
                  lastDate: _endDate,
                  onDatePicked: (date) {
                    setState(() {
                      _startDate = date;
                    });
                  },
                ),
              ),
            ),
            _rowCreation(
              Text(
                'end: ',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: DateTimePicker(
                  currentDate: _endDate,
                  firstDate: _startDate,
                  lastDate: DateTime.now(),
                  onDatePicked: (date) {
                    setState(() {
                      _endDate = date;
                    });
                  },
                ),
              ),
            ),
            _rowCreation(
              Text(
                'toCloud: ',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: SizedBox(
                    width: constraints.maxWidth * 0.3,
                    child: Switch(
                      value: _toCloud,
                      onChanged: (newValue) {
                        setState(() {
                          _toCloud = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: _error.length == 0
                  ? null
                  : Text(
                      _error,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Colors.red),
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _syncViewModel.syncData(
                      widget.user,
                      _startDate,
                      _endDate,
                      _toCloud,
                    );
                  },
                  child: Text('backup',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Colors.white)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _syncViewModel.dispose();
  }
}
