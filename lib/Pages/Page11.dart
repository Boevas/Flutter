import 'package:flutter/material.dart';
import 'Page1.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:test4/widgets/DataTableWidget.dart';
import 'package:test4/OptimizeOrder.dart';
import 'dart:developer';
import 'package:test4/sqlite/Sqlite.dart';

class Page11 extends StatefulWidget {
  @override
  _Page11State createState() => _Page11State();
}

class _Page11State extends State<Page11> {
  TextEditingController moneyCtrl = new TextEditingController(text: "10000");

  FutureBuilder getsum() {
    return FutureBuilder<Object>(
      future: SqliteUtils("130")
          .executeScalar('SELECT SUM(SUM) FROM CURRENT_ORDER ;'),
      builder: (BuildContext c, AsyncSnapshot<Object> aspsh) {
        if (!aspsh.hasData) return CircularProgressIndicator();
        return Text(
            'Сумма:${double.parse(aspsh.data.toString()).toStringAsFixed(2)}');
      },
    );
  }

  FutureBuilder getcount() {
    return FutureBuilder<Object>(
      future: SqliteUtils("130")
          .executeScalar('SELECT COUNT(*) FROM CURRENT_ORDER;'),
      builder: (BuildContext c, AsyncSnapshot<Object> aspsh) {
        if (!aspsh.hasData) return CircularProgressIndicator();
        return Text('Количество:${aspsh.data}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizemonitor = MediaQuery.of(context).size;
    final sizemonitorheight = sizemonitor.height;
    final sizemonitorwidth = sizemonitor.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Заказ')),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(flex: 1, child: SizedBox.shrink()),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue[100],
                        border: Border.all(
                          width: 1.0,
                        )),
                    child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text('Цель: Выручка 1000  ')),
                  ),
                ),
                Expanded(flex: 1, child: SizedBox.shrink()),
              ],
            ),
          ),
          Expanded(flex: 1, child: SizedBox.shrink()),
          Expanded(
            flex: 90,
            child: DataTableWidget(
                dbName: "130",
                viewSqlScript:
                    "SELECT CURRENT_ORDER.ID, TMC_GROUP.LABEL, CURRENT_ORDER.QUANTITY, CURRENT_ORDER.QUANTITYAUTO,1 AS 'DELETE' FROM CURRENT_ORDER INNER JOIN TMC_GROUP ON CURRENT_ORDER.ID_TMC_GROUP=TMC_GROUP.IDGROUP",
                rowHeight: 100,
                updateTableName: "CURRENT_ORDER",
                updateTablePK: 'ID',
                columns: {
                  'ID': DataColumnEx(
                      show: false,
                      label: "ID",
                      numeric: true,
                      tooltip: "ID",
                      editable: false,
                      editableTextInputType: TextInputType.number,
                      width: 0),
                  'LABEL': DataColumnEx(
                      show: true,
                      label: "Товар",
                      numeric: false,
                      tooltip: "Название\nтовара",
                      editable: false,
                      editableTextInputType: TextInputType.text,
                      width: sizemonitorwidth,
                      align: TextAlign.left,
                      fontSize: 35),
                  'QUANTITY': DataColumnEx(
                    show: true,
                    label: "Количество\nтоваров",
                    numeric: true,
                    tooltip: "Количество\nтоваров\nв заказе",
                    editable: true,
                    editableTextInputType: TextInputType.number,
                    width: (sizemonitorwidth / 100) * 60,
                    align: TextAlign.center,
                    fontSize: 30,
                  ),
                  'QUANTITYAUTO': DataColumnEx(
                    show: true,
                    label: "Рекомендованное\nколичество",
                    numeric: true,
                    tooltip: "Рекомендованное\nколичество\nтоваров\nв заказе",
                    editable: false,
                    editableTextInputType: TextInputType.number,
                    width: (sizemonitorwidth / 100) * 80,
                    align: TextAlign.center,
                    fontSize: 30,
                  ),
                  'DELETE': DataColumnEx(
                    show: true,
                    label: "Удалить",
                    numeric: false,
                    tooltip: "Удалить",
                    editable: false,
                    editableTextInputType: TextInputType.text,
                    width: (sizemonitorwidth / 100) * 40,
                    align: TextAlign.center,
                    fontSize: 30,
                  ),
                }),
          ),
          Expanded(flex: 1, child: SizedBox.shrink()),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(flex: 32, child: SizedBox.shrink()),
                Expanded(flex: 2, child: SizedBox.shrink()),
                Expanded(
                  flex: 32,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue[100],
                        border: Border.all(
                          width: 1.0,
                        )),
                    child: FittedBox(fit: BoxFit.fitWidth, child: getcount()),
                  ),
                ),
                Expanded(flex: 2, child: SizedBox.shrink()),
                Expanded(
                  flex: 32,
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.blue[100],
                          border: Border.all(
                            width: 1.0,
                          )),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: getsum(),
                      )),
                ),
              ],
            ),
          ),
          Expanded(flex: 1, child: SizedBox.shrink()),
          Expanded(
            flex: 7,
            child: Row(
              children: [
                Expanded(flex: 32, child: TextField(controller: moneyCtrl)),
                Expanded(flex: 2, child: SizedBox.shrink()),
                Expanded(
                  flex: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      OptimizeOrder(
                              orderlimit: double.parse(moneyCtrl.text),
                              orderrestrainstrategy: 0)
                          .optimize()
                          .then((value) {
                        setState(() {
                          log('OptimizeOrder().optimize');
                        });
                      });
                    },
                    child: Text('Ограничение суммы'),
                  ),
                ),
                Expanded(flex: 2, child: SizedBox.shrink()),
                Expanded(
                  flex: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      AutoOrder().init().then((value) {
                        log(value.toString());
                        setState(() {
                          log('AutoOrder().init');
                        });
                      });
                    },
                    //child: Text('Заказать'),
                    child: Text('АвтоЗаказ'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
