import 'package:flutter/material.dart';
import 'package:pocket_money/component/index.dart';
import 'package:pocket_money/constant.dart';
import 'package:pocket_money/di.dart';
import 'package:pocket_money/utils/index.dart';
import 'package:pocket_money/view-models/index.dart';
import 'package:pocket_money/models/index.dart';

class InsertCostView extends StatefulWidget {
  static const route = 'InsertCostView';

  final CostItem cost;

  InsertCostView(this.cost) : assert(cost != null, 'cost must not be null');

  @override
  State<StatefulWidget> createState() => InsertCostState(cost);
}

class InsertCostState extends State<InsertCostView> {
  final _costViewModel = DI.instance.get<CostViewModel>(CostViewModel.diKey);
  final _logger = createLogger(InsertCostView.route);

  var _error = '';
  final CostItem cost;
  DateTime date = DateTime.now();
  final amountController = TextEditingController();
  final detailController = TextEditingController();
  CostType type;
  final bool isInsert;

  InsertCostState(this.cost) : isInsert = cost.id == null {
    date = DateTimeEX.fromDateStamp(cost.dateStamp);
    amountController.text = cost.amount.toString();
    detailController.text = cost.detail;
    type = cost.type;
  }

  @override
  void initState() {
    super.initState();
    _costViewModel.error.listen((error) {
      setState(() {
        _error = error;
      });
    });
    _costViewModel.updated.listen((updated) {
      exit();
    });
  }

  Widget _rowCreation(String title, Widget value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: value,
            ),
          ),
        ],
      ),
    );
  }

  void exit() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isInsert ? '新增' : '修改'),
      ),
      body: SimpleScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              _rowCreation(
                '日期:',
                InkWell(
                  onTap: () async {
                    final newDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate:
                          DateTime.now().subtract(Duration(days: 2 * 365)),
                      lastDate: DateTime.now().add(Duration(days: 7)),
                    );
                    setState(() {
                      date = newDate;
                    });
                  },
                  child: Text(
                    date.toYYYYMMDD(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
              _rowCreation(
                  '種類:',
                  DropdownButton<CostType>(
                    value: type,
                    focusColor: Theme.of(context).primaryColor,
                    underline: Container(),
                    isExpanded: true,
                    isDense: true,
                    onChanged: (newType) {
                      setState(() {
                        type = newType;
                      });
                    },
                    items: CostType.values
                        .map(
                          (t) => DropdownMenuItem<CostType>(
                            value: t,
                            child: Text(
                              t.name,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        )
                        .toList(),
                  )),
              _rowCreation(
                '花費:',
                TextField(
                  controller: amountController,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration.collapsed(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              _rowCreation(
                '細項:',
                TextField(
                  minLines: 4,
                  maxLines: null,
                  controller: detailController,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration.collapsed(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: '',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FlatButton.icon(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(isInsert ? Icons.add : Icons.edit),
                      label: Text(
                        isInsert ? '新增' : '修改',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      onPressed: () {
                        _costViewModel.updateOrInsertCost(CostItem.fromMap({
                          'type': type,
                          'amount': amountController.text,
                          'dateStamp': date.toDateStamp(),
                          'detail': detailController.text,
                          'year': date.year,
                          'month': date.month,
                          'day': date.day,
                          'id': cost.id,
                        }));
                      },
                    ),
                    isInsert
                        ? Container()
                        : FlatButton.icon(
                            color: Colors.blueGrey.shade300,
                            icon: Icon(Icons.delete),
                            label: Text(
                              '刪除',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            onPressed: () {
                              _costViewModel.deleteCost(cost.id);
                            },
                          ),
                    FlatButton.icon(
                      color: Colors.blueGrey.shade300,
                      icon: Icon(Icons.cancel),
                      label: Text(
                        '取消',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      onPressed: () {
                        exit();
                      },
                    ),
                  ],
                ),
              ),
            ],
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
