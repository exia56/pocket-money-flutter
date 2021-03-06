import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:pocket_money/component/index.dart';
import 'package:pocket_money/component/month-grid-view.dart';
import 'package:pocket_money/models/index.dart';
import 'package:pocket_money/utils/index.dart';
import 'package:pocket_money/view-models/main-view-model.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/views/index.dart';
import 'package:pocket_money/views/insert-cost-view.dart';

import 'index.dart';

class MainView extends StatefulWidget {
  static const route = 'MainView';

  @override
  State<StatefulWidget> createState() {
    return MainViewState();
  }
}

class MainViewState extends State<MainView> {
  MainViewModel mainViewModel =
      DI.instance.get<MainViewModel>(MainViewModel.diKey);

  final _logger = createLogger(MainView.route);
  List<DayItem> dayItems = [];
  int monthlyCost = 0;
  DateTime showDate = DateTime.now();
  final dateFormator = DateFormat('yyyy-MM');
  final scrollController = ScrollController();
  bool fabVisible = true;

  @override
  void initState() {
    super.initState();
    mainViewModel.dayItems.listen((newDayItems) {
      int total = 0;
      newDayItems.forEach((dayItem) {
        if (showDate.year == dayItem.date.year &&
            showDate.month == dayItem.date.month) {
          total += dayItem.amount;
        }
      });
      setState(() {
        dayItems = newDayItems;
        monthlyCost = total;
      });
    });
    mainViewModel.getDateFees(showDate);
    scrollController.addListener(() {
      _logger.d({
        'direction': scrollController.position.userScrollDirection.toString(),
        'event': 'main scroll controller event'
      });
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          fabVisible == true) {
        setState(() {
          fabVisible = false;
        });
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          fabVisible == false) {
        setState(() {
          fabVisible = true;
        });
      }
    });
  }

  void onCellPress(SingleDayArrguments args) async {
    await Navigator.of(context).pushNamed(SingleDayView.route, arguments: args);
    mainViewModel.getDateFees(showDate);
  }

  void updateShowDate(DateTime date) {
    showDate = date;
    mainViewModel.getDateFees(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pocket Money'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: IconButton(
              padding: EdgeInsets.all(5),
              onPressed: () async {
                await Navigator.of(context).pushNamed(SettingView.route);
                mainViewModel.getDateFees(showDate);
              },
              icon: Icon(
                Icons.settings,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: fabVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).pushNamed(InsertCostView.route);
            mainViewModel.getDateFees(showDate);
          },
        ),
      ),
      body: SimpleScrollView(
        controller: scrollController,
        child: Container(
          padding: EdgeInsets.all(10),
          child: dayItems.length != 42
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    MonthGridView(
                      dayItems,
                      onCellPress,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () => updateShowDate(DateTime(
                                  showDate.year,
                                  showDate.month - 1,
                                  showDate.day)),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.chevron_left,
                                  size: 30,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                dateFormator.format(showDate),
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () => updateShowDate(DateTime(
                                  showDate.year,
                                  showDate.month + 1,
                                  showDate.day)),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Theme.of(context).accentColor,
                                ),
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
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              color: Theme.of(context).accentColor,
                            ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(monthlyCost.toString(),
                          style: Theme.of(context).textTheme.headline4),
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                      thickness: 3,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
