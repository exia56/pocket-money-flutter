import 'package:flutter/material.dart';
import 'package:pocket_money/component/index.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/constant.dart';
import 'package:pocket_money/models/index.dart';
import 'package:pocket_money/view-models/index.dart';
import 'package:pocket_money/utils/index.dart';
import 'package:pocket_money/views/insert-cost-view.dart';

import '../constant.dart';

typedef OnItemPressed = void Function(CostItem);

class SingleDayArrguments {
  final DateTime date;

  SingleDayArrguments(this.date);
}

class SingleDayView extends StatefulWidget {
  static const route = 'SingleDayView';

  final SingleDayArrguments args;

  SingleDayView({required this.args, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SingleDayState(this.args.date);
}

class SingleDayState extends State<SingleDayView> {
  final _costViewModel = DI.instance.get<CostViewModel>(CostViewModel.diKey);
  final _logger = createLogger(SingleDayView.route);

  var _error = '';

  DateTime date;

  List<CostItem> costItems = [];

  SingleDayState(this.date);

  @override
  void initState() {
    super.initState();
    _costViewModel.error.listen((error) {
      _logger.i('error: $error');
      setState(() {
        _error = error;
      });
    });
    _costViewModel.costItems.listen((items) {
      setState(() {
        costItems = items;
      });
    });
    _costViewModel.querySingleDayCost(date);
  }

  void onItemPressed(CostItem item) async {
    await Navigator.of(context)
        .pushNamed(InsertCostView.route, arguments: item);
    _costViewModel.querySingleDayCost(date);
  }

  Widget _itemWidget(CostItem cost) {
    return InkWell(
      onTap: () {
        onItemPressed(cost);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    cost.type.name,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    cost.detail,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    cost.amount.toString(),
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: Theme.of(context).accentColor,
                        ),
                  ),
                ),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: Text(
                //     cost.amount.toString(),
                //     style:Theme.of(context).textTheme.bodyText2.copyWith(
                //   color: Theme.of(context).accentColor,
                // )
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    int total = 0;

    for (int i = 0; i < costItems.length; i++) {
      total += costItems[i].amount;
      children.addAll([
        _itemWidget(costItems[i]),
        Divider(
          color: Colors.grey.shade400,
          thickness: 1.5,
        ),
      ]);
    }
    if (children.length > 0) {
      children.removeLast();
    }

    children.addAll([
      Divider(
        color: Colors.black,
        thickness: 2,
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            Text(
              'Total:',
              style: Theme.of(context).textTheme.headline6,
            ),
            Spacer(),
            Text(
              total.toString(),
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                  ),
            ),
          ],
        ),
      ),
      Divider(
        color: Colors.black,
        thickness: 2,
      ),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(date.toYYYYMMDD()),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).pushNamed(
            InsertCostView.route,
            arguments:
                CostItem.fromMap({'dateStamp': date.toDateStamp(), 'type': 1}),
          );
          _costViewModel.querySingleDayCost(date);
        },
      ),
      body: SimpleScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _costViewModel.dispose();
  }
}
