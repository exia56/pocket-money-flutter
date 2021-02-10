import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_money/component/month-grid-view.dart';
import 'package:pocket_money/services/index.dart';
import 'package:pocket_money/view-models/main-view-model.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/constant.dart';

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainViewState();
  }
}

class MainViewState extends State<MainView> {
  MainViewModel mainViewModel = DI.instance.get<MainViewModel>('mainViewModel');

  List<DayItem> dayItems = [];
  DateTime showDate = DateTime.now();
  final dateFormator = DateFormat('yyyy-MM');

  @override
  void initState() {
    super.initState();
    mainViewModel.dayItems.listen((newDayItems) {
      setState(() {
        dayItems = newDayItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mounted && dayItems.length != 42) {
      mainViewModel.getDateFees(showDate);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Pocket Money'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: IconButton(
              padding: EdgeInsets.all(5),
              onPressed: () =>
                  Navigator.of(context).pushNamed(NamedRouter.setting.name),
              icon: Icon(
                Icons.settings,
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Container(
              padding: EdgeInsets.all(10),
              child: dayItems.length != 42
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        MonthGridView(cellContent: dayItems),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.arrow_left,
                                    size: 30,
                                    color: Colors.pinkAccent.shade700,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    dateFormator.format(showDate),
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.arrow_right,
                                    size: 30,
                                    color: Colors.pinkAccent.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade400,
                          thickness: 3,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '月花費:',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.pinkAccent.shade700,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '30000',
                            style: TextStyle(
                              fontSize: 35,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade400,
                          thickness: 3,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
