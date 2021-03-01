import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _syncViewModel.error.listen((error) {
      _logger.i('error: $error');
      // setState(() {
      //   _error = error;
      // });
    });
    _syncViewModel.loading.listen((loading) {
      if (loading) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });
  }

  Widget _rowCreation(Widget title, Widget value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: title,
          ),
          Expanded(
            flex: 4,
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
        child: StreamBuilder<SyncParam>(builder: (context, asyncSnapshot) {
          final value = asyncSnapshot.data ??
              SyncParam(
                start: DateTime.now().subtract(Duration(days: 30)),
                end: DateTime.now(),
                toCloud: true,
              );
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'start: ',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        value.start.toYYYYMMDD(),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'end: ',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        value.end.toYYYYMMDD(),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'toCloud: ',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        value.toCloud.toString(),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: asyncSnapshot.hasError
                    ? Text(asyncSnapshot.error.toString())
                    : null,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _syncViewModel.syncParamSink.add(value);
                      _syncViewModel.syncData(widget.user);
                    },
                    child: Text('backup'),
                  )
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _syncViewModel.dispose();
  }
}
